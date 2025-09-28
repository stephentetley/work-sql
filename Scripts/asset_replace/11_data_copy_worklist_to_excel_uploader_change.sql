CREATE OR REPLACE TEMPORARY MACRO rename_as_del(equi_description) AS
    CASE 
        WHEN len(equi_description) > 34 THEN left(equi_description, 34) || ' (Del)'
        ELSE equi_description || ' (Del)'
    END   
;

DELETE FROM excel_uploader_equi_change.equipment_data;
INSERT INTO excel_uploader_equi_change.equipment_data BY NAME
SELECT DISTINCT ON ("Existing S4 Record")
    "Existing S4 Record" AS equi,
    rename_as_del("S4 Name") AS equi_description,
    '9999' AS position,
    'DISP' AS status_of_an_object,
FROM ai2_landing.worklist
WHERE "Existing S4 Record" IS NOT NULL OR "Existing S4 Record" <> '';


