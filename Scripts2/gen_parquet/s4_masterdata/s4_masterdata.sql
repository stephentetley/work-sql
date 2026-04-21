.print 'Running s4_masterdata.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

-- ## CREATE TABLES


CREATE OR REPLACE TABLE s4_equi (
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

CREATE OR REPLACE TABLE s4_func (
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


CREATE OR REPLACE TABLE s4_equi_to_plinum (
    s4_equipment_id BIGINT,
    ai2_plinum VARCHAR,
);

CREATE OR REPLACE TABLE s4_equi_to_sainum (
    s4_equipment_id BIGINT,
    ai2_sainum VARCHAR,
);

CREATE OR REPLACE TABLE s4_floc_east_north (
    s4_floc VARCHAR,
    easting INTEGER,
    northing INTEGER,
    PRIMARY KEY (s4_floc)
);

