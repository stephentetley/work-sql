.print 'Running 10_translate_ai2_equiclass_to_s4.sql...'

-- We need to use a worklist as the destination type for a 
-- particular source type is the user's choice and not known
-- statically

-- ai2_classrep.equiclass_bridge ==> s4_classrep.equiclass_accstbr
INSERT OR REPLACE INTO s4_classrep.equiclass_acstbr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    NULL AS location_on_site,
    udf.get_weight_limit_tonnes(t1."Weight Limit") AS acst_weight_limit,
    t1."Alternative Crossing" AS alternative_crossing,
    t1."Public Access" AS acst_public_access,
    t1."Public Highway" AS acst_public_highway,
    t1."Parapet" AS acst_parapet,
    t1."Primary Access" AS acst_primary_access,
    t1."Secondary Access" AS acst_secondary_access,
    t1."Bridge Use" AS acst_bridge_use,
    t1."Crossing Use" AS acst_crossing_use,
    t1."Deck Surface Material" AS acst_deck_surface_material,
    udf.convert_to_millimetres(t1."Length (m)", 'M') AS acst_length_mm,
    udf.convert_to_millimetres(t1."Width (m)", 'M') AS acst_width_mm,
    t1."Average Pedestrian Per Day" AS average_pedestrian_per_day,
    udf.bdfv_757_to_bridge_vehicles_per_day(t1."Average Vehicles Per Day") AS average_vehicles_per_day,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_bridge t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'ACSTBR';


-- ai2_classrep.equiclass_actuator ==> s4_classrep.equiclass_actuem
INSERT OR REPLACE INTO s4_classrep.equiclass_actuem BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Insulation Class" AS insulation_class_deg_c,
    t1."IP Rating" AS ip_rating,
    t1."Current In" AS actu_rated_current_a,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS actu_rated_power_kw,
    t1."Voltage In" AS actu_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS actu_rated_voltage_units,
    t1."Speed (RPM)" AS actu_speed_rpm,
    t1."Valve Torque (Nm)" AS actu_valve_torque_nm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS actu_atex_code,
    NULL AS actu_number_of_phase,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_actuator t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'ACTUEM';


-- ai2_classrep.equiclass_pneumatic_actuator ==> s4_classrep.equiclass_actuep
INSERT OR REPLACE INTO s4_classrep.equiclass_actuep BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_pneumatic_actuator t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'ACTUEP';


-- ai2_classrep.equiclass_fire_alarm ==> s4_classrep.equiclass_alamfs
INSERT OR REPLACE INTO s4_classrep.equiclass_alamfs BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_fire_alarm t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'ALAMFS';

-- ai2_classrep.equiclass_burglar_alarm ==> s4_classrep.equiclass_alamia
INSERT OR REPLACE INTO s4_classrep.equiclass_alamia BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."IP Rating" AS ip_rating,
    t1."Voltage In" AS alam_input_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS alam_input_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_burglar_alarm t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'ALAMIA';

-- ai2_classrep.equiclass_ammonia_instrument ==> s4_classrep.equiclass_analam
INSERT OR REPLACE INTO s4_classrep.equiclass_analam BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Range max" AS anal_range_max,
    t1."Range min" AS anal_range_min,
    udf.rngu_132_to_anal_range_unit(t1."Range unit") AS anal_range_units,
    udf.format_signal3(t1."Signal min", t1."Signal max", t1."Signal unit") AS anal_signal_type,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ammonia_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'ANALAM';

-- ai2_classrep.equiclass_nitrate_instrument ==> s4_classrep.equiclass_analno
INSERT OR REPLACE INTO s4_classrep.equiclass_analno BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Range min" AS anal_range_min,
    t1."Range max" AS anal_range_max,
    upper(t1."Range unit") AS anal_range_units,
    udf.format_signal3(t1."Signal min", t1."Signal max", t1."Signal unit") AS anal_signal_type,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS anal_instrument_power_w,
    NULL AS anal_rated_voltage,
    NULL AS anal_rated_voltage_units,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_nitrate_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'ANALNO';


-- ai2_classrep.equiclass_turbidity_instrument ==> s4_classrep.equiclass_analtb
INSERT OR REPLACE INTO s4_classrep.equiclass_analtb BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_turbidity_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'ANALTB';


-- ai2_classrep.equiclass_uv_transmittance_instrument ==> s4_classrep.equiclass_analut
INSERT OR REPLACE INTO s4_classrep.equiclass_analut BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_uv_transmittance_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'ANALUT';


-- ai2_classrep.equiclass_distributors ==> s4_classrep.equiclass_biofrd
INSERT OR REPLACE INTO s4_classrep.equiclass_biofrd BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_distributors t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'BIOFRD';


-- ai2_classrep.equiclass_air_auto_cleaner ==> s4_classrep.equiclass_blowab
INSERT OR REPLACE INTO s4_classrep.equiclass_blowab BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS blow_rated_power_kw,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_air_auto_cleaner t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'BLOWAB';

-- ai2_classrep.equiclass_blowers ==> s4_classrep.equiclass_blowcb
INSERT OR REPLACE INTO s4_classrep.equiclass_blowcb BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_cubic_metres_per_hour(t1."Flow", t1."Flow Units") AS blow_flow_cubic_metre_per_hour,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS blow_rated_power_kw,
    t1."Speed (RPM)" AS blow_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_blowers t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'BLOWCB';

-- ai2_classrep.equiclass_blowers ==> s4_classrep.equiclass_blowsc
INSERT OR REPLACE INTO s4_classrep.equiclass_blowsc BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_cubic_metres_per_hour(t1."Flow", t1."Flow Units") AS blow_flow_cubic_metre_per_hour,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS blow_rated_power_kw,
    t1."Speed (RPM)" AS blow_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_blowers t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'BLOWSC';

-- ai2_classrep.equiclass_compressed_air_equipment ==> s4_classrep.equiclass_compre
INSERT OR REPLACE INTO s4_classrep.equiclass_compre BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_compressed_air_equipment t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'COMPRE';


-- ai2_classrep.equiclass_compressed_air_equipment ==> s4_classrep.equiclass_compsc
INSERT OR REPLACE INTO s4_classrep.equiclass_compsc BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_compressed_air_equipment t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'COMPSC';

-- ai2_classrep.equiclass_control_panel ==> s4_classrep.equiclass_conpnl
INSERT OR REPLACE INTO s4_classrep.equiclass_conpnl BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Current In" AS conp_rated_current_a,
    t1."Voltage In" AS conp_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS conp_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS conp_number_of_phase,
    NULL AS conp_number_of_ways,
    NULL AS conp_sld_ref_no,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_control_panel t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'CONPNL';


-- ai2_classrep.equiclass_plc ==> s4_classrep.equiclass_contpl
INSERT OR REPLACE INTO s4_classrep.equiclass_contpl BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS cont_instrument_power_w,
    NULL AS cont_rated_voltage,
    NULL AS cont_rated_voltage_units,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_plc t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'CONTPL';

