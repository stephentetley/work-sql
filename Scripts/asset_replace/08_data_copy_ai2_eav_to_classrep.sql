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
;



-- category and object_type should be in worklist...
DELETE FROM ai2_classrep.ai2_to_s4_mapping;
INSERT INTO ai2_classrep.ai2_to_s4_mapping BY NAME
WITH cte AS (
SELECT DISTINCT ON (ai2_reference) 
    row_number() OVER () AS row_num,
    ai2_reference AS ai2_reference,
FROM ai2_classrep.equi_masterdata
)
SELECT 
    t.ai2_reference AS ai2_reference,
    t1."AI2 Parent (SAI number)" AS ai2_parent_reference,
    printf('$1%04d', t.row_num) AS s4_equi_id,
    t1."S4 Name" AS s4_description,
    t1."S4 Category" AS s4_category,
    t1."S4 Object Type" AS s4_object_type,
    t1."S4 Class" AS s4_class,
    t1."S4 Floc" AS s4_floc,
    t1."S4 Superord Equipment" AS s4_superord_equi,
    t1."S4 Position" AS s4_position,
FROM cte t
JOIN ai2_landing.worklist t1 ON t1."Operational AI2 record (PLI)" = t.ai2_reference
;

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





-- Needs a filter to only pick up 'MODEM'...
CREATE OR REPLACE MACRO classrep_modem() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: MODEM'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_modem;
INSERT OR IGNORE INTO ai2_classrep.equiclass_modem BY NAME
SELECT * FROM classrep_modem();

-- Needs a filter to only pick up 'NETWORK'...
CREATE OR REPLACE MACRO classrep_network() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: NETWORK'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_network;
INSERT OR IGNORE INTO ai2_classrep.equiclass_network BY NAME
SELECT * FROM classrep_network();


-- Needs a filter to only pick up 'POWER SUPPLY'...
CREATE OR REPLACE MACRO classrep_power_supply() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: POWER SUPPLY'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_power_supply;
INSERT OR IGNORE INTO ai2_classrep.equiclass_power_supply BY NAME
SELECT * FROM classrep_power_supply();

-- Needs a filter to only pick up 'TELEMETRY OUTSTATION'...
CREATE OR REPLACE MACRO classrep_telemetry_oustation() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: TELEMETRY OUTSTATION'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_telemetry_outstation;
INSERT OR IGNORE INTO ai2_classrep.equiclass_telemetry_outstation BY NAME
SELECT * FROM classrep_telemetry_oustation();




-- Needs a filter to only pick up 'ultrasonic_level_instrument'...
CREATE OR REPLACE MACRO classrep_ultrasonic_level_instrument() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: ULTRASONIC LEVEL INSTRUMENT'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site", 
                    "Range max", "Range min", "Range unit", 
                    "Relay 1 Function", "Relay 1 off Level (m)", "Relay 1 on Level (m)", 
                    "Relay 2 Function", "Relay 2 off Level (m)", "Relay 2 on Level (m)",
                    "Relay 3 Function", "Relay 3 off Level (m)", "Relay 3 on Level (m)",
                    "Relay 4 Function", "Relay 4 off Level (m)", "Relay 4 on Level (m)",
                    "Relay 5 Function", "Relay 5 off Level (m)", "Relay 5 on Level (m)",
                    "Relay 6 Function", "Relay 6 off Level (m)", "Relay 6 on Level (m)",
                    "Signal max", "Signal min", "Signal unit",
                    "Transducer Serial No", "Transducer Type"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_ultrasonic_level_instrument;
INSERT OR IGNORE INTO ai2_classrep.equiclass_ultrasonic_level_instrument BY NAME
SELECT * FROM classrep_ultrasonic_level_instrument();


