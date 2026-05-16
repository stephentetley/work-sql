-- run with:
-- duckdb -c ".read 'as_fitted_with_site_info.sql"


.print 'join with ai2 floc wide table for site names'

INSTALL inflector FROM community;
LOAD inflector;


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
)
select
    t.*,
    sld_path(t.db_or_panel_number, circuit_ref_and_phase) as "sld_path",
    coalesce(t1.ai2_site_name, t2.ai2_site_name) as ai2_site_name,
    coalesce(t1.s4_all_site_codes, t2.s4_all_site_codes) as s4_all_site_codes,
    coalesce(t1.s4_best_site_code, t2.s4_best_site_code) as s4_best_site_code,
from as_fitted_cicuits t
left join cte1 t1 on t1.aib_ref = t.aib_ref
left join cte2 t2 on t2.aib_ref = t.aib_ref;



-- COPY (SELECT * FROM as_fitted_with_site_info) TO 'as_fitted_with_site_info.csv' (FORMAT csv);
