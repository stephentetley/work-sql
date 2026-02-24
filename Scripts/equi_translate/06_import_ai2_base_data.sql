.print 'Running 06_import_ai2_base_data.sql...'

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
    solution_id VARCHAR,
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
    t."Solution ID" AS solution_id,
FROM read_sheet(
    getvariable('equi_translate_worklist'), 
    columns={
        'Batch': 'INTEGER', 
        'S4 Superord Equipment': 'VARCHAR'
    }
) t;

