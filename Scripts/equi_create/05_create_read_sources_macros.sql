
-- Worklist
CREATE OR REPLACE MACRO read_equi_replace_worklist(xlsx_file) AS TABLE
SELECT 
    t."Operational AI2 record (PLI)" AS operational_AI2_record_pli,
    TRY_CAST(t."Batch" AS INTEGER) AS batch,
    t."Equipment Transit ID" AS equi_equi_id,
    t."AI2 Parent (SAI number)" AS ai2_parent_sai,
    t."S4 Category" AS s4_category,
    t."S4 Object Type" AS s4_object_type,
    t."S4 Class" AS s4_class,
    t."S4 Name" AS s4_name,
    t."S4 Floc" AS s4_floc,
    t."S4 Superord Equipment" AS s4_superord_equi,
    t."S4 Position" AS s4_position,
    t."Solution ID" AS solution_id,
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true, sheet='Worklist') AS t;

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

