
-- Setup the following environment variables:
-- `SURVEY_SHEETS_GLOB_PATH`
-- before running this file (e.g in a makefile)

-- Note - this generates and executes a .sql file it the directory the user runs the script from

.read '/home/stephen/_working/coding/work/work-sql/Scripts/electrical_surveys/panels_and_dist_boards/01_create_tables_and_macros.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/electrical_surveys/panels_and_dist_boards/02_gen_read_panel_inserts.sql'

-- local generated file...
.read '03o_insert_into_panel_surveys_landing.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/electrical_surveys/panels_and_dist_boards/04_transform_landing_data.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/electrical_surveys/panels_and_dist_boards/05_make_path_table.sql'
