
CREATE OR REPLACE MACRO actuator_to_actuem() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_actuator t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;



CREATE OR REPLACE MACRO centrifugal_pump_to_pumpce() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_centrifugal_pump t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO conductivity_level_instrument_to_lstnco() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_conductivity_level_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO diaphram_pump_to_pumpdi() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_diaphram_pump t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;

CREATE OR REPLACE MACRO distribution_board_to_distbd() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_distribution_board t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO emergency_eye_bath_to_decoeb() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_emergency_eye_bath t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;




CREATE OR REPLACE MACRO emergency_shower_eye_bath_to_decoes() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_emergency_shower_eye_bath t
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



CREATE OR REPLACE MACRO float_level_instrument_to_lstnfl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_float_level_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO gauge_pressure_to_pstndi() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_gauge_pressure t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;



CREATE OR REPLACE MACRO insertion_flow_instrument_to_fstnip() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_insertion_flow_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO isolating_valve_to_valvba() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_isolating_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference
WHERE t."Valve Type" = 'Ball';


CREATE OR REPLACE MACRO isolating_valve_to_valvbp() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_isolating_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference
WHERE t."Valve Type" = 'Butterfly';




CREATE OR REPLACE MACRO kiosk_to_kiskki() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_kiosk t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;




CREATE OR REPLACE MACRO l_o_i_to_intflo() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_l_o_i_ t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;



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

CREATE OR REPLACE MACRO network_switch_to_netwco() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_network_switch t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;



CREATE OR REPLACE MACRO non_immersible_motor_to_emtrin() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_non_immersible_motor t
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



CREATE OR REPLACE MACRO plc_to_contpl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_plc t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;



CREATE OR REPLACE MACRO power_supply_to_podedl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_power_supply t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PODEDL';


CREATE OR REPLACE MACRO power_supply_to_podetu() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_power_supply t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PODETU';

CREATE OR REPLACE MACRO pressure_for_level_instrument_to_lstnpr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pressure_for_level_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;

CREATE OR REPLACE MACRO pressure_reducing_valve_to_valvpr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pressure_reducing_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;




CREATE OR REPLACE MACRO pressure_regulating_valve_to_valvre() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pressure_regulating_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO pressure_switches_to_pstndi() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pressure_switches t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;



CREATE OR REPLACE MACRO pulsation_damper_to_veprpd() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pulsation_damper t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;



CREATE OR REPLACE MACRO safety_switch_to_gaswip() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_safety_switch t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO strainer_to_strner() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_strainer t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;

CREATE OR REPLACE MACRO telemetry_outstation_to_netwtl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_telemetry_outstation t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO temperature_instrument_to_tstntt() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_temperature_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;


CREATE OR REPLACE MACRO trace_heaters_to_heattr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_trace_heaters t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;




CREATE OR REPLACE MACRO tubular_heater_to_heattu() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_tubular_heater t
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



CREATE OR REPLACE MACRO wet_well_to_wellwt() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_wet_well t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;




CREATE OR REPLACE MACRO ww_chemical_storage_tank_to_tankst() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_chemical_storage_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;




CREATE OR REPLACE MACRO ww_service_water_storage_tank_to_tankst() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_service_water_storage_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;



