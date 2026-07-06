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

-- TODO SuffixSortKey - not a scalar function?