-- ai2_classrep.equiclass_controller ==> s4_classrep.equiclass_conttr
INSERT OR REPLACE INTO s4_classrep.equiclass_conpnl BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_controller t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'CONTTR';

-- ai2_classrep.equiclass_conveyors ==> s4_classrep.equiclass_cvyrbc
INSERT OR REPLACE INTO s4_classrep.equiclass_cvyrbc BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_conveyors t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'CVYRBC';

-- ai2_classrep.equiclass_emergency_eye_bath ==> s4_classrep.equiclass_decoeb
INSERT OR REPLACE INTO s4_classrep.equiclass_decoeb BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_emergency_eye_bath t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'DECOEB';


-- ai2_classrep.equiclass_emergency_shower_eye_bath ==> s4_classrep.equiclass_decoes
INSERT OR REPLACE INTO s4_classrep.equiclass_decoes BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_emergency_shower_eye_bath t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'DECOES';


-- ai2_classrep.equiclass_distribution_board ==> s4_classrep.equiclass_distbd
INSERT OR REPLACE INTO s4_classrep.equiclass_distbd BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_distribution_board t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'DISTBD';

-- ai2_classrep.equiclass_ac_induction_motor ==> s4_classrep.equiclass_emtrin
INSERT OR REPLACE INTO s4_classrep.equiclass_emtrin BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Insulation Class" AS insulation_class_deg_c,
    t1."IP Rating" AS ip_rating,
    t1."Current In" AS emtr_rated_current_a,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS emtr_rated_power_kw,
    t1."Speed (RPM)" AS emtr_rated_speed_rpm,
    t1."Voltage In" AS emtr_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS emtr_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ac_induction_motor t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'EMTRIN';

-- ai2_classrep.equiclass_non_immersible_motor ==> s4_classrep.equiclass_emtrin
INSERT OR REPLACE INTO s4_classrep.equiclass_emtrin BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS emtr_anti_condensation_heaters,
    NULL AS emtr_atex_code,
    NULL AS emtr_frame_size,
    NULL AS emtr_mounting_type,
    NULL AS emtr_number_of_phase,
    NULL AS emtr_rated_current_a,
    NULL AS emtr_rated_power_kw,
    NULL AS emtr_rated_speed_rpm,
    NULL AS emtr_rated_voltage,
    NULL AS emtr_rated_voltage_units,
    NULL AS emtr_thermal_protection,
    NULL AS insulation_class_deg_c,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_non_immersible_motor t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'EMTRIN';

-- ai2_classrep.equiclass_fan ==> s4_classrep.equiclass_fansce
INSERT OR REPLACE INTO s4_classrep.equiclass_fansce BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,  
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_fan t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'FANSCE';

-- ai2_classrep.equiclass_magnetic_flow_instrument ==> s4_classrep.equiclass__fstnem
INSERT OR REPLACE INTO s4_classrep.equiclass_fansce BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_magnetic_flow_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'FSTNEM';



-- ai2_classrep.equiclass_insertion_flow_instrument ==> s4_classrep.equiclass_fstnip
-- INSERT OR REPLACE INTO s4_classrep.equiclass_fstnip BY NAME
-- SELECT
--     t.equipment_transit_id AS equipment_id,  
--     t1."Location On Site" AS location_on_site,
--     'TEMP_VALUE' AS uniclass_code,
--     'TEMP_VALUE' AS uniclass_desc,
-- FROM equi_translate.worklist t
-- LEFT JOIN ai2_classrep.equiclass_insertion_flow_instrument t1 ON t1.ai2_reference = t.ai2_reference
-- WHERE t.s4_class = 'FSTNIP';


-- ai2_classrep.equiclass_ultrasonic_flow_instrument ==> s4_classrep.equiclass_fstnoc
-- INSERT OR REPLACE INTO s4_classrep.equiclass_fstnoc BY NAME
-- SELECT
--     t.equipment_transit_id AS equipment_id,  
--     t1."Location On Site" AS location_on_site,
--     'TEMP_VALUE' AS uniclass_code,
--     'TEMP_VALUE' AS uniclass_desc,
-- FROM equi_translate.worklist t
-- LEFT JOIN ai2_classrep.equiclass_insertion_flow_instrument t1 ON t1.ai2_reference = t.ai2_reference
-- WHERE t.s4_class = 'FSTNOC';


-- ai2_classrep.equiclass_thermal_flow_instrument ==> s4_classrep.equiclass_fstnth
INSERT OR REPLACE INTO s4_classrep.equiclass_fstnth BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS fstn_output_type,
    NULL AS fstn_range_max,
    NULL AS fstn_range_min,
    NULL AS fstn_range_units,
    NULL AS fstn_rated_voltage,
    NULL AS fstn_rated_voltage_units,
    NULL AS fstn_signal_type,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_thermal_flow_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'FSTNTH';

-- ai2_classrep.equiclass_thermal_mass_flow_instrument ==> s4_classrep.equiclass_fstntm
INSERT OR REPLACE INTO s4_classrep.equiclass_fstntm BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS fstn_range_max,
    NULL AS fstn_range_min,
    NULL AS fstn_range_units,
    NULL AS fstn_rated_voltage,
    NULL AS fstn_rated_voltage_units,
    NULL AS fstn_signal_type,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_thermal_mass_flow_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'FSTNTM';


-- ai2_classrep.equiclass_turbine_flow_instrument ==> s4_classrep.equiclass_fstntu
INSERT OR REPLACE INTO s4_classrep.equiclass_fstntu BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_turbine_flow_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'FSTNTU';


-- ai2_classrep.equiclass_doppler_flow_instrument ==> s4_classrep.equiclass_fstnus
INSERT OR REPLACE INTO s4_classrep.equiclass_fstnus BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_doppler_flow_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'FSTNUS';


-- ai2_classrep.equiclass_variable_area_flow_instrument ==> s4_classrep.equiclass_fstnva
INSERT OR REPLACE INTO s4_classrep.equiclass_fstnva BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_variable_area_flow_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'FSTNVA';


-- ai2_classrep.equiclass_venturi ==> s4_classrep.equiclass_fstnve
INSERT OR REPLACE INTO s4_classrep.equiclass_fstnve BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_venturi t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'FSTNVE';


-- ai2_classrep.equiclass_vortex_flow_instrument ==> s4_classrep.equiclass_fstnvo
INSERT OR REPLACE INTO s4_classrep.equiclass_fstnvo BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_vortex_flow_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'FSTNVO';


-- limit switch
-- ai2_classrep.equiclass_limit_switch ==> s4_classrep.equiclass_gaswip
INSERT OR REPLACE INTO s4_classrep.equiclass_gaswip BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS gasw_rated_voltage,
    NULL AS gasw_rated_voltage_units,
    NULL AS gasw_sensing_range_bar,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_limit_switch t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'GASWIP';

