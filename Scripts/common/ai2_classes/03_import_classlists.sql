.print 'Running 03_import_classlists.sql...'

CREATE OR REPLACE TABLE ai2_classlists_landing.asset_type_attributes AS
SELECT * FROM read_asset_types_attributes(
    getvariable('asset_types_attributes_path')
);


CREATE OR REPLACE TABLE ai2_classlists_landing.equipment_attribute_sets AS
SELECT * FROM read_equipment_attribute_sets(
    getvariable('equipment_attribute_sets_path')
);

