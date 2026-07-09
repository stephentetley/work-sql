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

create schema if not exists asset_lake.wide_tables;

create or replace table asset_lake.wide_tables.ai2_equi as
with cte1_ai2_flocs as (
    select 
        columns(t.*) as 'ai2_\0',
        (t.user_status = 'OPERATIONAL') as is_operational,
        (t.user_status = 'DISPOSED OF') as is_disposed_of,
        (t.user_status = 'NON OPERATIONAL') as is_non_op,
        (t.user_status = 'DECOMMISSIONED') as is_decommissioned,
        (t.site_sainum is null) as is_type2,
    from asset_lake.ai2_masterdata.ai2_equi t
), cte2_add_s4_site_codes as (
    select 
        t.*,
        list(t1.s4_site_funcloc) as __s4_site_codes,
    from cte1_ai2_flocs t
    left join asset_lake.site_mapping.site_mapping t1 on t1.ai2_site_id = t.ai2_site_sainum
    group by all
), cte3_s4_site_name_stats as (
    select 
        t.*,
        list_aggregate(t.__s4_site_codes, 'histogram') as __hist,
        map_keys(__hist) as s4_all_site_codes,
        map_keys(__hist).list_aggregate('mode') as s4_best_site_code,
    from cte2_add_s4_site_codes t
), cte4_add_equipment_list as (
    select 
        t.*,
        list(t1.pli_number) filter (t1.pli_number is not null) as __equipment_list,
        list(distinct t1.equi_type_name) filter (t1.equi_type_name is not null) as __equipment_types_list,
    from cte3_s4_site_name_stats t
    left join asset_lake.ai2_masterdata.ai2_equi t1 
        on t1.superequi_id = t.ai2_pli_number and t1.user_status = t.ai2_user_status
    group by all
), cte5_add_equipment_list_stats as (
    select 
        t.*, 
        coalesce(t.__equipment_list, []) as equipment_list,
        coalesce(t.__equipment_types_list, []) as equipment_types_list,
        length(equipment_list) as equipment_list_count,
        t.ai2_superequi_id is not null as is_sub_equi,
        (equipment_list_count > 0) as is_super_equi,
    from cte4_add_equipment_list t
), cte6_add_floc_names as (
    select 
        t.*,
        t1.floc_description as process_group,
        t2.floc_description as process,
        t3.floc_description as plant,
        t4.floc_description as sub_plant,
        t5.floc_description as plantitem,
        t6.floc_description as sub_plantitem,
    from cte5_add_equipment_list_stats t
    left join asset_lake.ai2_masterdata.ai2_floc t1 
        on t1.sai_number = t.ai2_process_group_sainum
        and t1.floc_source_type = 'PROCESS_GROUP'
    left join asset_lake.ai2_masterdata.ai2_floc t2
        on t2.sai_number = t.ai2_process_sainum
        and t2.floc_source_type = 'PROCESS'
    left join asset_lake.ai2_masterdata.ai2_floc t3
        on t3.sai_number = t.ai2_plant_sainum
        and t3.floc_source_type = 'PLANT'
    left join asset_lake.ai2_masterdata.ai2_floc t4
        on t4.sai_number = t.ai2_sub_plant_sainum
        and t4.floc_source_type = 'SUB_PLANT'
    left join asset_lake.ai2_masterdata.ai2_floc t5
        on t5.sai_number = t.ai2_plantitem_sainum
        and t5.floc_source_type = 'PLANTITEM'
    left join asset_lake.ai2_masterdata.ai2_floc t6
        on t6.sai_number = t.ai2_sub_plantitem_sainum
        and t6.floc_source_type = 'SUB_PLANTITEM'
), cte7_add_s4_equi_id_links as (
    select
        t.*,
        list(t1.s4_equipment_id) filter (t1.s4_equipment_id is not null) as __s4_equi_id_list,
    from cte6_add_floc_names t
    left join asset_lake.s4_masterdata.s4_equi_plinum t1 on t1.ai2_plinum = t.ai2_pli_number
    group by all
), cte8_add_s4_equi_id_links_stats as (
    select 
        t.*, 
        coalesce(t.__s4_equi_id_list, []) as s4_equi_id_list,
    from cte7_add_s4_equi_id_links t
)
select columns(lambda c: c not like '$_$_%' escape '$') from cte8_add_s4_equi_id_links_stats  
order by ai2_common_name;


