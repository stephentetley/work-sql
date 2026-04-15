.print 'Running ai2_asset_hierarchy.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;


CREATE SCHEMA IF NOT EXISTS ai2_masterdata;
CREATE SCHEMA IF NOT EXISTS landing;

-- ## CREATE TABLE

CREATE OR REPLACE TABLE ai2_masterdata.equi (
    -- e.g. 'PLI00123456'
    pli_number VARCHAR NOT NULL,
    -- e.g. 'LCC'
    equipment_name VARCHAR NOT NULL,
    -- e.g. 'EQUIPMENT: PENSTOCK'
    equi_type_name VARCHAR,
    -- e.g. 'EQPTMVNR'
    equi_type_code VARCHAR,
    -- e.g. '2017-09-12'
    installed_from_date DATE,
    -- e.g. 'UNKNOWN MANUFACTURER'
    manufacturer VARCHAR,
    -- e.g. 'UNSPECIFIED'
    model VARCHAR,
    -- e.g. 'OPERATIONAL'
    user_status VARCHAR,
    -- e.g. 'SITENAME/SPS/CONTROL SERVICES/PLC CONTROL/LCC' 
    common_name VARCHAR,
    -- e.g. 'SITENAME/SPS'
    site_or_installation_name VARCHAR,
    -- e.g. 'SAI00123456'
    sai_number VARCHAR,
    -- e.g. 'PLI00012345'
    superequi_id VARCHAR,
    PRIMARY KEY (pli_number)
);    
    

-- For dates on or after 1899-12-30, Sqlserver's date string format is 
-- `hours:mins:secs.millis` where hours is always positive (or zero).
-- Dates before 1899-12-30 are stored as '%Y-%m-%d %H:%M:%S' 
-- e.g. '1898-01-01 00:00:00.000' 
-- 
CREATE OR REPLACE MACRO sqlserver_date(str) AS (
    coalesce(
        try(strptime(str::VARCHAR, '%Y-%m-%d %H:%M:%S.%g')::DATETIME),
        try(date_add(DATE '1899-12-30', INTERVAL (try_cast(regexp_extract(str::VARCHAR, '^(\d+):\d{2}:\d{2}', 1) AS BIGINT)) HOUR))
    )
);

-- ai2 export:
-- Read fixed set of columns and do multiple passes to keep 
-- memory usage low. Do no processing until the data is stored 
-- on disk otherwise we are getting out-of-memory memory issues

-- ## LOAD DATA

-- Setup the environment variable `AIB_MASTER_GLOBPATH` before running this file
SELECT getenv('AIB_MASTER_GLOBPATH') AS AIB_MASTER_GLOBPATH;


.print 'Loading landing.ai2_plant...'


CREATE OR REPLACE TABLE landing.ai2_plant AS
SELECT
    t."InstallationCommonName",
    t."SubInstallationCommonName",
    t."PlantEquipReference",
    t."PlantEquipInstalledFromDate",
    t."PlantReference",
    t."PlantCommonName",
    t."PlantEquipManufacturer",
    t."PlantEquipModel",
    t."PlantEquipStatus",
    t."PlantEquipAssetTypeCode",
    t."PlantEquipAssetTypeDescription",
