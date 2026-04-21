.print 'Running ai2_masterdata.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

-- ## CREATE TABLE



CREATE OR REPLACE TABLE ai2_equi (
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

CREATE OR REPLACE TABLE ai2_floc (
    -- e.g. 'SAI00123456'
    sai_number VARCHAR NOT NULL,
    -- e.g. 'WATERFALL/WPS'
    common_name VARCHAR,
    -- e.g. 'OPERATIONAL'
    user_status VARCHAR,
    -- e.g. 'WATER SERVICES'
    type_decription VARCHAR,
    -- e.g. 'SAI00123456'
    parent_ref VARCHAR,
    -- derived, one of 'INSTALLATION' | 'SUB_INSTALLATION' | 'PROCESS_GROUP' | 'PROCESS'
    floc_source_type VARCHAR NOT NULL,
    PRIMARY KEY (sai_number)
);  

CREATE OR REPLACE TABLE ai2_site_simple (
    -- e.g. 'SAI00123456'
    sai_number VARCHAR NOT NULL,
    -- e.g. 'BRUNSWICK COMPLEX'
    site_name VARCHAR NOT NULL,
    PRIMARY KEY (sai_number)
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

-- Setup the environment variable `AIB_MASTERDATA_SRCPATH` before running this file
SELECT getenv('AIB_MASTERDATA_SRCPATH') AS AIB_MASTERDATA_SRCPATH;




CREATE OR REPLACE TABLE ai2_plant_landing AS
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
FROM read_sheet(
    getenv('AIB_MASTERDATA_SRCPATH'), 
    sheet='Sheet1', 
    error_as_null=true, nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
WHERE
    t."PlantEquipRuleDeleted" = '0'
AND t."PlantEquipReference" IS NOT NULL;


.print 'Loading ai2_sub_plant_landing...'

CREATE OR REPLACE TABLE ai2_sub_plant_landing AS
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
FROM read_sheet(
    getenv('AIB_MASTERDATA_SRCPATH'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
WHERE
    t."SubPlantEquipRuleDeleted" = '0'
AND t."SubPlantEquipReference" IS NOT NULL;

.print 'Loading ai2_plant_item_landing...'

CREATE OR REPLACE TABLE ai2_plant_item_landing AS
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
FROM read_sheet(
    getenv('AIB_MASTERDATA_SRCPATH'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
WHERE
    t."PlantItemEquipRuleDeleted" = '0'
AND t."PlantItemEquipReference" IS NOT NULL;


.print 'Loading ai2_sub_plant_item_landing...'

CREATE OR REPLACE TABLE ai2_sub_plant_item_landing AS
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
FROM read_sheet(
    getenv('AIB_MASTERDATA_SRCPATH'),
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
WHERE
    t."SubPlantItemEquipRuleDeleted" = '0'
AND t."SubPlantItemEquipReference" IS NOT NULL;


.print 'Loading ai2_site_landing...'


CREATE OR REPLACE TABLE ai2_site_landing AS
SELECT
    t."SiteReference",
    t."SiteCommonName",
FROM read_sheet(
    getenv('AIB_MASTERDATA_SRCPATH'), 
    sheet='Sheet1', 
    error_as_null=true, nulls=['NULL'], 
    columns={'*': 'varchar'}) t
WHERE
    t."SiteReference" IS NOT NULL
AND t."SiteCommonName" IS NOT NULL;



.print 'Loading ai2_installation_landing...'

CREATE OR REPLACE TABLE ai2_installation_landing AS
SELECT
    t."InstallationReference",
    t."InstallationCommonName",
    t."InstallationStatus",
    t."InstallationTypeDescription",
FROM read_sheet(
    getenv('AIB_MASTERDATA_SRCPATH'),
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
WHERE
    t."InstallationReference" IS NOT NULL;

.print 'Loading ai2_sub_installation_landing...'

CREATE OR REPLACE TABLE ai2_sub_installation_landing AS
SELECT
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."SubInstallationStatus",
    t."SubInstallationTypeDescription",
    t."InstallationReference" AS "ParentRef",
FROM read_sheet(
    getenv('AIB_MASTERDATA_SRCPATH'),
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
WHERE
    t."SubInstallationReference" IS NOT NULL;

.print 'Loading ai2_process_group_landing...'

CREATE OR REPLACE TABLE ai2_process_group_landing AS
SELECT
    t."ProcessGroupReference",
    coalesce(t."SubInstallationCommonName", t."InstallationCommonName") || '/' || t."ProcessGroupAssetTypeDescription" AS "CommonName",
    t."ProcessGroupStatus",
    t."ProcessGroupAssetTypeDescription",
    coalesce(t."SubInstallationReference", t."InstallationReference") AS "ParentRef",
FROM read_sheet(
    getenv('AIB_MASTERDATA_SRCPATH'),
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
WHERE
    t."ProcessGroupReference" IS NOT NULL;

CREATE OR REPLACE TABLE ai2_process_landing AS
SELECT
    t."ProcessReference",
    coalesce(t."SubInstallationCommonName", t."InstallationCommonName") 
        || '/' 
        || if(t."ProcessGroupAssetTypeDescription" IS NULL, '', (t."ProcessGroupAssetTypeDescription" || '/'))
        || t."ProcessAssetTypeDescription" AS "CommonName",
    t."ProcessStatus",
    t."ProcessAssetTypeDescription",
    coalesce(t."ProcessGroupReference", t."SubInstallationReference", t."InstallationReference") AS "ParentRef",
FROM read_sheet(
    getenv('AIB_MASTERDATA_SRCPATH'),
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
WHERE
    t."ProcessReference" IS NOT NULL;

-------------------------------------------------------------------------------
-- final tables

-- ai2_equi

DELETE FROM ai2_equi;

-- insert part 1
.print 'Inserting ai2_plant data into ai2_equi...'

INSERT OR REPLACE INTO ai2_equi BY NAME
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
FROM ai2_plant_landing t;

-- insert part 2    
.print 'Inserting ai2_sub_plant data into ai2_equi...'

INSERT OR REPLACE INTO ai2_equi BY NAME
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
FROM ai2_sub_plant_landing t;


-- insert part 3  
.print 'Inserting ai2_plant_item data into ai2_equi...'

INSERT OR REPLACE INTO ai2_equi BY NAME
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
FROM ai2_plant_item_landing t;

-- insert part 4 
.print 'Inserting ai2_sub_plant_item data into ai2_equi...'

INSERT OR REPLACE INTO ai2_equi BY NAME
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
FROM ai2_sub_plant_item_landing t;



-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ai2_equi) TO '$(AIB_MASTER_OUTPATH)' (FORMAT parquet, COMPRESSION uncompressed);


-- ai2_floc

DELETE FROM ai2_floc;


.print 'Inserting installation data into ai2_floc...'

INSERT OR REPLACE INTO ai2_floc BY NAME
SELECT 
    t."InstallationReference" AS sai_number,
    any_value(t."InstallationCommonName") AS common_name,
    any_value(t."InstallationStatus") as user_status,
    any_value(t."InstallationTypeDescription") AS type_decription,
    NULL AS parent_ref,
    'INSTALLATION' AS floc_source_type
FROM ai2_installation_landing t
GROUP BY t."InstallationReference";



.print 'Inserting sub_installation data into ai2_floc...'

INSERT OR REPLACE INTO ai2_floc BY NAME
SELECT 
    t."SubInstallationReference" AS sai_number,
    any_value(t."SubInstallationCommonName") AS common_name,
    any_value(t."SubInstallationStatus") as user_status,
    any_value(t."SubInstallationTypeDescription") AS type_decription,
    any_value(t."ParentRef") AS parent_ref,
    'SUB_INSTALLATION' AS floc_source_type
FROM ai2_sub_installation_landing t
GROUP BY t."SubInstallationReference";

.print 'Inserting process_group data into ai2_floc...'

INSERT OR REPLACE INTO ai2_floc BY NAME
SELECT 
    t."ProcessGroupReference" AS sai_number,
    any_value(t."CommonName") AS common_name,
    any_value(t."ProcessGroupStatus") as user_status,
    any_value(t."ProcessGroupAssetTypeDescription") AS type_decription,
    any_value(t."ParentRef") AS parent_ref,
    'PROCESS_GROUP' AS floc_source_type
FROM ai2_process_group_landing t
GROUP BY t."ProcessGroupReference";

.print 'Inserting process data into ai2_floc...'

INSERT OR REPLACE INTO ai2_floc BY NAME
SELECT 
    t."ProcessReference" AS sai_number,
    any_value(t."CommonName") AS common_name,
    any_value(t."ProcessStatus") as user_status,
    any_value(t."ProcessAssetTypeDescription") AS type_decription,
    any_value(t."ParentRef") AS parent_ref,
    'PROCESS' AS floc_source_type
FROM ai2_process_landing t
GROUP BY t."ProcessReference";

-- ai2_site 

-- Source has duplicates

INSERT OR REPLACE INTO ai2_site_simple BY NAME
SELECT 
    t."SiteReference" AS sai_number,
    any_value(t."SiteCommonName") AS site_name,
FROM ai2_site_landing t
GROUP BY t."SiteReference";
 
