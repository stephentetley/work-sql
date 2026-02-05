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

-- Setup the variables `zt_flobjl_path` before running this file
-- SET VARIABLE zt_eqobjl_path = 'path/to/zt_flobjl_20260205.XLSX';

INSERT INTO s4_ztables.flobjl
FROM read_ztable_flobjl(
    getvariable('zt_flobjl_path')
);