-- safety switch
-- ai2_classrep.equiclass_safety_switch ==> s4_classrep.equiclass_gaswip
INSERT OR REPLACE INTO s4_classrep.equiclass_gaswip BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_safety_switch t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'GASWIP';


-- ai2_classrep.equiclass_geared_motor ==> s4_classrep.equiclass_gmtrgm
INSERT OR REPLACE INTO s4_classrep.equiclass_gmtrgm BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_geared_motor t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'GMTRGM';

-- ai2_classrep.equiclass_classifier ==> s4_classrep.equiclass_gricsc
INSERT OR REPLACE INTO s4_classrep.equiclass_gricsc BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_classifier t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'GRICSC';

-- ai2_classrep.equiclass_mechanical_air_heater ==> s4_classrep.equiclass_heatai
INSERT OR REPLACE INTO s4_classrep.equiclass_heatai BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_mechanical_air_heater t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'HEATAI';


-- ai2_classrep.equiclass_trace_heaters ==> s4_classrep.equiclass_heattr
INSERT OR REPLACE INTO s4_classrep.equiclass_heattr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_trace_heaters t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'HEATTR';


-- ai2_classrep.equiclass_tubular_heater ==> s4_classrep.equiclass_heattu
INSERT OR REPLACE INTO s4_classrep.equiclass_heattu BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_tubular_heater t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'HEATTU';


-- ai2_classrep.equiclass_l_o_i ==> s4_classrep.equiclass_intflo
INSERT OR REPLACE INTO s4_classrep.equiclass_intflo BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS intf_instrument_power_w,
    NULL AS intf_rated_voltage,
    NULL AS intf_rated_voltage_units,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_l_o_i t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'INTFLO';


-- ai2_classrep.equiclass_kiosk ==> s4_classrep.equiclass_kiskki
INSERT OR REPLACE INTO s4_classrep.equiclass_kiskki BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.cafl_435_to_kisk_cat_flap_available(t1."Cat Flap Available") AS kisk_cat_flap_available,
    udf.kosk_471_to_kisk_material(t1."Kiosk Material") AS kisk_material,
    udf.convert_to_millimetres(t1."Kiosk Base Height (m)", 'METRES') AS kisk_base_height_mm,
    udf.convert_to_millimetres(t1."Kiosk Depth (m)", 'METRES') AS kisk_depth_mm,
    udf.convert_to_millimetres(t1."Kiosk Height (m)", 'METRES') AS kisk_height_mm,
    udf.convert_to_millimetres(t1."Kiosk Width (m)", 'METRES') AS kisk_width_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_kiosk t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'KISKKI';


-- ai2_classrep.equiclass_emergency_lighting ==> s4_classrep.equiclass_lideem
INSERT OR REPLACE INTO s4_classrep.equiclass_lideem BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_emergency_lighting t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LIDEEM';

-- ai2_classrep.equiclass_chain_slings ==> s4_classrep.equiclass_llcscs
INSERT OR REPLACE INTO s4_classrep.equiclass_llcscs BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_millimetres(t1."Effective Working Length (m)", 'METRES') AS leea_eff_working_length_mm,
    t1."Work Load" AS leea_safe_working_load,
    udf.wlun_337_to_swl_units(t1."Work Load Units") AS leea_safe_working_load_units,
    t1."YWRef" AS statutory_reference_number,
    t1."Test Cert No" AS test_cert_no,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_chain_slings t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLCSCS';


-- ai2_classrep.equiclass_davit ==> s4_classrep.equiclass_llddda
INSERT OR REPLACE INTO s4_classrep.equiclass_llddda BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Work Load" AS leea_safe_working_load,
    udf.wlun_337_to_swl_units(t1."Work Load Units") AS leea_safe_working_load_units,
    t1."YWRef" AS statutory_reference_number,
    t1."Test Cert No" AS test_cert_no,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_davit t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLDDDA';


-- ai2_classrep.equiclass_davit_sockets ==> s4_classrep.equiclass_lldsds
INSERT OR REPLACE INTO s4_classrep.equiclass_llddda BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Work Load" AS leea_safe_working_load,
    udf.wlun_337_to_swl_units(t1."Work Load Units") AS leea_safe_working_load_units,
    t1."YWRef" AS statutory_reference_number,
    t1."Test Cert No" AS test_cert_no,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_davit_sockets t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLDSDS';


-- ai2_classrep.equiclass_eye_bolts ==> s4_classrep.equiclass_llebbo
INSERT OR REPLACE INTO s4_classrep.equiclass_llebbo BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_eye_bolts t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLEBBO';


-- ai2_classrep.equiclass_ropes ==> s4_classrep.equiclass_llfsrp
INSERT OR REPLACE INTO s4_classrep.equiclass_llfsrp BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ropes t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLFSRP';

-- Fixed gantry
-- ai2_classrep.equiclass_gantries ==> s4_classrep.equiclass_llggfx
INSERT OR REPLACE INTO s4_classrep.equiclass_llebbo BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_gantries t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLGGFX';


-- Portable gantry
-- ai2_classrep.equiclass_gantries ==> s4_classrep.equiclass_llggpt
INSERT OR REPLACE INTO s4_classrep.equiclass_llebbo BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_gantries t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLGGPT';

-- ai2_classrep.equiclass_jib_crane ==> s4_classrep.equiclass_lljcji
INSERT OR REPLACE INTO s4_classrep.equiclass_lljcji BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_jib_crane t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLJCJI';


-- to pillar jib crane
-- ai2_classrep.equiclass_jib_crane ==> s4_classrep.equiclass_lljcpj
INSERT OR REPLACE INTO s4_classrep.equiclass_lljcpj BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_jib_crane t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLJCPJ';


-- to swing jib crane
-- ai2_classrep.equiclass_jib_crane ==> s4_classrep.equiclass_lljcsw
INSERT OR REPLACE INTO s4_classrep.equiclass_lljcsw BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_jib_crane t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLJCSW';


-- to wall jib crane
-- ai2_classrep.equiclass_jib_crane ==> s4_classrep.equiclass_lljcwa
INSERT OR REPLACE INTO s4_classrep.equiclass_lljcwa BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_jib_crane t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLJCWA';


-- ai2_classrep.equiclass_jack_hydraulic ==> s4_classrep.equiclass_lljjck
INSERT OR REPLACE INTO s4_classrep.equiclass_lljjck BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_jack_hydraulic t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLJJCK';

-- ai2_classrep.equiclass_jack_ratchet ==> s4_classrep.equiclass_lljjck
INSERT OR REPLACE INTO s4_classrep.equiclass_lljjck BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_jack_ratchet t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLJJCK';

