CREATE OR REPLACE VIEW ai2_landing.vw_plant_equipment AS
SELECT 
    coalesce("SubInstallationCommonName", "InstallationCommonName") AS gen_installation_name,
    "PlantEquipReference" AS pli_num,
    "PlantReference" AS sai_num,
    "PlantCommonName" AS common_name,
    try_cast(excel_text(try_cast("PlantEquipInstalledFromDate" AS DECIMAL), 'yyyy-mm-dd') AS DATE) AS installed_from_date,
    "PlantCommonName"[1 + instr("PlantCommonName", "ProcessAssetTypeDescription") + len("ProcessAssetTypeDescription"):] AS equi_name, 
    "PlantEquipManufacturer" AS manufacturer,
    "PlantEquipModel" AS model,
    "PlantEquipStatus" AS status,
    "PlantEquipCategory" AS ai2_equi_category,
    "PlantEquipAssetTypeCode" AS equi_type_code,
    "PlantEquipAssetTypeDescription" as equipment_type,
    'Plant Equipment' AS derivation,
FROM ai2_landing.assets_all
WHERE 
    "PlantEquipRuleDeleted" = '0'
AND "PlantEquipReference" IS NOT NULL;

CREATE OR REPLACE VIEW ai2_landing.vw_sub_plant_equipment AS
SELECT 
    coalesce("SubInstallationCommonName", "InstallationCommonName") AS gen_installation_name,
    "SubPlantEquipReference" AS pli_num,
    "SubPlantReference" AS sai_num,
    "SubPlantCommonName" AS common_name,
    try_cast(excel_text(try_cast("SubPlantEquipInstalledFromDate" AS DECIMAL), 'yyyy-mm-dd') AS DATE) AS installed_from_date,
    "SubPlantCommonName"[1 + instr("SubPlantCommonName", "ProcessAssetTypeDescription") + len("ProcessAssetTypeDescription"):] AS equi_name, 
    "SubPlantEquipManufacturer" AS manufacturer,
    "SubPlantEquipModel" AS model,
    "SubPlantEquipStatus" AS status,
    "SubPlantEquipCategory" AS ai2_equi_category,
    "SubPlantEquipAssetTypeCode" AS equi_type_code,
    "SubPlantEquipAssetTypeDescription" as equipment_type,
    'Sub-Plant Equipment' AS derivation,
FROM ai2_landing.assets_all
WHERE 
    "SubPlantEquipRuleDeleted" = '0'
AND "SubPlantEquipReference" IS NOT NULL;


CREATE OR REPLACE VIEW ai2_landing.vw_plant_item_equipment AS
SELECT 
    coalesce("SubInstallationCommonName", "InstallationCommonName") AS gen_installation_name,
    "PlantItemEquipReference" AS pli_num,
    "PlantItemReference" AS sai_num,
    "PlantItemCommonName" AS common_name,
    try_cast(excel_text(try_cast("PlantItemEquipInstalledFromDate" AS DECIMAL), 'yyyy-mm-dd') AS DATE) AS installed_from_date,
    "PlantItemCommonName"[1 + instr("PlantItemCommonName", "ProcessAssetTypeDescription") + len("ProcessAssetTypeDescription"):] AS equi_name, 
    "PlantItemEquiManufacturer" AS manufacturer,
    "PlantItemEquipModel" AS model,
    "PlantItemEquipStatus" AS status,
    "PlantItemEquipCategory" AS ai2_equi_category,
    "PlantItemEquipAssetTypeCode" AS equi_type_code,
    "PlantItemEquipAssetTypeDescription" as equipment_type,
    'Plant Item Equipment' AS derivation,
FROM ai2_landing.assets_all
WHERE 
    "PlantItemEquipRuleDeleted" = '0'
AND "PlantItemEquipReference" IS NOT NULL;


CREATE OR REPLACE VIEW ai2_landing.vw_sub_plant_item_equipment AS
SELECT 
    coalesce("SubInstallationCommonName", "InstallationCommonName") AS gen_installation_name,
    "SubPlantItemEquipReference" AS pli_num,
    "SubPlantItemReference" AS sai_num,
    "SubPlantItemCommonName" AS common_name,
    try_cast(excel_text(try_cast("SubPlantItemEquipInstalledFromDate" AS DECIMAL), 'yyyy-mm-dd') AS DATE) AS installed_from_date,
    "SubPlantItemCommonName"[1 + instr("SubPlantItemCommonName", "ProcessAssetTypeDescription") + len("ProcessAssetTypeDescription"):] AS equi_name, 
    "SubPlantItemEquipManufacturer" AS manufacturer,
    "SubPlantItemEquipModel" AS model,
    "SubPlantItemEquipStatus" AS status,
    "SubPlantItemEquipCategory" AS ai2_equi_category,
    "SubPlantItemEquipAssetTypeCode" AS equi_type_code,
    "SubPlantItemEquipAssetTypeDescription" as equipment_type,
    'Sub-Plant Item Equipment' AS derivation,
FROM ai2_landing.assets_all
WHERE 
    "SubPlantItemEquipRuleDeleted" = '0'
AND "SubPlantItemEquipReference" IS NOT NULL;


CREATE OR REPLACE VIEW ai2_landing.vw_equipment_all AS
SELECT * FROM ai2_landing.vw_plant_equipment
UNION BY NAME
SELECT * FROM ai2_landing.vw_sub_plant_equipment
UNION BY NAME
SELECT * FROM ai2_landing.vw_plant_item_equipment
UNION BY NAME
SELECT * FROM ai2_landing.vw_sub_plant_item_equipment
;



SELECT COUNT(pli_num) FROM ai2_landing.vw_equipment_all;






