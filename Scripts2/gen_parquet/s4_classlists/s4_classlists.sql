.print 'Running s4_classlists.sql...'


INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

-- ## CREATE TABLES

CREATE OR REPLACE TABLE s4_floc_classes (
    class_name TEXT NOT NULL,
    char_name TEXT NOT NULL,
    class_description TEXT,
    char_description TEXT,
    char_type TEXT,
    char_length INTEGER,
    char_precision INTEGER,
    PRIMARY KEY(class_name, char_name)
);


CREATE OR REPLACE TABLE s4_equi_classes (
    -- e.g. 'PODEPC'
    class_name TEXT NOT NULL,
    -- e.g. 'MEMO_LINE'
    char_name TEXT NOT NULL,
    -- e.g. 'Phase Converter'
    class_description TEXT,
    -- e.g. 'Memo Line'
    char_description TEXT,
    -- e.g. 'NUM'
    char_type TEXT,
    -- e.g. 30
    char_length INTEGER,
    -- e.g. 2
    char_precision INTEGER,
    PRIMARY KEY(class_name, char_name)
);


-- Dont bother with primary key as it is a 3-tuple.
CREATE OR REPLACE TABLE s4_floc_enums (
    class_name TEXT NOT NULL,
    char_name TEXT NOT NULL,
    enum_value TEXT NOT NULL,
    enum_description TEXT,
    PRIMARY KEY(class_name, char_name, enum_value)
);


-- Dont bother with primary key as it is a 3-tuple.
CREATE OR REPLACE TABLE s4_equi_enums (
    class_name TEXT NOT NULL,
    char_name TEXT NOT NULL,
    enum_value TEXT NOT NULL,
    enum_description TEXT,
    PRIMARY KEY(class_name, char_name, enum_value)
);


CREATE OR REPLACE TEMPORARY MACRO trim_cell(str) AS
    CASE WHEN trim(str) = '' THEN NULL ELSE trim(str) END;


CREATE OR REPLACE TEMPORARY MACRO read_classdefs(file_name) AS TABLE (
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


CREATE OR REPLACE MACRO setup_classes_table(table_name) AS TABLE
WITH cte_classes AS (
    SELECT
        t.class_name,
        t.description AS class_description,
    FROM query_table(table_name) t
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

CREATE OR REPLACE MACRO setup_enums_table(table_name) AS TABLE
SELECT
    t.class_name_filled AS class_name,
    t.char_name_filled AS char_name,
    t.char_value AS enum_value,
    t.description AS enum_description,
FROM query_table(table_name) t
WHERE t.char_value IS NOT NULL;




-- Setup the environment variable `FLOC_CLASSLIST_XLS_PATH` before running this file
SELECT getenv('FLOC_CLASSLIST_XLS_PATH') AS FLOC_CLASSLIST_XLS_PATH;

CREATE OR REPLACE TABLE floc_classlist_landing AS
SELECT * FROM read_classdefs(getenv('FLOC_CLASSLIST_XLS_PATH'));


-- Setup the environment variable `EQUI_CLASSLIST_XLS_PATH` before running this file
SELECT getenv('EQUI_CLASSLIST_XLS_PATH') AS EQUI_CLASSLIST_XLS_PATH;

CREATE OR REPLACE TABLE equi_classlist_landing AS
SELECT * FROM read_classdefs(getenv('EQUI_CLASSLIST_XLS_PATH'));


INSERT INTO s4_floc_classes BY NAME
SELECT * FROM setup_classes_table('floc_classlist_landing');

INSERT INTO s4_equi_classes BY NAME
SELECT * FROM setup_classes_table('equi_classlist_landing');


INSERT INTO s4_floc_enums BY NAME
SELECT * FROM setup_enums_table('floc_classlist_landing');

INSERT INTO s4_equi_enums BY NAME
SELECT * FROM setup_enums_table('equi_classlist_landing');