-- ai2_classrep.equiclass_chain_beam_hoist_hand ==> s4_classrep.equiclass_llmhch
INSERT OR REPLACE INTO s4_classrep.equiclass_llmhch BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Work Load" AS leea_safe_working_load,
    udf.wlun_337_to_swl_units(t1."Work Load Units") AS leea_safe_working_load_units,
    t1."YWRef" AS statutory_reference_number,
    t1."Test Cert No" AS test_cert_no,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_chain_beam_hoist_hand t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLMHCH';


-- ai2_classrep.equiclass_runways ==> s4_classrep.equiclass_llrrtb
INSERT OR REPLACE INTO s4_classrep.equiclass_llrrtb BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_runways t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLRRTB';


-- ai2_classrep.equiclass_beam_trolley ==> s4_classrep.equiclass_lltttr
INSERT OR REPLACE INTO s4_classrep.equiclass_lltttr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Work Load" AS leea_safe_working_load,
    udf.wlun_337_to_swl_units(t1."Work Load Units") AS leea_safe_working_load_units,
    t1."YWRef" AS statutory_reference_number,
    t1."Test Cert No" AS test_cert_no,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_beam_trolley t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLTTTR';

-- ai2_classrep.equiclass_fall_arrester ==> s4_classrep.equiclass_llwaab
INSERT OR REPLACE INTO s4_classrep.equiclass_llwaab BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_fall_arrester t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLWAAB';

-- ai2_classrep.equiclass_ropes ==> s4_classrep.equiclass_llwrwi
INSERT OR REPLACE INTO s4_classrep.equiclass_llwrwi BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ropes t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LLWRWI';


-- ai2_classrep.equiclass_conductivity_level_instrument ==> s4_classrep.equiclass_lstnco
INSERT OR REPLACE INTO s4_classrep.equiclass_lstnco BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS lstn_output_type,
    NULL AS lstn_range_max,
    NULL AS lstn_range_min,
    NULL AS lstn_range_units,
    NULL AS lstn_signal_type,
    NULL AS lstn_supply_voltage,
    NULL AS lstn_supply_voltage_units,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_conductivity_level_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LSTNCO';

-- ai2_classrep.equiclass_float_level_instrument ==> s4_classrep.equiclass_lstnfl
INSERT OR REPLACE INTO s4_classrep.equiclass_lstnfl BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS lstn_range_max,
    NULL AS lstn_range_min,
    NULL AS lstn_range_units,
    NULL AS lstn_signal_type,
    NULL AS lstn_supply_voltage,
    NULL AS lstn_supply_voltage_units,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_float_level_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LSTNFL';

-- ai2_classrep.equiclass_capacitance_level_instrument ==> s4_classrep.equiclass_lstncp
INSERT OR REPLACE INTO s4_classrep.equiclass_lstncp BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_capacitance_level_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LSTNCP';

-- ai2_classrep.equiclass_pressure_for_level_instrument ==> s4_classrep.equiclass_lstnpr
INSERT OR REPLACE INTO s4_classrep.equiclass_lstnpr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_pressure_for_level_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LSTNPR';

-- ai2_classrep.equiclass_radar_level_instrument ==> s4_classrep.equiclass_lstnrd
INSERT OR REPLACE INTO s4_classrep.equiclass_lstnrd BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS lstn_range_max,
    NULL AS lstn_range_min,
    NULL AS lstn_range_units,
    NULL AS lstn_signal_guidance,
    NULL AS lstn_signal_type,
    NULL AS lstn_supply_voltage,
    NULL AS lstn_supply_voltage_units,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_radar_level_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LSTNRD';


-- ai2_classrep.equiclass_tuning_fork_level_instrument ==> s4_classrep.equiclass_lstntf
INSERT OR REPLACE INTO s4_classrep.equiclass_lstntf BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_tuning_fork_level_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LSTNTF';


-- ai2_classrep.equiclass_sludge_blanket_level_instrument ==> s4_classrep.equiclass_lstnus
INSERT OR REPLACE INTO s4_classrep.equiclass_lstnus BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_sludge_blanket_level_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LSTNUS';

-- ai2_classrep.equiclass_ultrasonic_level_instrument ==> s4_classrep.equiclass_lstnut
INSERT OR REPLACE INTO s4_classrep.equiclass_lstnut BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Transducer Type" AS lstn_transducer_model,
    t1."Transducer Serial No" AS lstn_transducer_serial_no,
    t1."Range min" AS lstn_range_min,
    t1."Range max" AS lstn_range_max,
    upper(t1."Range unit") AS lstn_range_units,
    udf.format_signal3(t1."Signal min", t1."Signal max", t1."Signal unit") AS lstn_signal_type,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS lstn_relay_1_function,
    NULL AS lstn_relay_2_function,
    NULL AS lstn_relay_3_function,
    NULL AS lstn_relay_4_function,
    NULL AS lstn_relay_5_function,
    NULL AS lstn_relay_6_function,
    NULL AS lstn_relay_1_off_level_m,
    NULL AS lstn_relay_2_off_level_m,
    NULL AS lstn_relay_3_off_level_m,
    NULL AS lstn_relay_4_off_level_m,
    NULL AS lstn_relay_5_off_level_m,
    NULL AS lstn_relay_6_off_level_m,
    NULL AS lstn_relay_1_on_level_m,
    NULL AS lstn_relay_2_on_level_m,
    NULL AS lstn_relay_3_on_level_m,
    NULL AS lstn_relay_4_on_level_m,
    NULL AS lstn_relay_5_on_level_m,
    NULL AS lstn_relay_6_on_level_m,
    NULL AS lstn_set_to_snort,
    NULL AS lstn_supply_voltage,
    NULL AS lstn_supply_voltage_units,
    NULL AS lstn_transmitter_model,
    NULL AS lstn_transmitter_serial_no,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ultrasonic_level_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'LSTNUT';




-- ai2_classrep.equiclass_mcc_unit ==> s4_classrep.equiclass_mccepa
INSERT OR REPLACE INTO s4_classrep.equiclass_mccepa BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Voltage In" AS mcce_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS mcce_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS mcce_fault_rating_ka,
    NULL AS mcce_number_of_phase,
    NULL AS mcce_number_of_ways,
    NULL AS mcce_rated_current_a,
    NULL AS mcce_sld_ref_no,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_mcc_unit t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'MCCEPA';

-- ai2_classrep.equiclass_electric_meter ==> s4_classrep.equiclass_metrel
INSERT OR REPLACE INTO s4_classrep.equiclass_metrel BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."HH_non HH site" AS metr_hh_meter,
    t1."MPAN number" AS metr_mpan_number,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_electric_meter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'METREL';


-- ai2_classrep.equiclass_stirrers_mixers_agitators ==> s4_classrep.equiclass_mixrro
INSERT OR REPLACE INTO s4_classrep.equiclass_mixrro BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_stirrers_mixers_agitators t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'MIXRRO';

-- ai2_classrep.equiclass_network_switch ==> s4_classrep.equiclass_netwco
INSERT OR REPLACE INTO s4_classrep.equiclass_netwco BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_network_switch t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'NETWCO';


