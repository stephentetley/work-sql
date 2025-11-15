CREATE SCHEMA IF NOT EXISTS s4_landing;

CREATE OR REPLACE MACRO read_delete_worklist(xlsx_file) AS TABLE
SELECT 
    t."S4 Equi Id" AS s4_equi_id,
    t."S4 Deleted Name" AS s4_deleted_name,
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=TRUE, sheet='Sheet1') AS t;



