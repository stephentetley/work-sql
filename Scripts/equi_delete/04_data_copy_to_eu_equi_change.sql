
DELETE FROM excel_uploader_equi_change.equipment_data;
INSERT INTO excel_uploader_equi_change.equipment_data BY NAME
SELECT 
    t.s4_equi_id AS equi, 
    t.s4_deleted_name AS equi_description,
    '9999' AS position,
    'DISP' AS status_of_an_object,
FROM s4_landing.equidelete_worklist t;



DELETE FROM excel_uploader_equi_change.classification;
INSERT INTO excel_uploader_equi_change.classification BY NAME
SELECT 
    t.s4_equi_id AS equi, 
    'SOLUTION_ID' AS class_name,
    'SOLUTION_ID' AS characteristics,
    t.solution_id AS char_value,
FROM s4_landing.equidelete_worklist t
WHERE t.solution_id IS NOT NULL;



DELETE FROM excel_uploader_equi_change.batch_worklist;
INSERT INTO excel_uploader_equi_change.batch_worklist BY NAME
SELECT 
    t.s4_equi_id AS equi,
    t.batch AS batch_number,
FROM s4_landing.equidelete_worklist t;





