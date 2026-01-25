
CREATE OR REPLACE VIEW masterdata_landing.vw_plant_equipment AS
SELECT 
    t."PlantEquipReference" AS pli_num,
    t."PlantReference" AS sai_num,
    t."PlantCommonName" AS common_name,
    NULL AS installed_from_date,
    regexp_extract(t."PlantCommonName", '/([^/]*)$', 1) AS equi_name,
    t."PlantEquipManufacturer" AS manufacturer,
    t."PlantEquipModel" AS model,
    t."PlantEquipStatus" AS status,
    t."PlantEquipAssetTypeCode" AS equi_type_code,
    t."PlantEquipAssetTypeDescription" as equipment_type,
    coalesce(t."SubInstallationCommonName", t."InstallationCommonName") AS gen_installation_name,
    'Plant' as equi_sort,
FROM masterdata_landing.ai2_export_all t
WHERE 
    t."PlantEquipRuleDeleted" = '0'
AND t."PlantEquipReference" IS NOT NULL
GROUP BY ALL;

CREATE OR REPLACE VIEW masterdata_landing.vw_sub_plant_equipment AS
SELECT 
    t."SubPlantEquipReference" AS pli_num,
    t."SubPlantReference" AS sai_num,
    t."SubPlantCommonName" AS common_name,
    NULL AS installed_from_date,
    regexp_extract(t."SubPlantCommonName", '/([^/]*)$', 1) AS equi_name, 
    t."SubPlantEquipManufacturer" AS manufacturer,
    t."SubPlantEquipModel" AS model,
    t."SubPlantEquipStatus" AS status,
    t."SubPlantEquipAssetTypeCode" AS equi_type_code,
    t."SubPlantEquipAssetTypeDescription" as equipment_type,
    coalesce(t."SubInstallationCommonName", t."InstallationCommonName") AS gen_installation_name,
    'SubPlant' as equi_sort,
    FROM masterdata_landing.ai2_export_all t
WHERE 
    t."SubPlantEquipRuleDeleted" = '0'
AND t."SubPlantEquipReference" IS NOT NULL
GROUP BY ALL;

CREATE OR REPLACE VIEW masterdata_landing.vw_plant_item_equipment AS
SELECT 
    t."PlantItemEquipReference" AS pli_num,
    t."PlantItemReference" AS sai_num,
    "PlantItemCommonName" AS common_name,
    NULL AS installed_from_date,
    regexp_extract(t."PlantItemCommonName", '/([^/]*)$', 1) AS equi_name, 
    t."PlantItemEquipManufacturer" AS manufacturer,
    t."PlantItemEquipModel" AS model,
    t."PlantItemEquipStatus" AS status,
    t."PlantItemEquipAssetTypeCode" AS equi_type_code,
    t."PlantItemEquipAssetTypeDescription" as equipment_type,
    coalesce(t."SubInstallationCommonName", t."InstallationCommonName") AS gen_installation_name,
    'PlantItem' as equi_sort,
    FROM masterdata_landing.ai2_export_all t 
WHERE 
    t."PlantItemEquipRuleDeleted" = '0'
AND t."PlantItemEquipReference" IS NOT NULL
GROUP BY ALL;

CREATE OR REPLACE VIEW masterdata_landing.vw_sub_plant_item_equipment AS
SELECT 
    t."SubPlantItemEquipReference" AS pli_num,
    t."SubPlantItemReference" AS sai_num,
    t."SubPlantItemCommonName" AS common_name,
    NULL AS installed_from_date,
    regexp_extract(t."SubPlantItemCommonName", '/([^/]*)$', 1) AS equi_name, 
    t."SubPlantItemEquipManufacturer" AS manufacturer,
    t."SubPlantItemEquipModel" AS model,
    t."SubPlantItemEquipStatus" AS status,
    t."SubPlantItemEquipAssetTypeCode" AS equi_type_code,
    t."SubPlantItemEquipAssetTypeDescription" as equipment_type,
    coalesce(t."SubInstallationCommonName", t."InstallationCommonName") AS gen_installation_name,
    'SubPlantItem' as equi_sort,
FROM masterdata_landing.ai2_export_all t
WHERE 
    t."SubPlantItemEquipRuleDeleted" = '0'
AND t."SubPlantItemEquipReference" IS NOT NULL
GROUP BY ALL;


