.print 'Running 08_generate_ai2_eav_to_ai2_classrep_statments.sql...'

-- This doesn't work in DBeaver, it has to be run from the CLI...

-- TODO move this into a separate gen_equi_translate sub project

-- NOTE we generate some fatuous casts and renamings as we need to avoid empty
-- lists of casts and renamings during SQL generation

CREATE OR REPLACE TEMPORARY VIEW vw_ai2_equi_to_classrep_json AS
WITH cte1 AS (
    SELECT
        lower(t.class_derivation || '_' || t.class_table_name) AS table_name,
        t.class_description AS equipment_type,
        row_number() OVER (PARTITION BY t.class_table_name ORDER BY t.attribute_description) AS idx,
        t.attribute_description AS raw_name,
        t.attribute_description.replace('/', '_') AS safe_name,
        t.ddl_data_type AS ddl_datatype,
    FROM ai2_classlists_db.ai2_classlists.vw_equiclass_characteristics t
), cte2 AS (
    SELECT
        t.table_name,
        t.equipment_type, 
        json_group_array(json_object('idx', t.idx, 
                                    'raw_name', t.raw_name, 
                                    'safe_name', t.safe_name, 
                                    'ddl_datatype', t.ddl_datatype)) AS fields,
    FROM cte1 t
    GROUP BY ALL     
) 
SELECT * FROM cte2;


CREATE OR REPLACE TEMPORARY VIEW vw_ai2_equi_to_classrep_ddl AS
SELECT
    table_name, 
    tera_render('
        INSERT INTO ai2_classrep.{{ table_name }} BY NAME
        SELECT
            t.ai2_reference AS ai2_reference,
            {% for field in fields %}
            TRY_CAST(t{{ field.idx }}.attr_value AS {{ field.ddl_datatype }}) AS ''{{ field.safe_name }}'',
            {% endfor %}
        FROM
            ai2_eav.vw_ai2_eav_worklist t
        {% for field in fields %}
        LEFT JOIN ai2_eav.equipment_eav t{{ field.idx }} ON t{{ field.idx }}.ai2_reference = t.ai2_reference AND t{{ field.idx }}.attr_name = ''{{ field.raw_name }}''
        {% endfor %}
        WHERE t.equipment_type = ''{{ equipment_name }}'';        
        ', json_object(
            'table_name', t.table_name,
            'equipment_name', t.equipment_type,
            'fields', t.fields
            )
        ) AS sql_text
FROM vw_ai2_equi_to_classrep_json t
ORDER BY table_name;


