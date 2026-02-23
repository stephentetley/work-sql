.print 'Running 04_generate_s4_equiclasses_to_excel_uploader.sql...'

-- This doesn't work in DBeaver, it has to be run from the CLI...

-- TODO move this into a separate gen_equi_translate sub project

-- NOTE we generate some fatuous casts and renamings as we need to avoid empty
-- lists of casts and renamings during SQL generation

CREATE OR REPLACE TEMPORARY VIEW vw_ai2_classrep_to_uploader_json AS
SELECT
    'equiclass_' || lower(t.class_name).trim() AS table_name,
    lower(t.class_name).trim() AS s4_class,
FROM s4_classlists_db.s4_classlists.vw_equi_class_defs t
WHERE t.is_object_class = true
GROUP BY ALL;


CREATE OR REPLACE TEMPORARY VIEW vw_ai2_classrep_to_uploader_ddl AS
SELECT
    table_name, 
    tera_render('
        INSERT INTO excel_uploader_equi_create.classification BY NAME
        SELECT * FROM get_excel_loader_characteristics_for(''{{ s4_class }}'', s4_classrep.{{ table_name }});        
        ', json_object(
            's4_class', upper(t.s4_class),
            'table_name', t.table_name
            )
        ) AS sql_text
FROM vw_ai2_classrep_to_uploader_json t
ORDER BY table_name;


