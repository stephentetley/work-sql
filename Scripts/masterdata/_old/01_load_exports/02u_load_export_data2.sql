INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

-- Needs variable `s4_masterdata_path` setting


CREATE OR REPLACE TABLE masterdata_landing.s4_aib_references AS
SELECT * FROM read_sheet(
    getvariable('s4_masterdata_path'),
    sheet='Equipment_AI2_AIB_REF',
    columns={'EQUIPMENT_NUMBER(EQUNR)': 'BIGINT',
                'CHARACTERISTIC(ATINN)': 'VARCHAR',
                'CHARACTERISTIC(ATWRT)': 'VARCHAR'
                }
);




