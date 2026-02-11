.print 'Running 01_load_export_data.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE SCHEMA IF NOT EXISTS masterdata_landing;

-- ai2 export:
-- Read fixed set of columns and do multiple passes to keep 
-- memory usage low. Do no processing until the data is stored 
-- on disk otherwise we are getting out-of-memory memory issues


.print 'Loading masterdata_landing.ai2_plant...'
SELECT getvariable('aib_master_globpath') AS aib_master_globpath;

CREATE OR REPLACE TABLE masterdata_landing.ai2_plant AS
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
FROM read_sheets([getvariable('aib_master_globpath')], sheets=['Sheet1'], error_as_null=true, nulls=['NULL'], columns={'*FromDate': 'varchar'}) t
WHERE
    t."PlantEquipRuleDeleted" = '0'
AND t."PlantEquipReference" IS NOT NULL;


.print 'Loading masterdata_landing.ai2_sub_plant...'

CREATE OR REPLACE TABLE masterdata_landing.ai2_sub_plant AS
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
FROM read_sheets([getvariable('aib_master_globpath')], sheets=['Sheet1'], error_as_null=true, nulls=['NULL'], columns={'*FromDate': 'varchar'}) t
WHERE
    t."SubPlantEquipRuleDeleted" = '0'
AND t."SubPlantEquipReference" IS NOT NULL;

.print 'Loading masterdata_landing.ai2_plant_item...'

CREATE OR REPLACE TABLE masterdata_landing.ai2_plant_item AS
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
FROM read_sheets([getvariable('aib_master_globpath')], sheets=['Sheet1'], error_as_null=true, nulls=['NULL'], columns={'*FromDate': 'varchar'}) t
WHERE
    t."PlantItemEquipRuleDeleted" = '0'
AND t."PlantItemEquipReference" IS NOT NULL;


.print 'Loading masterdata_landing.ai2_sub_plant_item...'

CREATE OR REPLACE TABLE masterdata_landing.ai2_sub_plant_item AS
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
FROM read_sheets([getvariable('aib_master_globpath')], sheets=['Sheet1'], error_as_null=true, nulls=['NULL'], columns={'*FromDate': 'varchar'}) t
WHERE
    t."SubPlantItemEquipRuleDeleted" = '0'
AND t."SubPlantItemEquipReference" IS NOT NULL;

.print 'Loading masterdata_landing.s4_floc_data...'
SELECT getvariable('floc_master_globpath') AS floc_master_globpath;


CREATE OR REPLACE TABLE masterdata_landing.s4_floc_data AS
SELECT 
    * 
FROM read_sheets(
    [getvariable('floc_master_globpath')], 
    sheets=['Sheet1'],
    columns={'Start-up date': 'varchar'}
);


.print 'Loading masterdata_landing.s4_equi_data...'
SELECT getvariable('equi_master_globpath') AS equi_master_globpath;


CREATE OR REPLACE TABLE masterdata_landing.s4_equi_data AS
SELECT 
    * 
FROM read_sheets(
    [getvariable('equi_master_globpath')], 
    sheets=['Sheet1'],
    columns={'Start-up date': 'varchar'}
);



.print 'Loading masterdata_landing.s4_equi_aib_refs_data...'
SELECT getvariable('equi_aib_globpath') AS equi_aib_globpath;

CREATE OR REPLACE TABLE masterdata_landing.s4_equi_aib_refs_data AS
SELECT 
    * 
FROM read_sheets(
    [getvariable('equi_aib_globpath')], 
    sheets=['Sheet1']
);



