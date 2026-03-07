.print 'Running 02_patch_s4_floc_exports.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE OR REPLACE TEMPORARY MACRO getenv_with_default(varname VARCHAR, default_value VARCHAR) AS
    IF(getenv(varname) = '', default_value, getenv(varname));


CREATE SCHEMA IF NOT EXISTS masterdata_patch_landing;
CREATE TABLE masterdata_patch_landing.s4_flocs (
    "Functional Location" VARCHAR,
    "Description of functional location" VARCHAR,
    "FunctLocCategory" VARCHAR,
    "Installation allowed" VARCHAR,
    "Object Type" VARCHAR,
    "Cost Center" VARCHAR,
    "Planning Plant" VARCHAR,
    "Maintenance Plant" VARCHAR,
    "Main Work Center" VARCHAR,
    "Plant Section" VARCHAR,
    "Start-up date" VARCHAR,
    "Structure indicator" VARCHAR,
    "Superior functional location" VARCHAR,
    "User Status" VARCHAR,
    "Company Code" VARCHAR,
    "Address number" VARCHAR,
    PRIMARY KEY ("Functional Location")
);


.print 'masterdata_patch_landing.s4_flocs...'

-- Setup the environment variable `S4_IH06_PATCHES_GLOBPATH` before running this file
SELECT getenv('S4_IH06_PATCHES_GLOBPATH') AS S4_IH06_PATCHES_GLOBPATH;


-- Read from an empty ih06 export (with needed columns) if 
-- `S4_IH06_PATCHES_GLOBPATH` is blank 
-- 
INSERT OR REPLACE INTO masterdata_patch_landing.s4_flocs BY NAME
WITH cte AS (
    SELECT
        t."Functional Location",
        t."Description of functional location",
        t."FunctLocCategory",
        t."Installation allowed",
        t."Object Type",
        t."Cost Center",
        t."Planning Plant",
        t."Maintenance Plant",
        t."Main Work Center",
        t."Plant Section",
        t."Start-up date",
        t."Structure indicator",
        t."Superior functional location",
        t."User Status",
        t."Company Code",
        t."Address number",
    FROM read_sheets(
        [getenv_with_default('S4_IH06_PATCHES_GLOBPATH', 
                                '/home/stephen/_working/work/resources/patch_masterdata/empty_ih06_floc_patch.xlsx')],
        sheets=['Sheet1'],
        error_as_null=true,
        nulls=['NULL'],
        columns={'*': 'varchar'}
    ) t
    ORDER BY t."Functional Location"
)
SELECT
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

