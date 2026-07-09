--
-- Copyright 2026 Stephen Tetley
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
-- http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 

create schema if not exists asset_lake.eawr;


-- motors might be valuable though not much data - to do...

-- | Note survey has no survey date field have to get a value from elsewhere...
-- project_reference (Site name) must be a valid AI2 site name...
create or replace table asset_lake.eawr.dist_board (
    file_name varchar not null,
    file_year integer not null,
    sheet_name varchar not null,
    verbatim_site_name varchar,
    db_reference varchar not null,
    num_of_ways integer,
    fed_from varchar,
    phase varchar,
    -- derived
    s4_site_floc varchar,
    parent_sort_key varchar,
);


create or replace table asset_lake.eawr.dist_board_circuit (
    file_year integer,
    file_name varchar not null,
    sheet_name varchar not null,
    sheet_row integer,
    verbatim_site_name varchar,
    db_reference varchar not null,
    fed_from varchar,
    way integer,
    phase varchar,
    load_refernce varchar,
    protective_in_a decimal(8,3),
    device_ir_a decimal(8,3),
    rcd_ma decimal(8,3),
    conductor_line decimal(8,3),
    conductor_cpc decimal(8,3),
);


-- TODO make_sort_keys macros should include `SITE5::YEAR::` prefix

-- sld_type_descriptor := 'MCC', 'TX-DB' etc.
-- !At this point data has been corrected!
create or replace table asset_lake.eawr.db_or_panel (
    s4_site_name varchar not null,
    survey_year integer not null,
    db_or_panel_name varchar not null,
    file_name varchar not null,
    sheet_name varchar not null,
    verbatim_site_name varchar,
    ai2_aib_ref varchar,
    location varchar,
    single_or_triple_phase varchar,
    incomer_details varchar,
    -- derived fields
    sld_type_descriptor varchar, 
    sort_key varchar,
    level_sort_key varchar,
    suffix_sort_key varchar,
);



create or replace table asset_lake.eawr.db_or_panel_circuit (
    survey_year integer,
    file_name varchar not null,
    sheet_name varchar not null,
    sheet_column integer,
    verbatim_site_name varchar,
    ai2_aib_ref varchar,
    db_or_panel_name varchar not null,
    verbatim_location varchar,
    cable_number varchar,
    fed_from varchar,
    circuit_ref_and_phase varchar,
    circuit_description varchar,
    circuit_type varchar,
    load varchar,
    verbatim_test_date varchar,
    comment varchar,
    -- derived
    s4_site_floc varchar,
    parent_sort_key varchar,
);


-- locations

-- todo - should this have a list of identified pnael paths?
create or replace table asset_lake.eawr.reported_location (
    verbatim_site_name varchar,
    survey_year integer not null,
    location varchar,
    file_name varchar not null,
    sheet_name varchar not null,
    s4_site_floc varchar not null,
    db_or_panels varchar[],
);

insert into asset_lake.eawr.dist_board by name  
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
from asset_lake.eawr_circuits.dist_board_loads t
left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_name = t.project_reference;

-- -- fill `db_or_panel` 
-- -- !At this point data has been corrected!
-- create or replace temporary table as_fitted_circuits_landing as 
-- select * from read_parquet(getvariable('AS_FITTED_PARQUET_FILE');

insert into asset_lake.eawr.db_or_panel by name 
with cte1_distinct_panels as (
    select 
        coalesce(t1.s4_site_name, 'ERROR') as s4_site_name,
        t.checklist_year as survey_year,
        coalesce(t.db_or_panel_number, 'ERROR') as db_or_panel_name,
        any_value(t.file_name) as file_name,
        min(t.sheet_name) as sheet_name,
    	any_value(t.site_name) as verbatim_site_name,
        any_value(t.aib_ref) as ai2_aib_ref,
        any_value(t.location) as location,
        any_value(t.tp_or_sp) as single_or_triple_phase,
        any_value(t.db_or_panel_incomer_details) as incomer_details,
    from asset_lake.eawr_circuits.as_fitted_circuits t
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



-- Remove coalesce after data validation in place
insert into asset_lake.eawr.db_or_panel_circuit by name
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
from asset_lake.eawr_circuits.as_fitted_circuits t
left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_name = t.site_name;







insert into asset_lake.eawr.reported_location by name
with cte1_ungrouped as (
    select 
        t.site_name as verbatim_site_name,
        t1.s4_site_funcloc as s4_site_floc, 
        t.checklist_year as survey_year,
        t.location as location,
        t.file_name as file_name,
        t.sheet_name as sheet_name,
        t.db_or_panel_number as db_or_panels, 
    from asset_lake.eawr_circuits.as_fitted_circuits t
    left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_name = t.site_name
), cte2_grouped as (
    select 
        verbatim_site_name,
        any_value(s4_site_floc) as s4_site_floc, 
        survey_year,
        location,
        any_value(file_name) as file_name,
        min(sheet_name) as sheet_name,
        list(distinct db_or_panels order by length(db_or_panels) asc) as db_or_panels, 
    from cte1_ungrouped
    group by all
) 
-- Remove where clauses after data validation in place
select * from cte2_grouped where s4_site_floc is not null and location is not null;






