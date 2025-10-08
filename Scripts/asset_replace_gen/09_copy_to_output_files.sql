

COPY 
    (SELECT sql_text FROM ai2_classrep_tables_ddl) 
TO '/home/stephen/_working/coding/work/work-sql/Scripts/output/08g_ai2_classrep_create_equiclass_tables.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');



COPY 
    (SELECT sql_text FROM s4_classrep_tables_ddl) 
TO '/home/stephen/_working/coding/work/work-sql/Scripts/output/10g_s4_classrep_create_equiclass_tables.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');



COPY 
    (SELECT sql_text FROM ai2_eav_to_classrep_inserts) 
TO '/home/stephen/_working/coding/work/work-sql/Scripts/output/13g_data_copy_ai2_eav_to_classrep_equiclass.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');



COPY 
    (SELECT sql_text FROM delete_from_s4_classrep_tables) 
TO '/home/stephen/_working/coding/work/work-sql/Scripts/output/15g_delete_from_s4_classrep_tables.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');


COPY 
    (SELECT sql_text FROM insert_into_s4_classrep_tables) 
TO '/home/stephen/_working/coding/work/work-sql/Scripts/output/16g_insert_into_s4_classrep_tables.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');



COPY 
    (SELECT sql_text FROM s4_classrep_to_excel_uploader_chars) 
TO '/home/stephen/_working/coding/work/work-sql/Scripts/output/18g_data_copy_s4_classrep_to_excel_uploader_create_eavdata.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');




