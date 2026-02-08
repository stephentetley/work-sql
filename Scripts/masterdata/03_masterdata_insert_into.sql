.print 'Running 03_masterdata_insert_into.sql...'

DELETE FROM masterdata.s4_equipment;
INSERT OR REPLACE INTO masterdata.s4_equipment BY NAME
SELECT 
    try_cast(t."Equipment" AS BIGINT) AS equipment_id,
    t."Description of technical object" AS equipment_name,
    t."Functional Location" AS functional_location,
    try_cast(t."Superord. Equipment" AS BIGINT) AS superequi_id,
    t."Equipment category" AS category,
    t."Object Type" AS obj_type,
    t."Standard Class" AS std_class,
    try(strptime(t."Start-up date", '%Y-%m-%d')::DATE) AS startup_date,
    t."Manufacturer of Asset" AS manufacturer,
    t."Model number" AS model,
    t."Manufacturer part number" AS specific_model_frame,
    t."Manufacturer's Serial Number" AS serial_number,
    t."Technical identification no." AS tech_ident_number,
    t."User Status" AS user_status,
    t."Planning Plant" AS planning_plant,
    try_cast(t."Address number" AS INTEGER) AS address_number,
FROM masterdata_landing.s4_equi_data t;


DELETE FROM masterdata.s4_to_plinum;
INSERT INTO masterdata.s4_to_plinum BY NAME
SELECT 
    t."Equipment" AS s4_equipment_id,
    t."AI2 AIB Reference" AS ai2_plinum,
FROM masterdata_landing.s4_equi_aib_refs_data t
WHERE t."AI2 AIB Reference" LIKE 'PLI%';

DELETE FROM masterdata.s4_to_sainum;
INSERT INTO masterdata.s4_to_sainum BY NAME
SELECT 
    t."Equipment" AS s4_equipment_id,
    t."AI2 AIB Reference" AS ai2_sainum,
FROM masterdata_landing.s4_equi_aib_refs_data t
WHERE t."AI2 AIB Reference" IS NOT NULL
AND t."AI2 AIB Reference" NOT LIKE 'PLI%';



DELETE FROM masterdata.ai2_equipment;

-- insert part 1
INSERT OR REPLACE INTO masterdata.ai2_equipment BY NAME
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
    'Plant' as equi_sort,
FROM masterdata_landing.ai2_plant t;

-- insert part 2    
INSERT OR REPLACE INTO masterdata.ai2_equipment BY NAME
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
    'SubPlant' as equi_sort,
FROM masterdata_landing.ai2_sub_plant t;

-- insert part 3    
INSERT OR REPLACE INTO masterdata.ai2_equipment BY NAME
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
    'PlantItem' as equi_sort,
FROM masterdata_landing.ai2_plant_item t;

-- insert part 3    
INSERT OR REPLACE INTO masterdata.ai2_equipment BY NAME
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
    'PlantItem' as equi_sort,
FROM masterdata_landing.ai2_sub_plant_item t;

-- DELETE FROM masterdata.ai2_parent_references;
-- INSERT OR REPLACE INTO masterdata.ai2_parent_references BY NAME
-- SELECT 
--     t."pli_child" AS child_pli_number,
--     t."sai_child" AS child_sai_number,
--     t."pli_parent" AS parent_pli_number,
--     t."sai_parent" AS parent_sai_number,
--     t."reference_sort" AS reference_sort,
-- FROM masterdata_landing.vw_ai2_parent_references t;
