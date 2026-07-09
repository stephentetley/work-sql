-- needs `asset_lake`...	

create schema if not exists elf_working;

create or replace temporary macro make_loc_floc(site_floc varchar, idx int64) as 
    case
        when idx < 10 then site_floc || '-EPS-LVD-ELF-ELF0' || try_cast(idx as varchar)
        else site_floc || '-EPS-LVD-ELF-ELF' || try_cast(idx as varchar)
    end
;

create or replace temporary macro elf_index(level5_floc varchar) as 
   try_cast(regexp_extract(level5_floc, 'ELF(\d+)$', 1) as integer)
;

create or replace temporary macro sld_length(path varchar) as
    try_cast(string_split(path, '-')
                .list_filter(lambda s: not regexp_matches(s, '[\p{Lu}]+'))        
                .list_count() as integer)
;

.print 'here'
create or replace temporary macro sld_tag(path varchar) as
    string_split(path, '-')
        .list_filter(lambda s: regexp_matches(s, '[\p{Lu}]+'))
        .list_aggregate('string_agg', '-')
;

-- -1 is p < q, 0 is p = q, 1 is p > q less than 1 is Gt
create or replace temporary macro min_path_helper(plen integer, ptag varchar, qlen integer, qtag varchar) as
    case 
        when plen < qlen then -1
        when plen > qlen then 1
        when ptag = qtag then 0
        when ptag = 'MCC' then -1
        when qtag = 'MCC' then 1
	    when ptag < qtag then -1
	    else 1
    end
;

.print 'here1.5'
create or replace temporary macro min_path(p1 varchar, p2 varchar) as
    case 
        when p1 is null then p2
        when p2 is null then p1
        when min_path_helper(sld_length(p1), sld_tag(p1), sld_length(p2), sld_tag(p2)) <= 0 then p1 
        else p2
    end
;

.print 'here2'
-- TODO needs a view of most recent reported_locations
create or replace table elf_working.new_s4_funclocs as
with cte1_max_level5 as (
    select 
        t.s4_site_floc, 
        coalesce(max(elf_index(t1.s4_functional_location)), 0) as max_level5,
    from asset_lake.eawr.reported_location t
    join asset_lake.wide_tables.s4_floc t1 on t1.site_floc = t.s4_site_floc
    where t1.s4_category = 5 
    group by t.s4_site_floc   
), cte2_numbered_locations as (
    select 
        t.s4_site_floc, 
        t.location as location,
        row_number() over (partition by t.s4_site_floc) as idx,
    from asset_lake.eawr.reported_location t
), cte3_rescaled_numbered_locations as (
    select 
        t.s4_site_floc as site_root_floc, 
        t.location as location,
        t.idx + t1.max_level5 as idx
    from cte2_numbered_locations t
    join cte1_max_level5 t1 on t1.s4_site_floc = t.s4_site_floc  
), cte4_add_slds as (
    select 
        t.*,
        list(t1.db_or_panels) as sld_paths,
    from cte3_rescaled_numbered_locations t
    join asset_lake.eawr.reported_location t1 on t1.location = t.location and t1.s4_site_floc = t.site_root_floc
    group by all
), cte5_new_flocs as (
    select 
        t.site_root_floc,
        make_loc_floc(t.site_root_floc, t.idx) as functional_location,
        t.location as floc_description,
        flatten(t.sld_paths).list_distinct().list_sort() as sld_paths,
        'ELF' as object_type,
    from cte4_add_slds t
), cte6_new_flocs_with_minimum as (
    select
        t.*,
        list_reduce(t.sld_paths, lambda x, y: min_path(x, y), null) as minimum_sld_path
    from cte5_new_flocs t
)
select * from cte6_new_flocs_with_minimum
order by site_root_floc, functional_location;

select * from elf_working.new_s4_funclocs;

copy (select * from elf_working.new_s4_funclocs) to 'new_elf_flocs.csv';

