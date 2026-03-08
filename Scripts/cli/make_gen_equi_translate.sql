
-- no env vars

.bail on


ATTACH OR REPLACE DATABASE
    '~/_working/work/resources/ai2_classdefs/ai2_classdefs_db.duckdb'
AS ai2_classlists_db (READ_ONLY);


ATTACH OR REPLACE DATABASE
    '~/_working/work/resources/s4_classdefs/s4_classdefs_db.duckdb'
AS s4_classlists_db (READ_ONLY);

-- Create excel_uploader schema
.read '/home/stephen/_working/coding/work/work-sql/Scripts/gen_equi_translate/01_generate_ai2_equiclass_tables.sql'
COPY
    (SELECT sql_text FROM vw_ai2_classrep_tables_ddl)
TO '02o_create_ai2_equiclasses.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');


.read '/home/stephen/_working/coding/work/work-sql/Scripts/gen_equi_translate/02_generate_s4_equiclass_tables.sql'
COPY
    (SELECT sql_text FROM vw_s4_classrep_tables_ddl)
TO '04o_create_s4_equiclasses.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');


.read '/home/stephen/_working/coding/work/work-sql/Scripts/gen_equi_translate/03_generate_ai2_eav_to_ai2_classrep_statments.sql'
COPY
    (SELECT sql_text FROM vw_ai2_equi_to_classrep_ddl)
TO '08o_insert_into_ai2_equiclasses.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');


.read '/home/stephen/_working/coding/work/work-sql/Scripts/gen_equi_translate/04_generate_s4_equiclasses_to_excel_uploader.sql'
COPY
    (SELECT sql_text FROM vw_ai2_classrep_to_uploader_ddl)
TO '12o_s4_equiclasses_to_excel_uploader.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');
