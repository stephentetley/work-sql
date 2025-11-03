
DELETE FROM equi_create_gen.s4_equipment;
DELETE FROM equi_create_gen.ai2_equipment;

INSERT INTO equi_create_gen.s4_equipment BY NAME
SELECT 
    *
FROM read_worklist_for_s4_classes(
    '/home/stephen/_working/work/2025/equi_translation/bol10/bol10_equi_assetrep_worklist.xlsx'
);


INSERT INTO equi_create_gen.ai2_equipment BY NAME
SELECT 
    *
FROM read_ai2_masterdata_for_equipment(
    '/home/stephen/_working/work/2025/equi_translation/bol10/bol10_ai2_equi_masterdata.xlsx'
);






