
CREATE OR REPLACE TABLE electrical_surveys.distboard_or_panels AS
WITH cte1 AS (
    SELECT
        survey_file,
        sheet_name,
    FROM panel_or_dist_board_surveys_landing
    GROUP BY survey_file, sheet_name
), cte2 AS (
    SELECT
        t.survey_file,
        t.sheet_name,
        t1."B" AS site,
        t1."E" AS distboard_or_panel_number,
        t2."F" AS location,
        t3."B" AS equi_details,
        t4."C" AS fed_from1,
        t4."D" AS fed_from2,
        t4."E" AS fed_from3,
        t4."F" AS fed_from4,
        t4."G" AS fed_from5,
        t4."H" AS fed_from6,
        t4."I" AS fed_from7,
        t4."J" AS fed_from8,
        t4."K" AS fed_from9,
        t5."C" AS circuit_ref_and_phase1,
        t5."D" AS circuit_ref_and_phase2,
        t5."E" AS circuit_ref_and_phase3,
        t5."F" AS circuit_ref_and_phase4,
        t5."G" AS circuit_ref_and_phase5,
        t5."H" AS circuit_ref_and_phase6,
        t5."I" AS circuit_ref_and_phase7,
        t5."J" AS circuit_ref_and_phase8,
        t5."K" AS circuit_ref_and_phase9,
        t6."C" AS circuit_description1,
        t6."D" AS circuit_description2,
        t6."E" AS circuit_description3,
        t6."F" AS circuit_description4,
        t6."G" AS circuit_description5,
        t6."H" AS circuit_description6,
        t6."I" AS circuit_description7,
        t6."J" AS circuit_description8,
        t6."K" AS circuit_description9,
        t7."C" AS circuit_load1,
        t7."D" AS circuit_load2,
        t7."E" AS circuit_load3,
        t7."F" AS circuit_load4,
        t7."G" AS circuit_load5,
        t7."H" AS circuit_load6,
        t7."I" AS circuit_load7,
        t7."J" AS circuit_load8,
        t7."K" AS circuit_load9,
    FROM cte1 t
    LEFT JOIN panel_or_dist_board_surveys_landing t1 ON t1.survey_file = t.survey_file AND t1.sheet_name = t.sheet_name AND t1.row_num = 3
    LEFT JOIN panel_or_dist_board_surveys_landing t2 ON t2.survey_file = t.survey_file AND t2.sheet_name = t.sheet_name AND t2.row_num = 5
    LEFT JOIN panel_or_dist_board_surveys_landing t3 ON t3.survey_file = t.survey_file AND t3.sheet_name = t.sheet_name AND t3.row_num = 7
    LEFT JOIN panel_or_dist_board_surveys_landing t4 ON t4.survey_file = t.survey_file AND t4.sheet_name = t.sheet_name AND t4.row_num = 11
    LEFT JOIN panel_or_dist_board_surveys_landing t5 ON t5.survey_file = t.survey_file AND t5.sheet_name = t.sheet_name AND t5.row_num = 12
    LEFT JOIN panel_or_dist_board_surveys_landing t6 ON t6.survey_file = t.survey_file AND t6.sheet_name = t.sheet_name AND t6.row_num = 13
    LEFT JOIN panel_or_dist_board_surveys_landing t7 ON t7.survey_file = t.survey_file AND t7.sheet_name = t.sheet_name AND t7.row_num = 34
), cte_ans1 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        1 AS item_number,
        t.site,
        t.distboard_or_panel_number,
        t.location,
        t.equi_details,
        t.fed_from1 AS fed_from,
        t.circuit_ref_and_phase1 AS circuit_ref_and_phase,
        t.circuit_description1 AS circuit_description,
        t.circuit_load1 AS circuit_load,
    FROM cte2 t
    WHERE t.fed_from1 IS NOT NULL
), cte_ans2 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        2 AS item_number,
        t.site,
        t.distboard_or_panel_number,
        t.location,
        t.equi_details,
        t.fed_from2 AS fed_from,
        t.circuit_ref_and_phase2 AS circuit_ref_and_phase,
        t.circuit_description2 AS circuit_description,
        t.circuit_load2 AS circuit_load,
    FROM cte2 t
    WHERE t.fed_from2 IS NOT NULL
), cte_ans3 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        3 AS item_number,
        t.site,
        t.distboard_or_panel_number,
        t.location,
        t.equi_details,
        t.fed_from3 AS fed_from,
        t.circuit_ref_and_phase3 AS circuit_ref_and_phase,
        t.circuit_description3 AS circuit_description,
        t.circuit_load3 AS circuit_load,
    FROM cte2 t
    WHERE t.fed_from3 IS NOT NULL
), cte_ans4 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        4 AS item_number,
        t.site,
        t.distboard_or_panel_number,
        t.location,
        t.equi_details,
        t.fed_from4 AS fed_from,
        t.circuit_ref_and_phase4 AS circuit_ref_and_phase,
        t.circuit_description4 AS circuit_description,
        t.circuit_load4 AS circuit_load,
    FROM cte2 t
    WHERE t.fed_from4 IS NOT NULL
), cte_ans5 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        5 AS item_number,
        t.site,
        t.distboard_or_panel_number,
        t.location,
        t.equi_details,
        t.fed_from5 AS fed_from,
        t.circuit_ref_and_phase5 AS circuit_ref_and_phase,
        t.circuit_description5 AS circuit_description,
        t.circuit_load5 AS circuit_load,
    FROM cte2 t
    WHERE t.fed_from5 IS NOT NULL
), cte_ans6 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        6 AS item_number,
        t.site,
        t.distboard_or_panel_number,
        t.location,
        t.equi_details,
        t.fed_from6 AS fed_from,
        t.circuit_ref_and_phase6 AS circuit_ref_and_phase,
        t.circuit_description6 AS circuit_description,
        t.circuit_load6 AS circuit_load,
    FROM cte2 t
    WHERE t.fed_from6 IS NOT NULL
), cte_ans7 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        7 AS item_number,
        t.site,
        t.distboard_or_panel_number,
        t.location,
        t.equi_details,
        t.fed_from7 AS fed_from,
        t.circuit_ref_and_phase7 AS circuit_ref_and_phase,
        t.circuit_description7 AS circuit_description,
        t.circuit_load7 AS circuit_load,
    FROM cte2 t
    WHERE t.fed_from7 IS NOT NULL
), cte_ans8 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        8 AS item_number,
        t.site,
        t.distboard_or_panel_number,
        t.location,
        t.equi_details,
        t.fed_from8 AS fed_from,
        t.circuit_ref_and_phase8 AS circuit_ref_and_phase,
        t.circuit_description8 AS circuit_description,
        t.circuit_load8 AS circuit_load,
    FROM cte2 t
    WHERE t.fed_from8 IS NOT NULL
), cte_ans9 AS (
   SELECT
        t.survey_file,
        t.sheet_name,
        9 AS item_number,
        t.site,
        t.distboard_or_panel_number,
        t.location,
        t.equi_details,
        t.fed_from9 AS fed_from,
        t.circuit_ref_and_phase9 AS circuit_ref_and_phase,
        t.circuit_description9 AS circuit_description,
        t.circuit_load9 AS circuit_load,
    FROM cte2 t
    WHERE t.fed_from9 IS NOT NULL
)
SELECT * FROM cte_ans1
UNION BY NAME
SELECT * FROM cte_ans2
UNION BY NAME
SELECT * FROM cte_ans3
UNION BY NAME
SELECT * FROM cte_ans4
UNION BY NAME
SELECT * FROM cte_ans5
UNION BY NAME
SELECT * FROM cte_ans6
UNION BY NAME
SELECT * FROM cte_ans7
UNION BY NAME
SELECT * FROM cte_ans8
UNION BY NAME
SELECT * FROM cte_ans9
ORDER BY survey_file, sheet_name, item_number;

