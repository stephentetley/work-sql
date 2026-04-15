.print 'Running ih08_simple.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;



CREATE OR REPLACE TABLE ecc_equi_simple (
    -- e.g. '100200300'
    eqipment_id VARCHAR NOT NULL,
    -- e.g. 'EQUIPMENT: PENSTOCK'
    description VARCHAR,
    -- e.g. 'BLAA'
    const_type VARCHAR,
    -- e.g. '1LONWTD...'
    functional_loc VARCHAR,
    -- e.g. 'UNKNOWN MANUFACTURER'
    manufaturer VARCHAR,
    -- e.g. 'UNSPECIFIED' 
    model_number VARCHAR,
    -- e.g. 'DFLT INST'
    system_status VARCHAR,
    -- e.g. 'B'
    equip_category VARCHAR,
    -- e.g. 'PLI00012345'
    inventory_no VARCHAR,
    PRIMARY KEY (eqipment_id)
);    
    


-- Setup the environment variable `ECC_PARQUET_GLOBPATH` before running this file
SELECT getenv('ECC_PARQUET_GLOBPATH') AS ECC_PARQUET_GLOBPATH;


.print 'Loading landing.ecc_equi...'


INSERT INTO ecc_equi_simple BY NAME
SELECT
    t."Equipment" AS eqipment_id,
    t."Description" AS description,
    t."ConstType" as const_type,
    t."Functional Loc." AS functional_loc,
    t."Manufacturer" AS manufaturer,
    t."Model number" AS model_number,
    t."System status" AS system_status,
    t."EquipCategory" AS equip_category,
    t."Inventory no." AS inventory_no,
FROM read_parquet(getenv('ECC_PARQUET_GLOBPATH')) t
WHERE t."Equipment" IS NOT NULL;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ecc_equi_simple) TO '$(ECC_MASTER_OUTPATH)' (FORMAT parquet, COMPRESSION uncompressed);


-- .print 'Inserting ecc_equi data into ecc_equi_simple...'

-- INSERT OR REPLACE INTO ecc_equi_simple BY NAME
-- SELECT 
--     t."Equipment" AS eqipment_id,
--     t."Description" AS description,
--     t."ConstType" as const_type,
--     t."Functional Loc." AS functional_loc,
--     t."Manufacturer" AS manufaturer,
--     t."Model number" AS model_number,
--     t."System status" AS system_status,
--     t."EquipCategory" AS equip_category,
--     t."Inventory no." AS inventory_no,
-- FROM landing.ecc_equi t;



