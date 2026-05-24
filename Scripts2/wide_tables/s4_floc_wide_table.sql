-- run with
-- .read './Scripts2/wide_tables/s4_floc_wide_table.sql'

create or replace table s4_floc_wide_table as
with cte1_s4_flocs as (
    select 
        columns(t.*) as 's4_\0',
        string_split(t.functional_location, '-')[1] as site_floc,
        string_split(t.functional_location, '-')[2] as function_code,
        string_split(t.functional_location, '-')[3] as process_group_code,
        string_split(t.functional_location, '-')[4] as process_code,
        string_split(t.functional_location, '-')[5] as system_code,
        string_split(t.functional_location, '-')[6] as subsystem_code,
        string_split(t.functional_location, '-')[7] as level7_code,
        string_split(t.functional_location, '-')[8] as level8_code,
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
        on t1.s4_functional_location = t.site_floc and t1.s4_category = 1
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
), cte5_add_floc_names as (
    select 
        t.*,
        t1.funcloc_name as function_name,
        t2.funcloc_name as process_group_name,
        t3.funcloc_name as process_name,
        t4.funcloc_name as system_name,
        t5.funcloc_name as item_name,
    from cte4_add_equipment_list_stats   t
    left join asset_lake.s4_masterdata.s4_floc t1 
        on t1.functional_location = t.s4_functional_location[:9]
        and t1.category = 2
    left join asset_lake.s4_masterdata.s4_floc t2 
        on t2.functional_location = t.s4_functional_location[:13]
        and t2.category = 3
    left join asset_lake.s4_masterdata.s4_floc t3 
        on t3.functional_location = t.s4_functional_location[:17]
        and t3.category = 4
    left join asset_lake.s4_masterdata.s4_floc t4
        on t4.functional_location = t.s4_functional_location[:23]
        and t4.category = 5
    left join asset_lake.s4_masterdata.s4_floc t5
        on t5.functional_location = t.s4_functional_location[:29]
        and t5.category = 6
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte5_add_floc_names 
order by s4_functional_location;

describe s4_floc_wide_table;
select count(s4_functional_location) as "count should equal 245061" from s4_floc_wide_table;

-- copy (select * from vw_floc_wide_table limit 100) to './data/vw_floc_wide_table.csv';