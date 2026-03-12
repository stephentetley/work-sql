.bail on

CREATE SCHEMA IF NOT EXISTS electrical_surveys;

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE OR REPLACE TEMPORARY MACRO norm_text(name VARCHAR) AS
    trim(name).regexp_replace('\s+', ' ', 'g');

CREATE OR REPLACE TEMPORARY MACRO nospace(name VARCHAR) AS
    trim(name).regexp_replace('\s+', '', 'g');
    
-- Something strange is happening with ctes, sheet glob and row_number...
-- Do the processing from a temporary table


CREATE OR REPLACE TEMPORARY MACRO read_motor_survey_sheet(file_name VARCHAR, sheet_name VARCHAR) AS TABLE (
SELECT
    row_number() OVER (PARTITION BY survey_file, sheet_name) AS row_num,
    norm_text(COLUMNS(*)),
FROM read_sheet(
    file_name,
    sheet=sheet_name,
    header=false,
    file_name_column='survey_file',
    sheet_name_column='sheet_name',
    columns={'*': 'varchar'},
    range='A1:G11'
    )
);

CREATE OR REPLACE TEMPORARY TABLE motor_surveys_landing (
    row_num INTEGER,
    survey_file VARCHAR,
    sheet_name VARCHAR,
    "A" VARCHAR,
    "B" VARCHAR,
    "C" VARCHAR,
    "D" VARCHAR,
    "E" VARCHAR,
    "F" VARCHAR,
    "G" VARCHAR,
    PRIMARY KEY (row_num, survey_file, sheet_name)
);

