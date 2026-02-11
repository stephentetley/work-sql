.print 'Running 02_create_masterdata_tables.sql...'

CREATE SCHEMA IF NOT EXISTS masterdata;

CREATE OR REPLACE TABLE masterdata.s4_equipment (
    equipment_id BIGINT NOT NULL,
    equipment_name VARCHAR,
    functional_location VARCHAR,
    superequi_id BIGINT,
    category VARCHAR,
    obj_type VARCHAR,
    std_class VARCHAR,
    startup_date DATE,
    manufacturer VARCHAR,
    model VARCHAR,
    specific_model_frame VARCHAR,
    serial_number VARCHAR,
    tech_ident_number VARCHAR,
    user_status VARCHAR,
    planning_plant VARCHAR,
    address_number INTEGER,
    PRIMARY KEY (equipment_id)
);

CREATE OR REPLACE TABLE masterdata.s4_funcloc (
    functional_location VARCHAR NOT NULL,
    funcloc_name VARCHAR,
    category INTEGER,
    installation_allowed BOOLEAN,
    object_type VARCHAR,
    cost_center INTEGER,
    planning_plant INTEGER,
    maintenance_plant INTEGER,
    maint_work_center VARCHAR,
    plant_section VARCHAR,
    startup_date DATE,
    structure_indicator VARCHAR,
    superior_funcloc VARCHAR,
    user_status VARCHAR,
    company_code VARCHAR,
    address_number INTEGER,
    PRIMARY KEY (functional_location)
);


CREATE OR REPLACE TABLE masterdata.s4_to_plinum (
    s4_equipment_id BIGINT,
    ai2_plinum VARCHAR,
);

CREATE OR REPLACE TABLE masterdata.s4_to_sainum (
    s4_equipment_id BIGINT,
    ai2_sainum VARCHAR,
);

CREATE OR REPLACE TABLE masterdata.s4_floc_east_north (
    s4_floc VARCHAR,
    easting INTEGER,
    northing INTEGER,
    PRIMARY KEY (s4_floc)
);

CREATE OR REPLACE TABLE masterdata.ai2_equipment (
    pli_number VARCHAR NOT NULL,
    equipment_name VARCHAR NOT NULL,
    equi_type_name VARCHAR,
    equi_type_code VARCHAR,
    installed_from_date DATE,
    manufacturer VARCHAR,
    model VARCHAR,
    user_status VARCHAR,
    common_name VARCHAR,
    site_or_installation_name VARCHAR,
    sai_number VARCHAR,
    superequi_id VARCHAR,
    equi_sort VARCHAR,
    PRIMARY KEY (pli_number)
);    
    

-- For dates on or after 1899-12-30, Sqlserver's date string format is 
-- `hours:mins:secs.millis` where hours is always positive (or zero).
-- Dates before 1899-12-30 are stored as '%Y-%m-%d %H:%M:%S' 
-- e.g. '1898-01-01 00:00:00.000' 
-- 
CREATE OR REPLACE MACRO sqlserver_date(str) AS (
    coalesce(
        try(strptime(str::VARCHAR, '%Y-%m-%d %H:%M:%S.%g')::DATETIME),
        try(date_add(DATE '1899-12-30', INTERVAL (try_cast(regexp_extract(str::VARCHAR, '^(\d+):\d{2}:\d{2}', 1) AS BIGINT)) HOUR))
    )
);
