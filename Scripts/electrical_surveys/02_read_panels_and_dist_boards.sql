
CREATE SCHEMA IF NOT EXISTS electrical_surveys;

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;


-- Setup the environment variable `ELECTRICAL_SURVEYS_GLOB_PATH` before running this file
SELECT getenv('ELECTRICAL_SURVEYS_GLOB_PATH') AS ELECTRICAL_SURVEYS_GLOB_PATH;

WITH cte1 AS (
SELECT
    row_number() OVER (PARTITION BY survey_file, sheet_name) AS row_num,
    *
FROM read_sheets(
    [getenv(ELECTRICAL_SURVEYS_GLOB_PATH)],
    sheets=['[A-Z][A-Z]-[0-9]*', '[A-Z][A-Z][A-Z]-[0-9]*'],
    header=false,
    file_name_column='survey_file',
    sheet_name_column='sheet_name',
    range='B2:K14'
    )
), cte2 AS (
    SELECT survey_file, sheet_name, FROM cte1
    GROUP BY survey_file, sheet_name
), cte3 AS (
    SELECT
        t.survey_file,
        t.sheet_name,
        t1."B" AS site,
        t1."E" AS distboard_or_panel_number,
        t2."F" AS location,
    FROM cte2 t
    LEFT JOIN cte1 t1 ON t1.survey_file = t.survey_file AND t1.sheet_name = t.sheet_name AND t1.row_num = 2
    LEFT JOIN cte1 t2 ON t2.survey_file = t.survey_file AND t2.sheet_name = t.sheet_name AND t2.row_num = 4
    -- LEFT JOIN cte1 t3 ON t3.survey_file = t.survey_file AND t3.sheet_name = t.sheet_name AND t3."B" = 'Section:'
    -- LEFT JOIN cte1 t4 ON t4.survey_file = t.survey_file AND t4.sheet_name = t.sheet_name AND t4."C" LIKE 'Motor%'
)
SELECT * FROM cte3
ORDER BY survey_file
;
