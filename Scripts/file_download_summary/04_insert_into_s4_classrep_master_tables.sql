DELETE FROM s4_classrep.floc_masterdata;
DELETE FROM s4_classrep.equi_masterdata;
DELETE FROM s4_classrep.floc_aib_reference;
DELETE FROM s4_classrep.equi_aib_reference;
DELETE FROM s4_classrep.equi_asset_condition;
DELETE FROM s4_classrep.floc_solution_id;
DELETE FROM s4_classrep.equi_solution_id;
DELETE FROM s4_classrep.floc_east_north;
DELETE FROM s4_classrep.equi_east_north;

DELETE FROM s4_classrep.equishape_cfbm;
DELETE FROM s4_classrep.equishape_cobm;


INSERT OR REPLACE INTO s4_classrep.floc_masterdata BY NAME
SELECT 
    t."FUNCLOC" AS funcloc_id,
    IF(starts_with(t."FUNCLOC", '$'), t."FLOC_REF", t."FUNCLOC") AS functional_location,
    t."RBNR_FLOC" AS catalog_profile,
    t."FLTYP"::VARCHAR AS category,
    t."BUKRSFLOC" AS company_code,
    t."BAUMM" AS construction_month,
    t."BAUJJ" AS construction_year,
    t."KOKR_FLOC" controlling_area,
    t."KOST_FLOC" AS cost_center,
    t."TXTMI" AS floc_description,
    t."POSNR" AS display_position,
    IF(t."IEQUI" = 'X', true, false) AS installation_allowed,
    t."FLOC_REF" AS internal_floc_ref,
    t."STOR_FLOC" AS floc_location,
    t."SWERK_FL" AS maintenance_plant, 
    t."GEWRKFLOC" AS maint_work_center,
    t."EQART" AS object_type,
    t."JOBJN_FL" AS object_number,
    t."PLNT_FLOC" AS planning_plant,
    t."BEBER_FL" AS plant_section,
    t."INBDT" AS startup_date,
    t."TPLKZ_FLC" AS structure_indicator,
    t."TPLMA" AS superior_funct_loc,
    t."USTW_FLOC" AS status_of_an_object,
    t."USTA_FLOC" AS display_user_status,
    t."ARBPLFLOC" AS work_center,
    t."ADRNR" AS address_ref,
FROM file_download_landing.funcloc t;


INSERT OR REPLACE INTO s4_classrep.equi_masterdata BY NAME
SELECT 
    t."EQUI" AS equipment_id,
    t."RBNR_EEQZ" AS catalog_profile,
    t."EQTYP" AS category,
    t."BUKR_EILO" AS company_code,
    t."BAUMM_EQI" AS construction_month,
    t."BAUJJ" AS construction_year,
    t."KOKR_EILO" AS controlling_area,
    t."KOST_EILO" AS cost_center,
    t."TXTMI" AS equi_description,
    t."HEQN_EEQZ" AS display_position,
    t."TPLN_EILO" AS functional_location,
    t."BRGEW" AS gross_weight,
    t."STOR_EILO" AS equi_location,
    t."ARBP_EEQZ" AS maint_work_center,
    t."SWER_EILO" AS maintenance_plant,
    t."SERGE" AS serial_number,
    t."MAPA_EEQZ" AS manufact_part_number,
    t."HERST" AS manufacturer,
    t."TYPBZ" AS model_number,
    t."EQART_EQU" AS object_type,
    t."PPLA_EEQZ" AS planning_plant,
    t."BEBE_EILO" AS plant_section,
    t."INBDT" AS startup_date,
    t."HEQU_EEQZ" AS superord_id,
    t."USTW_EQUI" AS status_of_an_object,
    t."TIDN_EEQZ" AS technical_ident_number,
    t."GEWEI" AS unit_of_weight,
    t."USTA_EQUI" AS display_user_status,
    t."DATA_EEQZ" AS valid_from,
    t."ARBP_EILO" AS work_center,
    t."ADRNR" AS address_ref,
