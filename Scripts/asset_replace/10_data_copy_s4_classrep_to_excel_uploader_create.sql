CREATE SCHEMA IF NOT EXISTS s4_classrep_to_excel_uploader;

-- Serial numbers may already be mangeled by excel at this point...

--CREATE OR REPLACE MACRO excel_safe_number(str) AS (
--    CASE WHEN regexp_full_match(str :: VARCHAR, '\d+\.\d+E\+\d+') THEN '''' || TRY_CAST(str AS HUGEINT)
--    ELSE str
--    END
--);

--SELECT excel_safe_number('12345678');
--SELECT excel_safe_number('1.69E+18');
--SELECT TRY_CAST('1.69E+18' AS HUGEINT);


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

CREATE OR REPLACE MACRO get_aib_reference_excel_loader_characteristics() AS TABLE (
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
FROM cte2
);

CREATE OR REPLACE MACRO get_solution_id_excel_loader_characteristics() AS TABLE (
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
FROM cte2
);

CREATE OR REPLACE MACRO s4_classrep_to_excel_uploader.translate_equi_masterdata() AS TABLE
SELECT 
    t.equipment_id AS 'equi',
    t.category AS 'category',
    t.equi_description AS 'equi_description',
    t.object_type AS 'object_type',
    t.gross_weight AS 'gross_weight',
    t.unit_of_weight AS 'unit_of_weight',
    t.startup_date AS 'start_up_date',
    t.manufacturer AS 'manufacturer',
    t.model_number AS 'model_number',
    t.manufact_part_number AS 'manuf_part_no',
    t.serial_number AS 'manuf_serial_number',
    t.catalog_profile AS 'catalog_profile',
    t.functional_location AS 'functional_loc',
    t.superord_id AS 'superord_equip',
    t.display_position AS 'position',
    t.technical_ident_number AS 'tech_ident_no',
    'ZEQUIPST' AS 'status_profile',
    t.status_of_an_object AS 'status_of_an_object',
    t.status_of_an_object AS 'status_without_stsno',
FROM s4_classrep.equi_masterdata t
;

DELETE FROM excel_uploader_equi_create.equipment_data;
INSERT INTO excel_uploader_equi_create.equipment_data BY NAME
SELECT * FROM s4_classrep_to_excel_uploader.translate_equi_masterdata()
ORDER BY equi;



DELETE FROM excel_uploader_equi_create.classification;
INSERT INTO excel_uploader_equi_create.classification BY NAME
(
SELECT * FROM get_aib_reference_excel_loader_characteristics()
UNION BY NAME
SELECT * FROM get_solution_id_excel_loader_characteristics()
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('ASSET_CONDITION', s4_classrep.equi_asset_condition)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('EAST_NORTH', s4_classrep.equi_east_north )
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('LSTNUT', s4_classrep.equiclass_lstnut)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('NETWMB', s4_classrep.equiclass_netwmb)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('NETWMO', s4_classrep.equiclass_netwmo)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('NETWTL', s4_classrep.equiclass_netwtl)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('PODETU', s4_classrep.equiclass_podetu)
);



