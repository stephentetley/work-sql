CREATE SCHEMA IF NOT EXISTS s4_ztables;



CREATE OR REPLACE TABLE s4_ztables.manuf_model (
    manufacturer VARCHAR NOT NULL,
    model VARCHAR NOT NULL,
);


--  manuf_model
CREATE OR REPLACE MACRO read_ztable_manuf_model(xlsx_file) AS TABLE
SELECT 
    t."Manufacturer" AS 'manufacturer',
    t."Model Number" AS 'model',
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true) AS t;

PREPARE load_ztable_manuf_model AS 
    INSERT INTO s4_ztables.manuf_model
    FROM read_ztable_manuf_model($1);

-- To use at a SQL prompt, eval the file then:

-- EXECUTE load_ztable_manuf_model('/home/stephen/_working/work/2025/asset_data_facts/s4_ztables/manuf_model_2025.03.17.XLSX');




