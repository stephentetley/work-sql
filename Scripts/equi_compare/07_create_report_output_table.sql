CREATE OR REPLACE TEMPORARY MACRO pp_compare_status(cstatus) AS 
CASE 
    WHEN cstatus = 'in_both'::compare_status THEN 'In both'
    WHEN cstatus = 'no_pli_aib_ref'::compare_status THEN 'Missing AIB pli reference'
    WHEN cstatus = 'not_in_ai2_extract'::compare_status THEN 'Not in AI2 data extract'
    WHEN cstatus = 'not_in_s4_extract'::compare_status THEN 'Not in S4 data extract'
    ELSE 'Unknown'
END;

CREATE OR REPLACE TEMPORARY MACRO compare_dates(s4_date, ai2_date) AS 
CASE 
    WHEN s4_date IS NULL AND ai2_date IS NULL THEN {'short': '*', 's4': null, 'ai2': null}
    WHEN s4_date IS NULL THEN {'short': 'D', 's4': null, 'ai2': strftime(ai2_date, '%d.%m.%Y')}
    WHEN ai2_date IS NULL THEN {'short': 'D', 's4': strftime(s4_date, '%d.%m.%Y'), 'ai2': null}
    WHEN ai2_date::DATE = s4_date::DATE THEN {'short': '*', 's4': strftime(s4_date, '%d.%m.%Y'), 'ai2': '**'}
    ELSE {'short': 'D', 's4': strftime(s4_date, '%d.%m.%Y'), 'ai2': strftime(ai2_date, '%d.%m.%Y')}
END;

CREATE OR REPLACE TEMPORARY MACRO compare_status(s4_status, ai2_status) AS 
CASE 
    WHEN s4_status IS NULL AND ai2_status IS NULL THEN {'short': '*', 's4': null, 'ai2': null}
    WHEN s4_status IS NULL THEN {'short': 'S', 's4': null, 'ai2': ai2_status}
    WHEN ai2_status IS NULL THEN {'short': 'S', 's4': s4_status, 'ai2': null}
    WHEN s4_status LIKE 'OPER%' AND ai2_status = 'OPERATIONAL' THEN {'short': '*', 's4': s4_status, 'ai2': '**'}
    WHEN s4_status LIKE 'NOP%' AND ai2_status = 'NON OPERATIONAL' THEN {'short': '*', 's4': s4_status, 'ai2': '**'}
    WHEN s4_status LIKE 'DCOM%' AND ai2_status = 'DECOMMISSIONED' THEN {'short': '*', 's4': s4_status, 'ai2': '**'}
    WHEN s4_status LIKE 'OOS%' AND ai2_status = 'OUT OF SERVICE' THEN {'short': '*', 's4': s4_status, 'ai2': '**'}
    WHEN s4_status LIKE 'DISP%' AND ai2_status = 'DISPOSED OF' THEN {'short': '*', 's4': s4_status, 'ai2': '**'}
    WHEN s4_status LIKE 'TBCM%' AND ai2_status = 'TO BE COMMISSIONED' THEN {'short': '*', 's4': s4_status, 'ai2': '**'}
    ELSE {'short': 'S', 's4': s4_status, 'ai2': ai2_status}
END;


CREATE OR REPLACE TEMPORARY MACRO compare_manufacturer(s4_manuf, ai2_manuf) AS 
CASE 
    WHEN s4_manuf IS NULL AND ai2_manuf IS NULL THEN {'short': '*', 's4': null, 'ai2': null}
    WHEN s4_manuf IS NULL THEN {'short': 'M', 's4': null, 'ai2': ai2_manuf}
    WHEN ai2_manuf IS NULL THEN {'short': 'M', 's4': s4_manuf, 'ai2': null}
    WHEN s4_manuf = ai2_manuf THEN {'short': '*', 's4': s4_manuf, 'ai2': '**'}
    ELSE {'short': 'M', 's4': s4_manuf, 'ai2': ai2_manuf}
END;

