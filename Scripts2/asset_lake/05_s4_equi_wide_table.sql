


create or replace table asset_lake.wide_tables.s4_equi as
with cte1_s4_equi as (
    select 
        columns(t.* exclude(obj_type)) as 's4_\0',
        t.obj_type as s4_object_type,
        string_split(t.functional_location, '-')[1] as site_floc,
        string_split(t.functional_location, '-')[2] as function_code,
        string_split(t.functional_location, '-')[3] as process_group_code,
        string_split(t.functional_location, '-')[4] as process_code,
        string_split(t.functional_location, '-')[5] as system_code,
        string_split(t.functional_location, '-')[6] as subsystem_code,
        string_split(t.functional_location, '-')[7] as level7_code,
        string_split(t.functional_location, '-')[8] as level8_code,
        split_part(t.user_status, ' ', 1) as status1,
        (status1 = 'OPER') as is_operational,
        (status1 = 'DISP') as is_disposed_of,
        (status1 = 'NOP') as is_non_op,
        (status1 = 'DCOM') as is_decommissioned,      
    from asset_lake.s4_masterdata.s4_equi t
), cte2_add_s4_site_name as (
    select 
        t.*, 
        t1.funcloc_name as s4_site_name,
    from cte1_s4_equi t
    left join asset_lake.s4_masterdata.s4_floc t1 
        on t1.functional_location = t.site_floc and t1.category = 1
), cte3_add_stdclass_name as (
    select 
        t.*,
        any_value(t1.class_description) as std_class_description
    from cte2_add_s4_site_name t
    left join asset_lake.s4_classlists.s4_equi_classes t1 on t1.class_name = t.s4_std_class
    group by all
), cte4_add_equipment_list as (
    select 
        t.*,
        list(t1.equipment_id) filter (t1.equipment_id is not null) as __equipment_list,
        list(distinct t1.obj_type) filter (t1.obj_type is not null) as __equipment_types_list,
    from cte3_add_stdclass_name t
    left join asset_lake.s4_masterdata.s4_equi t1 
        on t1.superequi_id = t.s4_equipment_id and t1.user_status = t.s4_user_status
    group by all
), cte5_add_equipment_list_stats as (
    select 
        t.*, 
        coalesce(t.__equipment_list, []) as equipment_list,
        coalesce(t.__equipment_types_list, []) as equipment_types_list,
        length(equipment_list) as equipment_list_count,
        t.s4_superequi_id is not null as is_sub_equi,
        (equipment_list_count > 0) as is_super_equi,
    from cte4_add_equipment_list t
), cte6_add_floc_names as (
    select 
        t.*,
        t1.funcloc_name as function_name,
        t2.funcloc_name as process_group_name,
        t3.funcloc_name as process_name,
        t4.funcloc_name as system_name,
        t5.funcloc_name as subsystem_name,
    from cte5_add_equipment_list_stats t
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
), cte7_specific_subequi as (
    select 
        t.*,
        contains(equipment_types_list, 'ACTU') as has_subequi_actuator,
        contains(equipment_types_list, 'EMTR') or contains(equipment_types_list, 'GMTR') as has_subequi_motor,
        contains(equipment_types_list, 'STAR') as has_subequi_starter,
        contains(equipment_types_list, 'PODE') as has_subequi_power,
        contains(equipment_types_list, 'TRUT') as has_subequi_gearbox,
    from cte6_add_floc_names t
), cte8_add_ai2_plinum_links as (
    select
        t.*,
        list(t1.ai2_plinum) filter (t1.ai2_plinum is not null) as __ai2_plinums_list,
    from cte7_specific_subequi t
    left join asset_lake.s4_masterdata.s4_equi_plinum t1 on t1.s4_equipment_id = t.s4_equipment_id
    group by all
), cte9_add_ai2_plinum_links_stats as (
    select 
        t.*, 
        coalesce(t.__ai2_plinums_list, []) as ai2_plinums_list,
    from cte8_add_ai2_plinum_links t
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte9_add_ai2_plinum_links_stats  
order by s4_functional_location;


