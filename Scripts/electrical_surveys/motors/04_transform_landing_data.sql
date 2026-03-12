
CREATE OR REPLACE TABLE electrical_surveys.motors AS
WITH cte1 AS (
    SELECT
        survey_file,
        sheet_name,
    FROM motor_surveys_landing
    GROUP BY survey_file, sheet_name
), cte2 AS (
    SELECT
        t.survey_file,
        t.sheet_name,
        t1."C" AS aib_ref,
        t2."C" AS site,
        t3."C" AS location,
        nospace(t4."C").string_split_regex(',') AS section_arr,
        t5."D" AS item1,
        t5."E" AS item2,
        t5."F" AS item3,
        t5."G" AS item4,
    FROM cte1 t
    LEFT JOIN motor_surveys_landing t1 ON t1.survey_file = t.survey_file AND t1.sheet_name = t.sheet_name AND t1.row_num = 2
    LEFT JOIN motor_surveys_landing t2 ON t2.survey_file = t.survey_file AND t2.sheet_name = t.sheet_name AND t2.row_num = 3
    LEFT JOIN motor_surveys_landing t3 ON t3.survey_file = t.survey_file AND t3.sheet_name = t.sheet_name AND t3.row_num = 4
    LEFT JOIN motor_surveys_landing t4 ON t4.survey_file = t.survey_file AND t4.sheet_name = t.sheet_name AND t4.row_num = 5
    LEFT JOIN motor_surveys_landing t5 ON t5.survey_file = t.survey_file AND t5.sheet_name = t.sheet_name AND t5.row_num = 11
), cte_ans1 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        t.aib_ref,
        t.site,
        t.location,
        try(list_extract(section_arr, 1)) AS section,
        t.item1 AS item,
    FROM cte2 t
    WHERE t.item1 IS NOT NULL
), cte_ans2 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        t.aib_ref,
        t.site,
        t.location,
        try(list_extract(section_arr, 2)) AS section,
        t.item2 AS item,
    FROM cte2 t
    WHERE t.item2 IS NOT NULL
), cte_ans3 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        t.aib_ref,
        t.site,
        t.location,
        try(list_extract(section_arr, 3)) AS section,
        t.item3 AS item,
    FROM cte2 t
    WHERE t.item3 IS NOT NULL
), cte_ans4 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        t.aib_ref,
        t.site,
        t.location,
        try(list_extract(section_arr, 4)) AS section,
        t.item4 AS item,
    FROM cte2 t
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