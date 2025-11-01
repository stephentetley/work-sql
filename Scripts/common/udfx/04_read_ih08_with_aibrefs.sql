
-- This returns a single row per equipment with "AI2 AIB Reference"
-- aggregated into a list and "S/4 AIB Reference" dropped 
CREATE  OR REPLACE MACRO udfx.read_ih08_with_aibrefs(xlsx_path) AS TABLE 
WITH cte1 AS (    
    SELECT 
        * EXCLUDE("Selected Line", "Class AIB_REFERENCE is assigned"),
    FROM 
        read_xlsx(xlsx_path::VARCHAR)
), cte2 AS (
    SELECT 
        * EXCLUDE ("AI2 AIB Reference", "S/4 AIB Reference"),
        list("AI2 AIB Reference") as ai2_refs,
    FROM cte1
    GROUP BY ALL
)
SELECT * FROM cte2;



-- Use this macro to unnest the list of aib refs in a table produced by
-- `read_ih08_with_aibrefs` 
CREATE OR REPLACE MACRO udfx.ih08_get_ai2_refs(table_name) AS TABLE
SELECT 
    "Equipment" as equipment, 
    unnest(ai2_refs) AS ai2_ref,
FROM query_table(table_name);