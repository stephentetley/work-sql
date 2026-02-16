.print 'Running 01_create_base_tables.sql...'

CREATE SCHEMA IF NOT EXISTS s4_classrep;

-- Don't translate to masterdata.s4_equipment - it is missing fields 
-- that are not needed for analysis but needed for record creation

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
    construction_year INTEGER,
    construction_month INTEGER,
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


CREATE OR REPLACE TABLE s4_classrep.equi_solution_id (
    equipment_id VARCHAR NOT NULL,
    value_index INTEGER,
    solution_id VARCHAR,
    PRIMARY KEY(equipment_id)
);



