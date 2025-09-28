CREATE SCHEMA IF NOT EXISTS s4_classrep;

CREATE OR REPLACE TABLE s4_classrep.equi_masterdata (
    equipment_id VARCHAR NOT NULL,
    equi_description VARCHAR NOT NULL,
    functional_location VARCHAR,
    superord_id VARCHAR,
    category VARCHAR,
    object_type VARCHAR,
    display_user_status VARCHAR,
    status_of_an_object VARCHAR,
    startup_date DATE,
    construction_month INTEGER,
    construction_year INTEGER,
    manufacturer VARCHAR,
    model_number VARCHAR,
    manufact_part_number VARCHAR,
    serial_number VARCHAR,
    gross_weight DECIMAL(18, 3),
    unit_of_weight VARCHAR,
    technical_ident_number VARCHAR,
    valid_from DATE,
    display_position INTEGER,
    catalog_profile VARCHAR,
    company_code INTEGER,
    cost_center INTEGER,
    controlling_area INTEGER,
    maintenance_plant INTEGER,
    maint_work_center VARCHAR,
    work_center VARCHAR,
    planning_plant INTEGER,
    plant_section VARCHAR,
    equi_location VARCHAR,
    address_ref VARCHAR,
    PRIMARY KEY(equipment_id)
);


CREATE OR REPLACE TABLE s4_classrep.equi_longtext(
    equipment_id VARCHAR NOT NULL,
    long_text VARCHAR,
    PRIMARY KEY(equipment_id)
);




CREATE OR REPLACE TABLE s4_classrep.equi_aib_reference (
    equipment_id VARCHAR NOT NULL,
    value_index INTEGER,
    ai2_aib_reference VARCHAR,
    PRIMARY KEY (equipment_id, value_index)
);


-- ## ASSET_CONDITION

CREATE OR REPLACE TABLE s4_classrep.equi_asset_condition (
    equipment_id VARCHAR NOT NULL,
    condition_grade VARCHAR,
    condition_grade_reason VARCHAR,
    survey_comments VARCHAR,
    survey_date INTEGER,
    last_refurbished_date DATE,
    PRIMARY KEY(equipment_id)
);

CREATE OR REPLACE TABLE s4_classrep.equi_east_north (
    equipment_id VARCHAR NOT NULL,
    easting INTEGER,
    northing INTEGER,
    PRIMARY KEY(equipment_id)
);





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

-- telem_asset_replace_jun25_db.s4_classrep.equiclass_netwtl definition

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