FROM file_download_landing.equi t;



---- ## AIB_REFERENCE (floc)

INSERT OR REPLACE INTO s4_classrep.floc_aib_reference BY NAME
SELECT DISTINCT ON (funcloc_id, value_index)
    t.funcloc AS funcloc_id,
    t.valcnt AS value_index,
    t.atwrt AS ai2_aib_reference
FROM file_download_landing.valuafloc t
WHERE t.charid = 'AI2_AIB_REFERENCE'
AND ai2_aib_reference IS NOT NULL;

---- ## AIB_REFERENCE (equi)

INSERT OR REPLACE INTO s4_classrep.equi_aib_reference BY NAME
SELECT DISTINCT ON (equipment_id, value_index)
    t.equi AS equipment_id,
    t.valcnt AS value_index,
    t.atwrt AS ai2_aib_reference
FROM file_download_landing.valuaequi t
WHERE t.charid = 'AI2_AIB_REFERENCE'
AND ai2_aib_reference IS NOT NULL;

---- ## ASSET_CONDITION


---- Don't add empty records so use a cte for filtering
INSERT OR REPLACE INTO s4_classrep.equi_asset_condition BY NAME
WITH cte1 AS (
    PIVOT file_download_landing.valuaequi
    ON "CHARID" IN (
        'CONDITION_GRADE',
        'CONDITION_GRADE_REASON',
    )
    USING any_value("ATWRT")
    GROUP BY "EQUI"
), cte2 AS (
    PIVOT file_download_landing.valuaequi
    ON "CHARID" IN (
        'SURVEY_DATE'
    )
    USING any_value("ATFLV")
    GROUP BY "EQUI"
), cte3 AS (
SELECT 
    t."EQUI" AS equipment_id,
    t."CONDITION_GRADE" AS condition_grade,
    t."CONDITION_GRADE_REASON" AS condition_grade_reason,
    t1."SURVEY_DATE" AS survey_date,
FROM cte1 t
JOIN cte2 t1 ON t1."EQUI" = t."EQUI"
)
SELECT 
    * 
FROM cte3
WHERE coalesce(condition_grade, condition_grade_reason, survey_date::VARCHAR) IS NOT NULL;


---- ## EAST_NORTH 

INSERT OR REPLACE INTO s4_classrep.floc_east_north BY NAME
WITH cte AS (
    PIVOT file_download_landing.valuafloc
    ON "CHARID" IN (
        'EASTING',
        'NORTHING',
    )
    USING any_value("ATFLV")
    GROUP BY "FUNCLOC"
)
SELECT 
    "FUNCLOC" AS funcloc_id,
    "EASTING" AS easting,
    "NORTHING" AS northing,
FROM cte;


INSERT OR REPLACE INTO s4_classrep.equi_east_north BY NAME
WITH cte AS (
    PIVOT file_download_landing.valuaequi
    ON "CHARID" IN (
        'EASTING',
        'NORTHING',
    )
    USING any_value("ATFLV")
    GROUP BY "EQUI"
)
SELECT 
    "EQUI" AS equipment_id,
    "EASTING" AS easting,
    "NORTHING" AS northing,
FROM cte;


---- ## SOLUTION_ID

INSERT INTO s4_classrep.floc_solution_id BY NAME
SELECT DISTINCT ON (funcloc_id, value_index)
    t.funcloc AS funcloc_id,
    t.valcnt AS value_index,
    t.atwrt AS solution_id
FROM file_download_landing.valuafloc t
WHERE t.charid = 'SOLUTION_ID'
AND solution_id IS NOT NULL;


INSERT INTO s4_classrep.equi_solution_id BY NAME
SELECT DISTINCT ON (equipment_id, value_index)
    t.equi AS equipment_id,
    t.valcnt AS value_index,
    t.atwrt AS solution_id
FROM file_download_landing.valuaequi t
WHERE t.charid = 'SOLUTION_ID'
AND solution_id IS NOT NULL;


---- ## Equi shape classes

