
CREATE SCHEMA IF NOT EXISTS electrical_surveys;

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;


CREATE OR REPLACE TEMPORARY MACRO norm_name(name VARCHAR) AS
    trim(name).regexp_replace('\s+', ' ', 'g');

CREATE OR REPLACE TEMPORARY MACRO nospace(name VARCHAR) AS
    trim(name).regexp_replace('\s+', '', 'g');

-- Setup the environment variable `ELECTRICAL_SURVEYS_GLOB_PATH` before running this file
SELECT getenv('ELECTRICAL_SURVEYS_GLOB_PATH') AS ELECTRICAL_SURVEYS_GLOB_PATH;

CREATE OR REPLACE TABLE electrical_surveys.motors AS
WITH cte1 AS (
SELECT
    row_number() OVER (PARTITION BY survey_file, sheet_name) AS row_num,
    try_cast(regexp_extract(sheet_name, '\d+') AS INTEGER) AS sheet_num,
    *
FROM read_sheets(
    [getenv(ELECTRICAL_SURVEYS_GLOB_PATH)],
    sheets=['Motor Checklist*'],
    header=false,
    file_name_column='survey_file',
    sheet_name_column='sheet_name',
    range='B2:G11'
    )
), cte2 AS (
    SELECT survey_file, sheet_name, sheet_num FROM cte1
    GROUP BY survey_file, sheet_name, sheet_num
), cte3 AS (
    SELECT
        t.survey_file,
        t.sheet_name,
        t1."C" AS site,
        t2."C" AS location,
        nospace(t3."C").string_split_regex(',') AS section_arr,
        norm_name(t4."D") AS item1,
        norm_name(t4."E") AS item2,
        norm_name(t4."F") AS item3,
        norm_name(t4."G") AS item4,
    FROM cte2 t
    LEFT JOIN cte1 t1 ON t1.survey_file = t.survey_file AND t1.sheet_name = t.sheet_name AND t1."B" = 'Site:'
    LEFT JOIN cte1 t2 ON t2.survey_file = t.survey_file AND t2.sheet_name = t.sheet_name AND t2."B" = 'Location:'
    LEFT JOIN cte1 t3 ON t3.survey_file = t.survey_file AND t3.sheet_name = t.sheet_name AND t3."B" = 'Section:'
    LEFT JOIN cte1 t4 ON t4.survey_file = t.survey_file AND t4.sheet_name = t.sheet_name AND t4."C" LIKE 'Motor%'
), cte_ans1 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        t.site,
        t.location,
        try(list_extract(section_arr, 1)) AS section,
        t.item1 AS item,
    FROM cte3 t
    WHERE t.item1 IS NOT NULL
), cte_ans2 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        t.site,
        t.location,
        try(list_extract(section_arr, 2)) AS section,
        t.item2 AS item,
    FROM cte3 t
    WHERE t.item2 IS NOT NULL
), cte_ans3 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        t.site,
        t.location,
        try(list_extract(section_arr, 3)) AS section,
        t.item3 AS item,
    FROM cte3 t
    WHERE t.item3 IS NOT NULL
), cte_ans4 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        t.site,
        t.location,
        try(list_extract(section_arr, 4)) AS section,
        t.item4 AS item,
    FROM cte3 t
    WHERE t.item4 IS NOT NULL
)
SELECT * FROM cte_ans1
UNION BY NAME
SELECT * FROM cte_ans2
UNION BY NAME
SELECT * FROM cte_ans3
UNION BY NAME
SELECT * FROM cte_ans4
ORDER BY survey_file, sheet_name
;
