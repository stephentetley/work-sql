.print 'Running 02_translate_ai2_equiclass_to_s4.sql...'

-- We need to use a worklist as the destination type for a 
-- particular source type is the user's choice and not known
-- statically

DELETE FROM s4_classrep.equiclass_metrel;
INSERT OR REPLACE INTO s4_classrep.equiclass_metrel BY NAME
SELECT
    t.equipment_transit_id AS equipment_id,
    t1."Location On Site" AS location_on_site,
    t1."HH_non HH site" AS metr_hh_meter,
    t1."MPAN number" AS metr_mpan_number,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM equi_translate.worklist t
LEFT JOIN ai2_classrep.equiclass_electric_meter t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.s4_class = 'METREL';

-- SELECT * FROM s4_classrep.equiclass_metrel;