-- ai2_classrep.equiclass_network_switch ==> s4_classrep.equiclass_netwen
INSERT OR REPLACE INTO s4_classrep.equiclass_netwen BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_network_switch t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'NETWEN';

-- Modbus
-- ai2_classrep.equiclass_network ==> s4_classrep.equiclass_netwmb
INSERT OR REPLACE INTO s4_classrep.equiclass_netwmo BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,  
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_network t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'NETWMB';

-- ai2_classrep.equiclass_modem ==> s4_classrep.equiclass_netwmo
INSERT OR REPLACE INTO s4_classrep.equiclass_netwmo BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS netw_supply_voltage,
    NULL AS netw_supply_voltage_units,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_modem t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'NETWMO';


-- ai2_classrep.equiclass_radio_tx_rx_control_equipment ==> s4_classrep.equiclass_netwra
INSERT OR REPLACE INTO s4_classrep.equiclass_netwra BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS netw_supply_voltage,
    NULL AS netw_supply_voltage_units,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_radio_tx_rx_control_equipment t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'NETWRA';

-- ai2_classrep.equiclass_telemetry_outstation ==> s4_classrep.equiclass_netwtl
INSERT OR REPLACE INTO s4_classrep.equiclass_netwtl BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS netw_supply_voltage,
    NULL AS netw_supply_voltage_units,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_telemetry_outstation t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'NETWTL';


-- ai2_classrep.equiclass_power_supply ==> s4_classrep.equiclass_podedl
INSERT OR REPLACE INTO s4_classrep.equiclass_podedl BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_power_supply t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PODEDL';


-- ai2_classrep.equiclass_power_supply ==> s4_classrep.equiclass_podetu
INSERT OR REPLACE INTO s4_classrep.equiclass_podetu BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_power_supply t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PODETU';



-- ai2_classrep.equiclass_power_supply ==> s4_classrep.equiclass_podeup
INSERT OR REPLACE INTO s4_classrep.equiclass_podeup BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_power_supply t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PODEUP';

-- ai2_classrep.equiclass_ups_systems ==> s4_classrep.equiclass_podeup
INSERT OR REPLACE INTO s4_classrep.equiclass_podeup BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    t1."IP Rating" AS ip_rating,
    t1."Current In" AS pode_input_current_a,
    t1."Voltage In" AS pode_input_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS pode_input_voltage_units,
    t1."No of Phases" AS pode_number_of_phase,
    t1."Voltage Out" AS pode_output_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage Out (AC Or DC)") AS pode_output_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pode_battery_backup_time_min,
    NULL AS pode_battery_recharge_time_h,
    NULL AS pode_output_current_a,
    NULL AS pode_rated_temperature_deg_c,
    NULL AS pode_sld_ref_no,
    NULL AS rated_power_kva, -- TODO
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ups_systems t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PODEUP';


-- ai2_classrep.equiclass_ww_cloth_media_filter ==> s4_classrep.equiclass_profsa
INSERT OR REPLACE INTO s4_classrep.equiclass_profsa BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_cloth_media_filter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PROFSA';



-- ai2_classrep.equiclass_ww_percolating_filter ==> s4_classrep.equiclass_profsa
INSERT OR REPLACE INTO s4_classrep.equiclass_profsa BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_percolating_filter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PROFPC';


-- ai2_classrep.equiclass_ww_sand_filter ==> s4_classrep.equiclass_profsn
INSERT OR REPLACE INTO s4_classrep.equiclass_profsn BY NAME
SELECT
    t.equipment_transit_id AS equipment_id, 
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_sand_filter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PROFSN';


-- ai2_classrep.equiclass_differential_pressure_flow_instrument ==> s4_classrep.equiclass_pstndi
INSERT OR REPLACE INTO s4_classrep.equiclass_pstndi BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'DIFFERENTIAL' AS pstn_pressure_instrument_type,
    t1."Range min" AS pstn_range_min,
    t1."Range max" AS pstn_range_max,
    upper(t1."Range unit") AS pstn_range_units,
    udf.format_signal3(t1."Signal min", t1."Signal max", t1."Signal unit") AS pstn_signal_type,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pstn_supply_voltage,
    NULL AS pstn_supply_voltage_units,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_differential_pressure_flow_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PSTNDI';

-- ai2_classrep.equiclass_gauge_pressure ==> s4_classrep.equiclass_pstndi
INSERT OR REPLACE INTO s4_classrep.equiclass_pstndi BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Range min" AS pstn_range_min,
    t1."Range max" AS pstn_range_max,
    upper(t1."Range unit") AS pstn_range_units,
    udf.format_signal3(t1."Signal min", t1."Signal max", t1."Signal unit") AS pstn_signal_type,
    t1."Voltage In" AS pstn_supply_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS pstn_supply_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pstn_pressure_instrument_type,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_gauge_pressure t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PSTNDI';


-- ai2_classrep.equiclass_pressure_switches ==> s4_classrep.equiclass_pstndi
INSERT OR REPLACE INTO s4_classrep.equiclass_pstndi BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Range min" AS pstn_range_min,
    t1."Range max" AS pstn_range_max,
    upper(t1."Range unit") AS pstn_range_units,
    udf.format_signal3(t1."Signal min", t1."Signal max", t1."Signal unit") AS pstn_signal_type,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pstn_pressure_instrument_type,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_pressure_switches t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PSTNDI';

-- ai2_classrep.equiclass_axial_pump ==> s4_classrep.equiclass_pumpax
INSERT OR REPLACE INTO s4_classrep.equiclass_pumpax BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    t1."Impeller Type" AS pump_impeller_type,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_axial_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPAX';


-- ai2_classrep.equiclass_centrifugal_pump ==> s4_classrep.equiclass_pumpce
INSERT OR REPLACE INTO s4_classrep.equiclass_pumpce BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    t1."Impeller Type" AS pump_impeller_type,
    udf.convert_to_metres(t1."Duty Head", t1."Duty Head Units") AS pump_installed_design_head_m,
    t1."No Of Stages" AS pump_number_of_stage,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pump_inlet_size_mm,
    NULL AS pump_media_type,
    NULL AS pump_outlet_size_mm,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_centrifugal_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPCE';

-- ai2_classrep.equiclass_diaphragm_pump ==> s4_classrep.equiclass_pumpdi
INSERT OR REPLACE INTO s4_classrep.equiclass_pumpdi BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    udf.convert_to_metres(t1."Duty Head", t1."Duty Head Units") AS pump_installed_design_head_m,
    t2."Insulation Class" AS insulation_class_deg_c,
    t2."IP Rating" AS ip_rating,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pump_diaphragm_material,
    NULL AS pump_inlet_size_mm,
    NULL AS pump_media_type,
    NULL AS pump_motor_type,
    NULL AS pump_outlet_size_mm,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_diaphragm_pump t1 ON t1.ai2_reference = t.ai2_reference
