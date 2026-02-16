

-- TODO need to use a worklist as the destination type for
-- a particular source type is a user choice and not known
-- statically

INSERT OR REPLACE INTO s4_classrep.equiclass_metrel BY NAME
SELECT
    t.ai2_reference AS equipment_id,
    t."Location On Site" AS location_on_site,
    t."HH_non HH site" AS metr_hh_meter,
    t."MPAN number" AS metr_mpan_number,
    'TEMP_VALUE' AS uniclass_code,
    'TEMP_VALUE' AS uniclass_desc,
FROM ai2_classrep.equiclass_electric_meter t;

