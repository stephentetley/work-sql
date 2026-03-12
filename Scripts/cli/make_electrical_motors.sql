
-- Setup the following environment variables:
-- `SURVEY_SHEETS_GLOB_PATH`
-- before running this file (e.g in a makefile)

-- Note - this generates and executes a .sql file it the directory the user runs the script from

.read '/home/stephen/_working/coding/work/work-sql/Scripts/electrical_surveys/motors/01_create_tables_and_macros.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/electrical_surveys/motors/02_gen_read_motor_inserts.sql'
.read '03o_insert_into_motor_surveys_landing.sql'
.read '/home/stephen/_working/coding/work/work-sql/Scripts/electrical_surveys/motors/04_transform_landing_data.sql'
