.print 'Running 01_create_masterdata_tables.sql...'

CREATE SCHEMA IF NOT EXISTS masterdata;
CREATE SCHEMA IF NOT EXISTS masterdata_landing;

CREATE OR REPLACE TABLE masterdata.s4_equipment (
    -- e.g. 101003320
    equipment_id BIGINT NOT NULL,
    -- e.g. 'Outstation'
    equipment_name VARCHAR,
    -- e.g. 'XYZ10-CAA-NET-FBC-SYS01'
    functional_location VARCHAR,
    -- e.g. 101003319
    superequi_id BIGINT,
    -- e.g. 'C'
    category VARCHAR,
    -- e.g. 'PUMP'
    obj_type VARCHAR,
    -- e.g. 'PUMPMO'
    std_class VARCHAR,
    -- e.g. '2017-09-12'
    startup_date DATE,
    -- e.g. 'TO BE DETERMINED'
    manufacturer VARCHAR,
    -- e.g. 'TO BE DETERMINED'
    model VARCHAR,
    -- e.g. 'TO BE DETERMINED'
    specific_model_frame VARCHAR,
    -- e.g. 'TO BE DETERMINED'
    serial_number VARCHAR,
    -- e.g. 'PUM01'
    tech_ident_number VARCHAR,
    -- e.g. 'OPER'
    user_status VARCHAR,
    -- e.g. 3100
    planning_plant VARCHAR,
    -- e.g. 80125
    address_number INTEGER,
    PRIMARY KEY (equipment_id)
);

CREATE OR REPLACE TABLE masterdata.s4_funcloc (
    -- e.g. 'XYZ10-CAA-NET-FBC'
    functional_location VARCHAR NOT NULL,
    -- e.g. 'Networks'
    funcloc_name VARCHAR,
    -- e.g. 'C'
    category INTEGER,
    -- e.g. true
    installation_allowed BOOLEAN,
    -- e.g. 'PUMP'
    object_type VARCHAR,
    -- e.g. 145353
    cost_center INTEGER,
    -- e.g. 3100
    planning_plant INTEGER,
    -- e.g. 3110
    maintenance_plant INTEGER,
    -- e.g. 'NW_KEIG'
    maint_work_center VARCHAR,
    -- e.g. 'FLS'
    plant_section VARCHAR,
    -- e.g. '2017-09-12'
    startup_date DATE,
    -- e.g. 'YW-ES'
    structure_indicator VARCHAR,
    -- e.g. 'XYZ10-CAA-NET'
    superior_funcloc VARCHAR,
    -- e.g. 'OPER'
    user_status VARCHAR,
    -- e.g. 3100
    company_code INTEGER,
    -- e.g. 80125
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
    -- e.g. 'PLI00123456'
    pli_number VARCHAR NOT NULL,
    -- e.g. 'LCC'
    equipment_name VARCHAR NOT NULL,
    -- e.g. 'EQUIPMENT: PENSTOCK'
    equi_type_name VARCHAR,
    -- e.g. 'EQPTMVNR'
    equi_type_code VARCHAR,
    -- e.g. '2017-09-12'
    installed_from_date DATE,
    -- e.g. 'UNKNOWN MANUFACTURER'
    manufacturer VARCHAR,
    -- e.g. 'UNSPECIFIED'
    model VARCHAR,
    -- e.g. 'OPERATIONAL'
    user_status VARCHAR,
    -- e.g. 'SITENAME/SPS/CONTROL SERVICES/PLC CONTROL/LCC' 
    common_name VARCHAR,
    -- e.g. 'SITENAME/SPS'
    site_or_installation_name VARCHAR,
    -- e.g. 'SAI00123456'
    sai_number VARCHAR,
    -- e.g. 'PLI00012345'
    superequi_id VARCHAR,
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
