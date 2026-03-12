
INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

INSTALL tera FROM community;
LOAD tera;

-- Setup the environment variable `SURVEY_SHEETS_GLOB_PATH` before running this file
SELECT getenv('SURVEY_SHEETS_GLOB_PATH') AS SURVEY_SHEETS_GLOB_PATH;

CREATE OR REPLACE TEMPORARY TABLE read_motor_dml AS
WITH cte AS (
    SELECT
        file_name,
        sheet_name,
    FROM analyze_sheets(
        [getenv('SURVEY_SHEETS_GLOB_PATH')], 
        sheets=['Motor Checklist *']
        )
    GROUP BY file_name, sheet_name
)
SELECT
    tera_render(
        'INSERT OR REPLACE INTO motor_surveys_landing BY NAME
            SELECT * FROM read_motor_survey_sheet(''{{ file_name }}'', ''{{ sheet_name }}'');',
        json_object(
            'file_name', t.file_name,
            'sheet_name', t.sheet_name
        ), autoescape := false
        ) AS sql_text
FROM cte t;

COPY
    (SELECT sql_text FROM read_motor_dml)
TO '03o_insert_into_motor_surveys_landing.sql'
WITH (FORMAT csv, HEADER false, QUOTE '');
