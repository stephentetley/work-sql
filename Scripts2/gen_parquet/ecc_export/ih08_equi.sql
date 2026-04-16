.print 'Running ih08_equi.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;



CREATE OR REPLACE TABLE ecc_equi (
    -- e.g. '100200300'
    equipment_id VARCHAR NOT NULL,
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
    PRIMARY KEY (equipment_id)
);    
    


-- Setup the environment variable `ECC_EQUI_XLS_PATH` before running this file
SELECT getenv('ECC_EQUI_XLS_PATH') AS ECC_EQUI_XLS_PATH;


.print 'Loading ecc_equi...'


INSERT INTO ecc_equi BY NAME
SELECT
    t."Equipment" AS equipment_id,
    t."Description" AS description,
    t."ConstType" as const_type,
    t."Functional Loc." AS functional_loc,
    t."Manufacturer" AS manufaturer,
    t."Model number" AS model_number,
    t."System status" AS system_status,
    t."EquipCategory" AS equip_category,
    t."Inventory no." AS inventory_no,
FROM read_sheet(  
    getenv('ECC_EQUI_XLS_PATH'),
    error_as_null = true) t
WHERE t."Equipment" IS NOT NULL;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ecc_equi) TO '$(ECC_EQUI_OUTPATH)' (FORMAT parquet, COMPRESSION uncompressed);

