CREATE SCHEMA IF NOT EXISTS s4_ztables;



CREATE OR REPLACE TABLE s4_ztables.flobjl (
    structure_indicator VARCHAR NOT NULL,
    object_type VARCHAR NOT NULL,
    object_type_1 VARCHAR NOT NULL,
    remarks VARCHAR,
);


--  flobjl
CREATE OR REPLACE MACRO read_ztable_flobjl(xlsx_file) AS TABLE
SELECT 
    t."Structure indicator" AS 'structure_indicator',
    t."Object Type" AS 'object_type',
    t."Object Type_1" AS 'object_type_1',
    t."Remarks" AS 'remarks',
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true) AS t;

-- Setup the environment variable `ZT_FLOBJL_PATH` before running this file
SELECT getenv('ZT_FLOBJL_PATH') AS ZT_FLOBJL_PATH;

INSERT INTO s4_ztables.flobjl
SELECT 
    t."Structure indicator" AS 'structure_indicator',
    t."Object Type" AS 'object_type',
    t."Object Type_1" AS 'object_type_1',
    t."Remarks" AS 'remarks',
FROM read_xlsx(getenv('ZT_FLOBJL_PATH'), all_varchar=true) AS t;





