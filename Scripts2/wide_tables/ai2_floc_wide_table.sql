-- run with
-- .read './Scripts2/wide_tables/ai2_floc_wide_table.sql'


create or replace table ai2_floc_wide_table as
with cte1_ai2_flocs as (
    select 
        columns(t.*) as 'ai2_\0',
        (t.user_status = 'OPERATIONAL') as is_operational,
        (t.user_status = 'DISPOSED OF') as is_disposed_of,
        (t.user_status = 'NON OPERATIONAL') as is_non_op,
        (t.user_status = 'DECOMMISSIONED') as is_decommissioned,
        (t.user_status = 'INSTALLATION') as is_installation,
        (t.user_status = 'SUB_INSTALLATION') as is_sub_installation,
        (t.user_status = 'PROCESS_GROUP') as is_process_group,
        (t.user_status = 'PROCESS') as is_process,
    from asset_lake.ai2_masterdata.ai2_floc t
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
), cte5_add_equipment1 as (
    -- ai2 only allows 1 equipment on a floc
    select 
        t.*,
        any_value(t1.pli_number) as equipment
    from cte3_add_s4_site_codes t
    left join asset_lake.ai2_masterdata.ai2_equi t1 on t1.sai_number = t.ai2_sai_number
    group by all    
), cte6_add_equipment_stats as (
    select 
        t.*, 
        (t.equipment is not null) as has_equipment,
    from cte5_add_equipment1 t
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte6_add_equipment_stats 
order by ai2_common_name;

describe ai2_floc_wide_table;

-- COPY (SELECT * FROM ai2_floc_wide_table) TO 'ai2_floc_wide_table.parquet' (FORMAT parquet, COMPRESSION snappy);
   
   -- select * from ai2_floc_wide_table where ai2_site_id = 'SAI00002748'