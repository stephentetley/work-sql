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

PREPARE load_ztable_flobjl AS 
    INSERT INTO s4_ztables.flobjl
    FROM read_ztable_flobjl($1);

-- To use at a SQL prompt, eval the file then:

-- EXECUTE load_ztable_flobjl('/home/stephen/_working/work/2025/asset_data_facts/s4_ztables/flobjl_2025.03.17.XLSX');





