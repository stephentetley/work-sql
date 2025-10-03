CREATE SCHEMA IF NOT EXISTS ai2_classrep;


CREATE OR REPLACE TABLE ai2_classrep.ai2_to_s4_mapping (
    equi_equi_id VARCHAR NOT NULL,
    ai2_reference VARCHAR,
    ai2_parent_reference VARCHAR,
    s4_equi_id VARCHAR,
    s4_description VARCHAR,
    s4_category VARCHAR,
    s4_object_type VARCHAR,
    s4_class VARCHAR,
    s4_floc VARCHAR,
    s4_superord_equi VARCHAR,
    s4_position INTEGER,
    solution_id VARCHAR,
    PRIMARY KEY (equi_equi_id)
);


CREATE OR REPLACE TABLE ai2_classrep.equi_masterdata (
    ai2_reference VARCHAR NOT NULL,
    common_name VARCHAR NOT NULL,
    item_name VARCHAR,
    equipment_type VARCHAR NOT NULL,
    installed_from DATE,
    weight_kg DECIMAL(18, 3),
    manufacturer VARCHAR,
    model VARCHAR,
    specific_model_frame VARCHAR,
    serial_number VARCHAR,
    asset_status VARCHAR,
    grid_ref VARCHAR,
    pandi_tag VARCHAR,
    PRIMARY KEY (ai2_reference)
);


CREATE OR REPLACE TABLE ai2_classrep.equi_agasp (
    ai2_reference VARCHAR NOT NULL,
    comments VARCHAR,
    condition_grade VARCHAR,
    condition_grade_reason VARCHAR,
    exclude_from_survey VARCHAR,
    loading_factor VARCHAR,
    loading_factor_reason VARCHAR,
    other_details VARCHAR,
    performance_grade VARCHAR,
    performance_grade_reason VARCHAR,
    reason_for_change VARCHAR,
    survey_date VARCHAR,
    survey_year VARCHAR,
    updated_using VARCHAR,
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


