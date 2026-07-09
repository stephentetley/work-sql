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


-- Preliminaries: 
-- Must have asset_lake already attached but not set as the default database 

-- The script (level1) builds tables from external data with no dependencies
-- on data already in asset_lake

-- ztables

create schema if not exists asset_lake.ztables;

create or replace table asset_lake.ztables.eqobjl as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_ztables/ztable_eqobjl.parquet');

create or replace table asset_lake.ztables.flobjl as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_ztables/ztable_flobjl.parquet');

create or replace table asset_lake.ztables.flocdes as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_ztables/ztable_flocdes.parquet');

create or replace table asset_lake.ztables.manuf as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_ztables/ztable_manuf.parquet');

create or replace table asset_lake.ztables.objtype_manuf as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_ztables/ztable_objtype_manuf.parquet');

-- site mapping

create schema if not exists asset_lake.site_mapping;

create or replace table asset_lake.site_mapping.site_mapping as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/site_mapping/site_mapping.parquet');

-- ai2 classlists

create schema if not exists asset_lake.ai2_classlists;

create or replace table asset_lake.ai2_classlists.ai2_equi_classes as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/ai2_classlists/ai2_equi_classlist.parquet');

-- s4 classlists

create schema if not exists asset_lake.s4_classlists;

create or replace table asset_lake.s4_classlists.s4_equi_classes as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_classlists/s4_equi_classlist.parquet');

create or replace table asset_lake.s4_classlists.s4_equi_enums as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_classlists/s4_equi_classlist.parquet');

create or replace table asset_lake.s4_classlists.s4_floc_classes as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_classlists/s4_floc_classlist.parquet');

create or replace table asset_lake.s4_classlists.s4_floc_enums as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_classlists/s4_floc_classlist.parquet');


-- ai2_masterdata

create schema if not exists asset_lake.ai2_masterdata;

create or replace table asset_lake.ai2_masterdata.ai2_floc as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/ai2_masterdata/ai2_masterdata_floc.parquet');

create or replace table asset_lake.ai2_masterdata.ai2_equi as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/ai2_masterdata/ai2_masterdata_equi.parquet');


-- s4 masterdata

create schema if not exists asset_lake.s4_masterdata;

create or replace table asset_lake.s4_masterdata.s4_floc as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_masterdata/s4_masterdata_floc.parquet');

create or replace table asset_lake.s4_masterdata.s4_equi as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_masterdata/s4_masterdata_equi.parquet');

create or replace table asset_lake.s4_masterdata.s4_floc_east_north as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_masterdata/s4_masterdata_floc_east_north.parquet');

create or replace table asset_lake.s4_masterdata.s4_equi_plinum as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_masterdata/s4_masterdata_equi_to_plinum.parquet');

create or replace table asset_lake.s4_masterdata.s4_equi_sainum as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/s4_masterdata/s4_masterdata_equi_to_sainum.parquet');


-- s4 masterdata

create schema if not exists asset_lake.eawr_circuits;

create or replace table asset_lake.eawr_circuits.as_fitted_circuits as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/eawr/eawr_as_fitted_circuits.parquet');

create or replace table asset_lake.eawr_circuits.dist_board_loads as
select * from read_parquet(
    getvariable('asset_lake_resources') || '/eawr/eawr_dist_board_loads.parquet');





