
CREATE SCHEMA IF NOT EXISTS asset_replace_gen;

-- TODO create a view of ai2_classes_db.ai2_classlists.equi_characteristics
-- and drop the master data and common data attributes...


CREATE OR REPLACE TABLE asset_replace_gen.s4_equipment (
    ai2_plinum VARCHAR NOT NULL,
    s4_category VARCHAR,
    s4_object_type VARCHAR,
    s4_class_name VARCHAR, 
    PRIMARY KEY (ai2_plinum)
);

CREATE OR REPLACE VIEW asset_replace_gen.vw_s4_classes_used AS
SELECT DISTINCT ON (s4_class_name)
    s4_class_name
FROM asset_replace_gen.s4_equipment;

CREATE OR REPLACE TABLE asset_replace_gen.ai2_equipment (
    ai2_plinum VARCHAR NOT NULL,
    common_name VARCHAR,
    equipment_type_name VARCHAR,
    PRIMARY KEY (ai2_plinum)
);

CREATE OR REPLACE VIEW asset_replace_gen.vw_ai2_equipment_types_used AS
SELECT DISTINCT ON (equipment_type_name)
    equipment_type_name
FROM asset_replace_gen.ai2_equipment;

-- Worklist
CREATE OR REPLACE TEMPORARY MACRO read_worklist_for_s4_classes(src) AS TABLE
SELECT 
    t."Operational AI2 record (PLI)" AS ai2_plinum,
    t."S4 Category" AS s4_category,
    t."S4 Object Type" AS s4_object_type,
    t."S4 Class" AS s4_class_name,
FROM read_xlsx(src :: VARCHAR, sheet='Worklist', all_varchar=true) t;


CREATE OR REPLACE TEMPORARY MACRO read_ai2_masterdata_for_equipment(src) AS TABLE
SELECT 
    t."AssetId" AS ai2_plinum,
    t."Common Name" AS common_name,
    regexp_extract(t."Common Name", '(EQUIPMENT:.*)', 1) AS equipment_type_name,
FROM read_xlsx(src :: VARCHAR, sheet='Sheet1', all_varchar=true) t;


