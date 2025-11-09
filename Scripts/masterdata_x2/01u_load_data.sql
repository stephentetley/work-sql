CREATE SCHEMA IF NOT EXISTS s4_landing;
CREATE SCHEMA IF NOT EXISTS ai2_landing;

CREATE OR REPLACE TABLE s4_landing.equi_all AS
SELECT * FROM read_xlsx(
    '/home/stephen/_working/work/2025/masterdata_x2/EQUIPMENT_REPORT_301025.xlsx',
    sheet='Equipment_Report'
);

CREATE OR REPLACE TABLE s4_landing.equi_aib_refs AS
SELECT * FROM read_xlsx(
    '/home/stephen/_working/work/2025/masterdata_x2/EQUIPMENT_REPORT_301025.xlsx',
    sheet='Equipment_AI2_AIB_REF'
);

CREATE OR REPLACE TEMPORARY MACRO null_string_to_null(str) AS
    IF(str='NULL', null, str);

CREATE OR REPLACE TABLE ai2_landing.assets_all AS
SELECT 
    null_string_to_null(COLUMNS(*)) 
FROM read_xlsx(
    '/home/stephen/_working/work/2025/masterdata_x2/AI2AssetHierarchy_20250916.xlsx',
    sheet='Sheet1',
    all_varchar=true
);



