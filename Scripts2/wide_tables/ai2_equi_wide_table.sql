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
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte1_ai2_flocs 
order by ai2_common_name;

describe ai2_equi_wide_table;

