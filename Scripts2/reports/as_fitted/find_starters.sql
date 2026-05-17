-- Setup the environment variable `S4_EQUI_WIDE_TABLE` before running this file
SELECT getenv('S4_EQUI_WIDE_TABLE') AS S4_EQUI_WIDE_TABLE;

create or replace table s4_equi_all as 
select 
    * 
from read_parquet(getenv('S4_EQUI_WIDE_TABLE'));

-- Setup the environment variable `AS_FITTED_WITH_SITE_INFO` before running this file
SELECT getenv('AS_FITTED_WITH_SITE_INFO') AS AS_FITTED_WITH_SITE_INFO;

create or replace table as_fitted_circuits as 
select 
    * 
from read_csv(getenv('AS_FITTED_WITH_SITE_INFO'));

-- create or replace table starter_mappings as 
-- select



-- This identifies sld_paths for a floc - starters (equi) under the floc
-- are not likely to have sld_paths within their names. __The sld_path is
-- coming from other equipment__ e.g. control panels, cubicles, ...
with cte1 as (
    select 
        'SLD' || regexp_extract(s4_equipment_name, '^([A-Z]+)(-[A-Z0-9\-]+)', 2, 'i') as sld_path,
        *, 
    from s4_equi_all 
    where s4_functional_location like '%E-LV%' and regexp_matches(s4_equipment_name, '^([A-Z]+)(-[A-Z0-9\-]+)')
), cte2 as (
    select 
        t.s4_functional_location,
        list(distinct t.sld_path order by t.sld_path asc) as sld_paths,
    from cte1 t
    group by all
) select * from cte2;

describe s4_equi_all;

select 
    t.s4_equipment_id as "Equipment",
    t.s4_equipment_name as "Equipment Description", 
    t.s4_functional_location as "Functional Location",
    t.s4_user_status as "User Status", 
    t.s4_std_class as "Std Class", 
from s4_equi_all t
where s4_functional_location like '%E-LV%' and s4_obj_type = 'STAR';

describe as_fitted_circuits;

create or replace temporary macro swap_null(str varchar) as 
    if(str == 'NULL', null, str);

-- just an investigation...
create or replace table temp_starter_id_by_hand as 
select 
    t."Functional Location".trim() as s4_funcloc,
    s4_funcloc[1:5] as s4_site,
    t."Circuit Ref & Phase".trim().swap_null().replace('+', '#') as combined_ff_crp,
    t."Circuit Description".trim().swap_null() as circuit_description,
    regexp_extract(combined_ff_crp, '^([A-Z0-9\-]+)#', 1) as fed_from,
    regexp_extract(combined_ff_crp, '#([A-Z0-9\-]+)$', 1) as circuit_ref_and_phase,
from read_xlsx('starter_id_by_hand_may.xlsx', all_varchar:=true) as t;

select 
    t.*,
    t1.load,
from temp_starter_id_by_hand t
join as_fitted_circuits t1 
    on t1.s4_best_site_code = t.s4_site  
    and t1.fed_from = t.fed_from 
    and t1.circuit_ref_and_phase = t.circuit_ref_and_phase
where t.fed_from is not null and t.circuit_ref_and_phase is not null
;

