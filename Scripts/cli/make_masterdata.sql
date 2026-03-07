
-- Setup the following environment variables:
-- `AIB_MASTER_GLOBPATH` 
-- `FLOC_MASTER_GLOBPATH` 
-- `EQUI_MASTER_GLOBPATH`
-- `EQUI_AIB_GLOBPATH`
-- before running this file (e.g in a makefile)

.read '/home/stephen/_working/coding/work/work-sql/Scripts/masterdata/01_create_masterdata_tables.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/masterdata/02_load_export_data.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/masterdata/03_masterdata_insert_into.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/masterdata/04_create_masterdata_stats.sql'
