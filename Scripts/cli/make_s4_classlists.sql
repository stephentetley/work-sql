
-- Setup the variables `equi_classdefs_path` and `floc_classdefs_path` 
-- before running this file, e.g.:

-- SET VARIABLE equi_classdefs_path = '~/_working/work/resources/s4_classdefs/002_equi_classdefs_20260205.xlsx';
-- SET VARIABLE floc_classdefs_path = '~/_working/work/resources/s4_classdefs/003_floc_classdefs_20260205.xlsx';

SELECT getvariable('equi_classdefs_path') AS equi_classdefs_path;
SELECT getvariable('floc_classdefs_path') AS floc_classdefs_path;

.read '../common/s4_classes/01_create_tables.sql'
.read '../common/s4_classes/02_read_classlist_export_macro.sql'
.read '../common/s4_classes/03_import_classlists.sql'
.read '../common/s4_classes/04_setup_floc_range_tables.sql'
.read '../common/s4_classes/05_setup_equi_range_tables.sql'
.read '../common/s4_classes/06_setup_s4_floc_classlists_tables.sql'
.read '../common/s4_classes/07_setup_s4_equi_classlists_tables.sql'