CREATE SCHEMA IF NOT EXISTS s4_ztables;


CREATE OR REPLACE TABLE s4_ztables.eqobjl (
    structure_indicator VARCHAR NOT NULL,
    object_type VARCHAR NOT NULL,
    object_type_1 VARCHAR NOT NULL,
    remarks VARCHAR
);

--  eqobjl
CREATE OR REPLACE MACRO read_ztable_eqobjl(xlsx_file) AS TABLE
SELECT 
    t."Object Type" AS 'object_type',
    t."Object Type_1" AS 'object_type_1',
    t."Equipment category" AS 'equipment_category',
    t."Remarks" AS 'remarks',
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true) AS t;

-- Setup the variables `zt_eqobjl_path` before running this file
-- SET VARIABLE zt_eqobjl_path = 'path/to/zt_eqobj_20260205.XLSX';

INSERT INTO s4_ztables.eqobjl
FROM read_ztable_eqobjl(
    getvariable('zt_eqobjl_path')
);






