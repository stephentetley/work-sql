.print 'Running 02_generate_eav_to_classrep.sql...'

-- SAMPLE OF WHAT'S TO BE GENERATED:

DELETE FROM ai2_classrep.equiclass_electric_meter;

INSERT INTO ai2_classrep.equiclass_electric_meter BY NAME
WITH cte1 AS (
    SELECT
        t1.*
    FROM
        ai2_eav.worklist t
    JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
    WHERE t.equipment_type = 'EQUIPMENT: ELECTRIC METER'
), cte2 AS (
    PIVOT cte1
    ON attr_name IN (
        'HH/non HH site',
        'Location On Site',
        'MPAN number',
        'No of Broken Fibres Repaired',
        'Supply capacity',
    )
    USING any_value(attr_value)
    GROUP BY ai2_reference
), cte3 AS (
    SELECT * RENAME ("HH/non hh site" AS "hh_non HH site")  FROM cte2
), cte4 AS (    
    SELECT * REPLACE (try_cast("MPAN number" AS DECIMAL(18,3)) AS "MPAN number") FROM cte3
)
SELECT * FROM cte4;