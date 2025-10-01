


CREATE SCHEMA IF NOT EXISTS ai2_landing;


CREATE OR REPLACE TABLE ai2_landing.worklist AS
SELECT 
    *
FROM read_equi_replace_worklist(
    '/home/stephen/_working/work/2025/equi_translation/stonvalv/flapvalve_equi_assetrep_worklist.xlsx'
);


CREATE OR REPLACE TABLE ai2_landing.masterdata AS
SELECT 
    *
FROM read_ai2_export_masterdata(
    '/home/stephen/_working/work/2025/equi_translation/stonvalv/ai2_masterdata_new_valves.xlsx'
);

-- use `UNION` to concat multiple files... 
CREATE OR REPLACE TABLE ai2_landing.eavdata AS
(SELECT 
    *
FROM read_ai2_export_eavdata(
    '/home/stephen/_working/work/2025/equi_translation/stonvalv/ai2_masterdata_new_valves.xlsx'
    )
)
UNION 
(SELECT 
    *
FROM read_ai2_export_eavdata(
    '/home/stephen/_working/work/2025/equi_translation/stonvalv/ai2_eavdata_new_valves.xlsx'
    )
)
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





