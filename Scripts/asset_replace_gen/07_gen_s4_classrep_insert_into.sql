

CREATE OR REPLACE TEMPORARY TABLE delete_from_s4_classrep_tables AS
WITH cte1 AS (
    SELECT 
        array_agg(format(E'DELETE FROM s4_classrep.s4_classrep.equiclass_{});', lower(t.class_name))) AS delete_lines,
    FROM s4_classes_db.s4_classlists.vw_equi_class_defs t
    WHERE EXISTS (FROM asset_replace_gen.s4_classes_used t2 WHERE t2.class_name = t.class_name)
)
SELECT 
    list_sort(t.delete_lines).list_aggregate('string_agg', E'\n') AS sql_text
FROM cte1 t;