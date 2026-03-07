
INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;


CREATE OR REPLACE TEMPORARY MACRO trim_cell(str VARCHAR) AS
    CASE WHEN trim(str) = '' THEN NULL ELSE trim(str) END;


CREATE OR REPLACE TEMPORARY MACRO read_classdefs(file_name VARCHAR) AS TABLE (
WITH cte1 AS (
    SELECT
        row_number() OVER () AS idx,
        trim_cell(COLUMNS(*))
    FROM read_sheet(
        file_name,
        skip_empty_rows = true,
        nulls = ['']
    )
), cte2 AS (
   SELECT
        -- Probably should do trim and replace as NULL on a select *...
        idx,
        regexp_replace(#3, '\d{3} ', '') AS class_name,
        -- if(class_name_s='', NULL, class_name_s) AS class_name,
        #4 AS char_name,
        #5 AS char_value,
        #6 AS description,
        #8 AS data_type,
        #9 AS char_length,
        #10 AS char_precision,
    FROM cte1
    WHERE class_name IS NOT NULL OR char_name IS NOT NULL OR char_value IS NOT NULL
)
SELECT
    *,
    last(class_name IGNORE NULLS) OVER (ORDER BY idx) AS class_name_filled,
    last(char_name IGNORE NULLS) OVER (ORDER BY idx) AS char_name_filled,
FROM cte2
);


-- Setup the environment variable `EQUI_CLASSDEFS_PATH` before running this file
SELECT getenv('EQUI_CLASSDEFS_PATH') AS EQUI_CLASSDEFS_PATH;

CREATE OR REPLACE TEMPORARY TABLE equi_import AS
SELECT * FROM read_classdefs(getenv('EQUI_CLASSDEFS_PATH'));


-- Setup the environment variable `FLOC_CLASSDEFS_PATH` before running this file
SELECT getenv('FLOC_CLASSDEFS_PATH') AS FLOC_CLASSDEFS_PATH;

CREATE OR REPLACE TEMPORARY TABLE floc_import AS
SELECT * FROM read_classdefs(getenv('FLOC_CLASSDEFS_PATH'));

CREATE OR REPLACE TEMPORARY MACRO setup_classes_table(table_name VARCHAR) AS TABLE
WITH cte_classes AS (
    SELECT
        t.class_name,
        t.description AS class_description,
    FROM equi_import t
    WHERE t.class_name IS NOT NULL
)
SELECT
    t.class_name_filled AS class_name,
    t.char_name AS char_name,
    t1.class_description AS class_description,
    t.description AS char_description,
    t.data_type AS char_type,
    t.char_length AS char_length,
    t.char_precision AS char_precision,
FROM query_table(table_name) t
JOIN cte_classes t1 ON t1.class_name = t.class_name_filled
WHERE t.char_name IS NOT NULL;

INSERT INTO s4_classlists.floc_characteristics BY NAME
SELECT * FROM setup_classes_table('floc_import');

INSERT INTO s4_classlists.equi_characteristics BY NAME
SELECT * FROM setup_classes_table('equi_import');

CREATE OR REPLACE TEMPORARY MACRO setup_enums_table(table_name VARCHAR) AS TABLE
SELECT
    t.class_name_filled AS class_name,
    t.char_name_filled AS char_name,
    t.char_value AS enum_value,
    t.description AS enum_description,
FROM query_table(table_name) t
WHERE t.char_value IS NOT NULL;

INSERT INTO s4_classlists.floc_enums BY NAME
SELECT * FROM setup_enums_table('floc_import');

INSERT INTO s4_classlists.equi_enums BY NAME
SELECT * FROM setup_enums_table('equi_import');
