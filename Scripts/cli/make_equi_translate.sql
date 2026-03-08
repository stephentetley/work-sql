
-- Setup the following environment variables:
-- `EQUI_TRANSLATE_WORKLIST`
-- `AI2_ATTRIBUTES_GLOB`
-- `AI2_STRUCTURE_PATCHES_GLOBPATH` [optional]
-- before running this file (e.g in a makefile)



.bail on




SELECT 'The database created by the client must always be called `floc_delta_db`' AS WARNING;

ATTACH OR REPLACE DATABASE '~/_working/work/resources/masterdata/masterdata_latest_db' AS masterdata_db (READ_ONLY);
COPY FROM DATABASE masterdata_db TO equi_translate_db;
DETACH DATABASE masterdata_db;

-- patch masterdata with updates from ih06 exports
.read '/home/stephen/_working/coding/work/work-sql/Scripts/patch_masterdata/01_patch_ai2_structure_exports.sql'


.read '/home/stephen/_working/coding/work/work-sql/Scripts/common/excel_uploader/01_setup_equi_create_tables.sql'

.read '/home/stephen/_working/coding/work/work-sql/Scripts/equi_translate/01_create_ai2_classrep_base_tables.sql'
.read '/home/stephen/_working/coding/work/work-sql/Output/equi_translate/02o_create_ai2_equiclasses.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/equi_translate/03_create_s4_classrep_base_tables.sql'
.read '/home/stephen/_working/coding/work/work-sql/Output/equi_translate/04o_create_s4_equiclasses.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/equi_translate/05_create_udfs.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/equi_translate/06_import_equi_translate_worklist.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/equi_translate/07_import_ai2_eav_data.sql'
.read '/home/stephen/_working/coding/work/work-sql/Output/equi_translate/08o_insert_into_ai2_equiclasses.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/equi_translate/09_translate_ai2_base_data_to_s4.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/equi_translate/10_translate_ai2_equiclass_to_s4.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/equi_translate/11_s4_classrep_to_excel_uploader.sql'
.read '/home/stephen/_working/coding/work/work-sql/Output/equi_translate/12o_s4_equiclasses_to_excel_uploader.sql'


