-- needs `asset_lake`...	

create schema if not exists elf_working;

create or replace temporary macro make_loc_floc(site_floc varchar, idx int64) as 
   site_floc || '-EPS-LVD-ELF-ELF' || lpad(try_cast(idx as varchar), 2, '0')
;

create or replace temporary macro elf_index(level5_floc varchar) as 
   try_cast(regexp_extract(level5_floc, 'ELF(\d+)$', 1) as integer)
;



create or replace table elf_working.new_s4_funclocs as
with cte1_max_level5 as (
    select 
        t.s4_site_floc, 
        max(elf_index(t1.s4_functional_location)) as max_level5,
    from eawr.reported_locations t
    join asset_lake.wide_tables.s4_floc t1 on t1.site_floc = t.s4_site_floc
    where t1.s4_category = 5 
    group by t.s4_site_floc   
), cte2_loc_counts as (
    select 
        t.s4_site_floc, 
        count(t.location) as location_count
    from eawr.reported_locations t
    group by t.s4_site_floc
), cte3_indices as (
    select 
        t.s4_site_floc as site_root_floc, 
        unnest(range(t.max_level5, t.max_level5 + t1.location_count)) as idx
    from cte1_max_level5 t
    join cte2_loc_counts t1 on t1.s4_site_floc = t.s4_site_floc  
), cte4_just_new_flocs as (
    select 
        t.site_root_floc, 
        make_loc_floc(t.site_root_floc, t.idx) as level5_floc,
    from cte3_indices t
), cte5_elaborated_new_flocs as (
    select 
        t.site_root_floc, 
        t.level5_floc,
        'ELF' as object_type,
        any_value(t1.location) as location,
    from cte4_just_new_flocs t
    join eawr.reported_locations t1 on t1.s4_site_floc = t.site_root_floc
    group by t.site_root_floc, t.level5_floc, object_type
)
select * from cte5_elaborated_new_flocs
order by site_root_floc;
