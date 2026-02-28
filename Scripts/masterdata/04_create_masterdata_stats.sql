.print 'Running 04_create_masterdata_stats.sql...'

CREATE SCHEMA IF NOT EXISTS masterdata_stats;

CREATE OR REPLACE VIEW masterdata_stats.vw_translation_stats AS
WITH cte1 AS (
    SELECT 
        count(t.pli_number) AS translation_count, 
        t.equi_type_name AS ai2_source_type,
        t2.std_class AS s4_destination_type,
    FROM masterdata.ai2_equipment t
    JOIN masterdata.s4_to_plinum t1 ON t1.ai2_plinum = t.pli_number
    JOIN masterdata.s4_equipment t2 ON t2.equipment_id = t1.s4_equipment_id
    GROUP BY t.equi_type_name, t2.std_class
), cte2 AS (
    SELECT 
        count(t.pli_number) AS item_total, 
        t.equi_type_name AS ai2_source_type,
    FROM masterdata.ai2_equipment t
    GROUP BY t.equi_type_name
)
SELECT 
    t.item_total AS source_type_total,
    t1.translation_count AS translation_count,
    format('{:.2f}%', (translation_count / item_total) * 100.0) AS percent,
    t1.ai2_source_type AS ai2_source_type,
    t1.s4_destination_type AS s4_destination_type,
FROM cte2 t
JOIN cte1 t1 ON t1.ai2_source_type = t.ai2_source_type 
ORDER BY ai2_source_type ASC, translation_count DESC;