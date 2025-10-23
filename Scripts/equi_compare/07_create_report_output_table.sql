CREATE OR REPLACE MACRO pp_compare_status(cstatus) AS 
CASE 
    WHEN cstatus = 'in_both'::compare_status THEN 'In both'
    WHEN cstatus = 'no_pli_aib_ref'::compare_status THEN 'Missing AIB pli reference'
    WHEN cstatus = 'not_in_ai2_extract'::compare_status THEN 'Not in AI2 data extract'
    WHEN cstatus = 'not_in_s4_extract'::compare_status THEN 'Not in S4 data extract'
    ELSE 'Unknown'
END;

CREATE OR REPLACE MACRO compare_dates(s4_date, ai2_date) AS 
CASE 
    WHEN s4_date IS NULL THEN {'s4': null, 'ai2': strftime(ai2_date, '%d.%m.%Y')}
    WHEN ai2_date IS NULL THEN {'s4': strftime(s4_date, '%d.%m.%Y'), 'ai2': null}
    WHEN ai2_date::DATE = s4_date::DATE THEN {'s4': strftime(s4_date, '%d.%m.%Y'), 'ai2': '**'}
    ELSE {'s4': strftime(s4_date, '%d.%m.%Y'), 'ai2': strftime(ai2_date, '%d.%m.%Y')}
END;


CREATE OR REPLACE TABLE equi_compare.output_report AS
SELECT 
    t.site AS site_code,
    coalesce(t.ai2_inst_name, t.s4_site_name) AS site_name,
    coalesce(t.s4_floc, t.ai2_floc) AS floc,
    t.s4_equi_id AS s4_equi_id,
    t.pli_num AS pli_num, 
    t.name_s4 AS name_s4,
    t.name_ai2 AS name_ai2, 
    pp_compare_status(t.compare_status) AS compare_status,
    null AS diff_summary,
    null AS diff_count,
    t.s4_standard_class AS s4_standard_class,
    t.ai2_equipment_type AS ai2_equipment_type,
    compare_dates(t.install_date_s4, t.install_date_ai2) AS __date_ans,
    struct_extract(__date_ans, 's4') AS install_date_s4,
    struct_extract(__date_ans, 'ai2') AS install_date_ai2,
    t.status_s4 AS status_s4,
    t.status_ai2 AS status_ai2,    
FROM equi_compare.output_report_source_all t;

SELECT * FROM equi_compare.output_report 
ORDER BY site_code;
    