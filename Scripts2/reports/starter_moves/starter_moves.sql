
create or replace table worklist as 
select 
    t."Equipment" as equipment_id,
    t."Description of technical object" as original_name,
    t."Functional Location" as original_floc,
    t."S4 Equi Name" as super_equi_name,
    t."New Funcloc" as super_equi_floc,
    t."New Superord" as super_equi_id,
from read_xlsx(
    getvariable('starter_moves_xlsx'),
    sheet = 'worklist',
    header = true,
    all_varchar = true) t
where
    t."Equipment" is not null and t."New Superord" is not null;


insert into sqlite_db.equi_change_change_request_header by name
select 'Starter moves from E-LV (MP/BF) ' || strftime(today(), '%d.%m.%y') as change_request_description;

insert into sqlite_db.equi_change_equipment_data by name
select 
    1 as batch_number,
    t.equipment_id as equipment,
    t.super_equi_id as superord_equip,
from worklist t;



