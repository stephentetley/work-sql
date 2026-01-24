INSTALL EXCEL;
LOAD EXCEL;

CREATE SCHEMA IF NOT EXISTS masterdata_landing;

-- Needs variable `s4_masterdata_path` setting


-- MANUFACTURER_SERIAL_NUMBER(SERGE) has read problems for rusty-sheet...
CREATE OR REPLACE TABLE masterdata_landing.s4_equi_temp AS
SELECT 
    t.*
FROM read_xlsx(getvariable('s4_masterdata_path'),
                sheet='Equipment_Report') t;

