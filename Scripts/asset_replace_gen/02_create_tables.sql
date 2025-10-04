
CREATE SCHEMA IF NOT EXISTS asset_replace_gen;

CREATE OR REPLACE TABLE asset_replace_gen.ai2_equipment_used (
    equipment_type_name VARCHAR,
);

CREATE OR REPLACE TABLE asset_replace_gen.s4_classes_used (
    class_name VARCHAR,
);


-- Worklist
CREATE OR REPLACE MACRO read_worklist_for_s4_classes(xlsx_file) AS TABLE
SELECT 
    t."S4 Class" AS class_name,
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true, sheet='Worklist') AS t;

CREATE OR REPLACE MACRO read_ai2_masterdata_for_equipment(xlsx_file) AS TABLE
SELECT 
    regexp_extract(t."Common Name", '(EQUIPMENT:.*)', 1) AS equipment_type_name,
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true) AS t;


