

CREATE OR REPLACE TABLE ai2_classlists_landing.asset_type_attributes AS
SELECT * FROM read_asset_types_attributes(
    '/home/stephen/_working/work/2025/asset_data_facts/ai2_metadata/AI2AssetTypeAttributes20250123.xlsx'
);


CREATE OR REPLACE TABLE ai2_classlists_landing.equipment_attribute_sets AS
SELECT * FROM read_equipment_attribute_sets(
    '/home/stephen/_working/work/2025/asset_data_facts/ai2_metadata/equipment_attribute_sets.xlsx'
);

