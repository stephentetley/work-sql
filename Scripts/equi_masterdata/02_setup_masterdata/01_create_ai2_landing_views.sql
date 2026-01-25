
CREATE OR REPLACE VIEW masterdata_landing.vw_plant_equipment AS
SELECT 
    coalesce("SubInstallationCommonName", "InstallationCommonName") AS gen_installation_name,
    "PlantEquipReference" AS pli_num,
    "PlantReference" AS sai_num,
    "PlantCommonName" AS common_name,
    NULL AS installed_from_date,
    regexp_extract("PlantCommonName", '/([^/]*)$', 1) AS equi_name,
    "PlantEquipManufacturer" AS manufacturer,
    "PlantEquipModel" AS model,
    "PlantEquipStatus" AS status,
    "PlantEquipAssetTypeCode" AS equi_type_code,
    "PlantEquipAssetTypeDescription" as equipment_type,
FROM masterdata_landing.ai2_export_all
WHERE 
    "PlantEquipRuleDeleted" = '0'
AND "PlantEquipReference" IS NOT NULL
GROUP BY ALL;

CREATE OR REPLACE VIEW masterdata_landing.vw_sub_plant_equipment AS
SELECT 
    coalesce("SubInstallationCommonName", "InstallationCommonName") AS gen_installation_name,
    "SubPlantEquipReference" AS pli_num,
    "SubPlantReference" AS sai_num,
    "SubPlantCommonName" AS common_name,
    NULL AS installed_from_date,
    regexp_extract("SubPlantCommonName", '/([^/]*)$', 1) AS equi_name, 
    "SubPlantEquipManufacturer" AS manufacturer,
    "SubPlantEquipModel" AS model,
    "SubPlantEquipStatus" AS status,
    "SubPlantEquipAssetTypeCode" AS equi_type_code,
    "SubPlantEquipAssetTypeDescription" as equipment_type,
    FROM masterdata_landing.ai2_export_all
WHERE 
    "SubPlantEquipRuleDeleted" = '0'
AND "SubPlantEquipReference" IS NOT NULL
GROUP BY ALL;

CREATE OR REPLACE VIEW masterdata_landing.vw_plant_item_equipment AS
SELECT 
    coalesce("SubInstallationCommonName", "InstallationCommonName") AS gen_installation_name,
    "PlantItemEquipReference" AS pli_num,
    "PlantItemReference" AS sai_num,
    "PlantItemCommonName" AS common_name,
    NULL AS installed_from_date,
    regexp_extract("PlantItemCommonName", '/([^/]*)$', 1) AS equi_name, 
    "PlantItemEquipManufacturer" AS manufacturer,
    "PlantItemEquipModel" AS model,
    "PlantItemEquipStatus" AS status,
    "PlantItemEquipAssetTypeCode" AS equi_type_code,
    "PlantItemEquipAssetTypeDescription" as equipment_type,
    FROM masterdata_landing.ai2_export_all
WHERE 
    "PlantItemEquipRuleDeleted" = '0'
AND "PlantItemEquipReference" IS NOT NULL
GROUP BY ALL;

CREATE OR REPLACE VIEW masterdata_landing.vw_sub_plant_item_equipment AS
SELECT 
    coalesce("SubInstallationCommonName", "InstallationCommonName") AS gen_installation_name,
    "SubPlantItemEquipReference" AS pli_num,
    "SubPlantItemReference" AS sai_num,
    "SubPlantItemCommonName" AS common_name,
    NULL AS installed_from_date,
    regexp_extract("SubPlantItemCommonName", '/([^/]*)$', 1) AS equi_name, 
    "SubPlantItemEquipManufacturer" AS manufacturer,
    "SubPlantItemEquipModel" AS model,
    "SubPlantItemEquipStatus" AS status,
    "SubPlantItemEquipAssetTypeCode" AS equi_type_code,
    "SubPlantItemEquipAssetTypeDescription" as equipment_type,
FROM masterdata_landing.ai2_export_all
WHERE 
    "SubPlantItemEquipRuleDeleted" = '0'
AND "SubPlantItemEquipReference" IS NOT NULL
GROUP BY ALL;


CREATE OR REPLACE VIEW masterdata_landing.vw_ai2_equipment_all AS
SELECT * FROM masterdata_landing.vw_plant_equipment
UNION BY NAME
SELECT * FROM masterdata_landing.vw_sub_plant_equipment
UNION BY NAME
SELECT * FROM masterdata_landing.vw_plant_item_equipment
UNION BY NAME
SELECT * FROM masterdata_landing.vw_sub_plant_item_equipment;

--
--
--SELECT COUNT(pli_num) FROM masterdata_landing.vw_equipment_all;


--DESCRIBE SELECT * FROM masterdata_landing.ai2_export_all;





