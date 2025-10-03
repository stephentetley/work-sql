
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
FROM ai2_classrep.equiclass_non_return_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;
