
CREATE OR REPLACE TEMPORARY TABLE s4_classrep_tables_ddl AS
WITH cte AS (
    SELECT 
        t.class_name AS class_name,
        array_agg(format(E'    {} {},', lower(t.char_name), t.ddl_data_type)) AS field_elements,
    FROM classlists_db.s4_classlists.vw_refined_equi_characteristic_defs t
    JOIN classlists_db.s4_classlists.vw_equi_class_defs t1 ON t1.class_name = t.class_name 
    WHERE EXISTS (FROM asset_replace_gen.s4_classes_used t2 WHERE t2.class_name = t.class_name)
    AND t1.is_object_class = true
    GROUP BY t.class_name
)
SELECT 
    t.class_name AS class_name,
    concat_ws(E'\n',
        format(E'CREATE OR REPLACE TABLE s4_classrep.equiclass_{} (', lower(t.class_name)),
        '    equipment_id VARCHAR NOT NULL, ',
        list_sort(t.field_elements).list_aggregate('string_agg', E'\n'),
        '    PRIMARY KEY(equipment_id)',
        ');'
        ) AS sql_text,
FROM cte t
ORDER BY t.class_name ASC; 


--SELECT * FROM s4_classrep_tables_ddl;


--COPY 
--    (SELECT sql_text FROM s4_classrep_tables_ddl) 
--TO '/home/stephen/_working/coding/work/work-sql/Scripts/output/s4_equiclass_ddl.txt'
--WITH (FORMAT csv, HEADER false, QUOTE '');
