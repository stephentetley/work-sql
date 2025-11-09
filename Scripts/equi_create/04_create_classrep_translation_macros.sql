-- # ai2 to s4 translation macros

-- Schema name should always be 'ai2_classrep'
-- We have made this a parameter to stop DuckDB "type checking" these macros
-- ahead of use. We won't necessarily be creating all the `ai2_classrep.equiclass_*`
-- tables because it creates huge files.

CREATE OR REPLACE MACRO ac_induction_motor_to_emtrin(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."Insulation Class" AS insulation_class_deg_c,
    t."IP Rating" AS ip_rating,
    t."Current In" AS emtr_rated_current_a,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS emtr_rated_power_kw,
    t."Speed (RPM)" AS emtr_rated_speed_rpm,
    t."Voltage In" AS emtr_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS emtr_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name:: VARCHAR || '.equiclass_ac_induction_motor') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'EMTRIN';



CREATE OR REPLACE MACRO actuator_to_actuem(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."Insulation Class" AS insulation_class_deg_c,
    t."IP Rating" AS ip_rating,
    t."Current In" AS actu_rated_current_a,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS actu_rated_power_kw,
    t."Voltage In" AS actu_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS actu_rated_voltage_units,
    t."Speed (RPM)" AS actu_speed_rpm,
    t."Valve Torque (Nm)" AS actu_valve_torque_nm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS actu_atex_code,
    NULL AS actu_number_of_phase,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_actuator') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ACTUEM';


CREATE OR REPLACE MACRO air_auto_cleaner_to_blowab(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS blow_rated_power_kw,
    t."Voltage In" AS blow_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS blow_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_air_auto_cleaner') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'BLOWAB';


CREATE OR REPLACE MACRO air_receiver_to_veprar(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."Bar Litres" AS vepr_bar_litres,
    t."Manufactured Year" AS vepr_manufactured_year,
    t."P.V.Capacity Ltrs" AS vepr_pv_capacity_ltrs_l,
    t."PV Verification Status" AS vepr_pv_verification_status,
    t."PV Verification Status Date" AS vepr_pv_verification_date,
    IF(t."S.W.P or S.O.L. Units" = 'BAR', t."S.W.P or S.O.L.", null) AS vepr_safe_working_pressure_bar,
    t."YWRef" AS statutory_reference_number,
    t."Test Cert No" AS test_cert_no,
    t."Test Pressure bars" AS vepr_test_pressure_bar,
    t."Written Scheme No" AS vepr_written_scheme_number,
    udf_local.swpt_815_to_vepr_swp_type(t."Safe Working Procedure Type - Location") AS vepr_swp_type,
    udf_local.swpt_815_to_vepr_swp_location(t."Safe Working Procedure Type - Location") AS vepr_swp_location,
    t."Safe Working Procedure Name" AS vepr_swp_name,
    t."Safe Working Procedure Date" AS vepr_swp_date,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_air_receiver') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VEPRAR';


CREATE OR REPLACE MACRO ammonia_instrument_to_analam(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."Range max" AS anal_range_max,
    t."Range min" AS anal_range_min,
    udf_local.rngu_132_to_anal_range_unit(t."Range unit") AS anal_range_units,
    udf_local.format_signal3(t."Signal min", t."Signal max", t."Signal unit") AS anal_signal_type,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ammonia_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ANALAM';


CREATE OR REPLACE MACRO auto_transformer_starter_to_starat(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."IP Rating" AS ip_rating,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS star_rated_power_kw,
    t."Voltage In" AS star_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_auto_transformer_starter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STARAT';


CREATE OR REPLACE MACRO axial_pump_to_pumpax(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    t."Impeller Type" AS pump_impeller_type,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_axial_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPAX';


CREATE OR REPLACE MACRO beam_trolley_to_lltttr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."Work Load" AS leea_safe_working_load,
    udf_local.wlun_337_to_swl_units(t."Work Load Units") AS leea_safe_working_load_units,
    t."YWRef" AS statutory_reference_number,
    t."Test Cert No" AS test_cert_no,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_beam_trolley') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLTTTR';


CREATE OR REPLACE MACRO blowers_to_blowcb(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_cubic_metres_per_hour(t."Flow", t."Flow Units") AS blow_flow_cubic_metre_per_hour,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS blow_rated_power_kw,
    t."Speed (RPM)" AS blow_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_blowers') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'BLOWCB';


CREATE OR REPLACE MACRO blowers_to_blowsc(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_cubic_metres_per_hour(t."Flow", t."Flow Units") AS blow_flow_cubic_metre_per_hour,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS blow_rated_power_kw,
    t."Speed (RPM)" AS blow_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_blowers') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'BLOWSC';


CREATE OR REPLACE MACRO borehole_pump_to_pumsbh(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pums_flow_litres_per_sec,
    udfx_db.udfx.convert_to_metres(t."Duty Head", t."Duty Head Units") AS pums_installed_design_head_m,
    t."No Of Stages" AS pums_number_of_stage,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pums_rated_power_kw,
    t."Speed (RPM)" AS pums_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_borehole_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMSBH';


CREATE OR REPLACE MACRO bridge_to_accstbr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udf_local.get_weight_limit_tonnes(t."Weight Limit") AS acst_weight_limit,
    t."Alternative Crossing" AS alternative_crossing,
    t."Public Access" AS acst_public_access,
    t."Public Highway" AS acst_public_highway,
    t."Parapet" AS acst_parapet,
    t."Primary Access" AS acst_primary_access,
    t."Secondary Access" AS acst_secondary_access,
    t."Bridge Use" AS acst_bridge_use,
    t."Crossing Use" AS acst_crossing_use,
    t."Deck Surface Material" AS acst_deck_surface_material,
    udfx_db.udfx.convert_to_millimetres(t."Length (m)", 'M') AS acst_length_mm,
    udfx_db.udfx.convert_to_millimetres(t."Width (m)", 'M') AS acst_width_mm,
    t."Average Pedestrian Per Day" AS average_pedestrian_per_day,
    udf_local.bdfv_757_to_bridge_vehicles_per_day(t."Average Vehicles Per Day") AS average_vehicles_per_day,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_bridge') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ACSTBR';


CREATE OR REPLACE MACRO burglar_alarm_to_alamia(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."IP Rating" AS ip_rating,
    t."Voltage In" AS alam_input_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS alam_input_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_burglar_alarm') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ALAMIA';


CREATE OR REPLACE MACRO capacitance_level_instrument_to_lstncp(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_capacitance_level_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNCP';


CREATE OR REPLACE MACRO centrifugal_pump_to_pumpce(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    t."Impeller Type" AS pump_impeller_type,
    udfx_db.udfx.convert_to_metres(t."Duty Head", t."Duty Head Units") AS pump_installed_design_head_m,
    t."No Of Stages" AS pump_number_of_stage,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pump_inlet_size_mm,
    NULL AS pump_media_type,
    NULL AS pump_outlet_size_mm,
FROM query_table(schema_name::VARCHAR || '.equiclass_centrifugal_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPCE';


CREATE OR REPLACE MACRO chain_beam_hoist_hand_to_llmhch(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."Work Load" AS leea_safe_working_load,
    udf_local.wlun_337_to_swl_units(t."Work Load Units") AS leea_safe_working_load_units,
    t."YWRef" AS statutory_reference_number,
    t."Test Cert No" AS test_cert_no,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_chain_beam_hoist_hand') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLMHCH';


CREATE OR REPLACE MACRO chain_slings_to_llcscs(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_millimetres(t."Effective Working Length (m)", 'METRES') AS leea_eff_working_length_mm,
    t."Work Load" AS leea_safe_working_load,
    udf_local.wlun_337_to_swl_units(t."Work Load Units") AS leea_safe_working_load_units,
    t."YWRef" AS statutory_reference_number,
    t."Test Cert No" AS test_cert_no,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_chain_slings') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLCSCS';


CREATE OR REPLACE MACRO classifier_gricse(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_classifier') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'GRICSC';


CREATE OR REPLACE MACRO compressed_air_equipment_to_compsc(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_compressed_air_equipment') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'COMPSC';


CREATE OR REPLACE MACRO compressed_air_equipment_to_compre(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_compressed_air_equipment') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'COMPRE';


CREATE OR REPLACE MACRO conductivity_level_instrument_to_lstnco(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
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
FROM query_table(schema_name::VARCHAR || '.equiclass_conductivity_level_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNCO';


CREATE OR REPLACE MACRO control_panel_to_conpnl(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_control_panel') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'CONPNL';


CREATE OR REPLACE MACRO controller_to_conttr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_controller') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'CONTTR';


CREATE OR REPLACE MACRO conveyors_to_cvyrbc(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_conveyor') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'CVYRBC';


CREATE OR REPLACE MACRO cw_chemical_storage_tank_to_tankst(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_cw_chemical_storage_tank') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKST';


CREATE OR REPLACE MACRO davit_to_llddda(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."Work Load" AS leea_safe_working_load,
    udf_local.wlun_337_to_swl_units(t."Work Load Units") AS leea_safe_working_load_units,
    t."YWRef" AS statutory_reference_number,
    t."Test Cert No" AS test_cert_no,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_davit') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLDDDA';


CREATE OR REPLACE MACRO davit_sockets_to_lldsds(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."Work Load" AS leea_safe_working_load,
    udf_local.wlun_337_to_swl_units(t."Work Load Units") AS leea_safe_working_load_units,
    t."YWRef" AS statutory_reference_number,
    t."Test Cert No" AS test_cert_no,
    t."Test Cert No" AS test_cert_no,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_davit_sockets') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLDSDS';


CREATE OR REPLACE MACRO diaphragm_pump_to_pumpdi(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    udfx_db.udfx.convert_to_metres(t."Duty Head", t."Duty Head Units") AS pump_installed_design_head_m,
    t2."Insulation Class" AS insulation_class_deg_c,
    t2."IP Rating" AS ip_rating,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pump_diaphragm_material,
    NULL AS pump_inlet_size_mm,
    NULL AS pump_media_type,
    NULL AS pump_motor_type,
    NULL AS pump_outlet_size_mm,
FROM query_table(schema_name::VARCHAR || '.equiclass_diaphragm_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
JOIN ai2_classrep.equimixin_integral_motor t2 
    ON t2.ai2_reference = t.ai2_reference    
WHERE t1.s4_class = 'PUMPDI';

CREATE OR REPLACE MACRO direct_on_line_starter_to_stardo(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."IP Rating" AS ip_rating,
    t."Current In" AS star_rated_current_a,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS star_rated_power_kw,
    t."Voltage In" AS star_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS star_number_of_phase,
    NULL AS star_number_of_ways,
    NULL AS star_sld_ref_no,
FROM query_table(schema_name::VARCHAR || '.equiclass_direct_on_line_starter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STARDO';


CREATE OR REPLACE MACRO distribution_board_to_distbd(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_distribution_board') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'DISTBD';


CREATE OR REPLACE MACRO distributors_to_biofrd(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_distributors') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'BIOFRD';


CREATE OR REPLACE MACRO doppler_flow_instrument_to_fstnus(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_doppler_flow_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNUS';


CREATE OR REPLACE MACRO ejector_pump_to_pumpej(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ejector_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPEJ';


CREATE OR REPLACE MACRO electric_meter_to_metrel(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_electric_meter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'METREL';



CREATE OR REPLACE MACRO emergency_eye_bath_to_decoeb(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_emergency_eye_bath') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'DECOEB';


CREATE OR REPLACE MACRO emergency_lighting_to_lideem(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_emergency_lighting') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LIDEEM';


CREATE OR REPLACE MACRO emergency_shower_eye_bath_to_decoes(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_emergency_shower_eye_bath') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'DECOES';


CREATE OR REPLACE MACRO eye_bolts_to_llebbo(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_eye_bolts') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLEBBO';


CREATE OR REPLACE MACRO fall_arrester_to_llwaab(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_fall_arrester') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLWAAB';


CREATE OR REPLACE MACRO fan_to_fansce(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_fan') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FANSCE';


CREATE OR REPLACE MACRO fire_alarm_to_alamfs(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_fire_alarm') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ALAMFS';


CREATE OR REPLACE MACRO flap_valve_to_valvfl(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udfx_db.udfx.convert_to_millimetres(t."Size", t."Size Units") AS valv_inlet_size_mm,
FROM query_table(schema_name::VARCHAR || '.equiclass_flap_valve') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VAVLFL';


CREATE OR REPLACE MACRO float_level_instrument_to_lstnfl(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
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
FROM query_table(schema_name::VARCHAR || '.equiclass_float_level_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNFL';

-- Fixed
CREATE OR REPLACE MACRO gantries_to_llggfx(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_gantries') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLGGFX';


-- Portable
CREATE OR REPLACE MACRO gantries_to_llggpt(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_gantries') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLGGPT';


CREATE OR REPLACE MACRO gauge_pressure_to_pstndi(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pstn_pressure_instrument_type,
    NULL AS pstn_range_max,
    NULL AS pstn_range_min,
    NULL AS pstn_range_units,
    NULL AS pstn_signal_type,
    NULL AS pstn_supply_voltage,
    NULL AS pstn_supply_voltage_units,
FROM query_table(schema_name::VARCHAR || '.equiclass_gauge_pressure') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PSTNDI';


CREATE OR REPLACE MACRO gear_pump_to_pumpge(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_gear_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPGE';


CREATE OR REPLACE MACRO gearbox_to_trutpg(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_gearbox') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TRUTPG';


CREATE OR REPLACE MACRO gearbox_to_truthg(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS trut_rated_power_kw,
    NULL AS trut_rated_torque_nm,
    NULL AS trut_speed_in_rpm,
    NULL AS trut_speed_out_rpm,
FROM query_table(schema_name::VARCHAR || '.equiclass_gearbox') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TRUTHG';


CREATE OR REPLACE MACRO geared_motor_to_gmtrgm(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_geared_motor') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'GMTRGM';


CREATE OR REPLACE MACRO helical_rotor_pump_to_pumphr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_helical_rotor_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPHR';



CREATE OR REPLACE MACRO inductive_sensor_to_sptnro(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
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
FROM query_table(schema_name::VARCHAR || '.equiclass_inductive_sensor') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'SPTNRO';



CREATE OR REPLACE MACRO insertion_flow_instrument_to_fstnip(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_insertion_flow_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNIP';


CREATE OR REPLACE MACRO isolating_valves_to_valvba(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_millimetres(t."Size", t."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS valv_media_type,
    NULL AS valv_valve_configuration,
FROM query_table(schema_name::VARCHAR || '.equiclass_isolating_valves') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVBA';


CREATE OR REPLACE MACRO isolating_valves_to_valvbp(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_millimetres(t."Size", t."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_isolating_valves') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVBP';


CREATE OR REPLACE MACRO isolating_valves_to_valvga(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_millimetres(t."Size", t."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_isolating_valves') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVGA';


CREATE OR REPLACE MACRO isolating_valves_to_valvft(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_millimetres(t."Size", t."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_isolating_valves') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVFT';


CREATE OR REPLACE MACRO isolating_valves_to_valvpg(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_millimetres(t."Size", t."Size Units") AS valv_inlet_size_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_isolating_valves') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVPG';



CREATE OR REPLACE MACRO jack_hydraulic_to_lljjck(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_jack_hydraulic') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLJJCK';


CREATE OR REPLACE MACRO jack_ratchet_to_lljjck(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_jack_ratchet') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLJJCK';


-- to jib crane
CREATE OR REPLACE MACRO jib_crane_to_lljcji(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_jib_crane') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLJCJI';


-- to pillar jib crane
CREATE OR REPLACE MACRO jib_crane_to_lljcpj(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_jib_crane') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLJCPJ';


-- to swing jib crane
CREATE OR REPLACE MACRO jib_crane_to_lljcsw(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_jib_crane') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLJCSW';


-- to wall jib crane
CREATE OR REPLACE MACRO jib_crane_to_lljcwa(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_jib_crane') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLJCWA';



CREATE OR REPLACE MACRO kiosk_to_kiskki(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udf_local.cafl_435_to_kisk_cat_flap_available(t."Cat Flap Available") AS kisk_cat_flap_available,
    udf_local.kosk_471_to_kisk_material(t."Kiosk Material") AS kisk_material,
    udfx_db.udfx.convert_to_millimetres(t."Kiosk Base Height (m)", 'METRES') AS kisk_base_height_mm,
    udfx_db.udfx.convert_to_millimetres(t."Kiosk Depth (m)", 'METRES') AS kisk_depth_mm,
    udfx_db.udfx.convert_to_millimetres(t."Kiosk Height (m)", 'METRES') AS kisk_height_mm,
    udfx_db.udfx.convert_to_millimetres(t."Kiosk Width (m)", 'METRES') AS kisk_width_mm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_kiosk') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'KISKKI';


CREATE OR REPLACE MACRO l_o_i_to_intflo(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS intf_instrument_power_w,
    NULL AS intf_rated_voltage,
    NULL AS intf_rated_voltage_units,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_l_o_i') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'INTFLO';


CREATE OR REPLACE MACRO limit_switch_to_gaswip(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS gasw_rated_voltage,
    NULL AS gasw_rated_voltage_units,
    NULL AS gasw_sensing_range_bar,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_limit_switch') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'GASWIP';

CREATE OR REPLACE MACRO macipump_to_pumpma(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_macipump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPMA';


CREATE OR REPLACE MACRO magnetic_flow_instrument_to_fstnem(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_magnetic_flow_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNEM';

CREATE OR REPLACE MACRO mcc_unit_to_mccepa(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS mcce_fault_rating_ka,
    NULL AS mcce_number_of_phase,
    NULL AS mcce_number_of_ways,
    NULL AS mcce_rated_current_a,
    NULL AS mcce_rated_voltage,
    NULL AS mcce_rated_voltage_units,
    NULL AS mcce_sld_ref_no,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_mcc_unit') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'MCCEPA';



CREATE OR REPLACE MACRO mechanical_air_heater_to_heatai(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_mechanical_air_heater') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'HEATAI';


CREATE OR REPLACE MACRO modem_to_netwmo(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS netw_supply_voltage,
    NULL AS netw_supply_voltage_units,
FROM query_table(schema_name::VARCHAR || '.equiclass_modem') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'NETWMO';


-- Modbus
CREATE OR REPLACE MACRO network_to_netwmb(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_network') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'NETWMB';


CREATE OR REPLACE MACRO network_switch_to_netwco(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_network_switch') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'NETWCO';


CREATE OR REPLACE MACRO network_switch_to_netwen(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_network_switch') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'NETWEN';

CREATE OR REPLACE MACRO non_immersible_motor_to_emtrin(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
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
FROM query_table(schema_name::VARCHAR || '.equiclass_non_immersible_motor') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'EMTRIN';


CREATE OR REPLACE MACRO non_return_valve_to_valvnr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udfx_db.udfx.convert_to_millimetres(t."Size", t."Size Units") AS valv_inlet_size_mm,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS valv_flow_litres_per_sec,
    NULL AS valv_rated_temperature_deg_c,
FROM query_table(schema_name::VARCHAR || '.equiclass_non_return_valve') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVNR';


CREATE OR REPLACE MACRO oil_air_receiver_to_veprao(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_oil_air_receiver') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VEPRAO';


-- to peristalic buffer pump
CREATE OR REPLACE MACRO peristaltic_pump_to_pumppb(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    udfx_db.udfx.convert_to_metres(t."Duty Head", t."Duty Head Units") AS pump_installed_design_head_m,
    t."Lubricant Type" AS pump_lubricant_type,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_peristaltic_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPPB';


-- to peristalic pump
CREATE OR REPLACE MACRO peristaltic_pump_to_pumppe(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    udfx_db.udfx.convert_to_metres(t."Duty Head", t."Duty Head Units") AS pump_installed_design_head_m,
    t."Lubricant Type" AS pump_lubricant_type,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_peristaltic_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPPE';


CREATE OR REPLACE MACRO plc_to_contpl(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS cont_instrument_power_w,
    NULL AS cont_rated_voltage,
    NULL AS cont_rated_voltage_units,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
FROM query_table(schema_name::VARCHAR || '.equiclass_plc') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'CONTPL';


CREATE OR REPLACE MACRO plc_to_actuep(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_pneumatic_actuator') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ACTUEP';


-- to plunger pump
CREATE OR REPLACE MACRO plunger_pump_to_pumppg(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_plunger_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPPG';


CREATE OR REPLACE MACRO power_supply_to_podedl(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_power_supply') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PODEDL';


CREATE OR REPLACE MACRO power_supply_to_podetu(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_power_supply') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PODETU';


CREATE OR REPLACE MACRO power_supply_to_podeup(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_power_supply') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PODEUP';

CREATE OR REPLACE MACRO pressure_for_level_instrument_to_lstnpr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_pressure_for_level_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNPR';


CREATE OR REPLACE MACRO pressure_reducing_valve_to_valvpr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_pressure_reducing_valve') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVPR';


CREATE OR REPLACE MACRO pressure_reducing_valve_water_to_valvpr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udfx_db.udfx.convert_to_millimetres(t."Size", t."Size Units") AS valv_inlet_size_mm,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS valv_rated_pressure_bar,
FROM query_table(schema_name::VARCHAR || '.equiclass_pressure_reducing_valve_water') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVPR';


CREATE OR REPLACE MACRO pressure_regulating_valve_to_valvre(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    udfx_db.udfx.convert_to_millimetres(t."Size", t."Size Units") AS valv_bore_diameter_mm,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS valv_flow_litres_per_sec,
FROM query_table(schema_name::VARCHAR || '.equiclass_pressure_regulating_valve') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVRE';


CREATE OR REPLACE MACRO pressure_switches_to_pstndi(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pstn_pressure_instrument_type,
    NULL AS pstn_range_max,
    NULL AS pstn_range_min,
    NULL AS pstn_range_units,
    NULL AS pstn_signal_type,
    NULL AS pstn_supply_voltage,
    NULL AS pstn_supply_voltage_units,
FROM query_table(schema_name::VARCHAR || '.equiclass_pressure_switches') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PSTNDI';



CREATE OR REPLACE MACRO pulsation_damper_to_veprpd(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."Bar Litres" AS vepr_bar_litres,
    t."Manufactured Year" AS vepr_manufactured_year,
    t."P.V.Capacity Ltrs" AS vepr_pv_capacity_ltrs_l,
    t."PV Verification Status" AS vepr_pv_verification_status,
    t."PV Verification Status Date" AS vepr_pv_verification_date,
    IF(t."S.W.P or S.O.L. Units" = 'BAR', t."S.W.P or S.O.L.", null) AS vepr_safe_working_pressure_bar,
    t."YWRef" AS statutory_reference_number,
    t."Test Cert No" AS test_cert_no,
    t."Test Pressure bars" AS vepr_test_pressure_bar,
    t."Written Scheme No" AS vepr_written_scheme_number,
    udf_local.swpt_815_to_vepr_swp_type(t."Safe Working Procedure Type - Location") AS vepr_swp_type,
    udf_local.swpt_815_to_vepr_swp_location(t."Safe Working Procedure Type - Location") AS vepr_swp_location,
    t."Safe Working Procedure Name" AS vepr_swp_name,
    t."Safe Working Procedure Date" AS vepr_swp_date,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pv_inspection_frequency_months,
    NULL AS vepr_material,
    NULL AS vepr_rated_temperature_deg_c,
FROM query_table(schema_name::VARCHAR || '.equiclass_pulsation_damper') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VEPRPD';


CREATE OR REPLACE MACRO radar_level_instrument_to_lstnrd(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
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
FROM query_table(schema_name::VARCHAR || '.equiclass_radar_level_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNRD';


CREATE OR REPLACE MACRO ram_pump_to_lstnrd(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    udfx_db.udfx.convert_to_metres(t."Duty Head", t."Duty Head Units") AS pump_installed_design_head_m,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ram_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPRA';


CREATE OR REPLACE MACRO relief_safety_valve_to_valvsf(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS valv_inlet_size_mm,
    NULL AS valv_rated_pressure_bar,
FROM query_table(schema_name::VARCHAR || '.equiclass_relief_safety_valve') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VALVSF';


CREATE OR REPLACE MACRO resistance_starter_to_starlq(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."IP Rating" AS ip_rating,
    t."Current In" AS star_rated_current_a,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS star_rated_power_kw,
    t."Voltage In" AS star_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_resistance_starter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STARLQ';


CREATE OR REPLACE MACRO resistance_starter_to_starre(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."IP Rating" AS ip_rating,
    t."Current In" AS star_rated_current_a,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS star_rated_power_kw,
    t."Voltage In" AS star_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_resistance_starter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STARRE';


CREATE OR REPLACE MACRO reversing_starter_to_starrv(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."IP Rating" AS ip_rating,
    t."Current In" AS star_rated_current_a,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS star_rated_power_kw,
    t."Voltage In" AS star_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_reversing_starter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STARRV';


CREATE OR REPLACE MACRO ropes_to_llfsrp(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ropes') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLFSRP';


CREATE OR REPLACE MACRO ropes_to_llwrwi(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ropes') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLWRWI';


CREATE OR REPLACE MACRO runways_to_llrrtb(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_runways') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LLRRTB';


CREATE OR REPLACE MACRO safety_switch_to_gaswip(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_safety_switch') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'GASWIP';


CREATE OR REPLACE MACRO screens_to_scrcba(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_screens') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'SCRCBA';


CREATE OR REPLACE MACRO screens_to_scrfsc(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_screens') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'SCRFSC';


CREATE OR REPLACE MACRO screw_pump_to_pumpsc(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    udfx_db.udfx.convert_to_metres(t."Duty Head", t."Duty Head Units") AS pump_installed_design_head_m,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_screw_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPSC';


CREATE OR REPLACE MACRO slip_ring_assembly_to_slipra(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."IP Rating" AS ip_rating,
    t."Voltage In" AS slip_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS slip_rated_voltage_units,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS slip_rated_power_kw,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS slip_number_of_brushes,
    NULL AS slip_rated_current_a,
FROM query_table(schema_name::VARCHAR || '.equiclass_slip_ring_assembly') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'SLIPRA';


CREATE OR REPLACE MACRO sludge_blanket_level_inst_to_lstnus(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_sludge_blanket_level_inst') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNUS';


CREATE OR REPLACE MACRO soft_starter_to_starss(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."Current In" AS star_input_current_a,
    t."Voltage In" AS star_input_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS star_input_voltage_units,
    t."IP Rating" AS ip_rating,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS star_rated_power_kw,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_soft_starter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STARSS';



CREATE OR REPLACE MACRO star_delta_starter_to_stardt(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."IP Rating" AS ip_rating,
    t."Current In" AS star_rated_current_a,
    udfx_db.udfx.convert_to_kilowatts(t."Power", t."Power Units") AS star_rated_power_kw,
    t."Voltage In" AS star_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t."Voltage In (AC Or DC)") AS star_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS star_number_of_phase,
    NULL AS star_sld_ref_no,
FROM query_table(schema_name::VARCHAR || '.equiclass_star_delta_starter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STARDT';



CREATE OR REPLACE MACRO stirrers_mixers_agitators_to_mixrro(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_stirrers_mixers_agitators') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'MIXRRO';

CREATE OR REPLACE MACRO strainer_to_strnbf(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_strainer') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STRNBF';


CREATE OR REPLACE MACRO strainer_to_strner(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_strainer') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STRNER';


-- NOTE submersible_centrifugal_pump does not currently exist in the test data
-- so this hasn't been run
CREATE OR REPLACE MACRO submersible_centrifugal_pump_to_pumsmo(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    t2."Insulation Class" AS insulation_class_deg_c,
    t2."IP Rating" AS ip_rating,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pums_flow_litres_per_sec,
    t."Impeller Type" AS pums_impeller_type,
    udfx_db.udfx.convert_to_metres(t."Duty Head", t."Duty Head Units") AS pums_installed_design_head_m,
    udf_local.lity_388_to_pump_lifting_type(t."Lifting Type") AS pums_lifting_type,
    t2."Current In" AS pums_rated_current_a,
    udfx_db.udfx.convert_to_kilowatts(t2."Rating (Power)", t2."Rating Units") AS pums_rated_power_kw,
    t2."Speed (RPM)" AS pums_rated_speed_rpm,
    t2."Voltage In" AS pums_rated_voltage,
    udf_local.acdc_3_to_voltage_units(t2."Voltage In (AC Or DC)") AS pums_rated_voltage_units,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS pums_inlet_size_mm,
    NULL AS pums_media_type,
    NULL AS pums_outlet_size_mm,
FROM query_table(schema_name::VARCHAR || '.equiclass_submersible_centrifugal_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
JOIN ai2_classrep.equimixin_integral_motor t2
    ON t2.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMSMO';


CREATE OR REPLACE MACRO submersible_centrifugal_pump_to_pumssu(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_submersible_centrifugal_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMSSU';


CREATE OR REPLACE MACRO telemetry_outstation_to_netwtl(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS ip_rating,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS netw_supply_voltage,
    NULL AS netw_supply_voltage_units,
FROM query_table(schema_name::VARCHAR || '.equiclass_telemetry_outstation') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'NETWTL';


CREATE OR REPLACE MACRO temperature_instrument_to_tstntt(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_temperature_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TSTNTT';


CREATE OR REPLACE MACRO thermal_flow_instrument_to_fstnth(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
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
FROM query_table(schema_name::VARCHAR || '.equiclass_thermal_flow_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNTH';


CREATE OR REPLACE MACRO thermal_mass_flow_instrument_to_fstntm(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
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
FROM query_table(schema_name::VARCHAR || '.equiclass_thermal_mass_flow_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNTM';


CREATE OR REPLACE MACRO trace_heaters_to_heattr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_trace_heaters') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'HEATR';


CREATE OR REPLACE MACRO tubular_heater_to_heattu(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_tubular_heater') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'HEATTU';


CREATE OR REPLACE MACRO tuning_fork_level_instrument_to_lstntf(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_tuning_fork_level_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNTF';


CREATE OR REPLACE MACRO turbidity_instrument_to_analtb(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_turbidity_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ANALTB';


CREATE OR REPLACE MACRO turbine_flow_instrument_to_fstntu(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_turbine_flow_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNTU';


CREATE OR REPLACE MACRO ultrasonic_flow_instrument_to_fstnoc(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ultrasonic_flow_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNOC';


CREATE OR REPLACE MACRO ultrasonic_level_instrument_to_lstnut(schema_name) AS TABLE
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
FROM query_table(schema_name::VARCHAR || '.equiclass_ultrasonic_level_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'LSTNUT';


CREATE OR REPLACE MACRO ups_systems_to_podeup(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ups_systems') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PODEUP';



CREATE OR REPLACE MACRO urban_wastewater_sampler_to_sampch(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_urban_wastewater_sampler') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'SAMPCH';


CREATE OR REPLACE MACRO uv_transmittance_instrument_to_analut(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_uv_transmittance_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'ANALUT';


CREATE OR REPLACE MACRO ultra_violet_unit_to_uvunit(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ultra_violet_unit') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'UVUNIT';


CREATE OR REPLACE MACRO vacuum_pump_to_pumpva(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    udfx_db.udfx.convert_to_litres_per_second(t."Flow", t."Flow Units") AS pump_flow_litres_per_sec,
    udfx_db.udfx.convert_to_kilowatts(t."Rating (Power)", t."Rating Units") AS pump_rated_power_kw,
    t."Speed (RPM)" AS pump_rated_speed_rpm,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_vacuum_pump') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PUMPVA';


CREATE OR REPLACE MACRO variable_frequency_starter_to_starvf(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_variable_frequency_starter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'STARVF';


CREATE OR REPLACE MACRO variable_area_flow_instrument_to_fstnva(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_variable_area_flow_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNVA';


CREATE OR REPLACE MACRO venturi_to_fstnve(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_venturi') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNVE';


CREATE OR REPLACE MACRO vortex_flow_instrument_to_fstnvo(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_vortex_flow_instrument') t
JOIN ai2_classrep.ai2_to_s4_mapping t1 
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'FSTNVO';


CREATE OR REPLACE MACRO water_air_receiver_to_vepraw(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_water_air_receiver') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'VEPRAW';


CREATE OR REPLACE MACRO wet_well_to_wellwt(schema_name) AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    t."Tank Construction" AS well_tank_construction,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_chemical_storage_tank') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'WELLWT';



CREATE OR REPLACE MACRO ww_balancing_tank_to_tankpr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_balancing_tank') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKPR';


CREATE OR REPLACE MACRO ww_chemical_storage_tank_to_tankst(schema_name) AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    t."Tank Construction" AS tank_tank_construction,
    t."Tank Level" AS tank_tank_level,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS tank_tank_covering,
    NULL AS tank_tank_use,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_chemical_storage_tank') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKST';


CREATE OR REPLACE MACRO ww_cloth_media_filter_to_profsa(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_cloth_media_filter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PROFSA';


CREATE OR REPLACE MACRO ww_flocculation_tank_to_tankpr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_flocculation_tank') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKPR';


CREATE OR REPLACE MACRO ww_humus_tank_to_tankpr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_humus_tank') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKPR';



CREATE OR REPLACE MACRO ww_percolating_filter_to_profpc(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_percolating_filter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PROFPC';


CREATE OR REPLACE MACRO ww_primary_sedimentation_to_tankpr(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_primary_sedimentation_tank') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKPR';


CREATE OR REPLACE MACRO ww_sand_filter_to_profsn(schema_name) AS TABLE
SELECT
    t1.equi_equi_id AS equipment_id,  
    t."Location On Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_sand_filter') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'PROFSN';


CREATE OR REPLACE MACRO ww_service_water_storage_tank_to_tankst(schema_name) AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    t."Tank Construction" AS tank_tank_construction,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS tank_tank_covering,
    NULL AS tank_tank_level,
    NULL AS tank_tank_use,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_service_water_storage_tank') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKST';


CREATE OR REPLACE MACRO ww_sludge_storage_tank_to_tankst(schema_name) AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
    NULL AS manufacturers_asset_life_yr,
    NULL AS memo_line,
    NULL AS tank_tank_construction,
    NULL AS tank_tank_covering,
    NULL AS tank_tank_level,
    NULL AS tank_tank_use,

FROM query_table(schema_name::VARCHAR || '.equiclass_ww_sludge_storage_tank') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKST';


CREATE OR REPLACE MACRO ww_storm_sedimentation_tank_to_tankpr(schema_name) AS TABLE
SELECT 
    t1.equi_equi_id AS equipment_id,
    t."Location on Site" AS location_on_site,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM query_table(schema_name::VARCHAR || '.equiclass_ww_storm_sedimentation_tank') t
JOIN ai2_classrep.ai2_to_s4_mapping t1
    ON t1.ai2_reference = t.ai2_reference
WHERE t1.s4_class = 'TANKPR';

