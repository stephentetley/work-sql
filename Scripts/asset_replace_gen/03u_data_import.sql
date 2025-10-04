
DELETE FROM asset_replace_gen.s4_classes_used;
DELETE FROM asset_replace_gen.ai2_equipment_used;

INSERT INTO asset_replace_gen.s4_classes_used BY NAME
SELECT 
    *
FROM read_worklist_for_s4_classes(
    '/home/stephen/_working/work/2025/equi_translation/bol10/bol10_equi_assetrep_worklist.xlsx'
);


INSERT INTO asset_replace_gen.ai2_equipment_used BY NAME
SELECT 
    *
FROM read_ai2_masterdata_for_equipment(
    '/home/stephen/_working/work/2025/equi_translation/bol10/bol10_ai2_equi_masterdata.xlsx'
);






