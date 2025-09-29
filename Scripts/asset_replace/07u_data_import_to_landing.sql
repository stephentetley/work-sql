


CREATE SCHEMA IF NOT EXISTS ai2_landing;


CREATE OR REPLACE TABLE ai2_landing.worklist AS
SELECT 
    t.*
FROM read_xlsx(
    '/home/stephen/_working/work/2025/equi_translation/dra05/dra05_equi_assetrep_worklist.xlsx', 
    all_varchar=true) AS t;


CREATE OR REPLACE TABLE ai2_landing.masterdata AS
SELECT 
    *
FROM read_ai2_export_masterdata(
    '/home/stephen/_working/work/2025/equi_translation/dra05/ai2_equi_masterdata_export.xlsx'
);

-- use `UNION` to concat multiple files... 
CREATE OR REPLACE TABLE ai2_landing.eavdata AS
(SELECT 
    *
FROM read_ai2_export_eavdata(
    '/home/stephen/_working/work/2025/equi_translation/dra05/ai2_equi_masterdata_export.xlsx'
    )
)
--UNION 
--(SELECT 
--    *
--FROM read_ai2_export_eavdata(
--    '/home/stephen/_working/work/2025/lstnut_sweco_aug/batch2/ai2_export_batch2_2.xlsx'
--    )
--)
--UNION 
--(SELECT 
--    *
--FROM read_ai2_export_eavdata(
--    '/home/stephen/_working/work/2025/lstnut_sweco_aug/batch2/ai2_export_batch2_3.xlsx'
--    )
--)
--UNION 
--(SELECT 
--    *
--FROM read_ai2_export_eavdata(
--    '/home/stephen/_working/work/2025/lstnut_sweco_aug/batch2/ai2_export_batch2_4.xlsx'
--    )
--)
;