CREATE OR REPLACE TEMPORARY MACRO compare_model(s4_model, ai2_model) AS 
CASE 
    WHEN s4_model IS NULL AND ai2_model IS NULL THEN {'short': '*', 's4': null, 'ai2': null}
    WHEN s4_model IS NULL THEN {'short': 'M', 's4': null, 'ai2': ai2_model}
    WHEN ai2_model IS NULL THEN {'short': 'M', 's4': s4_model, 'ai2': null}
    WHEN s4_model = ai2_model THEN {'short': '*', 's4': s4_model, 'ai2': '**'}
    ELSE {'short': 'M', 's4': s4_model, 'ai2': ai2_model}
END;

CREATE OR REPLACE TEMPORARY MACRO compare_specific_model(s4_specific_model, ai2_specific_model) AS 
CASE 
    WHEN s4_specific_model IS NULL AND ai2_specific_model IS NULL THEN {'short': '*', 's4': null, 'ai2': null}
    WHEN s4_specific_model IS NULL THEN {'short': 'S', 's4': null, 'ai2': ai2_specific_model}
    WHEN ai2_specific_model IS NULL THEN {'short': 'S', 's4': s4_specific_model, 'ai2': null}
    WHEN s4_specific_model = ai2_specific_model THEN {'short': '*', 's4': s4_specific_model, 'ai2': '**'}
    ELSE {'short': 'S', 's4': s4_specific_model, 'ai2': ai2_specific_model}
END;

CREATE OR REPLACE TEMPORARY MACRO norm_serial_number(serial_number) AS
    regexp_replace(serial_number, '[[:^alnum:]]', '', 'g').regexp_replace('0+' , '')
;


CREATE OR REPLACE TEMPORARY MACRO compare_serial_number(s4_serial_number, ai2_serial_number) AS 
CASE 
    WHEN s4_serial_number IS NULL AND ai2_serial_number IS NULL THEN {'short': '*', 's4': null, 'ai2': null}
    WHEN s4_serial_number IS NULL THEN {'short': 'S', 's4': null, 'ai2': ai2_serial_number}
    WHEN ai2_serial_number IS NULL THEN {'short': 'S', 's4': s4_serial_number, 'ai2': null}
    WHEN norm_serial_number(s4_serial_number) = norm_serial_number(ai2_serial_number) THEN {'short': '*', 's4': s4_serial_number, 'ai2': '**'}
    ELSE {'short': 'S', 's4': s4_serial_number, 'ai2': ai2_serial_number}
END;

CREATE OR REPLACE TEMPORARY MACRO norm_pandi_tag(serial_number) AS
    regexp_replace(serial_number, '[[:^alnum:]]', '', 'g')
;

CREATE OR REPLACE TEMPORARY MACRO compare_pandi_tag(s4_pandi_tag, ai2_pandi_tag) AS 
CASE 
    WHEN s4_pandi_tag IS NULL AND ai2_pandi_tag IS NULL THEN {'short': '*', 's4': null, 'ai2': null}
    WHEN s4_pandi_tag IS NULL THEN {'short': 'P', 's4': null, 'ai2': ai2_pandi_tag}
    WHEN ai2_pandi_tag IS NULL THEN {'short': 'P', 's4': s4_pandi_tag, 'ai2': null}
    WHEN norm_pandi_tag(s4_pandi_tag) = norm_pandi_tag(ai2_pandi_tag) THEN {'short': '*', 's4': s4_pandi_tag, 'ai2': '**'}
    ELSE {'short': 'P', 's4': s4_pandi_tag, 'ai2': ai2_pandi_tag}
END;

CREATE OR REPLACE TEMPORARY MACRO compare_parent_ref(s4_parent_ref, ai2_parent_ref) AS 
CASE 
    WHEN s4_parent_ref IS NULL AND ai2_parent_ref IS NULL THEN {'short': '*', 's4': null, 'ai2': null}
    WHEN s4_parent_ref IS NULL THEN {'short': 'P', 's4': null, 'ai2': ai2_parent_ref}
    WHEN ai2_parent_ref IS NULL THEN {'short': 'P', 's4': s4_parent_ref, 'ai2': null}
    WHEN s4_parent_ref = ai2_parent_ref THEN {'short': '*', 's4': s4_parent_ref, 'ai2': '**'}
    ELSE {'short': 'P', 's4': s4_parent_ref, 'ai2': ai2_parent_ref}
END;

