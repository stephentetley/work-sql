
CREATE OR REPLACE MACRO actuator_to_actuem() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_actuator t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ACTUEM';


CREATE OR REPLACE MACRO air_auto_cleaner_to_blowab() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_air_auto_cleaner t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'BLOWAB';


CREATE OR REPLACE MACRO air_receiver_to_veprar() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_air_receiver t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VEPRAR';


CREATE OR REPLACE MACRO ammonia_instrument_to_analam() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ammonia_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ANALAM';


CREATE OR REPLACE MACRO blowers_to_blowsc() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_blowers t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'BLOWSC';


CREATE OR REPLACE MACRO centrifugal_pump_to_pumpce() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_centrifugal_pump t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPCE';


CREATE OR REPLACE MACRO compressed_air_equipment_to_compre() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_compressed_air_equipment t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'COMPRE';


CREATE OR REPLACE MACRO conductivity_level_instrument_to_lstnco() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_conductivity_level_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNCO';


CREATE OR REPLACE MACRO control_panel_to_conpnl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_control_panel t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'CONPNL';


CREATE OR REPLACE MACRO controller_to_conttr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_controller t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'CONTTR';

--
--CREATE OR REPLACE MACRO diaphram_pump_to_pumpdi() AS TABLE
--SELECT
--    t1.equi_equi_id AS equipment_id,
--    t."Location On Site" AS location_on_site,
--    'TEMP_VALUE' AS uniclass_code,
--    'TEMP_VALUE' AS uniclass_desc,
--FROM ai2_classrep.equiclass_diaphram_pump t
--JOIN ai2_classrep.ai2_to_s4_mapping t1 
--    ON t1.ai2_reference = t.ai2_reference
--WHERE t1.s4_class = 'PUMPDI';


CREATE OR REPLACE MACRO diaphragm_pump_to_pumpdi() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_diaphragm_pump t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPDI';

CREATE OR REPLACE MACRO direct_online_starter_to_stardo() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_direct_online_starter t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STARDO';


CREATE OR REPLACE MACRO distribution_board_to_distbd() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_distribution_board t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'DISBD';


CREATE OR REPLACE MACRO emergency_eye_bath_to_decoeb() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_emergency_eye_bath t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'DECOEB';


CREATE OR REPLACE MACRO emergency_shower_eye_bath_to_decoes() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_emergency_shower_eye_bath t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'DECOES';


CREATE OR REPLACE MACRO flap_valve_to_valvfl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udf_local.convert_to_mm(t."Size", t."Size Units") AS valv_inlet_size_mm,
FROM ai2_classrep.equiclass_flap_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VAVLFL';


CREATE OR REPLACE MACRO float_level_instrument_to_lstnfl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_float_level_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNFL';


CREATE OR REPLACE MACRO gauge_pressure_to_pstndi() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_gauge_pressure t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PSTNDI';


CREATE OR REPLACE MACRO insertion_flow_instrument_to_fstnip() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_insertion_flow_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNIP';


CREATE OR REPLACE MACRO isolating_valves_to_valvba() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_isolating_valves t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVBA';


CREATE OR REPLACE MACRO isolating_valves_to_valvbp() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_isolating_valves t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVBP';


CREATE OR REPLACE MACRO kiosk_to_kiskki() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_kiosk t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'KISKKI';


CREATE OR REPLACE MACRO l_o_i_to_intflo() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_l_o_i t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'INTFLO';


CREATE OR REPLACE MACRO mcc_unit_to_mccepa() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_mcc_unit t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'MCCEPA';


CREATE OR REPLACE MACRO modem_to_netwmo() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_modem t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'NETWMO';


-- Modbus
CREATE OR REPLACE MACRO network_to_netwmb() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_network t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'NETWMB';


CREATE OR REPLACE MACRO network_switch_to_netwco() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_network_switch t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'NETWCO';


CREATE OR REPLACE MACRO non_immersible_motor_to_emtrin() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_non_immersible_motor t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'EMTRIN';


CREATE OR REPLACE MACRO non_return_valve_to_valvnr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udf_local.convert_to_mm(t."Size", t."Size Units") AS valv_inlet_size_mm,
FROM ai2_classrep.equiclass_non_return_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVNR';


CREATE OR REPLACE MACRO plc_to_contpl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_plc t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'CONTPL';



CREATE OR REPLACE MACRO power_supply_to_podedl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_power_supply t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PODEDL';


CREATE OR REPLACE MACRO power_supply_to_podetu() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_power_supply t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PODETU';

CREATE OR REPLACE MACRO pressure_for_level_instrument_to_lstnpr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pressure_for_level_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNPR';


CREATE OR REPLACE MACRO pressure_reducing_valve_to_valvpr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pressure_reducing_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVPR';

-- caution - have we got the s4 class right?
CREATE OR REPLACE MACRO pressure_regulating_valve_to_valvpr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pressure_regulating_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVPR';

CREATE OR REPLACE MACRO pressure_regulating_valve_to_valvre() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pressure_regulating_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVRE';


CREATE OR REPLACE MACRO pressure_switches_to_pstndi() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pressure_switches t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PSTNDI';



CREATE OR REPLACE MACRO pulsation_damper_to_veprpd() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pulsation_damper t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VEPRPD';



CREATE OR REPLACE MACRO safety_switch_to_gaswip() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_safety_switch t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'GASWIP';


CREATE OR REPLACE MACRO strainer_to_strner() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_strainer t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STRNER';

CREATE OR REPLACE MACRO telemetry_outstation_to_netwtl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_telemetry_outstation t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'NETWTL';


CREATE OR REPLACE MACRO temperature_instrument_to_tstntt() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_temperature_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TSTNTT';

CREATE OR REPLACE MACRO thermal_flow_instrument_to_fstnth() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_thermal_flow_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNTH';

CREATE OR REPLACE MACRO trace_heaters_to_heattr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_trace_heaters t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'HEATR';




CREATE OR REPLACE MACRO tubular_heater_to_heattu() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_tubular_heater t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'HEATTU';


CREATE OR REPLACE MACRO ultrasonic_level_instrument_to_lstnut() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    t."Transducer Type" AS lstn_transducer_model,
    t."Transducer Serial No" AS lstn_transducer_serial_no,
    t."Range min" AS lstn_range_min,
    t."Range max" AS lstn_range_max,
    upper(t."Range unit") AS lstn_range_units,
    udf_local.format_signal3(t."Signal min", t."Signal max", t."Signal unit") AS lstn_signal_type,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ultrasonic_level_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNUT';


CREATE OR REPLACE MACRO uv_transmittance_instrument_to_analut() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_uv_transmittance_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ANALUT';


CREATE OR REPLACE MACRO ultra_violet_unit_to_uvunit() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ultra_violet_unit t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'UVUNIT';


CREATE OR REPLACE MACRO wet_well_to_wellwt() AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    t."Tank Construction" AS well_tank_construction,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_chemical_storage_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'WELLWT';


CREATE OR REPLACE MACRO ww_chemical_storage_tank_to_tankst() AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    t."Tank Construction" AS tank_tank_construction,
    t."Tank Level" AS tank_tank_level,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_chemical_storage_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKST';


CREATE OR REPLACE MACRO ww_service_water_storage_tank_to_tankst() AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    t."Tank Construction" AS tank_tank_construction,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_chemical_storage_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKST';



