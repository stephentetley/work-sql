CREATE SCHEMA IF NOT EXISTS s4_ztables;



CREATE OR REPLACE TABLE s4_ztables.flocdes (
    object_type VARCHAR NOT NULL,
    standard_floc_description VARCHAR,
);



-- Setup the environment variable `ZT_FLOCDES_PATH` before running this file
SELECT getenv('ZT_FLOCDES_PATH') AS ZT_FLOCDES_PATH;

INSERT INTO s4_ztables.flocdes
SELECT 
    t."Object Type" AS 'object_type',
    t."Standard FLoc Description" AS 'standard_floc_description',
FROM read_xlsx(getenv('ZT_FLOCDES_PATH'), all_varchar=true) AS t;