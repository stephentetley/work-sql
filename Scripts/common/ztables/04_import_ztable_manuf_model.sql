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


-- Setup the variables `zt_manuf_model_path` before running this file
-- SET VARIABLE zt_manuf_model_path = 'path/to/zt_manuf_20260205.XLSX';

INSERT INTO s4_ztables.manuf_model
FROM read_ztable_manuf_model(
    getvariable('zt_manuf_model_path')
);



