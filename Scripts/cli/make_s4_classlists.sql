
-- Setup the variables `equi_classdefs_path` and `floc_classdefs_path` 
-- before running this file, e.g.:

-- SET VARIABLE equi_classdefs_path = '~/_working/work/resources/s4_classdefs/002_equi_classdefs_20260205.xlsx';
-- SET VARIABLE floc_classdefs_path = '~/_working/work/resources/s4_classdefs/003_floc_classdefs_20260205.xlsx';

SELECT getvariable('equi_classdefs_path') AS equi_classdefs_path;
SELECT getvariable('floc_classdefs_path') AS floc_classdefs_path;

.read '../common/s4_classes/01_create_tables.sql'
.read '../common/s4_classes/02_setup_classlists.sql'