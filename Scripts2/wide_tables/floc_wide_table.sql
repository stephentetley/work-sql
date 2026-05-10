
with cte_s4_flocs as (
    select 
        columns(t.*) as 's4_\0',
        string_split(t.functional_location, '-')[1] as s4_floc_root,

    from asset_lake.s4_masterdata.s4_floc t
), site_names as (
    select 
        s4_functional_location, 
        s4_funcloc_name as site_name,
    from cte_s4_flocs
    where
        s4_category = 1
), floc_wide_table as (
    select 
        t.*,
        t1.site_name as site_name,
    from cte_s4_flocs t
    left join site_names t1 on t1.s4_functional_location = t.s4_floc_root
)
select * from floc_wide_table 
order by s4_functional_location;