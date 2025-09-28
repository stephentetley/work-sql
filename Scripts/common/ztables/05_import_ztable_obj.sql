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

PREPARE load_ztable_obj AS 
    INSERT INTO s4_ztables.obj
    FROM read_ztable_obj($1);

-- To use at a SQL prompt, eval the file then:

-- EXECUTE load_ztable_obj('/home/stephen/_working/work/2025/asset_data_facts/s4_ztables/obj_2025.03.17.XLSX');


