

create or replace temporary macro replace_empty(str varchar) as
    case when str = '' then null else str end;

create or replace temporary macro norm_text(str varchar) as
    trim(str).regexp_replace('\s+', ' ', 'g').replace_empty();

create or replace table as_fitted_circuits_landing as
select 
    norm_text(columns(* exclude(checklist_year))),
    checklist_year as checklist_year,
from read_json(
    getvariable('as_fitted_globpath'),
    union_by_name = true
);
