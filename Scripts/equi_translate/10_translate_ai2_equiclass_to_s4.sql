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
INSERT OR REPLACE INTO s4_classrep.equiclass_conpnl BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_conveyors t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'CVYRBC';

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

