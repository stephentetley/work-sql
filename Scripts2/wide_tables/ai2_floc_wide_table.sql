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
), cte2_add_s4_site_codes as (
    select 
        t.*,
        list(t1.s4_site_funcloc) as __s4_site_codes,
    from cte1_ai2_flocs t
    left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_id = t.ai2_site_sainum
    group by all
), cte3_s4_site_name_stats as (
    select 
        columns(lambda c: c not like '$_$_%' escape '$'),
        list_aggregate(t.__s4_site_codes, 'histogram') as __hist,
        map_keys(__hist) as s4_all_site_codes,
        map_keys(__hist).list_aggregate('mode') as s4_best_site_code,
    from cte2_add_s4_site_codes t
), cte4_add_equipment1 as (
    -- ai2 only allows 1 equipment on a floc
    select 
        t.*,
        any_value(t1.pli_number) as equipment
    from cte3_s4_site_name_stats t
    left join asset_lake.ai2_masterdata.ai2_equi t1 on t1.sai_number = t.ai2_sai_number
    group by all    
), cte5_add_equipment_stats as (
    select 
        t.*, 
        (t.equipment is not null) as has_equipment,
    from cte4_add_equipment1 t
), cte6_add_floc_names as (
    select 
        t.*,
        t1.floc_description as process_group,
        -- t2.funcloc_name as process_name,
        -- t3.funcloc_name as system_name,
        -- t4.funcloc_name as item_name,
    from cte5_add_equipment_stats t
    left join asset_lake.ai2_masterdata.ai2_floc t1 
        on t1.sai_number = t.ai2_process_group_sainum
        and t1.floc_source_type = 'PROCESS_GROUP'
    -- left join asset_lake.s4_masterdata.s4_floc t2 
    --     on t2.functional_location = t.s4_functional_location[:13]
    --     and t2.category = 3
    -- left join asset_lake.s4_masterdata.s4_floc t3 
    --     on t3.functional_location = t.s4_functional_location[:17]
    --     and t3.category = 4
    -- left join asset_lake.s4_masterdata.s4_floc t4
    --     on t4.functional_location = t.s4_functional_location[:23]
    --     and t4.category = 5
    -- left join asset_lake.s4_masterdata.s4_floc t5
    --     on t5.functional_location = t.s4_functional_location[:29]
    --     and t5.category = 6
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte6_add_floc_names 
order by ai2_common_name;

describe ai2_floc_wide_table;

-- COPY (SELECT * FROM ai2_floc_wide_table) TO 'ai2_floc_wide_table.parquet' (FORMAT parquet, COMPRESSION snappy);
   
   -- select * from ai2_floc_wide_table where ai2_site_id = 'SAI00002748'