





CREATE OR REPLACE TABLE ai2_landing.worklist AS
SELECT 
    *
FROM read_equi_replace_worklist(
    '/home/stephen/_working/work/2025/telemetry_october/netwtl_assetrep_worklist.xlsx'
);


CREATE OR REPLACE TABLE ai2_landing.masterdata AS
SELECT 
    *
FROM read_ai2_export_masterdata(
    '/home/stephen/_working/work/2025/telemetry_october/ai2_netwtl_export.xlsx'
);

-- use `UNION` to concat multiple files... 
CREATE OR REPLACE TABLE ai2_landing.eavdata AS
(SELECT 
    *
FROM read_ai2_export_eavdata(
    '/home/stephen/_working/work/2025/telemetry_october/ai2_netwtl_export.xlsx'
    )
)
--UNION 
--(SELECT 
--    *
--FROM read_ai2_export_eavdata(
--    '/home/stephen/_working/work/2025/equi_translation/bol10/bol10_ai2_valv_eavdata.xlsx'
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





