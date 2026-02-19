.print 'Running 08_generate_ai2_eav_to_ai2_classrep_statments.sql...'

INSTALL tera FROM community;
LOAD tera;

-- This doesn't work in DBeaver, it has to be run from the CLI...

-- TODO move this into a separate gen_equi_translate sub project

-- NOTE we generate some fatuous casts and renamings as we need to avoid empty
-- lists of casts and renamings during SQL generation

CREATE OR REPLACE TEMPORARY VIEW vw_ai2_equi_to_classrep_json AS
WITH cte1 AS (
    SELECT
        lower(t.class_derivation || '_' || t.class_table_name) AS table_name,
        t.class_description AS equipment_type,
        t.attribute_description AS attribute_name,
        t.attribute_description.replace('/', '_') AS safe_attribute_name,
        t.ddl_data_type AS ddl_data_type,
    FROM ai2_classlists_db.ai2_classlists.vw_equiclass_characteristics t
    GROUP BY ALL
), cte2 AS (
    SELECT
        table_name,
        json_group_array(attribute_name) AS fields,
    FROM cte1
    GROUP BY ALL
), cte3 AS (
    SELECT
        table_name,
        json_group_array(json_object('namefrom', attribute_name, 'nameto', safe_attribute_name)) AS renamings,
    FROM cte1
    GROUP BY ALL
), cte4 AS (
    SELECT
        table_name,
        json_group_array(json_object('field', safe_attribute_name, 'ddl_datatype', ddl_data_type)) AS casts,
    FROM cte1
    GROUP BY ALL
)
SELECT
    t.table_name,
    t.equipment_type,
    t1.fields AS fields,
    t2.renamings AS renamings,
    t3.casts AS casts,
FROM cte1 t
JOIN cte2 t1 ON t1.table_name = t.table_name
LEFT JOIN cte3 t2 ON t2.table_name = t.table_name
LEFT JOIN cte4 t3 ON t3.table_name = t.table_name;



CREATE OR REPLACE TEMPORARY VIEW vw_ai2_equi_to_classrep_ddl AS
SELECT
    tera_render(
        'INSERT INTO ai2_classrep.{{ table_name }} BY NAME
            WITH cte1 AS (
                SELECT
                    t1.*
                FROM
                    ai2_eav.vw_ai2_eav_worklist t
                JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
                WHERE t.equipment_type = ''{{ equipment_name }}''
            ), cte2 AS (
                PIVOT cte1
                ON attr_name IN (
                    {% for field in fields %}
                    ''{{ field }}'',
                    {% endfor %}
                )
                USING any_value(attr_value)
                GROUP BY ai2_reference
            ), cte3 AS (
                SELECT * RENAME (
                    {% for renaming in renamings %}
                    "{{ renaming.namefrom }}" AS "{{ renaming.nameto }}",
                    {% endfor %}
                )  FROM cte2
            ), cte4 AS (
                SELECT * REPLACE (
                    {% for cast in casts %}
                    try_cast("{{ cast.field }}" AS {{ cast.ddl_datatype }}) AS "{{ cast.field }}",
                    {% endfor %}
                ) FROM cte3
            )
            SELECT * FROM cte4;',
    json_object(
            'table_name', t.table_name,
            'equipment_name', t.equipment_type,
            'fields', t.fields,
            'renamings', t.renamings,
            'casts', t.casts
        )
        ) AS sql_text
FROM vw_ai2_equi_to_classrep_json t
ORDER BY table_name;


