-- Only evaluate this file on a fresh database
--
-- If you `COPY FROM DATABASE ...` any macros get copied into the 
-- `floc_delta_db.main` schema and then they will cause conflicts if
-- this file is evaluated again.
-- Only copy databases without macros where you need writable tables
-- e.g. "excel_uploader_*"
-- Attached (not) copied databases are detached when DBeaver is closed,
-- eval the bottom half of the file to reattach them

-- excel_uploader - needs write access, import copies...

DROP SCHEMA IF EXISTS asset_replace_db.excel_uploader_equi_change CASCADE;
DROP SCHEMA IF EXISTS asset_replace_db.excel_uploader_equi_create CASCADE;
DROP SCHEMA IF EXISTS asset_replace_db.excel_uploader_floc_create CASCADE;


ATTACH OR REPLACE DATABASE 
    '/home/stephen/_working/coding/work/work-sql/databases/excel_uploader_db.duckdb' 
AS excel_uploader;

-- This relies on the main database being called `asset_replace_db`, check this with:
-- SELECT current_database();
-- 
COPY FROM DATABASE excel_uploader TO asset_replace_db (SCHEMA);

DETACH DATABASE IF EXISTS excel_uploader;