INSERT INTO s4_classrep.equishape_cfbm BY NAME
WITH cte1 AS (
    PIVOT file_download_landing.valuaequi
    ON "CHARID" IN (
        'CAPACITY_M3',
        'TOP_SURFACE_AREA_M2',
        'WORKING_VOLUME_M3',
    )
    USING any_value("ATWRT")
    GROUP BY "EQUI"
), cte2 AS (
    PIVOT file_download_landing.valuaequi
    ON "CHARID" IN (
        'SIDE_DEPTH_MM',
        'DAIMETER_MM',    
    )
    USING any_value("ATFLV")
    GROUP BY "EQUI"
), cte3 AS (
SELECT 
    t."EQUI" AS equipment_id,
    t."CAPACITY_M3"::DECIMAL AS capacity_m3,
    t."TOP_SURFACE_AREA_M2"::DECIMAL AS top_surface_area_m2,
    t."WORKING_VOLUME_M3"::DECIMAL AS working_volume_m3,
    t1."SIDE_DEPTH_MM" AS side_depth_mm,
    t1."DAIMETER_MM" AS diameter_mm,
FROM cte1 t
JOIN cte2 t1 ON t1."EQUI" = t."EQUI"
)
SELECT 
    t.* 
FROM cte3 t
SEMI JOIN file_download_landing.classequi t1 ON (t1.equi = t.equipment_id) AND t1."CLASS" = 'SHCFBM';


INSERT INTO s4_classrep.equishape_cobm BY NAME
WITH cte1 AS (
    PIVOT file_download_landing.valuaequi
    ON "CHARID" IN (
        'CAPACITY_M3',
        'WORKING_VOLUME_M3',
    )
    USING any_value("ATWRT")
    GROUP BY "EQUI"
), cte2 AS (
    PIVOT file_download_landing.valuaequi
    ON "CHARID" IN (
        'CENTRE_DEPTH_MM',
        'DIAMETER_MM', 
        'SIDE_DEPTH_MM',
    )
    USING any_value("ATFLV")
    GROUP BY "EQUI"
), cte3 AS (
SELECT 
    t."EQUI" AS equipment_id,
    t."CAPACITY_M3"::DECIMAL AS capacity_m3,
    t."WORKING_VOLUME_M3"::DECIMAL AS working_volume_m3,
    t1."SIDE_DEPTH_MM" AS side_depth_mm,
    t1."CENTRE_DEPTH_MM" AS centre_depth_mm,
    t1."DIAMETER_MM" AS diameter_mm,
FROM cte1 t
JOIN cte2 t1 ON t1."EQUI" = t."EQUI"
)
SELECT 
    t.* 
FROM cte3 t
SEMI JOIN file_download_landing.classequi t1 ON (t1.equi = t.equipment_id) AND t1."CLASS" = 'SHCOBM';



