.print 'Running 04_create_masterdata_stats.sql...'

CREATE SCHEMA IF NOT EXISTS masterdata_stats;

CREATE OR REPLACE VIEW masterdata_stats.vw_translation_class_stats AS
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
    (translation_count / item_total) * 100.0 AS percent,
    t1.ai2_source_type AS ai2_source_type,
    t1.s4_destination_type AS s4_destination_type,
FROM cte2 t
JOIN cte1 t1 ON t1.ai2_source_type = t.ai2_source_type 
ORDER BY ai2_source_type ASC, translation_count DESC;

CREATE OR REPLACE VIEW masterdata_stats.vw_unknown_in_s4_stats AS
WITH cte1 AS (
    SELECT 
        count(t.pli_number) AS unknown_in_s4, 
        t.equi_type_name AS ai2_type,
    FROM masterdata.ai2_equipment t
    ANTI JOIN masterdata.s4_to_plinum t1 ON t1.ai2_plinum = t.pli_number
    WHERE t.user_status = 'OPERATIONAL'
    GROUP BY t.equi_type_name
), cte2 AS (
    SELECT 
        count(t.pli_number) AS count_in_ai2, 
        t.equi_type_name AS ai2_type,
    FROM masterdata.ai2_equipment t
    WHERE t.user_status = 'OPERATIONAL'
    GROUP BY t.equi_type_name
)
SELECT 
    t.count_in_ai2 AS count_in_ai2,
    t1.unknown_in_s4 AS unknown_in_s4,
    (unknown_in_s4 / count_in_ai2) * 100.0 AS percent,
    t1.ai2_type AS ai2_type,
FROM cte2 t
JOIN cte1 t1 ON t1.ai2_type = t.ai2_type 
ORDER BY ai2_type ASC;