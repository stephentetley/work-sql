CREATE SCHEMA IF NOT EXISTS s4_ztables;



CREATE OR REPLACE TABLE s4_ztables.obj (
    object_type VARCHAR NOT NULL,
    manufacturer VARCHAR NOT NULL,
    remarks VARCHAR,
);


-- Setup the environment variable `ZT_OBJ_PATH` before running this file
SELECT getenv('ZT_OBJ_PATH') AS ZT_OBJ_PATH;

INSERT INTO s4_ztables.obj
SELECT 
    t."Object Type" AS 'object_type',
    t."Manufacturer" AS 'manufacturer',
    t."Remarks" AS 'remarks',
FROM read_xlsx(getenv('ZT_OBJ_PATH'), all_varchar=true) AS t;


