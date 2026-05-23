-- run with
-- .read './Scripts2/wide_tables/s4_equi_wide_table.sql'


create or replace table s4_equi_wide_table as
with cte1_s4_equi as (
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
        (t.user_status like 'OPER%') as is_operational,
        (t.user_status like 'DISP%') as is_disposed_of,
        (t.user_status like 'NOP%') as is_non_op,
        (t.user_status like 'DCOM%') as is_decommissioned,         
    from asset_lake.s4_masterdata.s4_equi t
), cte2_add_s4_site_name as (
    select 
        t.*, 
        t1.funcloc_name as s4_site_name,
    from cte1_s4_equi t
    left join asset_lake.s4_masterdata.s4_floc t1 
        on t1.functional_location = t.s4_site_floc and t1.category = 1
), cte3_add_stdclass_name as (
    select 
        t.*,
        any_value(t1.class_description) as std_class_description
    from cte2_add_s4_site_name t
    left join asset_lake.s4_classlists.s4_equi_classes t1 on t1.class_name = t.s4_std_class
    group by all
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte3_add_stdclass_name  
order by s4_functional_location;



describe s4_equi_wide_table;

-- select * from vw_equi_wide_table order by s4_functional_location limit 20;

