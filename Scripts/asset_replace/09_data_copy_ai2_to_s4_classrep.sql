
CREATE OR REPLACE MACRO modem_to_netwmo() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_modem t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO network_to_netwmb() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_network t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO power_supply_to_podetu() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_power_supply t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO telemetry_outstation_to_netwtl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_telemetry_outstation t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;

CREATE OR REPLACE MACRO ultrasonic_level_instrument_to_lstnut() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    -- Relay 1
    t."Relay 1 Function" AS lstn_relay_1_function,
    t."Relay 1 off Level (m)" AS lstn_relay_1_off_level_m,
    t."Relay 1 on Level (m)" AS lstn_relay_1_on_level_m,
    -- relay 2
    t."Relay 2 Function" AS lstn_relay_2_function,
    t."Relay 2 off Level (m)" AS lstn_relay_2_off_level_m,
    t."Relay 2 on Level (m)" AS lstn_relay_2_on_level_m,
    -- relay 3
    t."Relay 3 Function" AS lstn_relay_3_function,
    t."Relay 3 off Level (m)" AS lstn_relay_3_off_level_m,
    t."Relay 3 on Level (m)" AS lstn_relay_3_on_level_m,
    -- relay 4
    t."Relay 4 Function" AS lstn_relay_4_function,
    t."Relay 4 off Level (m)" AS lstn_relay_4_off_level_m,
    t."Relay 4 on Level (m)" AS lstn_relay_4_on_level_m,
    -- relay 5
    t."Relay 5 Function" AS lstn_relay_5_function,
    t."Relay 5 off Level (m)" AS lstn_relay_5_off_level_m,
    t."Relay 5 on Level (m)" AS lstn_relay_5_on_level_m,
    -- relay 6
    t."Relay 6 Function" AS lstn_relay_6_function,
    t."Relay 6 off Level (m)" AS lstn_relay_6_off_level_m,
    t."Relay 6 on Level (m)" AS lstn_relay_6_on_level_m,
    
    t."Transducer Type" AS lstn_transducer_model,
    t."Transducer Serial No" AS lstn_transducer_serial_no,
    t."Range min" AS lstn_range_min,
    t."Range max" AS lstn_range_max,
    upper(t."Range unit") AS lstn_range_units,
    udf_local.format_signal3(t."Signal min", t."Signal max", t."Signal unit") AS lstn_signal_type,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ultrasonic_level_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;

CREATE OR REPLACE MACRO flap_valve_to_valvfl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udf_local.convert_to_mm(t."Size", t."Size Units") AS valv_inlet_size_mm,
FROM ai2_classrep.equiclass_flap_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;

CREATE OR REPLACE MACRO non_return_valve_to_valvnr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udf_local.convert_to_mm(t."Size", t."Size Units") AS valv_inlet_size_mm,
FROM ai2_classrep.equiclass_flap_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;



-- non-equiclass tables


DELETE FROM s4_classrep.equi_masterdata;
INSERT OR REPLACE INTO s4_classrep.equi_masterdata BY NAME
SELECT 
    t1.equi_equi_id AS equipment_id,
    t1.s4_description AS equi_description,
    t1.s4_floc AS functional_location,
    t1.s4_superord_equi AS superord_id,
    t1.s4_category AS category,
    t1.s4_object_type AS object_type,
    udf_local.get_s4_asset_status(t.asset_status) AS display_user_status,
    udf_local.get_s4_asset_status(t.asset_status) AS status_of_an_object,
    TRY_CAST(t.installed_from AS DATE) AS startup_date,
    year(startup_date) AS construction_year,
    month(startup_date) AS construction_month,
    t.manufacturer AS manufacturer,
    t.model AS model_number,
    t.specific_model_frame AS manufact_part_number,
    t.serial_number AS serial_number,
    t.weight_kg AS gross_weight,
    IF(t.weight_kg IS NOT NULL, 'KG', null) AS unit_of_weight,
    t.pandi_tag AS technical_ident_number,
    t1.s4_position AS display_position,
    t1.s4_class catalog_profile,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;
;


DELETE FROM s4_classrep.equi_east_north;
INSERT OR REPLACE INTO s4_classrep.equi_east_north BY NAME
SELECT 
    t1.equi_equi_id AS equipment_id,
    t2.easting AS easting,
    t2.northing AS northing,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference
CROSS JOIN udfx_db.udfx.get_east_north(t.grid_ref) t2
;

DELETE FROM s4_classrep.equi_asset_condition;
INSERT OR REPLACE INTO s4_classrep.equi_asset_condition BY NAME
SELECT 
    t1.equi_equi_id AS equipment_id,
    upper(t2.condition_grade) AS condition_grade,
    upper(t2.condition_grade_reason) AS condition_grade_reason,
    t2.survey_year AS survey_date,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference
LEFT JOIN ai2_classrep.equi_agasp t2 ON t2.ai2_reference = t.ai2_reference;


-- THIS IS SOURCE DATA SPECIFIC depends on `ai2_to_s4_mapping` table
DELETE FROM s4_classrep.equi_aib_reference;
INSERT OR REPLACE INTO s4_classrep.equi_aib_reference BY NAME 
(SELECT DISTINCT ON (t.ai2_reference)
    t1.equi_equi_id AS equipment_id,
    1 AS value_index,
    t.ai2_reference AS ai2_aib_reference,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference)
UNION
(SELECT DISTINCT ON (t.ai2_reference)
    t1.equi_equi_id AS equipment_id,
    2 AS value_index,
    t1.ai2_parent_reference AS ai2_aib_reference,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference);

-- THIS IS SOURCE DATA SPECIFIC depends on `ai2_to_s4_mapping` table

DELETE FROM s4_classrep.equi_solution_id;
INSERT OR REPLACE INTO s4_classrep.equi_solution_id BY NAME 
(SELECT DISTINCT ON (t.ai2_reference)
    t1.equi_equi_id AS equipment_id,
    1 AS value_index,
    t1.solution_id AS solution_id,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference);

-- Delete from equiclass tables before _any_ writes
-- An equiclass table may have more than one source

DELETE FROM s4_classrep.equiclass_lstnut;
DELETE FROM s4_classrep.equiclass_netwmb;
DELETE FROM s4_classrep.equiclass_netwmo;
DELETE FROM s4_classrep.equiclass_netwtl;
DELETE FROM s4_classrep.equiclass_podetu;
DELETE FROM s4_classrep.equiclass_valvfl;
DELETE FROM s4_classrep.equiclass_valvnr;

INSERT OR REPLACE INTO s4_classrep.equiclass_lstnut BY NAME
SELECT * FROM ultrasonic_level_instrument_to_lstnut();


INSERT OR REPLACE INTO s4_classrep.equiclass_netwmb BY NAME
SELECT * FROM network_to_netwmb();

INSERT OR REPLACE INTO s4_classrep.equiclass_netwmo BY NAME
SELECT * FROM modem_to_netwmo();


INSERT OR REPLACE INTO s4_classrep.equiclass_netwtl BY NAME
SELECT * FROM telemetry_outstation_to_netwtl();

INSERT OR REPLACE INTO s4_classrep.equiclass_podetu BY NAME
SELECT * FROM power_supply_to_podetu();

INSERT OR REPLACE INTO s4_classrep.equiclass_valvfl BY NAME
SELECT * FROM flap_valve_to_valvfl();

INSERT OR REPLACE INTO s4_classrep.equiclass_valvnr BY NAME
SELECT * FROM non_return_valve_to_valvnr();









