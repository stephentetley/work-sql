
CREATE OR REPLACE TABLE s4_landing.equidelete_worklist AS
SELECT * 
FROM read_delete_worklist(
    '/home/stephen/_working/work/2025/equi_delete/working/equidelete_worklist.xlsx'
);



