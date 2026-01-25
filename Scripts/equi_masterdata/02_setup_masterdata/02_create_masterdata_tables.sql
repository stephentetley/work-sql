-- EQUIPMENT_NUMBER(EQUNR) DOUBLE
-- EQUIPMENT_DESC(EQKTX)   VARCHAR
-- EQUIPMENT_CATEGORY(EQTYP)   VARCHAR
-- TYPE_OF_TECHOBJECT(EQART)   VARCHAR
-- SUP_FUNCTIONAL_LOCATION(TPLNR)  VARCHAR
-- OBJECT_NUMBER(OBJNR)    VARCHAR
-- MANUFACTURER(HERST) VARCHAR
-- MANUFACTURER_SERIAL_NUMBER(SERGE)   VARCHAR
-- MANUFACTURER_MODEL_NUMBER(TYPBZ)    VARCHAR
-- MANUFACTURER_PART_NUMBER(MAPAR) VARCHAR
-- USER_STATUS(STAT)   VARCHAR
-- USER_STATUS(TXT04)  VARCHAR
-- USER_STATUS(TXT30)  VARCHAR
-- CLASS   VARCHAR

CREATE SCHEMA IF NOT EXISTS masterdata;

CREATE OR REPLACE TABLE masterdata.s4_equipment (
    equipment_id BIGINT NOT NULL,
    equipment_name VARCHAR NOT NULL,
    functional_location VARCHAR,
    category VARCHAR,
    obj_type VARCHAR,
    startup_date DATE,
    manufacturer VARCHAR,
    model VARCHAR,
    specific_model_frame VARCHAR,
    serial_number VARCHAR,
    user_status VARCHAR,
    obj_class VARCHAR,
    PRIMARY KEY (equipment_id)
);

-- EQUIPMENT_NUMBER(EQUNR) BIGINT
-- CHARACTERISTIC(ATINN)   VARCHAR
-- CHARACTERISTIC_VALUE(ATWRT) VARCHAR

CREATE OR REPLACE TABLE masterdata.s4_to_plinum (
    s4_equipment_id BIGINT,
    ai2_plinum VARCHAR,
);

CREATE OR REPLACE TABLE masterdata.s4_to_sainum (
    s4_equipment_id BIGINT,
    ai2_sainum VARCHAR,
);

-- gen_installation_name   VARCHAR
-- pli_num VARCHAR
-- sai_num VARCHAR
-- common_name VARCHAR
-- installed_from_date INTEGER
-- equi_name   VARCHAR
-- manufacturer    VARCHAR
-- model   VARCHAR
-- status  VARCHAR
-- equi_type_code  VARCHAR
-- equipment_type  VARCHAR

CREATE OR REPLACE TABLE masterdata.ai2_equipment (
    pli_number VARCHAR NOT NULL,
    equipment_name VARCHAR NOT NULL,
    equi_type_name VARCHAR,
    equi_type_code VARCHAR,
    installed_from_data DATE,
    manufacturer VARCHAR,
    model VARCHAR,
    user_status VARCHAR,
    common_name VARCHAR,
    site_or_installation_name VARCHAR,
    PRIMARY KEY (pli_number)
);    
    


