

.bail on

ATTACH OR REPLACE DATABASE '~/_working/work/resources/masterdata/masterdata_latest_db' AS masterdata_db (READ_ONLY);

ATTACH OR REPLACE DATABASE '~/_working/work/resources/ztables/ztables_db.duckdb' AS ztables_db (READ_ONLY);

ATTACH OR REPLACE DATABASE '~/_working/work/resources/udf/udf_db.duckdb' AS udf_db (READ_ONLY);

-- setup output tables
.read '/home/stephen/_working/coding/work/work-sql/Scripts/common/excel_uploader/03_setup_floc_create_tables.sql'

-- run floc_delta scripts
.read '/home/stephen/_working/coding/work/work-sql/Scripts/floc_delta/01_create_floc_delta_tables.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/floc_delta/02_import_worklist.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/floc_delta/03_floc_delta_insert_into.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/floc_delta/04_excel_uploader_insert_into.sql'