LEFT JOIN ai2_classrep.equimixin_integral_motor t2 
    ON t2.ai2_reference = t.ai2_reference    
WHERE t.s4_class = 'PUMPDI';

-- ai2_classrep.equiclass_ejector_pump ==> s4_classrep.equiclass_pumpej
INSERT OR REPLACE INTO s4_classrep.equiclass_pumpej BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ejector_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPEJ';


-- ai2_classrep.equiclass_gear_pump ==> s4_classrep.equiclass_pumpge
INSERT OR REPLACE INTO s4_classrep.equiclass_pumpge BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_gear_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPGE';


-- ai2_classrep.equiclass_helical_rotor_pump ==> s4_classrep.equiclass_pumphr
-- INSERT OR REPLACE INTO s4_classrep.equiclass_pumphr BY NAME
-- SELECT
--     t.equipment_transit_id AS equipment_id,
--     t1."Location On Site" AS location_on_site,
--     'TEMP_VALUE' AS uniclass_code,
--     'TEMP_VALUE' AS uniclass_desc,
-- FROM equi_translate.worklist t
-- LEFT JOIN ai2_classrep.equiclass_helical_rotor_pump t1 ON t1.ai2_reference = t.ai2_reference
-- WHERE t.s4_class = 'PUMPHR';


-- ai2_classrep.equiclass_macipump ==> s4_classrep.equiclass_pumpma
INSERT OR REPLACE INTO s4_classrep.equiclass_pumpma BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_macipump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPMA';

-- to peristalic buffer pump
-- ai2_classrep.equiclass_peristaltic_pump ==> s4_classrep.equiclass_pumppb
INSERT OR REPLACE INTO s4_classrep.equiclass_pumppb BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    udf.convert_to_metres(t1."Duty Head", t1."Duty Head Units") AS pump_installed_design_head_m,
    t1."Lubricant Type" AS pump_lubricant_type,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_peristaltic_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPPB';


-- to peristalic pump
-- ai2_classrep.equiclass_peristaltic_pump ==> s4_classrep.equiclass_pumppe
INSERT OR REPLACE INTO s4_classrep.equiclass_pumppe BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    udf.convert_to_metres(t1."Duty Head", t1."Duty Head Units") AS pump_installed_design_head_m,
    t1."Lubricant Type" AS pump_lubricant_type,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_peristaltic_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPPE';


-- to plunger pump
-- ai2_classrep.equiclass_plunger_pump ==> s4_classrep.equiclass_pumppg
INSERT OR REPLACE INTO s4_classrep.equiclass_pumppg BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_plunger_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPPG';

-- to ram pump
-- ai2_classrep.equiclass_ram_pump ==> s4_classrep.equiclass_pumpra
INSERT OR REPLACE INTO s4_classrep.equiclass_pumpra BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    udf.convert_to_metres(t1."Duty Head", t1."Duty Head Units") AS pump_installed_design_head_m,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ram_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPRA';


-- ai2_classrep.equiclass_vacuum_pump ==> s4_classrep.equiclass_pumpva
INSERT OR REPLACE INTO s4_classrep.equiclass_pumpva BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_vacuum_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPVA';


-- to screw pump
-- ai2_classrep.equiclass_screw_pump ==> s4_classrep.equiclass_pumpsc
INSERT OR REPLACE INTO s4_classrep.equiclass_pumpsc BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pump_flow_litres_per_sec,
    udf.convert_to_metres(t1."Duty Head", t1."Duty Head Units") AS pump_installed_design_head_m,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pump_rated_power_kw,
    t1."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_screw_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMPSC';


-- ai2_classrep.equiclass_borehole_pump ==> s4_classrep.equiclass_pumsbh
INSERT OR REPLACE INTO s4_classrep.equiclass_pumsbh BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_litres_per_second(t1."Flow", t1."Flow Units") AS pums_flow_litres_per_sec,
    udf.convert_to_metres(t1."Duty Head", t1."Duty Head Units") AS pums_installed_design_head_m,
    t1."No Of Stages" AS pums_number_of_stage,
    udf.convert_to_kilowatts(t1."Rating (Power)", t1."Rating Units") AS pums_rated_power_kw,
    t1."Speed (RPM)" AS pums_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_borehole_pump t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'PUMSBH';



-- ai2_classrep.equiclass_urban_wastewater_sampler ==> s4_classrep.equiclass_sampch
INSERT OR REPLACE INTO s4_classrep.equiclass_sampch BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_urban_wastewater_sampler t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'SAMPCH';


-- ai2_classrep.equiclass_screens ==> s4_classrep.equiclass_scrcba
INSERT OR REPLACE INTO s4_classrep.equiclass_scrcba BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_screens t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'SCRCBA';


-- ai2_classrep.equiclass_screens ==> s4_classrep.equiclass_scrfsc
-- INSERT OR REPLACE INTO s4_classrep.equiclass_scrfsc BY NAME
-- SELECT
--     t.equipment_transit_id AS equipment_id,
--     t1."Location On Site" AS location_on_site,
--     'TEMP_VALUE' AS uniclass_code,
--     'TEMP_VALUE' AS uniclass_desc,
-- FROM equi_translate.worklist t
-- LEFT JOIN ai2_classrep.equiclass_screens t1 ON t1.ai2_reference = t.ai2_reference
-- WHERE t.s4_class = 'SCRFSC';


-- ai2_classrep.equiclass_slip_ring_assembly ==> s4_classrep.equiclass_slipra
INSERT OR REPLACE INTO s4_classrep.equiclass_slipra BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."IP Rating" AS ip_rating,
    t1."Voltage In" AS slip_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS slip_rated_voltage_units,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS slip_rated_power_kw,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS slip_number_of_brushes,
    NULL AS slip_rated_current_a,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_slip_ring_assembly t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'SLIPRA';

-- ai2_classrep.equiclass_inductive_sensor ==> s4_classrep.equiclass_sptnro
INSERT OR REPLACE INTO s4_classrep.equiclass_sptnro BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS sptn_range_max,
    NULL AS sptn_range_min,
    NULL AS sptn_range_units,
    NULL AS sptn_supply_voltage,
    NULL AS sptn_supply_voltage_units,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_inductive_sensor t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'SPTNRO';

-- ai2_classrep.equiclass_auto_transformer_starter ==> s4_classrep.equiclass_starat
INSERT OR REPLACE INTO s4_classrep.equiclass_starat BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."IP Rating" AS ip_rating,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS star_rated_power_kw,
    t1."Voltage In" AS star_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_auto_transformer_starter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'STARAT';


-- ai2_classrep.equiclass_star_delta_starter ==> s4_classrep.equiclass_stardt
INSERT OR REPLACE INTO s4_classrep.equiclass_stardt BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."IP Rating" AS ip_rating,
    t1."Current In" AS star_rated_current_a,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS star_rated_power_kw,
    t1."Voltage In" AS star_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS star_number_of_phase,
    NULL AS star_sld_ref_no,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_star_delta_starter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'STARDT';


