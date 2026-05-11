
create or replace view vw_floc_wide_table as
with cte_s4_flocs as (
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
    from asset_lake.s4_masterdata.s4_floc t
), site_names as (
    select 
        t.s4_functional_location, 
        t.s4_funcloc_name as site_name,
    from cte_s4_flocs t
    where
        s4_category = 1
), equipment1 as (
    select 
        t.functional_location as s4_functional_location, 
        list(t.equipment_id) as s4_equipment_list, 
    from asset_lake.s4_masterdata.s4_equi t
    group by all    
), direct_equipment as (
    select 
        t.s4_functional_location, 
        t.s4_equipment_list as s4_direct_equipment, 
        length(t.s4_equipment_list) as s4_direct_equipment_count,
        (s4_direct_equipment_count>0) as s4_has_direct_equipment,
    from equipment1 t
), floc_wide_table as (
    select 
        t.*,
        t1.site_name as site_name,
        t2.* exclude (t2.s4_functional_location),
    from cte_s4_flocs t
    left join site_names t1 on t1.s4_functional_location = t.s4_site_floc
    left join direct_equipment t2 on t2.s4_functional_location = t.s4_functional_location
)
select * from floc_wide_table 
order by s4_functional_location;

describe vw_floc_wide_table;

-- copy (select * from vw_floc_wide_table limit 100) to './data/vw_floc_wide_table.csv';