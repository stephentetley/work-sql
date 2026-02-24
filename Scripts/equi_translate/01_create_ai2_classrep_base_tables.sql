.print 'Running 01_create_ai2_classrep_base_tables.sql...'


CREATE SCHEMA IF NOT EXISTS ai2_classrep;



CREATE OR REPLACE TABLE ai2_classrep.equi_extra_masterdata (
    ai2_reference VARCHAR NOT NULL,
    weight_kg DECIMAL(18, 3),
    specific_model_frame VARCHAR,
    serial_number VARCHAR,
    grid_ref VARCHAR,
    pandi_tag VARCHAR,
    PRIMARY KEY (ai2_reference)
);


CREATE OR REPLACE TABLE ai2_classrep.equi_agasp (
    ai2_reference VARCHAR NOT NULL,
    agasp_comments VARCHAR,
    agasp_survey_year INTEGER,
    condition_grade VARCHAR,
    condition_grade_reason VARCHAR,
    exclude_from_survey VARCHAR,
    loading_factor VARCHAR,
    loading_factor_reason VARCHAR,
    performance_grade VARCHAR,
    performance_grade_reason VARCHAR,
    PRIMARY KEY (ai2_reference)
);

CREATE OR REPLACE TABLE ai2_classrep.equi_memo_line (
    ai2_reference VARCHAR NOT NULL,
    memo_line_1 VARCHAR,
    memo_line_2 VARCHAR,
    memo_line_3 VARCHAR,
    memo_line_4 VARCHAR,
    memo_line_5 VARCHAR,
    PRIMARY KEY (ai2_reference)
);

CREATE OR REPLACE TABLE ai2_classrep.equi_solution_id (
    ai2_reference VARCHAR NOT NULL,
    solution_id VARCHAR,
    PRIMARY KEY (ai2_reference)
);

