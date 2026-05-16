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
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte2_add_site_name  
order by ai2_common_name;

describe ai2_equi_wide_table;

