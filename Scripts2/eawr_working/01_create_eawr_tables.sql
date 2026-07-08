
create schema if not exists eawr;

-- circuits have valuable dat - to do...

-- | Note survey has no survey date field have to get a value from elsewhere...
-- project_reference (Site name) must be a valid AI2 site name...
create or replace table eawr.dist_board (
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
    primary key (verbatim_site_name, file_year, sheet_name)
);


create or replace table eawr.db_circuit (
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
    primary key (verbatim_site_name, file_year, sheet_name, sheet_row)
);



create or replace table eawr.asf_circuit (
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
    primary key (verbatim_site_name, survey_year, sheet_name, sheet_column)
);



-- TODO make_sort_keys macros should include `SITE5::YEAR::` prefix

-- sld_type_descriptor := 'MCC', 'TX-DB' etc.
-- !At this point data has been corrected!
create or replace table eawr.db_or_panel (
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
    primary key (verbatim_site_name, survey_year, db_or_panel_name)
);

-- locations

-- todo - should this have a list of identified pnael paths?
create or replace table eawr.reported_locations (
    verbatim_site_name varchar,
    survey_year integer not null,
    location varchar,
    file_name varchar not null,
    sheet_name varchar not null,
    s4_site_floc varchar not null,
    db_or_panels varchar[],
    primary key (verbatim_site_name, survey_year, location)
);


