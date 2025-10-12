
CREATE SCHEMA IF NOT EXISTS ai2_landing;

CREATE SCHEMA IF NOT EXISTS ai2_eav;

CREATE OR REPLACE TABLE ai2_eav.equipment_masterdata(
    ai2_reference VARCHAR,
    common_name VARCHAR,
    equipment_name VARCHAR,
    installed_from TIMESTAMP_MS,
    manufacturer VARCHAR,
    model VARCHAR,
    asset_status VARCHAR,
    loc_ref VARCHAR,
    PRIMARY KEY (ai2_reference)
);

CREATE OR REPLACE TABLE ai2_eav.equipment_eav(
    ai2_reference VARCHAR,
    attr_name VARCHAR,
    attr_value VARCHAR
);

