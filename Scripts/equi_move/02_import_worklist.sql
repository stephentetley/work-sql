.print 'Running 02_import_worklist.sql...'

.print 'Loading equi_move_worklist...'
SELECT getvariable('equi_move_worklist') AS equi_move_worklist;

CREATE OR REPLACE TABLE equi_move_landing.worklist AS
SELECT * 
FROM read_sheet(
    getvariable('equi_move_worklist'), 
    header=true,
    columns={
        'Equipment Id': 'BIGINT', 
        'Batch': 'INTEGER', 
        'Target Superord Equi': 'BIGINT',
        'Position': 'INTEGER'
        }
);

.print 'Inserting into equi_move.worklist...'

DELETE FROM equi_move.worklist;

INSERT OR REPLACE INTO equi_move.worklist BY NAME
SELECT 
    t."Equipment Id" AS equipment_id,
    t."Equipment Name" AS equi_description,
    t."Target Funcloc" AS target_funcloc,
    t."Target Superord Equi" AS target_superord_equi,
    t."Position" AS position,
    t."Batch" AS batch,
FROM equi_move_landing.worklist t;