--INSERT INTO s4_classrep.equishape_ecyl BY NAME
--SELECT DISTINCT ON(t.equipment_id)
--    t.equipment_id AS equipment_id,
--    any_value(CASE WHEN t2.charid = 'CAPACITY_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS capacity_m3,
--    any_value(CASE WHEN t2.charid = 'LENGTH_MM' THEN t2.atflv ELSE NULL END) AS length_mm,
--    any_value(CASE WHEN t2.charid = 'MAJOR_AXIS' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS major_axis_mm,
--    any_value(CASE WHEN t2.charid = 'MINOR_AXIS' THEN t2.atflv ELSE NULL END) AS minor_axis_mm,
--    any_value(CASE WHEN t2.charid = 'WORKING_VOLUME_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS working_volume_m3,
--FROM s4_classrep.equi_masterdata t
--SEMI JOIN file_download_landing.classequi t1 ON (t1.equi = t.equipment_id) AND t1.classname = 'SHECYL'
--JOIN file_download_landing.valuaequi t2 ON t2.equi = t.equipment_id
--GROUP BY equipment_id;
--
--INSERT INTO s4_classrep.equishape_hcyl BY NAME
--SELECT DISTINCT ON(t.equipment_id)
--    t.equipment_id AS equipment_id,
--    any_value(CASE WHEN t2.charid = 'CAPACITY_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS capacity_m3,
--    any_value(CASE WHEN t2.charid = 'DIAMETER_MM' THEN t2.atflv ELSE NULL END) AS diameter_mm,
--    any_value(CASE WHEN t2.charid = 'LENGTH_MM' THEN t2.atflv ELSE NULL END) AS length_mm,
--    any_value(CASE WHEN t2.charid = 'WORKING_VOLUME_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS working_volume_m3,
--FROM s4_classrep.equi_masterdata t
--SEMI JOIN file_download_landing.classequi t1 ON (t1.equi = t.equipment_id) AND t1.classname = 'SHHCYL'
--JOIN file_download_landing.valuaequi t2 ON t2.equi = t.equipment_id
--GROUP BY equipment_id;
--
--INSERT INTO s4_classrep.equishape_miir BY NAME
--SELECT DISTINCT ON(t.equipment_id)
--    t.equipment_id AS equipment_id,
--    any_value(CASE WHEN t2.charid = 'CAPACITY_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS capacity_m3,
--    any_value(CASE WHEN t2.charid = 'CENTRE_DEPTH_MM' THEN t2.atflv ELSE NULL END) AS centre_depth_mm,
--    any_value(CASE WHEN t2.charid = 'DIAMETER_MM' THEN t2.atflv ELSE NULL END) AS diameter_mm,
--    any_value(CASE WHEN t2.charid = 'LENGTH_MM' THEN t2.atflv ELSE NULL END) AS length_mm,
--    any_value(CASE WHEN t2.charid = 'SIDE_DEPTH_MM' THEN t2.atflv ELSE NULL END) AS side_depth_mm,
--    any_value(CASE WHEN t2.charid = 'SIDE_DEPTH_MAX_MM' THEN t2.atflv ELSE NULL END) AS side_depth_max_mm,
--    any_value(CASE WHEN t2.charid = 'SIDE_DEPTH_MIN_MM' THEN t2.atflv ELSE NULL END) AS side_depth_min_mm,
--    any_value(CASE WHEN t2.charid = 'TOP_SURFACE_AREA_M2' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS top_surface_area_m2,
--    any_value(CASE WHEN t2.charid = 'WIDTH_MM' THEN t2.atflv ELSE NULL END) AS width_mm,
--    any_value(CASE WHEN t2.charid = 'WORKING_VOLUME_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS working_volume_m3,
--FROM s4_classrep.equi_masterdata t
--SEMI JOIN file_download_landing.classequi t1 ON (t1.equi = t.equipment_id) AND t1.classname = 'SHMIIR'
--JOIN file_download_landing.valuaequi t2 ON t2.equi = t.equipment_id
--GROUP BY equipment_id;
--
--INSERT INTO s4_classrep.equishape_rfbm BY NAME
--SELECT DISTINCT ON(t.equipment_id)
--    t.equipment_id AS equipment_id,
--    any_value(CASE WHEN t2.charid = 'CAPACITY_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS capacity_m3,
--    any_value(CASE WHEN t2.charid = 'LENGTH_MM' THEN t2.atflv ELSE NULL END) AS length_mm,
--    any_value(CASE WHEN t2.charid = 'SIDE_DEPTH_MM' THEN t2.atflv ELSE NULL END) AS side_depth_mm,
--    any_value(CASE WHEN t2.charid = 'TOP_SURFACE_AREA_M2' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS top_surface_area_m2,
--    any_value(CASE WHEN t2.charid = 'WIDTH_MM' THEN t2.atflv ELSE NULL END) AS width_mm,
--    any_value(CASE WHEN t2.charid = 'WORKING_VOLUME_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS working_volume_m3,
--FROM s4_classrep.equi_masterdata t
--SEMI JOIN file_download_landing.classequi t1 ON (t1.equi = t.equipment_id) AND t1.classname = 'SHRFBM'
--JOIN file_download_landing.valuaequi t2 ON t2.equi = t.equipment_id
--GROUP BY equipment_id;
--
--INSERT INTO s4_classrep.equishape_rpbm BY NAME
--SELECT DISTINCT ON(t.equipment_id)
--    t.equipment_id AS equipment_id,
--    any_value(CASE WHEN t2.charid = 'CAPACITY_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS capacity_m3,
--    any_value(CASE WHEN t2.charid = 'CENTRE_DEPTH_MM' THEN t2.atflv ELSE NULL END) AS centre_depth_mm,
--    any_value(CASE WHEN t2.charid = 'LENGTH_MM' THEN t2.atflv ELSE NULL END) AS length_mm,
--    any_value(CASE WHEN t2.charid = 'SIDE_DEPTH_MM' THEN t2.atflv ELSE NULL END) AS side_depth_mm,
--    any_value(CASE WHEN t2.charid = 'WIDTH_MM' THEN t2.atflv ELSE NULL END) AS width_mm,
--    any_value(CASE WHEN t2.charid = 'WORKING_VOLUME_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS working_volume_m3,
--FROM s4_classrep.equi_masterdata t
--SEMI JOIN file_download_landing.classequi t1 ON (t1.equi = t.equipment_id) AND t1.classname = 'SHRPBM'
--JOIN file_download_landing.valuaequi t2 ON t2.equi = t.equipment_id
--GROUP BY equipment_id;
--
--INSERT INTO s4_classrep.equishape_rsbm BY NAME
--SELECT DISTINCT ON(t.equipment_id)
--    t.equipment_id AS equipment_id,
--    any_value(CASE WHEN t2.charid = 'CAPACITY_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS capacity_m3,
--    any_value(CASE WHEN t2.charid = 'LENGTH_MM' THEN t2.atflv ELSE NULL END) AS length_mm,
--    any_value(CASE WHEN t2.charid = 'SIDE_DEPTH_MAX_MM' THEN t2.atflv ELSE NULL END) AS side_depth_max_mm,
--    any_value(CASE WHEN t2.charid = 'SIDE_DEPTH_MIN_MM' THEN t2.atflv ELSE NULL END) AS side_depth_min_mm,
--    any_value(CASE WHEN t2.charid = 'TOP_SURFACE_AREA_M2' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS top_surface_area_m2,
--    any_value(CASE WHEN t2.charid = 'WIDTH_MM' THEN t2.atflv ELSE NULL END) AS width_mm,
--    any_value(CASE WHEN t2.charid = 'WORKING_VOLUME_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS working_volume_m3,
--FROM s4_classrep.equi_masterdata t
--SEMI JOIN file_download_landing.classequi t1 ON (t1.equi = t.equipment_id) AND t1.classname = 'SHRSBM'
--JOIN file_download_landing.valuaequi t2 ON t2.equi = t.equipment_id
--GROUP BY equipment_id;
--
--INSERT INTO s4_classrep.equishape_scyl BY NAME
--SELECT DISTINCT ON(t.equipment_id)
--    t.equipment_id AS equipment_id,
--    any_value(CASE WHEN t2.charid = 'CAPACITY_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS capacity_m3,
--    any_value(CASE WHEN t2.charid = 'DIAMETER_MM' THEN t2.atflv ELSE NULL END) AS diameter_mm,
--    any_value(CASE WHEN t2.charid = 'SIDE_DEPTH_MM' THEN t2.atflv ELSE NULL END) AS side_depth_mm,
--    any_value(CASE WHEN t2.charid = 'WORKING_VOLUME_M3' THEN TRY_CAST(t2.atwrt AS DECIMAL) ELSE NULL END) AS working_volume_m3,
--FROM s4_classrep.equi_masterdata t
--SEMI JOIN file_download_landing.classequi t1 ON (t1.equi = t.equipment_id) AND t1.classname = 'SHSCYL'
--JOIN file_download_landing.valuaequi t2 ON t2.equi = t.equipment_id
--GROUP BY equipment_id;
