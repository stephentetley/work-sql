
CREATE OR REPLACE TEMPORARY TABLE s4_classrep_to_excel_uploader_chars AS
WITH cte1 AS (
    SELECT 
        array_agg(format(E'SELECT * FROM get_excel_loader_characteristics_for(''{}'', s4_classrep.equiclass_{})', t.class_name , lower(t.class_name))) AS select_lines,
    FROM s4_classes_db.s4_classlists.vw_equi_class_defs t
    WHERE EXISTS (FROM equi_create_gen.vw_s4_classes_used t2 WHERE t2.s4_class_name = t.class_name)
)
SELECT 
    concat_ws(E'\n',
        'INSERT INTO excel_uploader_equi_create.classification BY NAME',
        '(',
        list_sort(t.select_lines).list_aggregate('string_agg', E',\nUNION BY NAME\n'),
        ');',
        ''
    ) AS sql_text
FROM cte1 t;
        
