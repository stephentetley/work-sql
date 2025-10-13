-- # ai2 to s4 translation macros

CREATE OR REPLACE MACRO ac_induction_motor_to_emtrin() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ac_induction_motor t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'EMTRIN';



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


CREATE OR REPLACE MACRO beam_trolley_to_lltttr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_beam_trolley t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLTTTR';


CREATE OR REPLACE MACRO blowers_to_blowcb() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_blowers t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'BLOWCB';


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


CREATE OR REPLACE MACRO bridge_to_accstbr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_bridge t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ACSTBR';


CREATE OR REPLACE MACRO burglar_alarm_to_alamia() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_burglar_alarm t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ALAMIA';


CREATE OR REPLACE MACRO chain_beam_hoist_hand_to_llmhch() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_chain_beam_hoist_hand t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLMHCH';


CREATE OR REPLACE MACRO chain_slings_to_llcscs() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_chain_slings t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLCSCS';


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


CREATE OR REPLACE MACRO classifier_gricse() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_classifier t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'GRICSC';


CREATE OR REPLACE MACRO compressed_air_equipment_to_compsc() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_compressed_air_equipment t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'COMPSC';


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


CREATE OR REPLACE MACRO conveyors_to_cvyrbc() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_conveyor t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'CVYRBC';


CREATE OR REPLACE MACRO cw_chemical_storage_tank_to_tankst() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_cw_chemical_storage_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKST';


CREATE OR REPLACE MACRO davit_to_llddda() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_davit t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLDDDA';


CREATE OR REPLACE MACRO davit_sockets_to_lldsds() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_davit_sockets t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLDSDS';


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

CREATE OR REPLACE MACRO direct_on_line_starter_to_stardo() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_direct_on_line_starter t
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


CREATE OR REPLACE MACRO distributors_to_biofrd() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_distributors t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'BIOFRD';


CREATE OR REPLACE MACRO electric_meter_to_metrel() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_electric_meter t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'METREL';



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


CREATE OR REPLACE MACRO emergency_lighting_to_lideem() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_emergency_lighting t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LIDEEM';


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


CREATE OR REPLACE MACRO fan_to_fansce() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_fan t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FANSCE';


CREATE OR REPLACE MACRO fire_alarm_to_alamfs() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_fire_alarm t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ALAMFS';


CREATE OR REPLACE MACRO flap_valve_to_valvfl() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udfx_db.udfx.convert_to_mm(t."Size", t."Size Units") AS valv_inlet_size_mm,
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


CREATE OR REPLACE MACRO gearbox_to_trutpg() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_gearbox t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TRUTPG';


CREATE OR REPLACE MACRO geared_motor_to_gmtrgm() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_geared_motor t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'GMTRGM';


CREATE OR REPLACE MACRO helical_rotor_pump_to_pumphr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_helical_rotor_pump t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPHR';


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


CREATE OR REPLACE MACRO isolating_valves_to_valvga() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_isolating_valves t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVGA';


CREATE OR REPLACE MACRO isolating_valves_to_valvft() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_isolating_valves t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVFT';

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


CREATE OR REPLACE MACRO limit_switch_to_gaswip() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_limit_switch t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'GASWIP';


CREATE OR REPLACE MACRO magnetic_flow_instrument_to_fstnem() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_magnetic_flow_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNEM';

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



CREATE OR REPLACE MACRO mechanical_air_heater_to_heatai() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_mechanical_air_heater t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'HEATAI';


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


CREATE OR REPLACE MACRO network_switch_to_netwen() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_network_switch t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'NETWEN';

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
    udfx_db.udfx.convert_to_mm(t."Size", t."Size Units") AS valv_inlet_size_mm,
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


CREATE OR REPLACE MACRO plc_to_actuep() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_pneumatic_actuator t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ACTUEP';


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


CREATE OR REPLACE MACRO power_supply_to_podeup() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_power_supply t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PODEUP';

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


CREATE OR REPLACE MACRO radar_level_instrument_to_lstnrd() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_radar_level_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNRD';


CREATE OR REPLACE MACRO ram_pump_to_lstnrd() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ram_pump t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPRA';


CREATE OR REPLACE MACRO relief_safety_valve_to_valvsf() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_relief_safety_valve t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVSF';



CREATE OR REPLACE MACRO runways_to_llrrtb() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_runways t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLRRTB';


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


CREATE OR REPLACE MACRO screens_to_scrcba() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_screens t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'SCRCBA';


CREATE OR REPLACE MACRO screens_to_scrfsc() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_screens t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'SCRFSC';


CREATE OR REPLACE MACRO stirrers_mixers_agitators_to_mixrro() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_stirrers_mixers_agitators t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'MIXRRO';


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


CREATE OR REPLACE MACRO submersible_centrifugal_pump_to_pumsmo() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_submersible_centrifugal_pump t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMSMO';


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


CREATE OR REPLACE MACRO turbidity_instrument_to_analtb() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_turbidity_instrument t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ANALTB';


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


CREATE OR REPLACE MACRO ups_systems_to_podeup() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ups_systems t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PODEUP';



CREATE OR REPLACE MACRO urban_wastewater_sampler_to_sampch() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_urban_wastewater_sampler t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'SAMPCH';


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


CREATE OR REPLACE MACRO variable_frequency_starter_to_starvf() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_variable_frequency_starter t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STARVF';



CREATE OR REPLACE MACRO water_air_receiver_to_vepraw() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_water_air_receiver t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VEPRAW';


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



CREATE OR REPLACE MACRO ww_balancing_tank_to_tankpr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_balancing_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKPR';


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


CREATE OR REPLACE MACRO ww_cloth_media_filter_to_profsa() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_cloth_media_filter t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PROFSA';


CREATE OR REPLACE MACRO ww_flocculation_tank_to_tankpr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_flocculation_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKPR';


CREATE OR REPLACE MACRO ww_humus_tank_to_tankpr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_humus_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKPR';



CREATE OR REPLACE MACRO ww_percolating_filter_to_profpc() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_percolating_filter t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PROFPC';


CREATE OR REPLACE MACRO ww_primary_sedimentation_to_tankpr() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_primary_sedimentation_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKPR';


CREATE OR REPLACE MACRO ww_sand_filter_to_profsn() AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_sand_filter t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PROFSN';


CREATE OR REPLACE MACRO ww_service_water_storage_tank_to_tankst() AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    t."Tank Construction" AS tank_tank_construction,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_service_water_storage_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKST';


CREATE OR REPLACE MACRO ww_sludge_storage_tank_to_tankst() AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_sludge_storage_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKST';


CREATE OR REPLACE MACRO ww_storm_sedimentation_tank_to_tankpr() AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_ww_storm_sedimentation_tank t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKPR';

