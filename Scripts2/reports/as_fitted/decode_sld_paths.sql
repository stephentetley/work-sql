create or replace macro make_sort_key(sld_id varchar) as 
    'SLD-' 
        || string_split(sld_id, '-')
            .list_filter(lambda s: not (regexp_full_match(s, '[\p{Lu}]{2,}')))
            .list_transform(lambda s: regexp_extract(s, '(\d+)(\w*)', 1).lpad(3, '0') || '.' || regexp_extract(s, '(\d+)(\w*)', 2))
            .list_transform(lambda s: regexp_replace(s, '\.$', ''))
            .list_aggregate('string_agg', '-')
;

create or replace macro level_letter(i bigint) as chr(64 + i :: integer) :: varchar;

create or replace macro make_level_designator(sld_id varchar) as 
    'L' || 
        string_split(sld_id, '-')
                        .list_filter(lambda s: not (regexp_full_match(s, '[\p{Lu}]{2,}')))
                        .list_count()
                        .level_letter()
;

create or replace macro make_level_sort_key(sld_id varchar) as 
    make_level_designator(sld_id) || '-' || string_split(sld_id, '-')
            .list_filter(lambda s: not (regexp_full_match(s, '[\p{Lu}]{2,}')))
            .list_transform(lambda s: regexp_extract(s, '(\d+)(\w*)', 1).lpad(3, '0') || '.' || regexp_extract(s, '(\d+)(\w*)', 2))
            .list_transform(lambda s: regexp_replace(s, '\.$', ''))
            .list_aggregate('string_agg', '-')
;

create or replace temporary macro is_mcc_or_bb(sld_id varchar) as 
    string_split(sld_id, '-').list_has_any(['MCC', 'BB'])
;

create or replace temporary macro make_suffix_sort_key(sort_key varchar, parent_sort_key varchar) as 
    case 
        when parent_sort_key is not null then parent_sort_key || '-!!' || sort_key[(length(parent_sort_key) + 2):]
        else sort_key
    end
;

create or replace table keys_table as
with cte1_base as (
    select 
        t.s4_best_site_code as s4_site, 
        t.db_or_panel_number as panel_number, 
        is_mcc_or_bb(t.db_or_panel_number) as is_bus,
        make_sort_key(t.db_or_panel_number) as sort_key,
    from as_fitted_with_site_info t
), cte2_parent as (
    select 
        t.s4_site, 
        t.panel_number, 
        t.sort_key,
        t1.sort_key as ancestor_bus_key,
    from cte1_base t 
    left join cte1_base t1 
        on t1.s4_site = t.s4_site
        and t1.is_bus = true
        and prefix(t.sort_key, t1.sort_key)
        and t1.sort_key != t.sort_key
), cte3_parent_max as (
    select 
        t.s4_site, 
        t.panel_number, 
        t.sort_key,
        max(t.ancestor_bus_key) as parent_bus_key,
    from cte2_parent t
    group by all
), cte4_keys as (
    select 
        t.s4_site, 
        t.panel_number, 
        t.sort_key,
        make_level_sort_key(panel_number) as level_sort_key,
        make_suffix_sort_key(t.sort_key, t.parent_bus_key) as suffix_sort_key,
    from cte3_parent_max t
)

select * from cte4_keys
order by s4_site;

select * from keys_table;

-- copy (select * from keys_table) to keys_table.csv;

