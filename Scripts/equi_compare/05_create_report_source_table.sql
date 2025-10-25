CREATE OR REPLACE MACRO ai2_floc_part(pg_name, p_name) AS 
CASE 
    WHEN pg_name IS NULL AND p_name IS NULL THEN ''
    WHEN pg_name IS NULL THEN '<<__/' || p_name || '>>' 
    WHEN p_name IS NULL THEN '<<' || pg_name || '/__>>'
    ELSE '<<' || pg_name || '/' || p_name || '>>'
END;

CREATE OR REPLACE TABLE equi_compare.output_report_source_all AS
SELECT 
    coalesce(t1.s4_site, left(t2.funcloc, 5)) AS site,
    t1.inst_name AS ai2_inst_name,
    t2.s4_site_name AS s4_site_name,
    t2.funcloc AS s4_floc,
    ai2_floc_part(t1.process_group_name, t1.process_name) AS ai2_floc,
    t.s4_equi_id AS s4_equi_id,
    t.ai2_pli_num AS pli_num,
    t.equi_compare_status AS compare_status,
    t2.equi_name AS name_s4,
    t1.equi_name AS name_ai2,
    t2.standard_class AS s4_standard_class,
    replace(t3.equipment_type, 'EQUIPMENT: ', '') AS ai2_equipment_type,
    t2.startup_date AS install_date_s4,
    t3.install_date AS install_date_ai2,
    t2.asset_status AS status_s4,
    t3.status AS status_ai2,
    t2.manufacturer AS manufacturer_s4,
    t3.manufacturer AS manufacturer_ai2,
    t2.model AS model_s4,
    t3.model AS model_ai2,
    t2.specific_model AS specific_model_s4,
    t3.specific_model AS specific_model_ai2,
    t2.serial_number AS serial_number_s4,
    t3.serial_number AS serial_number_ai2,
    t2.pandi_tag AS pandi_tag_s4,
    t3.pandi_tag AS pandi_tag_ai2,
    t2.sai_num AS parent_ref_s4,
    t3.sai_num AS parent_ref_ai2,
FROM  equi_compare.vw_equi_compare_status t
LEFT JOIN equi_compare.vw_ai2_common_name_decoded t1 ON t1.pli_num = t.ai2_pli_num
LEFT JOIN equi_compare_landing.vw_ih08_equi_masterdata t2 ON t2.equi_id = t.s4_equi_id
LEFT JOIN equi_compare_landing.ai2_equi_masterdata t3 ON t3.pli_num = t.ai2_pli_num
;

