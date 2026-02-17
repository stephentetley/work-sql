.print 'Running 10_s4_equiclass_to_excel_uploader.sql...'

DELETE FROM excel_uploader_equi_create.batch_worklist;
INSERT OR REPLACE INTO excel_uploader_equi_create.batch_worklist BY NAME
SELECT
    t.equipment_transit_id AS equi,
    t.batch AS batch_number,
FROM equi_translate.worklist t;

DELETE FROM excel_uploader_equi_create.equipment_data;
INSERT OR REPLACE INTO excel_uploader_equi_create.equipment_data BY NAME 
SELECT 
    t.equipment_id AS equi,
    t.category AS category,
    t.equi_description AS equi_description,
    t.object_type AS object_type,
    t.gross_weight AS gross_weight,
    t.unit_of_weight AS unit_of_weight,
    t.startup_date AS start_up_date,
    t.manufacturer AS manufacturer,
    t.model_number AS model_number,
    t.manufact_part_number AS manuf_part_no,
    t.serial_number AS manuf_serial_number,
    t.catalog_profile AS catalog_profile,
    t.functional_location AS functional_loc,
    t.superord_id AS superord_equip,
    t.display_position AS position,
    t.technical_ident_number AS tech_ident_no,
    'ZEQUIPST' AS status_profile,
    t.status_of_an_object AS status_of_an_object,
    t.status_of_an_object AS status_without_stsno,
FROM s4_classrep.equi_masterdata t;

-- Characteristics
DELETE FROM excel_uploader_equi_create.classification;

-- AIB_REFERENCE (needs to exclude value_index)
INSERT INTO excel_uploader_equi_create.classification BY NAME
WITH cte1 AS (
    SELECT COLUMNS(* EXCLUDE (value_index))
    FROM s4_classrep.equi_aib_reference
), cte2 AS (
    UNPIVOT cte1
    ON COLUMNS (* EXCLUDE (equipment_id))
    INTO 
        NAME 'characteristics'
        VALUE 'char_value'
)
SELECT 
    equipment_id AS equi,
    'AIB_REFERENCE' AS class_name, 
    upper(characteristics) AS characteristics,
    char_value,
FROM cte2;

-- SOLUTION_ID (needs to exclude value_index)
INSERT INTO excel_uploader_equi_create.classification BY NAME
WITH cte1 AS (
    SELECT COLUMNS(* EXCLUDE (value_index))
    FROM s4_classrep.equi_solution_id
), cte2 AS (
    UNPIVOT cte1
    ON COLUMNS (* EXCLUDE (equipment_id))
    INTO 
        NAME 'characteristics'
        VALUE 'char_value'
)
SELECT 
    equipment_id AS equi,
    'SOLUTION_ID' AS class_name, 
    upper(characteristics) AS characteristics,
    char_value,
FROM cte2;



CREATE OR REPLACE MACRO get_excel_loader_characteristics_for(s4_class_name, table_name) AS TABLE (
WITH cte AS (
    UNPIVOT (SELECT CAST(COLUMNS(*) AS VARCHAR) FROM query_table(table_name::VARCHAR))
    ON COLUMNS (* EXCLUDE (equipment_id))
    INTO 
        NAME 'characteristics'
        VALUE 'char_value'
) 
SELECT 
    equipment_id AS equi,
    s4_class_name::VARCHAR AS class_name, 
    upper(characteristics) AS characteristics,
    char_value,
FROM cte
);

INSERT INTO excel_uploader_equi_create.classification BY NAME
(
    SELECT * FROM get_excel_loader_characteristics_for('ASSET_CONDITION', s4_classrep.equi_asset_condition)
    UNION BY NAME
    SELECT * FROM get_excel_loader_characteristics_for('EAST_NORTH', s4_classrep.equi_east_north )
);

INSERT INTO excel_uploader_equi_create.classification BY NAME
SELECT * FROM get_excel_loader_characteristics_for('METREL', s4_classrep.equiclass_metrel)