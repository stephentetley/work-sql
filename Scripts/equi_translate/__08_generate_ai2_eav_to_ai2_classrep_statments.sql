.print 'Running 08_generate_ai2_eav_to_ai2_classrep_statments.sql...'

-- SAMPLE OF WHAT'S TO BE GENERATED:

DELETE FROM ai2_classrep.equiclass_electric_meter;

INSERT INTO ai2_classrep.equiclass_electric_meter BY NAME
            WITH cte1 AS (
                SELECT
                    t1.*
                FROM
                    ai2_eav.vw_ai2_eav_worklist t
                JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
                WHERE t.equipment_type = 'EQUIPMENT: ELECTRIC METER'
            ), cte2 AS (
                PIVOT cte1
                ON attr_name IN (
                    
                    'HH&#x2F;non HH site',
                    
                    'Location On Site',
                    
                    'MPAN number',
                    
                    'No of Broken Fibres Repaired',
                    
                    'Supply capacity',
                    
                )
                USING any_value(attr_value)
                GROUP BY ai2_reference
            ), cte3 AS (
                SELECT * RENAME (
                    
                    "HH&#x2F;non hh site" AS "HH_non HH site",
                    
                )  FROM cte2
            ), cte4 AS (
                SELECT * REPLACE (
                    
                    try_cast("MPAN number" AS DECIMAL(18,3)) AS "MPAN number",
                    
                    try_cast("No of Broken Fibres Repaired" AS INTEGER) AS "No of Broken Fibres Repaired",
                    
                ) FROM cte3
            )
            SELECT * FROM cte4;