CREATE SCHEMA IF NOT EXISTS s4_ztables;



CREATE OR REPLACE TABLE s4_ztables.flocdes (
    object_type VARCHAR NOT NULL,
    standard_floc_description VARCHAR,
);



--  flocdes
CREATE OR REPLACE MACRO read_ztable_flocdes(xlsx_file) AS TABLE
SELECT 
    t."Object Type" AS 'object_type',
    t."Standard FLoc Description" AS 'standard_floc_description',
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true) AS t;


PREPARE load_ztable_flocdes AS 
    INSERT INTO s4_ztables.flocdes
    FROM read_ztable_flocdes($1);

-- To use at a SQL prompt, eval the file then:

-- EXECUTE load_ztable_flocdes('/home/stephen/_working/work/2025/asset_data_facts/s4_ztables/flocdes_2025.03.17.XLSX');