CREATE OR REPLACE VIEW masterdata_landing.vw_ai2_equipment_all AS
SELECT * FROM masterdata_landing.vw_plant_equipment
UNION BY NAME
SELECT * FROM masterdata_landing.vw_sub_plant_equipment
UNION BY NAME
SELECT * FROM masterdata_landing.vw_plant_item_equipment
UNION BY NAME
SELECT * FROM masterdata_landing.vw_sub_plant_item_equipment;


-- B->A
CREATE OR REPLACE VIEW masterdata_landing.vw_ai2_sub_plant_to_plant AS 
SELECT 
    t.pli_num AS pli_child,
    t.sai_num AS sai_child,
    t1."PlantEquipReference" AS pli_parent,
    t1."PlantReference" AS sai_parent, 
    'SubPlant_to_Plant' as reference_sort,
FROM masterdata_landing.vw_sub_plant_equipment t
JOIN masterdata_landing.ai2_export_all t1 ON t1."SubPlantEquipReference" = t.pli_num
WHERE t1."PlantEquipReference" IS NOT NULL;

-- D->C
CREATE OR REPLACE VIEW masterdata_landing.vw_ai2_sub_plant_item_to_plant_item AS 
SELECT 
    t.pli_num AS pli_child,
    t.sai_num AS sai_child,
    t1."PlantItemEquipReference" AS pli_parent,
    t1."PlantItemReference" AS sai_parent, 
    'SubPlantItem_to_PlantItem' as reference_sort,    
FROM masterdata_landing.vw_sub_plant_item_equipment t
JOIN masterdata_landing.ai2_export_all t1 ON t1."SubPlantItemEquipReference" = t.pli_num
WHERE t1."PlantItemEquipReference" IS NOT NULL;

-- C->A
CREATE OR REPLACE VIEW masterdata_landing.vw_ai2_plant_item_to_plant AS 
SELECT 
    t.pli_num AS pli_child,
    t.sai_num AS sai_child,
    t1."PlantEquipReference" AS pli_parent,
    t1."PlantReference" AS sai_parent, 
    'PlantItem_to_Plant' as reference_sort,
FROM masterdata_landing.vw_plant_item_equipment t
JOIN masterdata_landing.ai2_export_all t1 ON t1."PlantItemEquipReference" = t.pli_num
WHERE t1."PlantEquipReference" IS NOT NULL AND t1."SubPlantEquipReference" IS NULL;

-- C->B
CREATE OR REPLACE VIEW masterdata_landing.vw_ai2_plant_item_to_sub_plant AS 
SELECT 
    t.pli_num AS pli_child,
    t.sai_num AS sai_child,
    t1."SubPlantEquipReference" AS pli_parent,
    t1."SubPlantReference" AS sai_parent, 
    'PlantItem_to_SubPlant' as reference_sort,
FROM masterdata_landing.vw_plant_item_equipment t
JOIN masterdata_landing.ai2_export_all t1 ON t1."PlantItemEquipReference" = t.pli_num
WHERE t1."SubPlantEquipReference" IS NOT NULL;

-- D->A
CREATE OR REPLACE VIEW masterdata_landing.vw_ai2_sub_plant_item_to_plant AS 
SELECT 
    t.pli_num AS pli_child,
    t.sai_num AS sai_child,
    t1."PlantEquipReference" AS pli_parent,
    t1."PlantReference" AS sai_parent, 
    'SubPlantItem_to_Plant' as reference_sort,
FROM masterdata_landing.vw_sub_plant_item_equipment t
JOIN masterdata_landing.ai2_export_all t1 ON t1."SubPlantItemEquipReference" = t.pli_num
WHERE t1."PlantEquipReference" IS NOT NULL;



CREATE OR REPLACE VIEW masterdata_landing.vw_ai2_parent_references AS
SELECT * FROM masterdata_landing.vw_ai2_sub_plant_to_plant
UNION BY NAME
SELECT * FROM masterdata_landing.vw_ai2_sub_plant_item_to_plant_item
UNION BY NAME
SELECT * FROM masterdata_landing.vw_ai2_plant_item_to_plant
UNION BY NAME
SELECT * FROM masterdata_landing.vw_ai2_plant_item_to_sub_plant
UNION BY NAME
SELECT * FROM masterdata_landing.vw_ai2_sub_plant_item_to_plant;



