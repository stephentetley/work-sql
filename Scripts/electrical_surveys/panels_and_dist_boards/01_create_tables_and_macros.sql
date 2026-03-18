.print 'Running 01_create_tables_and_macros.sql...'

.bail on

CREATE SCHEMA IF NOT EXISTS electrical_surveys;


CREATE OR REPLACE TABLE electrical_surveys.distboard_or_panels (
    survey_file VARCHAR NOT NULL,
    sheet_name VARCHAR NOT NULL,
    item_number INTEGER,
    site VARCHAR,
    db_or_panel_num VARCHAR,
    sheet_num_of VARCHAR,
    aib_ref VARCHAR,
    location VARCHAR,
    equi_details VARCHAR,
    fed_from VARCHAR,
    circuit_ref_and_phase VARCHAR,
    circuit_description VARCHAR,
    circuit_load VARCHAR
);

CREATE OR REPLACE VIEW electrical_surveys.vw_distboard_or_panels_with_resolved_item_number AS
WITH cte AS (
    SELECT 
        t.*,
        regexp_extract(t.sheet_num_of, '(\d*)\s?[Oo][Ff]\s?', 1) AS __sheet_number,
        try_cast(__sheet_number AS INTEGER) AS resolved_sheet_number,
        ((resolved_sheet_number - 1) * 9) + t.item_number AS resolved_item_number,
    FROM electrical_surveys.distboard_or_panels t
) SELECT COLUMNS(lambda c: c NOT LIKE '$_$_%' ESCAPE '$') FROM cte;



CREATE OR REPLACE VIEW electrical_surveys.vw_panel_parent_child AS
WITH cte1 AS (
    SELECT
        t.site,
        t.aib_ref,
        t.db_or_panel_num,
        t.resolved_item_number AS item_num,
        t.location,
        t.circuit_description,
    FROM electrical_surveys.vw_distboard_or_panels_with_resolved_item_number t
), cte_panel_nums AS (
    SELECT
        t.site,
        t.db_or_panel_num,
        t.item_num,
    FROM cte1 t
    GROUP BY ALL
), cte_splits AS (
    SELECT
        t.site,
        t.db_or_panel_num,
        t.item_num,
        regexp_split_to_table(t.circuit_description, '\s+') AS identifier_or_word,
    FROM cte1 t
), cte_parent_and_child_panels AS (
    SELECT
        t.site,
        t.db_or_panel_num,
        t.identifier_or_word AS child_panel,
        t.item_num,
    FROM cte_splits t
    SEMI JOIN cte_panel_nums t1 ON t1.site = t.site AND t1.db_or_panel_num = t.identifier_or_word
), cte_no_parent AS (
    SELECT
        t.site,
        t.db_or_panel_num AS top_panel_num,
        0 AS item_num,
    FROM cte_parent_and_child_panels t
    ANTI JOIN cte_parent_and_child_panels t1 ON t1.site = t.site AND t1.child_panel = t.db_or_panel_num
    GROUP BY ALL
), cte_no_child AS (
    SELECT
        t.site,
        t.child_panel AS end_panel_num,
        t.item_num,
    FROM cte_parent_and_child_panels t
    ANTI JOIN cte_parent_and_child_panels t1 ON t1.site = t.site AND t1.db_or_panel_num = t.child_panel
    GROUP BY ALL
)
SELECT t.site, NULL AS this_item, t.item_num AS item_num, t.top_panel_num AS child_item FROM cte_no_parent t
UNION ALL BY NAME
SELECT t.site, t.db_or_panel_num AS this_item, t.item_num AS item_num, t.child_panel AS child_item FROM cte_parent_and_child_panels t
UNION ALL BY NAME
SELECT t.site, t.end_panel_num AS this_item, t.item_num AS item_num, NULL AS child_item FROM cte_no_child t;


INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE OR REPLACE TEMPORARY MACRO norm_text(name VARCHAR) AS
    trim(name).regexp_replace('\s+', ' ', 'g');


-- Something strange is happening with ctes, sheet glob and row_number...
-- Do the processing from a temporary table


CREATE OR REPLACE TEMPORARY MACRO read_panel_or_dist_board_survey_sheet(file_name VARCHAR, sheet_name VARCHAR) AS TABLE (
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
    range='A1:K35'
    )
);

CREATE OR REPLACE TEMPORARY TABLE panel_or_dist_board_surveys_landing (
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
    "H" VARCHAR,
    "I" VARCHAR,
    "J" VARCHAR,
    "K" VARCHAR,
    PRIMARY KEY (row_num, survey_file, sheet_name)
);

