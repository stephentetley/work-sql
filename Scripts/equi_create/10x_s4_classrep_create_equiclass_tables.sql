
-- lstnut_pseudo_upload.s4_classrep.equiclass_lstnut definition...

CREATE OR REPLACE TABLE s4_classrep.equiclass_lstnut(
    equipment_id VARCHAR,
    ip_rating VARCHAR,
    location_on_site VARCHAR,
    lstn_range_max DECIMAL(9, 3),
    lstn_range_min DECIMAL(9, 3),
    lstn_range_units VARCHAR,
    lstn_relay_1_function VARCHAR,
    lstn_relay_1_off_level_m DECIMAL(7, 3),
    lstn_relay_1_on_level_m DECIMAL(8, 3),
    lstn_relay_2_function VARCHAR,
    lstn_relay_2_off_level_m DECIMAL(7, 3),
    lstn_relay_2_on_level_m DECIMAL(8, 3),
    lstn_relay_3_function VARCHAR,
    lstn_relay_3_off_level_m DECIMAL(7, 3),
    lstn_relay_3_on_level_m DECIMAL(8, 3),
    lstn_relay_4_function VARCHAR,
    lstn_relay_4_off_level_m DECIMAL(6, 3),
    lstn_relay_4_on_level_m DECIMAL(6, 3),
    lstn_relay_5_function VARCHAR,
    lstn_relay_5_off_level_m DECIMAL(6, 3),
    lstn_relay_5_on_level_m DECIMAL(6, 3),
    lstn_relay_6_function VARCHAR,
    lstn_relay_6_off_level_m DECIMAL(5, 3),
    lstn_relay_6_on_level_m DECIMAL(5, 3),
    lstn_set_to_snort VARCHAR,
    lstn_signal_type VARCHAR,
    lstn_supply_voltage INTEGER,
    lstn_supply_voltage_units VARCHAR,
    lstn_transducer_model VARCHAR,
    lstn_transducer_serial_no VARCHAR,
    lstn_transmitter_model VARCHAR,
    lstn_transmitter_serial_no VARCHAR,
    manufacturers_asset_life_yr INTEGER,
    memo_line VARCHAR,
    uniclass_code VARCHAR,
    uniclass_desc VARCHAR,
PRIMARY KEY(equipment_id));

-- telem_equi_create_jun25_db.s4_classrep.equiclass_netwtl definition

CREATE OR REPLACE TABLE s4_classrep.equiclass_netwtl(
    equipment_id VARCHAR,
    ip_rating VARCHAR,
    location_on_site VARCHAR,
    manufacturers_asset_life_yr INTEGER,
    memo_line VARCHAR,
    netw_supply_voltage INTEGER,
    netw_supply_voltage_units VARCHAR,
    uniclass_code VARCHAR,
    uniclass_desc VARCHAR,
PRIMARY KEY(equipment_id));


CREATE OR REPLACE TABLE s4_classrep.equiclass_podetu(
    equipment_id VARCHAR,
    ip_rating VARCHAR,
    location_on_site VARCHAR,
    manufacturers_asset_life_yr INTEGER,
    memo_line VARCHAR,
    pode_battery_backup_time_min INTEGER,
    pode_battery_recharge_time_h INTEGER,
    pode_input_current_a DECIMAL(9, 3),
    pode_input_voltage DECIMAL(9, 3),
    pode_input_voltage_units VARCHAR,
    pode_number_of_phase VARCHAR,
    pode_output_current_a DECIMAL(9, 3),
    pode_output_voltage DECIMAL(9, 3),
    pode_output_voltage_units VARCHAR,
    pode_rated_temperature_deg_c INTEGER,
    pode_sld_ref_no VARCHAR,
    rated_power_kva DECIMAL(9, 3),
    uniclass_code VARCHAR,
    uniclass_desc VARCHAR,
PRIMARY KEY(equipment_id));



CREATE OR REPLACE TABLE s4_classrep.equiclass_netwmb (
    equipment_id VARCHAR NOT NULL, 
    ip_rating VARCHAR,
    location_on_site VARCHAR,
    manufacturers_asset_life_yr INTEGER,
    memo_line VARCHAR,
    netw_supply_voltage INTEGER,
    netw_supply_voltage_units VARCHAR,
    uniclass_code VARCHAR,
    uniclass_desc VARCHAR,
    PRIMARY KEY(equipment_id)
);

CREATE OR REPLACE TABLE s4_classrep.equiclass_netwmo (
    equipment_id VARCHAR NOT NULL, 
    ip_rating VARCHAR,
    location_on_site VARCHAR,
    manufacturers_asset_life_yr INTEGER,
    memo_line VARCHAR,
    netw_supply_voltage INTEGER,
    netw_supply_voltage_units VARCHAR,
    uniclass_code VARCHAR,
    uniclass_desc VARCHAR,
    PRIMARY KEY(equipment_id)
);

CREATE OR REPLACE TABLE s4_classrep.equiclass_valvfl (
    equipment_id VARCHAR NOT NULL, 
    location_on_site VARCHAR,
    manufacturers_asset_life_yr INTEGER,
    memo_line VARCHAR,
    uniclass_code VARCHAR,
    uniclass_desc VARCHAR,
    valv_inlet_size_mm INTEGER,
    PRIMARY KEY(equipment_id)
);


CREATE OR REPLACE TABLE s4_classrep.equiclass_valvnr (
    equipment_id VARCHAR NOT NULL, 
    location_on_site VARCHAR,
    manufacturers_asset_life_yr INTEGER,
    memo_line VARCHAR,
    uniclass_code VARCHAR,
    uniclass_desc VARCHAR,
    valv_flow_litres_per_sec DECIMAL(7, 2),
    valv_inlet_size_mm INTEGER,
    valv_rated_temperature_deg_c INTEGER,
    PRIMARY KEY(equipment_id)
);