FROM read_sheets(
    [getenv('AIB_MASTER_GLOBPATH')], 
    sheets=['Sheet1'], 
    error_as_null=true, nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
WHERE
    t."PlantEquipRuleDeleted" = '0'
AND t."PlantEquipReference" IS NOT NULL;


.print 'Loading landing.ai2_sub_plant...'

CREATE OR REPLACE TABLE landing.ai2_sub_plant AS
SELECT
    t."InstallationCommonName",
    t."SubInstallationCommonName",
    t."SubPlantEquipReference",
    t."SubPlantEquipInstalledFromDate",
    t."SubPlantReference",
    t."SubPlantCommonName",
    t."SubPlantEquipManufacturer",
    t."SubPlantEquipModel",
    t."SubPlantEquipStatus",
    t."SubPlantEquipAssetTypeCode",
    t."SubPlantEquipAssetTypeDescription",
    t."PlantEquipReference",
FROM read_sheets(
    [getenv('AIB_MASTER_GLOBPATH')], 
    sheets=['Sheet1'], 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
WHERE
    t."SubPlantEquipRuleDeleted" = '0'
AND t."SubPlantEquipReference" IS NOT NULL;

.print 'Loading landing.ai2_plant_item...'

CREATE OR REPLACE TABLE landing.ai2_plant_item AS
SELECT
    t."InstallationCommonName",
    t."SubInstallationCommonName",
    t."PlantItemEquipReference",
    t."PlantItemEquipInstalledFromDate",
    t."PlantItemReference",
    t."PlantItemCommonName",
    t."PlantItemEquipManufacturer",
    t."PlantItemEquipModel",
    t."PlantItemEquipStatus",
    t."PlantItemEquipAssetTypeCode",
    t."PlantItemEquipAssetTypeDescription",
    t."PlantEquipReference",
    t."SubPlantEquipReference",
FROM read_sheets(
    [getenv('AIB_MASTER_GLOBPATH')], 
    sheets=['Sheet1'], 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
WHERE
    t."PlantItemEquipRuleDeleted" = '0'
AND t."PlantItemEquipReference" IS NOT NULL;


.print 'Loading landing.ai2_sub_plant_item...'

CREATE OR REPLACE TABLE landing.ai2_sub_plant_item AS
SELECT
    t."InstallationCommonName",
    t."SubInstallationCommonName",
    t."SubPlantItemEquipReference",
    t."SubPlantItemEquipInstalledFromDate",
    t."SubPlantItemReference",
    t."SubPlantItemCommonName",
    t."SubPlantItemEquipManufacturer",
    t."SubPlantItemEquipModel",
    t."SubPlantItemEquipStatus",
    t."SubPlantItemEquipAssetTypeCode",
    t."SubPlantItemEquipAssetTypeDescription",
    t."PlantEquipReference",
    t."SubPlantEquipReference",
    t."PlantItemEquipReference",
FROM read_sheets(
    [getenv('AIB_MASTER_GLOBPATH')],
    sheets=['Sheet1'], 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
WHERE
    t."SubPlantItemEquipRuleDeleted" = '0'
AND t."SubPlantItemEquipReference" IS NOT NULL;


-- ai2

DELETE FROM ai2_masterdata.equi;

-- insert part 1
.print 'Inserting ai2_plant data into masterdata.ai2_equipment...'

INSERT OR REPLACE INTO ai2_masterdata.equi BY NAME
SELECT 
    t."PlantEquipReference" AS pli_number,
    regexp_extract(t."PlantCommonName", '/([^/]*)$', 1) AS equipment_name,
    t."PlantEquipAssetTypeDescription" as equi_type_name,
    t."PlantEquipAssetTypeCode" AS equi_type_code,
    sqlserver_date(t."PlantEquipInstalledFromDate") AS installed_from_date,
    t."PlantEquipManufacturer" AS manufacturer,
    t."PlantEquipModel" AS model,
    t."PlantEquipStatus" AS user_status,
    t."PlantCommonName" AS common_name,
    coalesce(t."SubInstallationCommonName", t."InstallationCommonName") AS site_or_installation_name,
    t."PlantReference" AS sai_number,
    NULL AS superequi_id,
FROM landing.ai2_plant t;

-- insert part 2    
.print 'Inserting ai2_sub_plant data into ai2_masterdata.equi...'

INSERT OR REPLACE INTO ai2_masterdata.equi BY NAME
SELECT 
    t."SubPlantEquipReference" AS pli_number,
    regexp_extract(t."SubPlantCommonName", '/([^/]*)$', 1) AS equipment_name,
    t."SubPlantEquipAssetTypeDescription" as equi_type_name,
    t."SubPlantEquipAssetTypeCode" AS equi_type_code,
    sqlserver_date(t."SubPlantEquipInstalledFromDate") AS installed_from_date,
    t."SubPlantEquipManufacturer" AS manufacturer,
    t."SubPlantEquipModel" AS model,
    t."SubPlantEquipStatus" AS user_status,
    t."SubPlantCommonName" AS common_name,
    coalesce(t."SubInstallationCommonName", t."InstallationCommonName") AS site_or_installation_name,
    t."SubPlantReference" AS sai_number,
    t."PlantEquipReference" AS superequi_id,
FROM landing.ai2_sub_plant t;


-- insert part 3  
.print 'Inserting ai2_plant_item data into ai2_masterdata.equi...'

INSERT OR REPLACE INTO ai2_masterdata.equi BY NAME
SELECT 
    t."PlantItemEquipReference" AS pli_number,
    regexp_extract(t."PlantItemCommonName", '/([^/]*)$', 1) AS equipment_name,
    t."PlantItemEquipAssetTypeDescription" as equi_type_name,
    t."PlantItemEquipAssetTypeCode" AS equi_type_code,
    sqlserver_date(t."PlantItemEquipInstalledFromDate") AS installed_from_date,
    t."PlantItemEquipManufacturer" AS manufacturer,
    t."PlantItemEquipModel" AS model,
    t."PlantItemEquipStatus" AS user_status,
    t."PlantItemCommonName" AS common_name,
    coalesce(t."SubInstallationCommonName", t."InstallationCommonName") AS site_or_installation_name,
    t."PlantItemReference" AS sai_number,
    t."PlantEquipReference" AS superequi_id,
FROM landing.ai2_plant_item t;

-- insert part 4 
.print 'Inserting ai2_sub_plant_item data into ai2_masterdata.equi...'

INSERT OR REPLACE INTO ai2_masterdata.equi BY NAME
SELECT 
    t."SubPlantItemEquipReference" AS pli_number,
    regexp_extract(t."SubPlantItemCommonName", '/([^/]*)$', 1) AS equipment_name,
    t."SubPlantItemEquipAssetTypeDescription" as equi_type_name,
    t."SubPlantItemEquipAssetTypeCode" AS equi_type_code,
    sqlserver_date(t."SubPlantItemEquipInstalledFromDate") AS installed_from_date,
    t."SubPlantItemEquipManufacturer" AS manufacturer,
    t."SubPlantItemEquipModel" AS model,
    t."SubPlantItemEquipStatus" AS user_status,
    t."SubPlantItemCommonName" AS common_name,
    coalesce(t."SubInstallationCommonName", t."InstallationCommonName") AS site_or_installation_name,
    t."SubPlantItemReference" AS sai_number,
    t."PlantItemEquipReference" AS superequi_id,
FROM landing.ai2_sub_plant_item t;



-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ai2_masterdata.equi) TO '$(AIB_MASTER_OUTPATH)' (FORMAT parquet, COMPRESSION uncompressed);

