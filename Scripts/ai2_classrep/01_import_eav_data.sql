.print 'Running 01_import_eav_data.sql...'

CREATE SCHEMA IF NOT EXISTS ai2_eav;


CREATE OR REPLACE TABLE ai2_eav.equipment_eav (
    ai2_reference VARCHAR,
    attr_name VARCHAR,
    attr_value VARCHAR
);

SELECT getvariable('ai2_attributes_glob') AS ai2_attributes_glob;


INSERT INTO ai2_eav.equipment_eav
WITH cte1 AS (
    SELECT
        t."Reference" AS 'ai2_reference',
        t.* EXCLUDE("AssetId", "Reference", "Common Name", "Installed From", "Manufacturer", "Model", "Hierarchy Key", "AssetStatus", "Asset in AIDE ?"),
    FROM read_sheets([getvariable('ai2_attributes_glob')], columns={'*': 'VARCHAR'}) t
), cte2 AS (
    FROM cte1 UNPIVOT INCLUDE NULLS (
        attr_value FOR attr_name IN (COLUMNS(* EXCLUDE "ai2_reference"))
    )
)
SELECT * FROM cte2 ORDER BY attr_name;



INSERT OR IGNORE INTO ai2_classrep.equi_extra_masterdata BY NAME
SELECT 
    t.ai2_reference AS ai2_reference,
    TRY_CAST(eav1.attr_value AS DECIMAL) AS weight_kg,
    eav2.attr_value AS specific_model_frame,
    eav3.attr_value AS serial_number,
    eav4.attr_value AS grid_ref,
    eav5.attr_value AS pandi_tag,
FROM ai2_eav.equipment_eav AS t
LEFT JOIN ai2_eav.equipment_eav eav1 ON eav1.ai2_reference = t.ai2_reference AND eav1.attr_name = 'Weight kg'
LEFT JOIN ai2_eav.equipment_eav eav2 ON eav2.ai2_reference = t.ai2_reference AND eav2.attr_name = 'Specific Model/Frame'
LEFT JOIN ai2_eav.equipment_eav eav3 ON eav3.ai2_reference = t.ai2_reference AND eav3.attr_name = 'Serial No'
LEFT JOIN ai2_eav.equipment_eav eav4 ON eav4.ai2_reference = t.ai2_reference AND eav4.attr_name = 'Loc.Ref.'
LEFT JOIN ai2_eav.equipment_eav eav5 ON eav5.ai2_reference = t.ai2_reference AND eav5.attr_name = 'P AND I Tag No';

SELECT * FROM ai2_eav.equipment_eav WHERE attr_name = 'Loc.Ref.';