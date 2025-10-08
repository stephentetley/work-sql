

CREATE OR REPLACE TEMPORARY TABLE delete_from_s4_classrep_tables AS
WITH cte1 AS (
    SELECT 
        array_agg(format(E'DELETE FROM s4_classrep.equiclass_{};', lower(t.class_name))) AS delete_lines,
    FROM s4_classes_db.s4_classlists.vw_equi_class_defs t
    WHERE EXISTS (FROM asset_replace_gen.vw_s4_classes_used t1 WHERE t1.s4_class_name = t.class_name)
)
SELECT 
    list_sort(t.delete_lines).list_aggregate('string_agg', E'\n') AS sql_text
FROM cte1 t;


-- Generate lines of the form:
-- INSERT OR REPLACE INTO s4_classrep.equiclass_lstnut BY NAME
-- SELECT * FROM ultrasonic_level_instrument_to_lstnut();

CREATE OR REPLACE TEMPORARY TABLE insert_into_s4_classrep_tables AS
WITH cte1 AS (
    SELECT DISTINCT ON (t.class_description)
        t.class_description,
        t.class_table_name,
    FROM ai2_classes_db.ai2_classlists.vw_equiclass_characteristics t
), cte2 AS (
    SELECT DISTINCT ON (t1.class_table_name, t2.s4_class_name)
        lower(t2.s4_class_name) AS s4_class,
        t1.class_table_name AS ai2_equi_type,
    FROM asset_replace_gen.ai2_equipment t
    JOIN cte1 t1
        ON t1.class_description = t.equipment_type_name
    JOIN asset_replace_gen.s4_equipment t2
        ON t2.ai2_plinum = t.ai2_plinum
), cte3 AS (
    SELECT 
        array_agg(
            concat_ws(E'\n',
                format(E'INSERT OR REPLACE INTO s4_classrep.equiclass_{} BY NAME', t.s4_class),
                format(E'SELECT * FROM {}_to_{}();', t.ai2_equi_type, t.s4_class)
                )
            ) AS insert_lines,
    FROM cte2 t

)
SELECT 
    list_sort(t.insert_lines).list_aggregate('string_agg', E'\n\n\n') AS sql_text
FROM cte3 t;
