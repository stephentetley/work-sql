CREATE SCHEMA IF NOT EXISTS s4_ztables;



CREATE OR REPLACE TABLE s4_ztables.obj (
    object_type VARCHAR NOT NULL,
    manufacturer VARCHAR NOT NULL,
    remarks VARCHAR,
);


--  obj
CREATE OR REPLACE MACRO read_ztable_obj(xlsx_file) AS TABLE
SELECT 
    t."Object Type" AS 'object_type',
    t."Manufacturer" AS 'manufacturer',
    t."Remarks" AS 'remarks',
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true) AS t;


-- Setup the variables `zt_obj_path` before running this file
-- SET VARIABLE zt_obj_path = 'path/to/zt_objtype_manuf_20260205.XLSX';

INSERT INTO s4_ztables.obj
FROM read_ztable_obj(
    getvariable('zt_obj_path')
);



