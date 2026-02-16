.print 'Running 01_create_base_tables.sql...'

CREATE SCHEMA IF NOT EXISTS s4_classrep;



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



