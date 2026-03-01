.print 'Running 02_patch_s4_floc_exports.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;


CREATE SCHEMA IF NOT EXISTS masterdata_patch_landing;

.print 'masterdata_patch_landing.s4_flocs...'
SELECT getvariable('s4_ih06_globpath') AS s4_ih06_globpath;


CREATE OR REPLACE TABLE masterdata_patch_landing.s4_flocs AS
WITH cte AS (
    SELECT
        t.*,
    FROM read_sheets(
        [getvariable('s4_ih06_globpath')],
        sheets=['Sheet1'],
        error_as_null=true,
        nulls=['NULL']
    ) t
    ORDER BY t."Functional Location"
)
SELECT
    row_number() OVER () AS row_num,
    t.*
FROM cte t;

INSERT OR REPLACE INTO masterdata.s4_funcloc BY NAME
SELECT 
    t."Functional Location" AS functional_location,
    t."Description of functional location" AS funcloc_name,
    try_cast(t."FunctLocCategory" AS INTEGER) AS category,
    IF(t."Installation allowed" = 'X', true, false) AS installation_allowed, -- BOOLEAN
    t."Object Type" AS object_type,
    try_cast(t."Cost Center" AS INTEGER) AS cost_center,
    try_cast(t."Planning Plant" AS INTEGER) AS planning_plant,
    try_cast(t."Maintenance Plant" AS INTEGER) AS maintenance_plant,
    t."Main Work Center" AS maint_work_center,
    t."Plant Section" AS plant_section,
    try(strptime(t."Start-up date", '%Y-%m-%d')::DATE) AS startup_date,
    t."Structure indicator" AS structure_indicator,
    t."Superior functional location" AS superior_funcloc,
    t."User Status" AS user_status,
    try_cast(t."Company Code" AS INTEGER) AS company_code,
    try_cast(t."Address number" AS INTEGER) AS address_number,
FROM masterdata_patch_landing.s4_flocs t;