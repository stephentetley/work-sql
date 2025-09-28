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


PREPARE load_ztable_eqobjl AS 
    INSERT INTO s4_ztables.eqobjl
    FROM read_ztable_eqobjl($1);

-- To use at a SQL prompt, eval the file then:

-- EXECUTE load_ztable_eqobjl('/home/stephen/_working/work/2025/asset_data_facts/s4_ztables/eqobjl_2025.03.17.XLSX');





