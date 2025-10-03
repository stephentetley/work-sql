


-- non-equiclass tables


DELETE FROM s4_classrep.equi_masterdata;
INSERT OR REPLACE INTO s4_classrep.equi_masterdata BY NAME
SELECT 
    t1.equi_equi_id AS equipment_id,
    t1.s4_description AS equi_description,
    t1.s4_floc AS functional_location,
    t1.s4_superord_equi AS superord_id,
    t1.s4_category AS category,
    t1.s4_object_type AS object_type,
    udf_local.get_s4_asset_status(t.asset_status) AS display_user_status,
    udf_local.get_s4_asset_status(t.asset_status) AS status_of_an_object,
    TRY_CAST(t.installed_from AS DATE) AS startup_date,
    year(startup_date) AS construction_year,
    month(startup_date) AS construction_month,
    t.manufacturer AS manufacturer,
    t.model AS model_number,
    t.specific_model_frame AS manufact_part_number,
    t.serial_number AS serial_number,
    t.weight_kg AS gross_weight,
    IF(t.weight_kg IS NOT NULL, 'KG', null) AS unit_of_weight,
    t.pandi_tag AS technical_ident_number,
    t1.s4_position AS display_position,
    t1.s4_class catalog_profile,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference;
;


DELETE FROM s4_classrep.equi_east_north;
INSERT OR REPLACE INTO s4_classrep.equi_east_north BY NAME
SELECT 
    t1.equi_equi_id AS equipment_id,
    t2.easting AS easting,
    t2.northing AS northing,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference
CROSS JOIN udfx_db.udfx.get_east_north(t.grid_ref) t2
;

DELETE FROM s4_classrep.equi_asset_condition;
INSERT OR REPLACE INTO s4_classrep.equi_asset_condition BY NAME
SELECT 
    t1.equi_equi_id AS equipment_id,
    upper(t2.condition_grade) AS condition_grade,
    upper(t2.condition_grade_reason) AS condition_grade_reason,
    t2.survey_year AS survey_date,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference
LEFT JOIN ai2_classrep.equi_agasp t2 ON t2.ai2_reference = t.ai2_reference;


-- THIS IS SOURCE DATA SPECIFIC depends on `ai2_to_s4_mapping` table
DELETE FROM s4_classrep.equi_aib_reference;
INSERT OR REPLACE INTO s4_classrep.equi_aib_reference BY NAME 
(SELECT DISTINCT ON (t.ai2_reference)
    t1.equi_equi_id AS equipment_id,
    1 AS value_index,
    t.ai2_reference AS ai2_aib_reference,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference)
UNION
(SELECT DISTINCT ON (t.ai2_reference)
    t1.equi_equi_id AS equipment_id,
    2 AS value_index,
    t1.ai2_parent_reference AS ai2_aib_reference,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference);

-- THIS IS SOURCE DATA SPECIFIC depends on `ai2_to_s4_mapping` table

DELETE FROM s4_classrep.equi_solution_id;
INSERT OR REPLACE INTO s4_classrep.equi_solution_id BY NAME 
(SELECT DISTINCT ON (t.ai2_reference)
    t1.equi_equi_id AS equipment_id,
    1 AS value_index,
    t1.solution_id AS solution_id,
FROM ai2_classrep.equi_masterdata t
JOIN ai2_classrep.ai2_to_s4_mapping t1 ON t1.ai2_reference = t.ai2_reference);

-- Delete from equiclass tables before _any_ writes
-- An equiclass table may have more than one source

DELETE FROM s4_classrep.equiclass_lstnut;
DELETE FROM s4_classrep.equiclass_netwmb;
DELETE FROM s4_classrep.equiclass_netwmo;
DELETE FROM s4_classrep.equiclass_netwtl;
DELETE FROM s4_classrep.equiclass_podetu;
DELETE FROM s4_classrep.equiclass_valvfl;
DELETE FROM s4_classrep.equiclass_valvnr;

INSERT OR REPLACE INTO s4_classrep.equiclass_lstnut BY NAME
SELECT * FROM ultrasonic_level_instrument_to_lstnut();


INSERT OR REPLACE INTO s4_classrep.equiclass_netwmb BY NAME
SELECT * FROM network_to_netwmb();

INSERT OR REPLACE INTO s4_classrep.equiclass_netwmo BY NAME
SELECT * FROM modem_to_netwmo();


INSERT OR REPLACE INTO s4_classrep.equiclass_netwtl BY NAME
SELECT * FROM telemetry_outstation_to_netwtl();

INSERT OR REPLACE INTO s4_classrep.equiclass_podetu BY NAME
SELECT * FROM power_supply_to_podetu();

INSERT OR REPLACE INTO s4_classrep.equiclass_valvfl BY NAME
SELECT * FROM flap_valve_to_valvfl();

INSERT OR REPLACE INTO s4_classrep.equiclass_valvnr BY NAME
SELECT * FROM non_return_valve_to_valvnr();









