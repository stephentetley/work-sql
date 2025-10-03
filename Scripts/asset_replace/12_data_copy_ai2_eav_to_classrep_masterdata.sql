-- Prelude - copy from the input data...

DELETE FROM ai2_eav.equipment_masterdata;
INSERT OR IGNORE INTO ai2_eav.equipment_masterdata BY NAME
SELECT
    t.* EXCLUDE (hierarchy_key, asset_in_aide),
FROM ai2_landing.masterdata t;


DELETE FROM ai2_eav.equipment_eav;
INSERT INTO ai2_eav.equipment_eav BY NAME
SELECT
    t.*,
FROM ai2_landing.eavdata t;




-- Now do the classrep stuff...



DELETE FROM ai2_classrep.equi_masterdata;
INSERT OR IGNORE INTO ai2_classrep.equi_masterdata BY NAME
SELECT 
    t.ai2_reference AS ai2_reference,
    t.common_name AS common_name,
    regexp_extract(t.common_name, '.*/([^[/]+)/EQUIPMENT:', 1) AS item_name,
    regexp_extract(t.common_name, '.*/(EQUIPMENT: .*)$', 1) AS equipment_type,
    (t.installed_from:: DATE) AS installed_from,
    TRY_CAST(eav4.attr_value AS DECIMAL) AS weight_kg,
    t.manufacturer AS manufacturer,
    t.model AS model,
    eav1.attr_value AS specific_model_frame,
    eav2.attr_value AS serial_number,
    t.asset_status AS asset_status,
    t.loc_ref AS grid_ref,
    eav3.attr_value AS pandi_tag,
FROM ai2_eav.equipment_masterdata AS t
LEFT JOIN ai2_eav.equipment_eav eav1 ON eav1.ai2_reference = t.ai2_reference AND eav1.attr_name = 'Specific Model/Frame'
LEFT JOIN ai2_eav.equipment_eav eav2 ON eav2.ai2_reference = t.ai2_reference AND eav2.attr_name = 'Serial No'
LEFT JOIN ai2_eav.equipment_eav eav3 ON eav3.ai2_reference = t.ai2_reference AND eav3.attr_name = 'P AND I Tag No'
LEFT JOIN ai2_eav.equipment_eav eav4 ON eav4.ai2_reference = t.ai2_reference AND eav4.attr_name = 'Weight kg'
;



-- equi_equi_id is the key field..
DELETE FROM ai2_classrep.ai2_to_s4_mapping;
INSERT INTO ai2_classrep.ai2_to_s4_mapping BY NAME
SELECT
    t.equi_equi_id AS equi_equi_id,
    t.operational_AI2_record_pli AS ai2_reference,
    t.ai2_parent_sai AS ai2_parent_reference,
    t.existing_s4_record AS s4_equi_id,
    t.s4_name AS s4_description,
    t.s4_category AS s4_category,
    t.s4_object_type AS s4_object_type,
    t.s4_class AS s4_class,
    t.s4_floc AS s4_floc,
    t.s4_superord_equi AS s4_superord_equi,
    TRY_CAST(t.s4_position AS INTEGER) AS s4_position,
    t.solution_id AS solution_id,
FROM ai2_landing.worklist t; 
    


DELETE FROM ai2_classrep.equi_memo_line;
INSERT OR IGNORE INTO ai2_classrep.equi_memo_line BY NAME
WITH cte AS (
PIVOT ai2_eav.equipment_eav 
ON attr_name IN ("Memo Line 1", "Memo Line 2", "Memo Line 3", "Memo Line 4", "Memo Line 5")
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT
    ai2_reference,
    "Memo Line 1" AS memo_line_1,
    "Memo Line 2" AS memo_line_2,
    "Memo Line 3" AS memo_line_3,
    "Memo Line 4" AS memo_line_4,
    "Memo Line 5" AS memo_line_5,
FROM cte;


DELETE FROM ai2_classrep.equi_agasp;
INSERT OR IGNORE INTO ai2_classrep.equi_agasp BY NAME
SELECT 
    t.ai2_reference AS ai2_reference,
    eav1.attr_value AS comments,
    eav2.attr_value AS condition_grade,
    eav3.attr_value AS condition_grade_reason,
    eav4.attr_value AS exclude_from_survey,
    eav5.attr_value AS loading_factor,
    eav6.attr_value AS loading_factor_reason,
    eav7.attr_value AS other_details,
    eav8.attr_value AS performance_grade,
    eav9.attr_value AS performance_grade_reason,
    eav10.attr_value AS reason_for_change,
    eav11.attr_value AS survey_date,
    eav12.attr_value AS survey_year,
    eav13.attr_value AS updated_using,
FROM ai2_eav.equipment_masterdata AS t
LEFT JOIN ai2_eav.equipment_eav eav1 ON eav1.ai2_reference = t.ai2_reference AND eav1.attr_name = 'AGASP Comments'
LEFT JOIN ai2_eav.equipment_eav eav2 ON eav2.ai2_reference = t.ai2_reference AND eav2.attr_name = 'Condition Grade'
LEFT JOIN ai2_eav.equipment_eav eav3 ON eav3.ai2_reference = t.ai2_reference AND eav3.attr_name = 'Condition Grade Reason'
LEFT JOIN ai2_eav.equipment_eav eav4 ON eav4.ai2_reference = t.ai2_reference AND eav4.attr_name = 'set_to_true_for_assets_to_be_excluded_from_survey'
LEFT JOIN ai2_eav.equipment_eav eav5 ON eav5.ai2_reference = t.ai2_reference AND eav5.attr_name = 'loading_factor'
LEFT JOIN ai2_eav.equipment_eav eav6 ON eav6.ai2_reference = t.ai2_reference AND eav6.attr_name = 'loading_factor_reason'
LEFT JOIN ai2_eav.equipment_eav eav7 ON eav7.ai2_reference = t.ai2_reference AND eav7.attr_name = 'agasp_other_details'
LEFT JOIN ai2_eav.equipment_eav eav8 ON eav8.ai2_reference = t.ai2_reference AND eav8.attr_name = 'performance_grade'
LEFT JOIN ai2_eav.equipment_eav eav9 ON eav9.ai2_reference = t.ai2_reference AND eav9.attr_name = 'performance_grade_reason'
LEFT JOIN ai2_eav.equipment_eav eav10 ON eav10.ai2_reference = t.ai2_reference AND eav10.attr_name = 'reason_for_change'
LEFT JOIN ai2_eav.equipment_eav eav11 ON eav11.ai2_reference = t.ai2_reference AND eav11.attr_name = 'agasp_survey_date'
LEFT JOIN ai2_eav.equipment_eav eav12 ON eav12.ai2_reference = t.ai2_reference AND eav12.attr_name = 'AGASP Survey Year'
LEFT JOIN ai2_eav.equipment_eav eav13 ON eav13.ai2_reference = t.ai2_reference AND eav13.attr_name = 'updated_using'
;


