CREATE OR REPLACE TEMPORARY MACRO empty_string_to_null(str) AS
    IF(str='', null, str);

CREATE OR REPLACE TEMPORARY MACRO simplify_class_name(str) AS
    IF(str LIKE '00_ %', str[5:], str);

CREATE OR REPLACE MACRO read_classlist_export(xlsx_file) AS TABLE
WITH trimmed AS (
    SELECT 
        row_number() OVER () AS row_ix_trimmed,
        empty_string_to_null(trim(t."B1")) AS class_name,
        empty_string_to_null(trim(t."C1")) AS char_name,
        empty_string_to_null(trim(t."D1")) AS enum_value,
        empty_string_to_null(trim(t."E1")) AS descrip,
        empty_string_to_null(trim(t."G1")) AS datatype,
        empty_string_to_null(trim(t."H1")) AS datatype_length,
        empty_string_to_null(trim(t."I1")) AS datatype_precision,
    FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true, header=false) AS t
), filtered AS (
    SELECT 
        row_number() OVER () AS row_ix,
        * EXCLUDE(row_ix_trimmed)    
    FROM trimmed 
    WHERE class_name IS NOT NULL OR char_name IS NOT NULL OR enum_value IS NOT NULL
    ORDER BY row_ix_trimmed
)
SELECT * FROM filtered;

