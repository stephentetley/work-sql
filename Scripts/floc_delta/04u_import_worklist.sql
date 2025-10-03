-- Keep this simple - it is a template...


CREATE OR REPLACE TABLE floc_delta_landing.worklist AS
SELECT * FROM read_floc_delta_worklist(
    '/home/stephen/_working/work/2025/floc_delta/bol10/BOL10_floc_delta_worklist.xlsx'
);


CREATE OR REPLACE TABLE floc_delta_landing.ih06_floc_exports AS
-- Use UNION if reading more than one IH06 export...
SELECT * FROM read_ih06_export(
    '/home/stephen/_working/work/2025/floc_delta/bol10/bol10_ih06_flocs_with_east_north.xlsx'
);