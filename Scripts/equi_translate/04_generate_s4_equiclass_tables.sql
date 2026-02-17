.print 'Running 04_generate_s4_equiclass_tables.sql...'

INSTALL tera FROM community;
LOAD tera;

-- This doesn't work in DBeaver, it has to be run from the CLI...


CREATE OR REPLACE TEMPORARY VIEW vw_s4_equi_classes_json AS
SELECT
    'equiclass_' || lower(t.class_name).trim() AS class_name,
    json_group_array(json_object('name', lower(t1.char_name), 'ddl_type', t1.ddl_data_type)) AS equi_characteristcs,
FROM s4_classlists_db.s4_classlists.vw_equi_class_defs t
JOIN s4_classlists_db.s4_classlists.vw_refined_equi_characteristic_defs t1
    ON t1.class_name = t.class_name
WHERE t.is_object_class = true
GROUP BY t.class_name
ORDER BY class_name;



CREATE OR REPLACE TEMPORARY VIEW vw_s4_classrep_tables_ddl AS
SELECT
    tera_render(
        'CREATE OR REPLACE TABLE s4_classrep.{{table_name}} (
            equipment_id VARCHAR NOT NULL,
            {% for field in fields %}
            {{ field.name }} {{ field.ddl_type }},
            {% endfor %}
            PRIMARY KEY(equipment_id)
        );', json_object(
            'table_name', t.class_name,
            'fields', t.equi_characteristcs
        )
        ) AS sql_text
FROM vw_s4_equi_classes_json t;




