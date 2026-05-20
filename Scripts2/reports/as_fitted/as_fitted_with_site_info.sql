.print 'join with ai2 floc wide table for site names...'



-- Setup the environment variable `AS_FITTED_TEST_SHEETS` before running this file
SELECT getenv('AS_FITTED_TEST_SHEETS') AS AS_FITTED_TEST_SHEETS;

create or replace table as_fitted_cicuits as
select * from read_parquet(getenv('AS_FITTED_TEST_SHEETS'));

-- Setup the environment variable `AI2_FLOC_WIDE_TABLE` before running this file
SELECT getenv('AI2_FLOC_WIDE_TABLE') AS AI2_FLOC_WIDE_TABLE;

create or replace table ai2_flocs as
select * from read_parquet(getenv('AI2_FLOC_WIDE_TABLE'));


create or replace temporary macro clean_aib_ref(str varchar) as
    regexp_replace(str, '\s+', '', 'g');

-- create or replace temporary macro clean_fed_from(fed_from varchar) as
--     trim(fed_from).regexp_replace('\s+', '-', 'g').regexp_replace('\-+', '-', 'g').upper();

create or replace temporary macro get_path1(str varchar) as
    regexp_extract(str, '^([A-Z]+)(-[A-Z0-9\-]+)', 2, 'i').upper();

create or replace temporary macro sld_path(db_or_panel_number varchar, circuit_ref_and_phase varchar) as 
    if(contains(circuit_ref_and_phase.upper(), get_path1(db_or_panel_number)),
        'SLD' || get_path1(circuit_ref_and_phase),
        'SLD' || get_path1(db_or_panel_number || '-' || circuit_ref_and_phase));

create or replace temporary macro is_radial(str varchar) as
    case 
        when str = 'RADIAL' then true
        when str = 'RADIAL/RING' then true
        when str like 'RA%' and damerau_levenshtein('RADIAL', str) <= 2 then true
        else false
    end;


create or replace temporary macro is_db_sp(str varchar) as
    case 
        when str like 'DB%' then true
        when str like 'SP%' then true
        else false
    end;

-- valve aka actuated valve
create or replace temporary macro is_motor_or_starter_candidate(str varchar) as
    case 
        when str = 'INV' then true
        when str like 'FWD%REV' then true
        when str like '%ASD%' then true
        when str like '%DOL%' then true
        when str like '%MOTOR%' then true
        when str like '%STAR DELTA%' then true
        when str like '%SOFT START%' then true
        when str like '%STARTER%' then true
        when str like '%USD%' then true
        when str like '%VALVE%' then true
        when str like 'INV%' and damerau_levenshtein('INVERTOR', str) <= 2 then true
        else false
    end;



create or replace table as_fitted_with_site_info as
with cte1 as (
    -- aib_ref is the site
    select
        t.aib_ref as aib_ref,
        any_value(t1.ai2_site_name) as ai2_site_name,
        any_value(t1.s4_all_site_codes) as s4_all_site_codes,
        any_value(t1.s4_best_site_code) as s4_best_site_code,
    from as_fitted_cicuits t
    join ai2_flocs t1 on t1.ai2_site_reference = clean_aib_ref(t.aib_ref)
    group by all
), cte2 as (
    -- aib_ref is the installation
    select
        t.aib_ref as aib_ref,
        any_value(t1.ai2_site_name) as ai2_site_name,
        any_value(t1.s4_all_site_codes) as s4_all_site_codes,
        any_value(t1.s4_best_site_code) as s4_best_site_code,
    from as_fitted_cicuits t
    join ai2_flocs t1 on t1.ai2_sai_number = clean_aib_ref(t.aib_ref)
    group by all
), cte3 as (
    select
        t.*,
        is_radial(t.circuit_type) as is_circuit_type_radial,
        not is_db_sp(t.fed_from) as is_not_dist_board_or_switch_panel,
        is_motor_or_starter_candidate(t.load) as is_motor_or_starter_candidate,
        sld_path(t.db_or_panel_number, circuit_ref_and_phase) as "sld_path",
        coalesce(t1.ai2_site_name, t2.ai2_site_name) as ai2_site_name,
        coalesce(t1.s4_all_site_codes, t2.s4_all_site_codes) as s4_all_site_codes,
        coalesce(t1.s4_best_site_code, t2.s4_best_site_code) as s4_best_site_code,
    from as_fitted_cicuits t
    left join cte1 t1 on t1.aib_ref = t.aib_ref
    left join cte2 t2 on t2.aib_ref = t.aib_ref
)
select 
    t.site_name,
    t.checklist_year,
    t.s4_best_site_code,
    t.location, 
    t.db_or_panel_number, 
    t.sld_path, 
    t.fed_from, 
    t.circuit_ref_and_phase,
    t.circuit_description, 
    t.load, 
    t.circuit_type, 
    t.is_circuit_type_radial, 
    t.is_not_dist_board_or_switch_panel, 
    t.is_motor_or_starter_candidate, 
    t.file_name, 
    t.sheet_name, 
    t.header_test_date, 
    t.sheet_number, 
    t.aib_ref, 
    t.tp_or_sp,
    t.db_or_panel_incomer_details,
    t.test_date, 
    t.comments,
    t.ai2_site_name,
from cte3 t
order by t.site_name asc, t.checklist_year desc, t.sld_path asc;



-- COPY (SELECT * FROM as_fitted_with_site_info) TO 'as_fitted_with_site_info.csv' (FORMAT csv);
