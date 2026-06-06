-- run with
-- .read './Scripts2/wide_tables/ai2_equi_wide_table.sql'

create or replace table ai2_equi_wide_table as
with cte1_ai2_flocs as (
    select 
        columns(t.*) as 'ai2_\0',
        (t.user_status = 'OPERATIONAL') as is_operational,
        (t.user_status = 'DISPOSED OF') as is_disposed_of,
        (t.user_status = 'NON OPERATIONAL') as is_non_op,
        (t.user_status = 'DECOMMISSIONED') as is_decommissioned,
    from asset_lake.ai2_masterdata.ai2_equi t
), cte2_add_site_name as (
    select 
        t.*,
        t1.site_name as ai2_site_name
    from cte1_ai2_flocs t
    left join asset_lake.ai2_masterdata.ai2_sites t1 on t1.sai_number = t.ai2_site_reference
), cte3_add_s4_site_codes as (
    select 
        t.*,
        list(t1.s4_site_funcloc) as __s4_site_codes,
    from cte2_add_site_name t
    left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_id = t.ai2_site_reference
    group by all
), cte4_s4_site_name_stats as (
    select 
        columns(lambda c: c not like '$_$_%' escape '$'),
        list_aggregate(t.__s4_site_codes, 'histogram') as __hist,
        map_keys(__hist) as s4_all_site_codes,
        map_keys(__hist).list_aggregate('mode') as s4_best_site_code,
    from cte3_add_s4_site_codes t
), cte4_add_equipment_list as (
    select 
        t.*,
        list(t1.pli_number) filter (t1.pli_number is not null) as __equipment_list,
        list(distinct t1.equi_type_name) filter (t1.equi_type_name is not null) as __equipment_types_list,
    from cte3_add_s4_site_codes t
    left join asset_lake.ai2_masterdata.ai2_equi t1 
        on t1.superequi_id = t.ai2_pli_number and t1.user_status = t.ai2_user_status
    group by all
), cte5_add_equipment_list_stats as (
    select 
        t.*, 
        coalesce(t.__equipment_list, []) as equipment_list,
        coalesce(t.__equipment_types_list, []) as equipment_types_list,
        length(equipment_list) as equipment_list_count,
        t.ai2_superequi_id is not null as is_sub_equi,
        (equipment_list_count > 0) as is_super_equi,
    from cte4_add_equipment_list t
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte5_add_equipment_list_stats  
order by ai2_common_name;

describe ai2_equi_wide_table;

