

DELETE FROM masterdata.s4_equipment;
INSERT INTO masterdata.s4_equipment BY NAME
SELECT 
    CAST(t."EQUIPMENT_NUMBER(EQUNR)" AS BIGINT) AS equipment_id,
    t."EQUIPMENT_DESC(EQKTX)" AS equipment_name,
    t."SUP_FUNCTIONAL_LOCATION(TPLNR)" AS functional_location,
    t."EQUIPMENT_CATEGORY(EQTYP)" AS category,
    t."TYPE_OF_TECHOBJECT(EQART)" AS obj_type,
    NULL AS startup_date,
    t."MANUFACTURER(HERST)" AS manufacturer,
    t."MANUFACTURER_MODEL_NUMBER(TYPBZ)" AS model,
    t."MANUFACTURER_PART_NUMBER(MAPAR)" AS specific_model_frame,
    t."MANUFACTURER_SERIAL_NUMBER(SERGE)" AS serial_number,
    t."USER_STATUS(TXT04)" AS user_status,
    t."CLASS" AS obj_class,
FROM masterdata_landing.s4_equi_all t;


DELETE FROM masterdata.s4_to_plinum;
INSERT INTO masterdata.s4_to_plinum BY NAME
SELECT 
    t."EQUIPMENT_NUMBER(EQUNR)" AS s4_equipment_id,
    t."CHARACTERISTIC_VALUE(ATWRT)" AS ai2_plinum,
FROM masterdata_landing.s4_aib_references t
WHERE t."CHARACTERISTIC(ATINN)" = 'AI2_AIB_REFERENCE' 
AND t."CHARACTERISTIC_VALUE(ATWRT)" LIKE 'PLI%';

DELETE FROM masterdata.s4_to_sainum;
INSERT INTO masterdata.s4_to_sainum BY NAME
SELECT 
    t."EQUIPMENT_NUMBER(EQUNR)" AS s4_equipment_id,
    t."CHARACTERISTIC_VALUE(ATWRT)" AS ai2_sainum,
FROM masterdata_landing.s4_aib_references t
WHERE t."CHARACTERISTIC(ATINN)" = 'AI2_AIB_REFERENCE' 
AND t."CHARACTERISTIC_VALUE(ATWRT)" NOT LIKE 'PLI%';



DELETE FROM masterdata.ai2_equipment;
INSERT OR REPLACE INTO masterdata.ai2_equipment BY NAME
SELECT 
    t."pli_num" AS pli_number,
    t."equi_name" AS equipment_name,
    replace(t."equipment_type", 'EQUIPMENT: ','') AS equi_type_name,
    t."equi_type_code" AS equi_type_code,
    NULL AS installed_from_data,
    t."manufacturer" AS manufacturer,
    t."model" AS model,
    t."status" AS user_status,
    t."common_name" AS common_name,
    t."gen_installation_name" AS site_or_installation_name,
FROM masterdata_landing.vw_equipment_all t;
    

