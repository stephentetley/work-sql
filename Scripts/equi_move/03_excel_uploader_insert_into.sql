.print 'Running 03_excel_uploader_insert_into.sql...'


.print 'Inserting into excel_uploader_equi_change.equipment_data...'

INSERT INTO excel_uploader_equi_change.equipment_data BY NAME
SELECT
    t.equipment_id AS equi,
    t.equi_description AS equi_description,
    t.target_funcloc AS functional_loc,
    t.target_superord_equi AS superord_equip,
    t.position AS position,
FROM equi_move.worklist t;


.print 'Inserting into excel_uploader_equi_change.batch_worklist...'

-- Batch worklist
INSERT INTO excel_uploader_equi_change.batch_worklist BY NAME
SELECT 
    t.equipment_id AS equi,
    t.batch AS batch_number,
FROM equi_move.worklist t;

