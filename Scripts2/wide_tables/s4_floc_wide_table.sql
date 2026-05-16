-- run with
-- .read './Scripts2/wide_tables/s4_floc_wide_table.sql'

create or replace table s4_floc_wide_table as
with cte1_s4_flocs as (
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
    from asset_lake.s4_masterdata.s4_floc t
), cte2_add_site_name as (
    select 
        t.*, 
        t1.s4_funcloc_name as s4_site_name,
    from cte1_s4_flocs t
    left join cte1_s4_flocs t1 
        on t1.s4_functional_location = t.s4_site_floc and t1.s4_category = 1
), cte3_add_equipment_list as (
    select 
        t.*,
        list(t1.equipment_id) filter (t1.equipment_id is not null) as __equipment_list 
    from cte2_add_site_name t
    left join asset_lake.s4_masterdata.s4_equi t1 on t1.functional_location = t.s4_functional_location
    group by all    
), cte4_add_equipment_list_stats as (
    select 
        t.*, 
        ifnull(t.__equipment_list, []) as equipment_list,
        length(equipment_list) as equipment_list_count,
        (equipment_list_count > 0) as has_equipment,
    from cte3_add_equipment_list t
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte4_add_equipment_list_stats 
order by s4_functional_location;

describe s4_floc_wide_table;

-- copy (select * from vw_floc_wide_table limit 100) to './data/vw_floc_wide_table.csv';