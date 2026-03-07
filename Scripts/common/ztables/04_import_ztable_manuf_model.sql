CREATE SCHEMA IF NOT EXISTS s4_ztables;



CREATE OR REPLACE TABLE s4_ztables.manuf_model (
    manufacturer VARCHAR NOT NULL,
    model VARCHAR NOT NULL,
);


-- Setup the environment variable `ZT_MANUF_MODEL_PATH` before running this file
SELECT getenv('ZT_MANUF_MODEL_PATH') AS ZT_MANUF_MODEL_PATH;

INSERT INTO s4_ztables.manuf_model
SELECT 
    t."Manufacturer" AS 'manufacturer',
    t."Model Number" AS 'model',
FROM read_xlsx(getenv('ZT_MANUF_MODEL_PATH'), all_varchar=true) AS t;