CREATE OR REPLACE TEMPORARY MACRO diff_count_of(summary) AS
    len(regexp_replace(summary::VARCHAR, '[[:^alnum:]]', '', 'g'))
;

CREATE OR REPLACE TABLE equi_compare.output_report AS
WITH cte AS (
    SELECT 
        t.site AS site_code,
        coalesce(t.ai2_inst_name, t.s4_site_name) AS site_name,
        coalesce(t.s4_floc, t.ai2_floc) AS floc,
        t.s4_equi_id AS s4_equi_id,
        t.pli_num AS pli_num, 
        t.name_s4 AS name_s4,
        t.name_ai2 AS name_ai2, 
        pp_compare_status(t.compare_status) AS compare_status,
        t.s4_standard_class AS s4_standard_class,
        t.ai2_equipment_type AS ai2_equipment_type,
        compare_dates(t.install_date_s4, t.install_date_ai2) AS __ans_date,
        struct_extract(__ans_date, 's4') AS install_date_s4,
        struct_extract(__ans_date, 'ai2') AS install_date_ai2,
        compare_status(t.status_s4, t.status_ai2) AS __ans_status,
        struct_extract(__ans_status, 's4') AS status_s4,
        struct_extract(__ans_status, 'ai2') AS status_ai2, 
        compare_manufacturer(t.manufacturer_s4, t.manufacturer_ai2) AS __ans_manufacturer,
        struct_extract(__ans_manufacturer, 's4') AS manufacturer_s4,
        struct_extract(__ans_manufacturer, 'ai2') AS manufacturer_ai2,   
        compare_model(t.model_s4, t.model_ai2) AS __ans_model,
        struct_extract(__ans_model, 's4') AS model_s4,
        struct_extract(__ans_model, 'ai2') AS model_ai2,
        compare_specific_model(t.specific_model_s4, t.specific_model_ai2) AS __ans_specific_model,
        struct_extract(__ans_specific_model, 's4') AS specific_model_s4,
        struct_extract(__ans_specific_model, 'ai2') AS specific_model_ai2,
        compare_serial_number(t.serial_number_s4, t.serial_number_ai2) AS __ans_serial_number,
        struct_extract(__ans_serial_number, 's4') AS serial_number_s4,
        struct_extract(__ans_serial_number, 'ai2') AS serial_number_ai2,
        compare_pandi_tag(t.pandi_tag_s4, t.pandi_tag_ai2) AS __ans_pandi_tag,
        struct_extract(__ans_pandi_tag, 's4') AS pandi_tag_s4,
        struct_extract(__ans_pandi_tag, 'ai2') AS pandi_tag_ai2,
        compare_parent_ref(t.parent_ref_s4, t.parent_ref_ai2) AS __ans_parent_ref,
        struct_extract(__ans_parent_ref, 's4') AS parent_ref_s4,
        struct_extract(__ans_parent_ref, 'ai2') AS parent_ref_ai2,
        concat(
            struct_extract(__ans_date, 'short'),
            struct_extract(__ans_status, 'short'),
            struct_extract(__ans_manufacturer, 'short'),
            struct_extract(__ans_model, 'short'),
            struct_extract(__ans_specific_model, 'short'),
            struct_extract(__ans_serial_number, 'short'),
            struct_extract(__ans_pandi_tag, 'short'),
            struct_extract(__ans_parent_ref, 'short') 
        ) AS diff_summary,
        diff_count_of(diff_summary) AS diff_count,
    FROM equi_compare.output_report_source_all t
) 
SELECT 
    site_code,
    site_name,
    floc,
    s4_equi_id,
    pli_num,
    name_s4,
    name_ai2,
    compare_status,
    diff_summary,
    diff_count,
    s4_standard_class,
    ai2_equipment_type,
    install_date_s4,
    install_date_ai2,
    status_s4,
    status_ai2,
    manufacturer_s4,
    manufacturer_ai2,
    model_s4,
    model_ai2,
    specific_model_s4,
    specific_model_ai2,
    serial_number_s4,
    serial_number_ai2,
    pandi_tag_s4,
    pandi_tag_ai2,
    parent_ref_s4,
    parent_ref_ai2,
FROM cte
ORDER BY site_name, floc;


    