-- ai2_classrep.equiclass_direct_on_line_starter ==> s4_classrep.equiclass_stardo
INSERT OR REPLACE INTO s4_classrep.equiclass_stardo BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."IP Rating" AS ip_rating,
    t1."Current In" AS star_rated_current_a,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS star_rated_power_kw,
    t1."Voltage In" AS star_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS star_number_of_phase,
    NULL AS star_number_of_ways,
    NULL AS star_sld_ref_no,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_direct_on_line_starter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'STARDO';

-- STARLQ
-- ai2_classrep.equiclass_resistance_starter ==> s4_classrep.equiclass_starlq
INSERT OR REPLACE INTO s4_classrep.equiclass_starlq BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."IP Rating" AS ip_rating,
    t1."Current In" AS star_rated_current_a,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS star_rated_power_kw,
    t1."Voltage In" AS star_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_resistance_starter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'STARLQ';


-- ai2_classrep.equiclass_resistance_starter ==> s4_classrep.equiclass_starre
INSERT OR REPLACE INTO s4_classrep.equiclass_starre BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."IP Rating" AS ip_rating,
    t1."Current In" AS star_rated_current_a,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS star_rated_power_kw,
    t1."Voltage In" AS star_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_resistance_starter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'STARRE';


-- ai2_classrep.equiclass_reversing_starter ==> s4_classrep.equiclass_starrv
INSERT OR REPLACE INTO s4_classrep.equiclass_starrv BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."IP Rating" AS ip_rating,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS star_rated_power_kw,
    t1."Voltage In" AS star_rated_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_reversing_starter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'STARRV';


-- ai2_classrep.equiclass_soft_starter ==> s4_classrep.equiclass_starss
INSERT OR REPLACE INTO s4_classrep.equiclass_starss BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Current In" AS star_input_current_a,
    t1."Voltage In" AS star_input_voltage,
    udf.acdc_3_to_voltage_units(t1."Voltage In (AC Or DC)") AS star_input_voltage_units,
    t1."IP Rating" AS ip_rating,
    udf.convert_to_kilowatts(t1."Power", t1."Power Units") AS star_rated_power_kw,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_soft_starter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'STARSS';



-- ai2_classrep.equiclass_variable_frequency_starter ==> s4_classrep.equiclass_starvf
INSERT OR REPLACE INTO s4_classrep.equiclass_starvf BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_variable_frequency_starter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'STARVF';


-- ai2_classrep.equiclass_strainer ==> s4_classrep.equiclass_strnbf
INSERT OR REPLACE INTO s4_classrep.equiclass_strnbf BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_strainer t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'STRNBF';

-- ai2_classrep.equiclass_strainer ==> s4_classrep.equiclass_strner
INSERT OR REPLACE INTO s4_classrep.equiclass_strner BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_strainer t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'STRNER';


-- ai2_classrep.equiclass_ww_balancing_tank ==> s4_classrep.equiclass_tankpr
INSERT OR REPLACE INTO s4_classrep.equiclass_tankpr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_balancing_tank t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TANKPR';


-- ai2_classrep.equiclass_ww_flocculation_tank ==> s4_classrep.equiclass_tankpr
INSERT OR REPLACE INTO s4_classrep.equiclass_tankpr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_flocculation_tank t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TANKPR';


-- ai2_classrep.equiclass_ww_humus_tank ==> s4_classrep.equiclass_tankpr
INSERT OR REPLACE INTO s4_classrep.equiclass_tankpr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_humus_tank t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TANKPR';


-- ai2_classrep.equiclass_ww_primary_sedimentation_tank ==> s4_classrep.equiclass_tankpr
INSERT OR REPLACE INTO s4_classrep.equiclass_tankpr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_primary_sedimentation_tank t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TANKPR';

-- ai2_classrep.equiclass_ww_storm_sedimentation_tank ==> s4_classrep.equiclass_tankpr
INSERT OR REPLACE INTO s4_classrep.equiclass_tankpr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_storm_sedimentation_tank t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TANKPR';


-- ai2_classrep.equiclass_cw_chemical_storage_tank ==> s4_classrep.equiclass_tankst
INSERT OR REPLACE INTO s4_classrep.equiclass_tankst BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_cw_chemical_storage_tank t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TANKST';

-- ai2_classrep.equiclass_ww_chemical_storage_tank ==> s4_classrep.equiclass_tankst
INSERT OR REPLACE INTO s4_classrep.equiclass_tankst BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Tank Construction" AS tank_tank_construction,
    t1."Tank Level" AS tank_tank_level,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS tank_tank_covering,
    NULL AS tank_tank_use,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_chemical_storage_tank t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TANKST';

-- ai2_classrep.equiclass_ww_service_water_storage_tank ==> s4_classrep.equiclass_tankst
INSERT OR REPLACE INTO s4_classrep.equiclass_tankst BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Tank Construction" AS tank_tank_construction,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS tank_tank_covering,
    NULL AS tank_tank_level,
    NULL AS tank_tank_use,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_service_water_storage_tank t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TANKST';


-- ai2_classrep.equiclass_ww_sludge_storage_tank ==> s4_classrep.equiclass_tankst
INSERT OR REPLACE INTO s4_classrep.equiclass_tankst BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS tank_tank_construction,
    NULL AS tank_tank_covering,
    NULL AS tank_tank_level,
    NULL AS tank_tank_use,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_sludge_storage_tank t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TANKST';


-- ai2_classrep.equiclass_gearbox ==> s4_classrep.equiclass_truthg
INSERT OR REPLACE INTO s4_classrep.equiclass_truthg BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS trut_rated_power_kw,
    NULL AS trut_rated_torque_nm,
    NULL AS trut_speed_in_rpm,
    NULL AS trut_speed_out_rpm,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_gearbox t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TRUTHG';


-- ai2_classrep.equiclass_gearbox ==> s4_classrep.equiclass_trutpg
INSERT OR REPLACE INTO s4_classrep.equiclass_tankst BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_gearbox t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TRUTPG';

-- ai2_classrep.equiclass_temperature_instrument ==> s4_classrep.equiclass_tstntt
INSERT OR REPLACE INTO s4_classrep.equiclass_tstntt BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_temperature_instrument t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'TSTNTT';

-- ai2_classrep.equiclass_ultra_violet_unit ==> s4_classrep.equiclass_uvunit
INSERT OR REPLACE INTO s4_classrep.equiclass_uvunit BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ultra_violet_unit t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'UVUNIT';


