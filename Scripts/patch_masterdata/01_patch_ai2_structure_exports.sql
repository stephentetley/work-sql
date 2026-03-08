.print 'Running 01_patch_ai2_structure_exports.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE OR REPLACE TEMPORARY MACRO getenv_with_default(varname VARCHAR, default_value VARCHAR) AS
    IF(getenv(varname) = '', default_value, getenv(varname));

CREATE SCHEMA IF NOT EXISTS masterdata_patch_landing;


CREATE TABLE masterdata_patch_landing.ai2_structure (
    row_num INTEGER NOT NULL,
    ai2_reference VARCHAR,
    common_name VARCHAR,
    installed_from_date TIMESTAMP,
    manufacturer VARCHAR,
    model VARCHAR,
    user_status VARCHAR,
    PRIMARY KEY (row_num)
);


.print 'masterdata_patch_landing.ai2_structure...'

SELECT getenv('AI2_STRUCTURE_PATCHES_GLOBPATH') AS AI2_STRUCTURE_PATCHES_GLOBPATH;


-- Read from an empty ih06 export (with required columns) if 
-- `IH06_PATCHES_GLOBPATH` is blank 
-- 
INSERT OR REPLACE INTO masterdata_patch_landing.ai2_structure BY NAME
WITH cte AS (
    SELECT
        t.*,
    FROM read_sheets(
        [getenv_with_default('AI2_STRUCTURE_PATCHES_GLOBPATH',
            '/home/stephen/_working/work/resources/patch_masterdata/empty_ai2_structure_patch.xlsx')],
        sheets=['Sheet1'],
        error_as_null=true,
        nulls=['NULL'],
        columns={'Installed From': 'timestamp', 'AGASP Survey Year': 'integer', 'Weight kg': 'double'}
    ) t
    ORDER BY t."Common Name"
)
SELECT
    row_number() OVER () AS row_num,
    t."Reference" AS ai2_reference,
    replace(t."Common Name", 'EQPT:', 'EQUIPMENT:') AS common_name,
    t."Installed From" AS installed_from_date,
    t."Manufacturer" AS manufacturer,
    t."Model" AS model,
    t."AssetStatus" as user_status,
FROM cte t;

CREATE OR REPLACE TABLE masterdata_patch_landing.ai2_new_equipment AS
WITH cte_parent AS (
    SELECT
        t.common_name AS common_name,
        max(t1.common_name) AS parent_common_name,
    FROM masterdata_patch_landing.ai2_structure t
    LEFT JOIN masterdata_patch_landing.ai2_structure t1 ON starts_with(t.common_name, t1.common_name) AND t.common_name != t1.common_name
    GROUP BY t.common_name
), cte_site AS (
    SELECT
        t.common_name AS common_name,
        min(t1.common_name) AS site,
    FROM masterdata_patch_landing.ai2_structure t
    LEFT JOIN masterdata_patch_landing.ai2_structure t1 ON starts_with(t.common_name, t1.common_name) AND length(t1.common_name) > 0
    GROUP BY t.common_name
), cte_equipment AS (
    SELECT
        t1.ai2_reference AS pli_number,
        replace(t4.common_name, t4.parent_common_name || '/', '') AS equipment_name,
        replace(t.common_name, t.parent_common_name || '/', '') AS equi_type_name,
        -- Do we need this have to use classlists if we do...
        NULL AS equi_type_code,
        t1.installed_from_date AS installed_from_date,
        t1.manufacturer AS manufacturer,
        t1.model AS model,
        t1.user_status AS user_status,
        t.common_name AS common_name,
        t.parent_common_name AS parent_common_name,
        t4.parent_common_name AS grand_parent_common_name,
        t2.site AS site_or_installation_name,
        t3.ai2_reference AS sai_number,
    FROM cte_parent t
    JOIN masterdata_patch_landing.ai2_structure t1 ON t1.common_name = t.common_name
    LEFT JOIN cte_site t2 ON t2.common_name = t.common_name
    LEFT JOIN masterdata_patch_landing.ai2_structure t3 ON t3.common_name = t.parent_common_name
    LEFT JOIN cte_parent t4 ON t4.common_name = t.parent_common_name
    WHERE  t1.ai2_reference LIKE 'PLI%'
)
SELECT
    t.* EXCLUDE(parent_common_name, grand_parent_common_name),
    t1.pli_number AS superequi_id,
FROM cte_equipment t
LEFT JOIN cte_equipment t1 ON t.grand_parent_common_name = t1.parent_common_name
ORDER BY t.common_name;

INSERT OR REPLACE INTO masterdata.ai2_equipment BY NAME
SELECT * FROM masterdata_patch_landing.ai2_new_equipment;