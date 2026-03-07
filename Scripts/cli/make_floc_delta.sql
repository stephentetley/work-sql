
-- Setup the following environment variables:
-- `FLOC_DELTA_WORKLIST`
-- `IH06_PATCHES_GLOBPATH` [optional]
-- before running this file (e.g in a makefile)

.bail on

SELECT 'The database created by the client must always be called `floc_delta_db`' AS WARNING;

ATTACH OR REPLACE DATABASE '~/_working/work/resources/masterdata/masterdata_latest_db' AS masterdata_db (READ_ONLY);
COPY FROM DATABASE masterdata_db TO floc_delta_db;
DETACH DATABASE masterdata_db;


ATTACH OR REPLACE DATABASE '~/_working/work/resources/ztables/ztables_db.duckdb' AS ztables_db (READ_ONLY);

ATTACH OR REPLACE DATABASE '~/_working/work/resources/udf/udf_db.duckdb' AS udf_db (READ_ONLY);

-- patch masterdata with updates from ih06 exports
.read '/home/stephen/_working/coding/work/work-sql/Scripts/patch_masterdata/02_patch_s4_floc_exports.sql'

-- setup output tables
.read '/home/stephen/_working/coding/work/work-sql/Scripts/common/excel_uploader/03_setup_floc_create_tables.sql'

-- run floc_delta scripts
.read '/home/stephen/_working/coding/work/work-sql/Scripts/floc_delta/01_create_floc_delta_tables.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/floc_delta/02_import_worklist.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/floc_delta/03_floc_delta_insert_into.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/floc_delta/04_excel_uploader_insert_into.sql'



