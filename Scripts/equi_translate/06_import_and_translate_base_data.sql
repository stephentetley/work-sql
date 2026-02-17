.print 'Running 06_import_and_translate_base_data.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE SCHEMA IF NOT EXISTS equi_translate;

CREATE OR REPLACE TABLE equi_translate.worklist (
    ai2_reference VARCHAR NOT NULL,
    batch INTEGER, 
    equipment_transit_id VARCHAR,
    s4_category	VARCHAR,
    s4_object_type VARCHAR,
    s4_class VARCHAR,
    s4_name VARCHAR,
    s4_floc	VARCHAR,
    s4_superord_equipment VARCHAR,
    s4_position INTEGER,
    PRIMARY KEY(ai2_reference)
);


-- Worklist
SELECT getvariable('equi_translate_worklist') AS equi_translate_worklist;

DELETE FROM equi_translate.worklist;
INSERT OR REPLACE INTO equi_translate.worklist BY NAME
SELECT
    t."AI2 Record" AS ai2_reference,
    t."Batch" AS batch, 
    t."Equipment Transit ID" AS equipment_transit_id,
    t."S4 Category" AS s4_category,
    t."S4 Object Type" AS s4_object_type,
    t."S4 Class" AS s4_class,
    t."S4 Name" AS s4_name,
    t."S4 Floc" AS s4_floc,
    t."S4 Superord Equipment" AS s4_superord_equipment,
    try_cast(t."S4 Position" AS INTEGER) AS s4_position,
FROM read_sheet(
    getvariable('equi_translate_worklist'), 
    columns={
        'Batch': 'INTEGER', 
        'S4 Superord Equipment': 'VARCHAR'
    }
) t;

INSERT OR REPLACE INTO s4_classrep.equi_masterdata BY NAME
SELECT 
    t.equipment_transit_id AS equipment_id,
    t.s4_name AS equi_description,
    t.s4_floc AS functional_location,
    t.s4_superord_equipment AS superord_id,
    t.s4_category AS category,
    t.s4_object_type AS object_type,
    'OPER' AS display_user_status,
    'OPER' AS status_of_an_object,
    t1.installed_from_date AS startup_date,
    month(startup_date) AS construction_year,
    year(startup_date) AS construction_month,
    t1.manufacturer AS manufacturer,
    t1.model AS model_number,
    t2.specific_model_frame AS manufact_part_number,
    t2.serial_number AS serial_number,
    t2.weight_kg AS gross_weight,
    IF(t2.weight_kg IS NOT NULL, 'KG', NULL) AS unit_of_weight,
    t2.pandi_tag AS technical_ident_number,
    t.s4_position AS display_position,
FROM equi_translate.worklist t
JOIN masterdata_db.masterdata.ai2_equipment t1 ON t1.pli_number = t.ai2_reference
JOIN ai2_classrep.equi_extra_masterdata t2 ON t2.ai2_reference = t.ai2_reference;

-- AIB_REFERENCE
DELETE FROM s4_classrep.equi_aib_reference;
INSERT INTO s4_classrep.equi_aib_reference BY NAME
WITH cte1 AS (
    SELECT
        t.equipment_transit_id AS equipment_id,
        1 AS value_index,
        t.ai2_reference AS ai2_aib_reference
    FROM equi_translate.worklist t
), cte2 AS (
    SELECT
        t.equipment_transit_id AS equipment_id,
        2 AS value_index,
        t1.sai_number AS ai2_aib_reference
    FROM equi_translate.worklist t
    JOIN masterdata_db.masterdata.ai2_equipment t1 ON t1.pli_number = t.ai2_reference
)
SELECT * FROM cte1
UNION BY NAME
SELECT * FROM cte2;

-- CONDITION_GRADE
DELETE FROM s4_classrep.equi_asset_condition;
INSERT INTO s4_classrep.equi_asset_condition BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1.condition_grade AS condition_grade,
    t1.condition_grade_reason AS condition_grade_reason,
    t1.agasp_survey_year AS survey_date,
FROM equi_translate.worklist t
JOIN ai2_classrep.equi_agasp t1 ON t1.ai2_reference = t.ai2_reference;


-- EAST_NORTH
DELETE FROM s4_classrep.equi_east_north;
INSERT INTO s4_classrep.equi_east_north BY NAME
WITH cte AS (
    SELECT
        t.equipment_transit_id AS equipment_id,
        udf.get_east_north_struct(t1.grid_ref) AS _grid_ref,

    FROM equi_translate.worklist t
    JOIN ai2_classrep.equi_extra_masterdata t1 ON t1.ai2_reference = t.ai2_reference
)
SELECT
    cte.equipment_id,
    cte._grid_ref['easting'] AS easting,
    cte._grid_ref['northing'] AS northing,
FROM cte;

