-- Only eval this file only once per session...

DROP SCHEMA IF EXISTS asset_replace_db.excel_uploader_equi_change CASCADE;
DROP SCHEMA IF EXISTS asset_replace_db.excel_uploader_equi_create CASCADE;
DROP SCHEMA IF EXISTS asset_replace_db.excel_uploader_floc_create CASCADE;


ATTACH OR REPLACE DATABASE '/home/stephen/_working/coding/work/work-sql/databases/excel_uploader_db.duckdb' AS excel_uploader;

-- This relies on the main database being called `asset_replace_db`, check this with:
-- SELECT current_database();
-- 
COPY FROM DATABASE excel_uploader TO asset_replace_db (SCHEMA);

DETACH DATABASE IF EXISTS excel_uploader;


DROP SCHEMA IF EXISTS asset_replace_db.udfx CASCADE;

ATTACH OR REPLACE DATABASE '/home/stephen/_working/coding/work/work-sql/databases/udf_db.duckdb' AS udf_db;

COPY FROM DATABASE udf_db TO asset_replace_db (SCHEMA);

DETACH DATABASE IF EXISTS udf_db;

