
INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

INSTALL tera FROM community;
LOAD tera;

-- Setup the environment variable `SURVEY_SHEETS_GLOB_PATH` before running this file
SELECT getenv('SURVEY_SHEETS_GLOB_PATH') AS SURVEY_SHEETS_GLOB_PATH;

CREATE OR REPLACE TEMPORARY TABLE read_panel_or_dist_board_dml AS
WITH cte AS (
    SELECT
        file_name,
        sheet_name
    FROM analyze_sheets([getenv('SURVEY_SHEETS_GLOB_PATH')], sheets=['CP-*', 'DB-*', 'MCC-*', 'TX-*'])
    WHERE column_name = 'TEST SHEET'
)
SELECT
    tera_render(
        'INSERT OR REPLACE INTO panel_or_dist_board_surveys_landing BY NAME
            SELECT * FROM read_panel_or_dist_board_survey_sheet(''{{ file_name }}'', ''{{ sheet_name }}'');',
        json_object(
            'file_name', to_json(t.file_name),
            'sheet_name', to_json(t.sheet_name)
        ), autoescape := false
        ) AS sql_text
FROM cte t;

COPY
    (SELECT sql_text FROM read_panel_or_dist_board_dml)
TO '03o_insert_into_panel_surveys_landing.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');
