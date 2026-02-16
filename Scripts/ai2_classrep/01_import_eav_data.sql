.print 'Running 01_import_eav_data.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE SCHEMA IF NOT EXISTS ai2_eav;

CREATE OR REPLACE TABLE ai2_eav.worklist (
    ai2_reference VARCHAR NOT NULL,
    equipment_type VARCHAR,
    PRIMARY KEY(ai2_reference)
);

CREATE OR REPLACE TABLE ai2_eav.equipment_eav (
    ai2_reference VARCHAR,
    attr_name VARCHAR,
    attr_value VARCHAR
);




-- Worklist
SELECT getvariable('classrep_worklist_glob') AS classrep_worklist_glob;

INSERT OR REPLACE INTO ai2_eav.worklist
WITH cte1 AS (
    SELECT
        t."Reference" AS ai2_reference,
    FROM read_sheets([getvariable('classrep_worklist_glob')], columns={'Reference': 'VARCHAR'}) t
), cte2 AS (
    SELECT
        t.ai2_reference AS ai2_reference,
        t1.equi_type_name AS equipment_type,
    FROM cte1 t
    LEFT JOIN masterdata_db.masterdata.ai2_equipment t1 ON t1.pli_number = t.ai2_reference
)
SELECT * FROM cte2;

-- attributes
SELECT getvariable('ai2_attributes_glob') AS ai2_attributes_glob;

INSERT INTO ai2_eav.equipment_eav
WITH cte1 AS (
    SELECT
        t."Reference" AS ai2_reference,
        t.* EXCLUDE("AssetId", "Reference", "Common Name", "Installed From", "Manufacturer", "Model", "Hierarchy Key", "AssetStatus", "Asset in AIDE ?"),
    FROM read_sheets([getvariable('ai2_attributes_glob')], columns={'*': 'VARCHAR'}) t
), cte2 AS (
    FROM cte1 UNPIVOT INCLUDE NULLS (
        attr_value FOR attr_name IN (COLUMNS(* EXCLUDE "ai2_reference"))
    )
)
SELECT * FROM cte2 ORDER BY attr_name;



INSERT OR REPLACE INTO ai2_classrep.equi_extra_masterdata BY NAME
WITH cte AS (
    PIVOT ai2_eav.equipment_eav
    ON attr_name IN (
        'Weight kg',
	    'Specific Model/Frame',
	    'Serial No',
	    'Loc.Ref.',
	    'P AND I Tag No'
    )
    USING any_value(attr_value)
    GROUP BY ai2_reference
) 
SELECT 
    t.ai2_reference AS ai2_reference,
    t."Weight kg" AS weight_kg,
    t."Specific Model/Frame" AS specific_model_frame,
    t."Serial No" AS serial_number,
    t."Loc.Ref." AS grid_ref,
    t."P AND I Tag No" AS pandi_tag,
FROM cte t;


INSERT OR IGNORE INTO ai2_classrep.equi_agasp BY NAME
WITH cte AS (
    PIVOT ai2_eav.equipment_eav
    ON attr_name IN (
        'AGASP Comments',
        'AGASP Survey Year',
        'Condition Grade',
        'Condition Grade Reason',
        'Loading Factor',
        'Loading Factor Reason',
        'Performance Grade',
        'Performance Grade Reason',
    )
    USING any_value(attr_value)
    GROUP BY ai2_reference
) 
SELECT 
    t.ai2_reference AS ai2_reference,
    t."AGASP Comments" AS agasp_comments,
    t."AGASP Survey Year" AS agasp_survey_year,
    t."Condition Grade" AS condition_grade,
    t."Condition Grade Reason" AS condition_grade_reason,
    t."Loading Factor" AS loading_factor,
    t."Loading Factor Reason" AS loading_factor_reason,
    t."Performance Grade" AS performance_grade,
    t."Performance Grade Reason" AS performance_grade_reason,
FROM cte t;

INSERT OR IGNORE INTO ai2_classrep.equi_memo_line BY NAME
WITH cte AS (
    PIVOT ai2_eav.equipment_eav
    ON attr_name IN (
        'Memo Line 1',
        'Memo Line 2',
        'Memo Line 3',
        'Memo Line 4',
        'Memo Line 5',
    )
    USING any_value(attr_value)
    GROUP BY ai2_reference
) 
SELECT 
    t.ai2_reference AS ai2_reference,
    t."Memo Line 1" AS memo_line_1,
    t."Memo Line 2" AS memo_line_2,
    t."Memo Line 3" AS memo_line_3,
    t."Memo Line 4" AS memo_line_4,
    t."Memo Line 5" AS memo_line_5,
FROM cte t;



