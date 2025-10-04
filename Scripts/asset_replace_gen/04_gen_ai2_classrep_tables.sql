

CREATE OR REPLACE TEMPORARY TABLE ai2_classrep_tables_ddl AS
WITH cte AS (
    SELECT 
        t.class_table_name AS table_name,
        array_agg(format(E'    "{}" {},', t.attribute_description, t.ddl_data_type)) AS field_elements,
    FROM ai2_classes_db.ai2_classlists.equi_characteristics t
    WHERE EXISTS (FROM asset_replace_gen.ai2_equipment_used t1 WHERE t1.equipment_type_name = t.class_description) 
    GROUP BY t.class_table_name
)
SELECT 
    t.table_name AS table_name,
    concat_ws(E'\n',
        format(E'CREATE OR REPLACE TABLE ai2_classrep.{} (', t.table_name),
        '    equipment_id VARCHAR NOT NULL, ',
        list_sort(t.field_elements).list_aggregate('string_agg', E'\n'),
        '    PRIMARY KEY(equipment_id)',
        ');'
        ) AS sql_text,
FROM cte t
ORDER BY t.table_name ASC; 

--SELECT * FROM ai2_classrep_tables_ddl;

--COPY 
--    (SELECT sql_text FROM ai2_classrep_tables_ddl) 
--TO '/home/stephen/_working/coding/work/work-sql/Scripts/output/ai2_equiclass_tables_ddl.txt'
--WITH (FORMAT csv, HEADER false, QUOTE '');