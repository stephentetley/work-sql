
create or replace table ai2_floc_wide_table as
with cte1_ai2_flocs as (
    select 
        columns(t.*) as 'ai2_\0',
    from asset_lake.ai2_masterdata.ai2_floc t
), cte2_ai2_site_name as (
    select 
        t.*,
        t1.site_name as ai2_site_name
    from cte1_ai2_flocs t
    left join asset_lake.ai2_masterdata.ai2_sites t1 on t1.sai_number = t.ai2_site_reference
), cte3_s4_site_name1 as (
    select 
        t.*,
        list(t1.s4_site_funcloc) as __s4_site_codes,
    from cte2_ai2_site_name t
    left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_id = t.ai2_site_reference
    group by all
), cte4_s4_site_name2 as (
    select 
        columns(lambda c: c not like '$_$_%' escape '$'),
        list_aggregate(t.__s4_site_codes, 'histogram') as __hist,
        map_keys(__hist) as s4_all_site_codes,
        map_keys(__hist).list_aggregate('mode') as s4_best_site_code,
    from cte3_s4_site_name1 t
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte4_s4_site_name2 
order by ai2_common_name;

describe ai2_floc_wide_table;

-- COPY (SELECT * FROM ai2_floc_wide_table) TO 'ai2_floc_wide_table.parquet' (FORMAT parquet, COMPRESSION snappy);
   
   -- select * from asset_lake.site_mapping.site_mapping where ai2_site_id = 'SAI00002748'