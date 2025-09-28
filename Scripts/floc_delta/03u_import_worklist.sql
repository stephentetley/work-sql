-- Keep this simple - it is a template...


ATTACH OR REPLACE DATABASE '/home/stephen/_working/coding/work/work-sql/databases/ztables_db.duckdb' AS ztables;
-- ATTACH OR REPLACE DATABASE '/home/stephen/_working/coding/work/work-sql/databases/udf_db.duckdb' AS udfx;


CREATE OR REPLACE TABLE floc_delta_landing.worklist AS
SELECT * FROM read_floc_delta_worklist('/home/stephen/_working/work/2025/asset_tools_sample_data/floc_delta/02_worklist.xlsx')
;


CREATE OR REPLACE TABLE floc_delta_landing.ih06_floc_exports AS
-- Use UNION if reading more than one IH06 export...
SELECT * FROM read_ih06_export('/home/stephen/_working/work/2025/asset_tools_sample_data/floc_delta/01_site_ih06.xlsx')
;