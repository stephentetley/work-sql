.print 'Running 02_generate_ai2_equiclass_tables.sql...'

INSTALL tera FROM community;
LOAD tera;

-- This doesn't work in DBeaver, it has to be run from the CLI...

-- TODO move this into a separate gen_equi_translate sub project

CREATE OR REPLACE TEMPORARY VIEW vw_ai2_equi_classes_json AS
WITH cte1 AS (
    SELECT
        lower(t.class_derivation || '_' || t.class_table_name) AS table_name,
        t.attribute_description.replace('/', '_') AS attribute_name,
        t.ddl_data_type,
    FROM ai2_classlists_db.ai2_classlists.vw_equiclass_characteristics t
    GROUP BY ALL
), cte2 AS (
SELECT
    t.table_name AS class_name,
    json_group_array(json_object('name', t.attribute_name, 'ddl_type', t.ddl_data_type)) AS equi_characteristcs,
FROM cte1 t
GROUP BY t.table_name
)
SELECT * FROM cte2 ORDER BY class_name;



CREATE OR REPLACE TEMPORARY VIEW vw_ai2_classrep_tables_ddl AS
SELECT
    tera_render(
        'CREATE OR REPLACE TABLE ai2_classrep.{{table_name}} (
            ai2_reference VARCHAR NOT NULL,
            {% for field in fields %}
            "{{ field.name }}" {{ field.ddl_type }},
            {% endfor %}
            PRIMARY KEY(ai2_reference)
        );', 
        json_object(
            'table_name', t.class_name,
            'fields', t.equi_characteristcs
        )
        ) AS sql_text
FROM vw_ai2_equi_classes_json t;




