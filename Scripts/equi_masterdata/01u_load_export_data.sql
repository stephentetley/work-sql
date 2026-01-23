INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE SCHEMA IF NOT EXISTS masterdata_landing;

-- Needs variable `s4_masterdata_path` and `ai2_masterdata_path` setting


-- MANUFACTURER_SERIAL_NUMBER(SERGE) has read problems for rusty-sheet...
CREATE OR REPLACE TABLE masterdata_landing.s4_equi_temp AS
SELECT * EXCLUDE(t."MANUFACTURER_SERIAL_NUMBER(SERGE)") FROM read_sheet(
    getvariable('s4_masterdata_path'),
    sheet='Equipment_Report',
    error_as_null=true
);



CREATE OR REPLACE TABLE masterdata_landing.s4_aib_references AS
SELECT * FROM read_sheet(
    getvariable('s4_masterdata_path'),
    sheet='Equipment_AI2_AIB_REF',
    columns={'EQUIPMENT_NUMBER(EQUNR)': 'BIGINT',
                'CHARACTERISTIC(ATINN)': 'VARCHAR',
                'CHARACTERISTIC(ATWRT)': 'VARCHAR'
                }
);


-- Source data has pre 1900-01-01 dates which cause errors
CREATE OR REPLACE TABLE masterdata_landing.ai2_export_all AS
SELECT *
FROM read_sheet(
    getvariable('ai2_masterdata_path'),
    sheet='Sheet1',
    nulls = ['NULL'],
    error_as_null=true,
    columns={'*FromDate': 'VARCHAR'}

);




