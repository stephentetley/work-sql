
-- attach 'ducklake:../asset_lake/asset_lake.ducklake' as asset_lake (READ_ONLY);

set variable dist_boards_parquet_file = 'eawr_dist_board_load.parquet';
set variable as_fitted_parquet_file = 'eawr_as_fitted_circuits.parquet';

create or replace temporary table dist_boards_landing as 
select * from read_parquet(getvariable('dist_boards_parquet_file'));

create or replace temporary table as_fitted_circuits_landing as 
select * from read_parquet(getvariable('as_fitted_parquet_file'));


insert or replace into eawr.reported_locations by name
with cte1_ungrouped as (
    select 
        t.site_name as verbatim_site_name,
        t1.s4_site_funcloc as s4_site_floc, 
        t.checklist_year as survey_year,
        t.location as location,
        t.file_name as file_name,
        t.sheet_name as sheet_name,
        t.db_or_panel_number as db_or_panels, 
    from as_fitted_circuits_landing t
    left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_name = t.site_name
), cte2_grouped as (
    select 
        verbatim_site_name,
        any_value(s4_site_floc) as s4_site_floc, 
        survey_year,
        location,
        any_value(file_name) as file_name,
        min(sheet_name) as sheet_name,
        list(db_or_panels order by length(db_or_panels) asc) as db_or_panels, 
    from cte1_ungrouped
    group by all
) 
-- Remove where clauses after data validation in place
select * from cte2_grouped where s4_site_floc is not null and location is not null
;



insert or replace into eawr.dist_board by name  
select 
    t.file_name as file_name,
    t.file_last_modified_year as file_year,
    t.sheet_name as sheet_name,
    t.project_reference as verbatim_site_name,
    t.db_reference as db_reference,
    t.number_of_ways as num_of_ways,
    t.fed_from as fed_from,
    t.dist_board_phase as phase,
    t1.s4_site_funcloc as s4_site_floc,
    -- make_sort_key(t1.s4_site_floc, t.file_year, t.db_reference) as parent_sort_key,
from dist_boards_landing t
left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_name = t.project_reference;




-- Remove coalesce after data validation in place
insert or replace into eawr.asf_circuit by name
select 
    t.checklist_year as survey_year,
    t.file_name as file_name,
    t.sheet_name as sheet_name,
    unicode(t.circuit_column) - 66 as sheet_column,
    coalesce(t.site_name, 'ERROR') as verbatim_site_name,
    t.aib_ref as ai2_aib_ref,
    coalesce(t.db_or_panel_number, 'ERROR') as db_or_panel_name,
    t.location as verbatim_location,
    t.cable_num as cable_number,
    t.fed_from as fed_from,
    t.circuit_ref_and_phase as circuit_ref_and_phase,
    t.circuit_description as circuit_description,
    t.circuit_type as circuit_type,
    t.load as load,
    t.test_date as verbatim_test_date,
    t.comments as comment,
    t1.s4_site_funcloc as s4_site_floc,
    -- make_sort_key(t1.s4_site_floc, t.checklist_year, t.db_or_panel_number) as parent_sort_key,
from as_fitted_circuits_landing t
left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_name = t.site_name;




-- -- fill `db_or_panel` 
-- -- !At this point data has been corrected!
-- create or replace temporary table as_fitted_circuits_landing as 
-- select * from read_parquet(getvariable('AS_FITTED_PARQUET_FILE');

-- insert or replace into eawr.db_or_panel as 
with cte1_distinct_panels as (
    select 
        t1.s4_site_name as s4_site_name,
        t.checklist_year as survey_year,
        t.db_or_panel_number as db_or_panel_name,
        any_value(t.file_name) as file_name,
        min(t.sheet_name) as sheet_name,
    	any_value(t.site_name) as verbatim_site_name,
        any_value(t.aib_ref) as ai2_aib_ref,
        any_value(t.location) as location,
        any_value(t.tp_or_sp) as single_or_triple_phase,
        any_value(t.db_or_panel_incomer_details) as incomer_details,
    from as_fitted_circuits_landing t
    left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_name = t.site_name
    group by s4_site_name, survey_year, db_or_panel_name 
), cte2_add_derivations as (
    select 
        t.*, 
	    -- extract_type_descriptor(t.db_or_panel_number) as sld_type_descriptor, 
        -- make_sort_key(s4_site_name, survey_year, t.db_or_panel_number) as sort_key,
        -- make_level_sort_key(s4_site_name, survey_year, t.db_or_panel_number) as level_sort_key,
        'TODO' as suffix_sort_key,
    from cte1_distinct_panels t
)
select * from cte2_add_derivations;




