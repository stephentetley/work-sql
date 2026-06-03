
-- Preliminary: 
-- The variable `floc_delta_worklist` is set in DuckDb (i.e. not an env var)


create or replace table starter_moves_worklist as 
select 
    t."Equipment" as equipment_id,
    t."Description of technical object" as original_name,
    t."Functional Location" as original_floc,
    t."Starter Name" as revised_starter_name,
    t."S4 Super Equi Name" as super_equi_name,
    t."Dest Funcloc" as super_equi_floc,
    t."Dest Superord" as super_equi_id,
    try_cast(t."Batch" as integer) as batch,
from read_xlsx(
    getvariable('starter_moves_xlsx'),
    sheet = 'Sheet1',
    header = true,
    all_varchar = true) t
where
    t."Equipment" is not null and t."Dest Superord" is not null;

create or replace table s4_equi_wide_table as 
select * from read_parquet(
    getvariable('equi_wide_table_parquet')
);





-- insert into sqlite_db.equi_change_change_request_header by name
-- select 'Starter moves from E-LV (MP/BF) ' || strftime(today(), '%d.%m.%y') as change_request_description;

-- insert into sqlite_db.equi_change_equipment_data by name
-- select 
--     1 as batch_number,
--     t.equipment_id as equipment,
--     t.super_equi_id as superord_equip,
-- from worklist t;



