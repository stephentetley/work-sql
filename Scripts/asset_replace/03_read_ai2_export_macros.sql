
-- Master data
CREATE OR REPLACE MACRO read_ai2_export_masterdata(xlsx_file) AS TABLE
SELECT 
    t."Reference" AS 'ai2_reference',
    t."Common Name" AS 'common_name',
    excel_text(t."Installed From" :: DOUBLE, 'dd.MM.yyyy').strptime('%d.%m.%Y') AS 'installed_from',
    t."Manufacturer" AS 'manufacturer',
    t."Model" AS 'model',
    t."Hierarchy Key" AS 'hierarchy_key',
    t."AssetStatus" AS 'asset_status',
    t."Loc.Ref." AS 'loc_ref',
    try_cast(t."Asset in AIDE ?" AS BOOLEAN) AS 'asset_in_aide',
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true) AS t;



-- EAV data (allows exports files to have different attribute sets)
CREATE OR REPLACE MACRO read_ai2_export_eavdata(xlsx_file) AS TABLE
WITH cte1 AS (
SELECT 
    t."Reference" AS 'ai2_reference',
    t.* EXCLUDE("AssetId", "Reference", "Common Name", "Installed From", "Manufacturer", "Model", "Hierarchy Key", "AssetStatus", "Loc.Ref.", "Asset in AIDE ?"),
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true) AS t
), cte2 AS (
    FROM cte1 UNPIVOT INCLUDE NULLS (
        attr_value FOR attr_name IN (COLUMNS(* EXCLUDE "ai2_reference"))
    )
)
SELECT * FROM cte2 ORDER BY attr_name;

