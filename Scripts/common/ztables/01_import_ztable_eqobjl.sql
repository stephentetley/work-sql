CREATE SCHEMA IF NOT EXISTS s4_ztables;


CREATE OR REPLACE TABLE s4_ztables.eqobjl (
    object_type VARCHAR NOT NULL,
    object_type_1 VARCHAR NOT NULL,
    equipment_category VARCHAR,
    remarks VARCHAR
);

-- Setup the environment variable `ZT_EQOBJL_PATH` before running this file
SELECT getenv('ZT_EQOBJL_PATH') AS ZT_EQOBJL_PATH;


INSERT INTO s4_ztables.eqobjl
SELECT
    t."Object Type" AS 'object_type',
    t."Object Type_1" AS 'object_type_1',
    t."Equipment category" AS 'equipment_category',
    t."Remarks" AS 'remarks',
FROM read_xlsx(getenv('ZT_EQOBJL_PATH'), all_varchar=true) AS t;







