
-- Setup the following environment variables:
-- `FUNCLOC_DOWNLOAD`
-- `CLASSFLOC_DOWNLOAD`
-- `VALUAFLOC_DOWNLOAD`
-- `EQUI_DOWNLOAD`
-- `CLASSEQUI_DOWNLOAD`
-- `VALUAEQUI_DOWNLOAD`
-- before running this file (e.g in a makefile)

.bail on

SELECT 'The database created by the client must always be called `file_download_summary_db`' AS WARNING;


.read '/home/stephen/_working/coding/work/work-sql/Scripts/file_download_summary/01_create_s4_classrep_master_tables.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/file_download_summary/02_import_file_downloads.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/file_download_summary/03_insert_into_s4_classrep_master_tables.sql'
