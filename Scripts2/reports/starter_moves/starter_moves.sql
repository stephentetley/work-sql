
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







insert into sqlite_db.equi_change_change_request_header by name
select 'Starter moves from E-LV (MP/BF) ' || strftime(today(), '%d.%m.%y') as change_request_description;

insert into sqlite_db.equi_change_equipment_data by name
with cte_moves as (
    select
        t.batch as batch_number,
        t.equipment_id as equipment,
        equi_description(t.revised_starter_name, t1.status1) as description_medium,
        t1.status1 as status_of_an_object,
        t.super_equi_id as superord_equip,
        '0050' as position,
    from starter_moves_worklist t
    join s4_equi_wide_table t1 on t1.s4_equipment_id = t.super_equi_id
    where t1.has_subequi_starter = false and t1.status1 != 'DISP'
), cte_duplicates as (
    select
        t.batch as batch_number,
        t.equipment_id as equipment,
        t.revised_starter_name || ' (Dup)' as description_medium,
        'DISP' as status_of_an_object,
        null as superord_equip,
        '9995' as position,
    from starter_moves_worklist t
    join s4_equi_wide_table t1 on t1.s4_equipment_id = t.super_equi_id
    where t1.has_subequi_starter = true
), cte_deletes as (
    select
        t.batch as batch_number,
        t.equipment_id as equipment,
        t.revised_starter_name || ' (Del)' as description_medium,
        'DISP' as status_of_an_object,
        null as superord_equip,
        '9999' as position,
    from starter_moves_worklist t
    join s4_equi_wide_table t1 on t1.s4_equipment_id = t.super_equi_id
    where t1.has_subequi_starter = false and t1.status1 = 'DISP'
)
select * from cte_moves
union by name
select * from cte_duplicates
union by name
select * from cte_deletes
order by batch_number;


