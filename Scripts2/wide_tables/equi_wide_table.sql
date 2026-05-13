
create or replace view vw_equi_wide_table as
with cte_s4_equi as (
    select 
        columns(t.*) as 's4_\0',
        string_split(t.functional_location, '-')[1] as s4_site_floc,
        string_split(t.functional_location, '-')[2] as s4_function_code,
        string_split(t.functional_location, '-')[3] as s4_process_group_code,
        string_split(t.functional_location, '-')[4] as s4_process_code,
        string_split(t.functional_location, '-')[5] as s4_system_code,
        string_split(t.functional_location, '-')[6] as s4_assembly_code,
        string_split(t.functional_location, '-')[7] as s4_item_code,
        string_split(t.functional_location, '-')[8] as s4_component_code,    
    from asset_lake.s4_masterdata.s4_equi t
), site_names as (
    select 
        t.functional_location as s4_functional_location, 
        t.funcloc_name as site_name,
    from asset_lake.s4_masterdata.s4_floc t
    where
        category = 1
), equi_wide_table as (
    select 
        t.*,
        t1.site_name as site_name,
    from cte_s4_equi t
    left join site_names t1 on t1.s4_functional_location = t.s4_site_floc
)
select * from equi_wide_table 
order by s4_functional_location;


select * from vw_equi_wide_table order by s4_functional_location limit 20;
describe vw_equi_wide_table;

