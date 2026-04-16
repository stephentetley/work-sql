.print 'Running ih06_floc.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;


CREATE OR REPLACE TABLE ecc_floc (
    -- e.g. '2XYZWWTRSTF02____'
    functional_location VARCHAR NOT NULL,
    -- e.g. 'PUMPING'
    description VARCHAR,
    -- e.g. '1000'
    planning_plant VARCHAR,
    -- e.g. 'CRTE DFLT'
    system_status VARCHAR,
    -- e.g. '01.01.1970'
    startup_date DATE,
    -- e.g. 'WM_N_TRT'
    work_center VARCHAR,
    -- e.g. '1000' 
    maint_plant VARCHAR,
    -- e.g. 'M'
    floc_category VARCHAR,
    -- e.g. 'SAI00012345'
    inventory_no VARCHAR,
    PRIMARY KEY (functional_location)
); 

-- Setup the environment variable `ECC_FLOC_XLS_PATH` before running this file
SELECT getenv('ECC_FLOC_XLS_PATH') AS ECC_FLOC_XLS_PATH;


.print 'Loading ecc_floc...'


INSERT INTO ecc_floc BY NAME
SELECT
    t."Functional Loc." AS functional_location,
    t."Description" AS description,
    t."Planning plant" as planning_plant,
    t."System status" AS system_status,
    t."Start-up Date" AS startup_date,
    t."Work center" AS work_center,
    t."MaintPlant" AS maint_plant,
    t."FunctLocCat." AS floc_category,
    t."Inventory no." AS inventory_no,
FROM read_sheet(  
    getenv('ECC_FLOC_XLS_PATH'),
    error_as_null = true) t
WHERE t."Functional Loc." IS NOT NULL;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ecc_floc) TO '$(ECC_FLOC_OUTPATH)' (FORMAT parquet, COMPRESSION uncompressed);


