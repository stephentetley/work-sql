INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE SCHEMA IF NOT EXISTS masterdata_landing;

-- Needs variable `s4_masterdata_path` setting


-- MANUFACTURER_SERIAL_NUMBER(SERGE) has read problems for rusty-sheet...
CREATE OR REPLACE TABLE masterdata_landing.s4_equi_all AS
SELECT * FROM read_sheet(
    getvariable('s4_masterdata_path'),
    sheet='Equipment_Report',
    error_as_null=TRUE,
    columns = {'EQUIPMENT_NUMBER(EQUNR)', 'BIGINT'}
);


