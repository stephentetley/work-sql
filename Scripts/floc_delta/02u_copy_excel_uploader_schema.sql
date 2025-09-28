
DROP SCHEMA IF EXISTS floc_delta_db.excel_uploader_equi_change CASCADE;
DROP SCHEMA IF EXISTS floc_delta_db.excel_uploader_equi_create CASCADE;
DROP SCHEMA IF EXISTS floc_delta_db.excel_uploader_floc_create CASCADE;


ATTACH OR REPLACE DATABASE '/home/stephen/_working/coding/work/work-sql/databases/excel_uploader_db.duckdb' AS excel_uploader;

-- This relies on the main database being called `floc_delta_db`, check this with:
-- SELECT current_database();
-- 
COPY FROM DATABASE excel_uploader TO floc_delta_db (SCHEMA);



DETACH DATABASE IF EXISTS excel_uploader;