-- ai2_classrep.equiclass_isolating_valves ==> s4_classrep.equiclass_valvba
INSERT OR REPLACE INTO s4_classrep.equiclass_valvba BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_millimetres(t1."Size", t1."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS valv_media_type,
    NULL AS valv_valve_configuration,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_isolating_valves t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VALVBA';


-- ai2_classrep.equiclass_isolating_valves ==> s4_classrep.equiclass_valvbp
INSERT OR REPLACE INTO s4_classrep.equiclass_valvbp BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_millimetres(t1."Size", t1."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_isolating_valves t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VALVBP';


-- ai2_classrep.equiclass_flap_valve ==> s4_classrep.equiclass_valvfl
INSERT OR REPLACE INTO s4_classrep.equiclass_valvfl BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,  
    t1."Location On Site" AS location_on_site,
    udf.convert_to_millimetres(t1."Size", t1."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_flap_valve t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VAVLFL';


-- ai2_classrep.equiclass_isolating_valves ==> s4_classrep.equiclass_valvft
INSERT OR REPLACE INTO s4_classrep.equiclass_valvft BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,  
    t1."Location On Site" AS location_on_site,
    udf.convert_to_millimetres(t1."Size", t1."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_isolating_valves t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VALVFT';

-- ai2_classrep.equiclass_isolating_valves ==> s4_classrep.equiclass_valvga
INSERT OR REPLACE INTO s4_classrep.equiclass_valvga BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_millimetres(t1."Size", t1."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_isolating_valves t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VALVGA';


-- ai2_classrep.equiclass_non_return_valve ==> s4_classrep.equiclass_valvnr
INSERT OR REPLACE INTO s4_classrep.equiclass_valvga BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,  
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udf.convert_to_millimetres(t1."Size", t1."Size Units") AS valv_inlet_size_mm,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_non_return_valve t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VALVNR';


-- ai2_classrep.equiclass_isolating_valves ==> s4_classrep.equiclass_valvpg
INSERT OR REPLACE INTO s4_classrep.equiclass_valvpg BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    udf.convert_to_millimetres(t1."Size", t1."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_isolating_valves t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VALVPG';


-- ai2_classrep.equiclass_pressure_reducing_valve ==> s4_classrep.equiclass_valvpr
INSERT OR REPLACE INTO s4_classrep.equiclass_valvpr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_pressure_reducing_valve t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VALVPR';

-- water
-- ai2_classrep.equiclass_pressure_reducing_valve_water ==> s4_classrep.equiclass_valvpr
INSERT OR REPLACE INTO s4_classrep.equiclass_valvpr BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udf.convert_to_millimetres(t1."Size", t1."Size Units") AS valv_inlet_size_mm,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS valv_rated_pressure_bar,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_pressure_reducing_valve_water t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VALVPR';



-- ai2_classrep.equiclass_pressure_regulating_valve ==> s4_classrep.equiclass_valvre
INSERT OR REPLACE INTO s4_classrep.equiclass_valvre BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udf.convert_to_millimetres(t1."Size", t1."Size Units") AS valv_bore_diameter_mm,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS valv_flow_litres_per_sec,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_pressure_regulating_valve t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VALVRE';


-- ai2_classrep.equiclass_relief_safety_valve ==> s4_classrep.equiclass_valvsf
INSERT OR REPLACE INTO s4_classrep.equiclass_valvsf BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS valv_inlet_size_mm,
    NULL AS valv_rated_pressure_bar,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_relief_safety_valve t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VALVSF';

-- ai2_classrep.equiclass_oil_air_receiver ==> s4_classrep.equiclass_veprao
INSERT OR REPLACE INTO s4_classrep.equiclass_veprao BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_isolating_valves t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VEPRAO';


-- ai2_classrep.equiclass_air_receiver ==> s4_classrep.equiclass_veprar
INSERT OR REPLACE INTO s4_classrep.equiclass_veprar BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Bar Litres" AS vepr_bar_litres,
    t1."Manufactured Year" AS vepr_manufactured_year,
    t1."P.V.Capacity Ltrs" AS vepr_pv_capacity_ltrs_l,
    t1."PV Verification Status" AS vepr_pv_verification_status,
    t1."PV Verification Status Date" AS vepr_pv_verification_date,
    IF(t1."S.W.P or S.O.L. Units" = 'BAR', t1."S.W.P or S.O.L.", null) AS vepr_safe_working_pressure_bar,
    t1."YWRef" AS statutory_reference_number,
    t1."Test Cert No" AS test_cert_no,
    t1."Test Pressure bars" AS vepr_test_pressure_bar,
    t1."Written Scheme No" AS vepr_written_scheme_number,
    udf.swpt_815_to_vepr_swp_type(t1."Safe Working Procedure Type - Location") AS vepr_swp_type,
    udf.swpt_815_to_vepr_swp_location(t1."Safe Working Procedure Type - Location") AS vepr_swp_location,
    t1."Safe Working Procedure Name" AS vepr_swp_name,
    t1."Safe Working Procedure Date" AS vepr_swp_date,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_air_receiver t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VEPRAR';



-- ai2_classrep.equiclass_water_air_receiver ==> s4_classrep.equiclass_vepraw
INSERT OR REPLACE INTO s4_classrep.equiclass_veprar BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_water_air_receiver t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VEPRAW';

-- ai2_classrep.equiclass_pulsation_damper ==> s4_classrep.equiclass_veprpd
INSERT OR REPLACE INTO s4_classrep.equiclass_veprpd BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Bar Litres" AS vepr_bar_litres,
    t1."Manufactured Year" AS vepr_manufactured_year,
    t1."P.V.Capacity Ltrs" AS vepr_pv_capacity_ltrs_l,
    t1."PV Verification Status" AS vepr_pv_verification_status,
    t1."PV Verification Status Date" AS vepr_pv_verification_date,
    IF(t1."S.W.P or S.O.L. Units" = 'BAR', t1."S.W.P or S.O.L.", null) AS vepr_safe_working_pressure_bar,
    t1."YWRef" AS statutory_reference_number,
    t1."Test Cert No" AS test_cert_no,
    t1."Test Pressure bars" AS vepr_test_pressure_bar,
    t1."Written Scheme No" AS vepr_written_scheme_number,
    udf.swpt_815_to_vepr_swp_type(t1."Safe Working Procedure Type - Location") AS vepr_swp_type,
    udf.swpt_815_to_vepr_swp_location(t1."Safe Working Procedure Type - Location") AS vepr_swp_location,
    t1."Safe Working Procedure Name" AS vepr_swp_name,
    t1."Safe Working Procedure Date" AS vepr_swp_date,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pv_inspection_frequency_months,
    NULL AS vepr_material,
    NULL AS vepr_rated_temperature_deg_c,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_pulsation_damper t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'VEPRPD';


-- ai2_classrep.equiclass_ww_chemical_storage_tank ==> s4_classrep.equiclass_wellwt
INSERT OR REPLACE INTO s4_classrep.equiclass_wellwt BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."Tank Construction" AS well_tank_construction,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_ww_chemical_storage_tank t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'WELLWT';



