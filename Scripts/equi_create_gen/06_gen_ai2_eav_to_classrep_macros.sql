-- SAMPLE:



CREATE OR REPLACE TEMPORARY TABLE ai2_eav_to_classrep_inserts AS
WITH cte1 AS (
    SELECT 
        table_prefix(t.class_derivation) || t.class_table_name AS table_name, 
        t.class_description AS equipment_type,
        array_agg(t.attribute_description) AS attributes_list,
    FROM ai2_classes_db.ai2_classlists.vw_equiclass_characteristics t
    WHERE EXISTS (FROM equi_create_gen.vw_ai2_equipment_types_used t1 WHERE t1.equipment_type_name = t.class_description)
    GROUP BY t.class_table_name, t.class_description, t.class_derivation
), cte2 AS (
SELECT 
    t.table_name AS table_name,
    t.equipment_type AS equipment_type,
    concat_ws(E'\n',
        '(',
        list_sort(t.attributes_list).list_transform(lambda s: squote(s)).list_aggregate('string_agg', E',\n\t'),
        ')'
        ) AS attributes_text,
FROM cte1 t
)
SELECT 
    t.table_name AS table_name,
    concat_ws(E'\n',
        format('DELETE FROM ai2_classrep.{};', t.table_name),
        '',
        format('INSERT OR IGNORE INTO ai2_classrep.{} BY NAME', t.table_name),
        'WITH cte1 AS (',
        'SELECT',
        '    t1.*',
        'FROM',
        '    ai2_classrep.equi_masterdata t',
        'JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference',
        format('WHERE t.equipment_type = {}', squote(t.equipment_type)),
        '), cte2 AS (',
        'PIVOT cte1',
        format('ON attr_name IN {}', t.attributes_text),
        'USING any_value(attr_value)',
        'GROUP BY ai2_reference',
        ')',
        'SELECT * from cte2;',
        ''
    ) AS sql_text,
FROM cte2 t
ORDER BY t.table_name ASC; 




