
-- Setup the variables `asset_types_attributes_path` and `equipment_attribute_sets_path` 
-- before running this file, e.g.:

-- SET VARIABLE asset_types_attributes_path = '~/_working/work/resources/ai2_classdefs/AI2AssetTypeAttributes20250123.xlsx';
-- SET VARIABLE equipment_attribute_sets_path = '~/_working/work/resources/ai2_classdefs/equipment_attribute_sets.xlsx';

SELECT getvariable('asset_types_attributes_path') AS asset_types_attributes_path;
SELECT getvariable('equipment_attribute_sets_path') AS equipment_attribute_sets_path;

.read '../common/ai2_classes/01_create_tables.sql'
.read '../common/ai2_classes/02_export_macros.sql'
.read '../common/ai2_classes/03_import_classlists.sql'
.read '../common/ai2_classes/04_setup_equi_classes.sql'