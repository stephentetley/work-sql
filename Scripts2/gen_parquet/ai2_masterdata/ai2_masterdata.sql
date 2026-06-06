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
-- The variables `ai2_masterdata_srcpath` and `equi_classlist_xlsx_path` 
-- set in DuckDb (i.e. not env vars)
-- The community extension `rusty_sheet` is loaded:
-- D INSTALL rusty_sheet FROM community;
-- D LOAD rusty_sheet;



-- This script akes a long time so we have left in some `.print` statements

-- ## CREATE TABLE


create or replace table ai2_site_simple (
    -- e.g. 'SAI00123456'
    sai_number varchar not null,
    -- e.g. 'BRUNSWICK COMPLEX'
    site_name varchar not null,
    primary key (sai_number)
);  

create or replace table ai2_floc (
    -- e.g. 'SAI00123456'
    sai_number varchar not null,
    -- e.g. 'WATERFALL/WPS'
    common_name varchar,
    -- e.g. 'OPERATIONAL'
    user_status varchar,
    -- e.g. 'WATER SERVICES'
    type_decription varchar,
    -- e.g. 'SAI00123456'
    parent_ref varchar,
    -- derived, one of 'INSTALLATION' | 'SUB_INSTALLATION' | 'PROCESS_GROUP' | 'PROCESS' | ...
    floc_source_type varchar not null,
    -- e.g. 'SAI00001000'
    site_reference varchar,
    -- e.g. 'SAI00001340'
    installation_or_subinstallation_number varchar,
    -- e.g. 'SITENAME/SPS'
    installation_or_subinstallation_name varchar,
    process_group_number varchar,
    process_number varchar,
    plant_number varchar,
    sub_plant_number varchar,
    plantitem_number varchar,
    sub_plantitem_number varchar,
    primary key (sai_number)
);  


create or replace table ai2_equi (
    -- e.g. 'PLI00123456'
    pli_number varchar not null,
    -- e.g. 'LCC'
    equipment_name varchar not null,
    -- e.g. 'EQUIPMENT: PENSTOCK'
    equi_type_name varchar,
    -- e.g. 'EQPTMVNR'
    equi_type_code varchar,
    -- e.g. '2017-09-12'
    installed_from_date date,
    -- e.g. 'UNKNOWN MANUFACTURER'
    manufacturer varchar,
    -- e.g. 'UNSPECIFIED'
    model varchar,
    -- e.g. 'OPERATIONAL'
    user_status varchar,
    -- e.g. 'SITENAME/SPS/CONTROL SERVICES/PLC CONTROL/LCC' 
    common_name varchar,
    -- e.g. 'SAI00123456'
    sai_number varchar,
    -- e.g. 'PLI00012345' (calculated by looking at rows to the left)
    superequi_id varchar,
    -- e.g. 'SAI00001000'
    site_reference varchar,
    -- e.g. 'SAI00001340'
    installation_or_subinstallation_number varchar,
    -- e.g. 'SITENAME/SPS'
    installation_or_subinstallation_name varchar,
    process_group_number varchar,
    process_number varchar,
    plant_number varchar,
    sub_plant_number varchar,
    plantitem_number varchar,
    sub_plantitem_number varchar,
    primary key (pli_number)
);    

  


-- For dates on or after 1899-12-30, Sqlserver's date string format is 
-- `hours:mins:secs.millis` where hours is always positive (or zero).
-- Dates before 1899-12-30 are stored as '%Y-%m-%d %H:%M:%S' 
-- e.g. '1898-01-01 00:00:00.000' 
-- 
create or replace temporary macro sqlserver_date(str varchar) as (
    coalesce(
        try(strptime(str, '%Y-%m-%d %H:%M:%S.%g')::dateTIME),
        try(date_add(date '1899-12-30', INTERVAL (try_cast(regexp_extract(str::varchar, '^(\d+):\d{2}:\d{2}', 1) as BIGINT)) HOUR))
    )
);


create or replace temporary macro make_common_name(xs varchar[]) as 
    list_aggregate(xs, 'string_agg', '/');

create or replace temporary macro split_plant_common_name(common_name varchar, process_atd varchar, process_group_atd varchar) as 
    coalesce(
        split_part(common_name, coalesce(process_atd, process_group_atd) || '/', 2),
        regexp_extract(common_name, '/([^/]*)$', 1),
        );

create or replace temporary macro split_sub_plant_common_name(common_name varchar, plant_common_name varchar) as 
    coalesce(
        split_part(common_name, plant_common_name || '/', 2),
        regexp_extract(common_name, '/([^/]*)$', 1),
        );


-- ai2 export:
-- Read fixed set of columns and do multiple passes to keep 
-- memory usage low. Do no processing until the data is stored 
-- on disk otherwise we are getting out-of-memory memory issues

-- ## LOAD DATA


.print 'Loading ai2_floc_site_landing...'

create or replace table ai2_floc_site_landing as
select
    t."SiteReference" as sai_number,
    t."SiteCommonName" as site_name,
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, nulls=['NULL'], 
    columns={'*': 'varchar'}) t
where
    t."SiteReference" is not null
and t."SiteCommonName" is not null;



.print 'Loading ai2_floc_installation_landing...'

create or replace table ai2_floc_installation_landing as
select
    t."InstallationReference" as sai_reference,
    t."InstallationCommonName" as common_name,
    t."InstallationStatus" as user_status,
    t."InstallationTypeCode",
    t."InstallationTypeDescription" as type_decription,
    t."SiteReference" as site_reference,
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
where
    t."InstallationReference" is not null;

.print 'Loading ai2_floc_sub_installation_landing...'

create or replace table ai2_floc_sub_installation_landing as
select
    t."SubInstallationReference" as sai_reference,
    t."SubInstallationCommonName" as common_name,
    t."SubInstallationStatus" as user_status,
    t."SubInstallationTypeCode",
    t."SubInstallationTypeDescription" as type_decription,
    t."SiteReference" as parent_ref,
    t."InstallationReference",
    t."SiteReference" as site_reference,
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
where
    t."SubInstallationReference" is not null;



.print 'Loading ai2_floc_process_group_landing...'

-- Don't bother with 'ProcessGroupAssetTypeCode' it is a numeric enum
-- that we don't have coding information for.
-- No 'ProcessGroupCommonName' column.
create or replace table ai2_floc_process_group_landing as
select
    t."ProcessGroupReference" as sai_reference,
    make_common_name([coalesce(t."SubInstallationCommonName", t."InstallationCommonName"), 
        t."ProcessGroupAssetTypeDescription"]) as common_name,        
    t."ProcessGroupStatus" as user_status,
    t."ProcessGroupAssetTypeDescription" as type_decription, -- e.g. 'CONTROL SERVICES'
    coalesce(t."SubInstallationReference", t."InstallationReference") as parent_ref,
    t."SiteReference" as site_reference,
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."InstallationReference",
    t."InstallationCommonName",
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
where
    t."ProcessGroupReference" is not null;


.print 'Loading ai2_floc_process_landing...'

-- Don't bother with 'ProcessAssetTypeCode' it is a numeric enum
-- that we don't have coding information for.
-- No 'ProcessCommonName' column.
create or replace table ai2_floc_process_landing as
select
    t."ProcessReference" as sai_reference,
    make_common_name([coalesce(t."SubInstallationCommonName", t."InstallationCommonName"),
        t."ProcessGroupAssetTypeDescription",
        t."ProcessAssetTypeDescription"]) as common_name,
    t."ProcessStatus" as user_status,
    t."ProcessAssetTypeDescription" as type_decription,        -- e.g. 'RTS MONITORING'
    coalesce(t."ProcessGroupReference", 
        t."SubInstallationReference", 
        t."InstallationReference") as parent_ref,
    t."SiteReference" as site_reference,
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."InstallationReference",
    t."InstallationCommonName",
    t."ProcessGroupReference",
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
where
    t."ProcessReference" is not null;


.print 'Loading ai2_floc_plant_landing...'

create or replace table ai2_floc_plant_landing as
select
    t."PlantReference" as sai_reference,
    t."PlantCommonName" as common_name,
    t."PlantStatus" as user_status,
    t."PlantAssetTypeDescription" as type_decription,
    coalesce(t."ProcessReference", 
        t."ProcessGroupReference", 
        t."SubInstallationReference", 
        t."InstallationReference") as parent_ref,
    t."SiteReference" as site_reference,
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."InstallationReference",
    t."InstallationCommonName",
    t."ProcessReference",
    t."ProcessGroupReference",
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
where
    t."PlantReference" is not null;


.print 'Loading ai2_floc_sub_plant_landing...'

create or replace table ai2_floc_sub_plant_landing as
select
    t."SubPlantReference" as sai_reference,
    t."SubPlantCommonName" as common_name,
    t."SubPlantStatus" as user_status,
    t."SubPlantAssetTypeDescription" as type_decription,
    coalesce(t."PlantReference",
        t."ProcessReference", 
        t."ProcessGroupReference", 
        t."SubInstallationReference", 
        t."InstallationReference") as parent_ref,
    t."SiteReference" as site_reference,
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."InstallationReference",
    t."InstallationCommonName",
    t."PlantReference",
    t."ProcessReference",
    t."ProcessGroupReference",
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
where
    t."SubPlantReference" is not null;


.print 'Loading ai2_floc_plantitem_landing...'

create or replace table ai2_floc_plantitem_landing as
select
    t."PlantItemReference" as sai_reference,
    t."PlantItemCommonName" as common_name,
    t."PlantItemStatus" as user_status,
    t."PlantItemAssetTypeDescription" as type_decription,
    coalesce(t."PlantReference",
        t."ProcessReference", 
        t."ProcessGroupReference", 
        t."SubInstallationReference", 
        t."InstallationReference") as parent_ref,

    t."SiteReference" as site_reference,
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."InstallationReference",
    t."InstallationCommonName",
    t."SubPlantReference",
    t."PlantReference",
    t."ProcessReference",
    t."ProcessGroupReference",
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
where
    t."PlantItemReference" is not null;

.print 'Loading ai2_floc_sub_plantitem_landing...'

create or replace table ai2_floc_sub_plantitem_landing as
select
    t."SubPlantItemReference" as sai_reference,
    t."SubPlantItemCommonName" as common_name,
    t."SubPlantItemStatus" as user_status,
    t."SubPlantItemAssetTypeDescription" as type_decription,
    coalesce(t."PlantItemReference",
        t."PlantReference",
        t."ProcessReference", 
        t."ProcessGroupReference", 
        t."SubInstallationReference", 
        t."InstallationReference") as parent_ref,
    t."SiteReference" as site_reference,
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."InstallationReference",
    t."InstallationCommonName",
    t."PlantItemReference",
    t."SubPlantReference",
    t."PlantReference",
    t."ProcessReference",
    t."ProcessGroupReference",
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*': 'varchar'}) t
where
    t."SubPlantItemReference" is not null;


-- equipment


.print 'Loading ai2_equi_plant_landing...'

-- 'PlantCommonName' column is common_name minus "EQUIPMENT: ..."
create or replace table ai2_equi_plant_landing as
select
    t."PlantEquipReference" as pli_reference,
    t."PlantReference" as sai_number,
    t."PlantEquipInstalledFromDate" as installed_from_date,
    t."PlantEquipManufacturer" as manufacturer,
    t."PlantEquipModel" as model,
    t."PlantEquipStatus" as user_status,
    t."PlantEquipAssetTypeCode" as equi_type_code,
    t."PlantEquipAssetTypeDescription" as equi_type_name, -- e.g. 'EQUIPMENT: PLC'
    t."SiteReference" as site_reference,
    t."PlantCommonName", 
    t."ProcessAssetTypeDescription", 
    t."ProcessGroupAssetTypeDescription",
    t."PlantEquipAssetTypeDescription",
    
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."InstallationReference",
    t."InstallationCommonName",
    t."ProcessReference",
    t."ProcessGroupReference",
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
where
    t."PlantEquipRuleDeleted" = '0'
and t."PlantEquipReference" is not null;


.print 'Loading ai2_equi_sub_plant_landing...'

create or replace table ai2_equi_sub_plant_landing as
select
    t."SubPlantEquipReference" as pli_reference,
    t."SubPlantReference" as sai_number,
    t."SubPlantEquipInstalledFromDate" as installed_from_date,
    t."SubPlantEquipManufacturer" as manufacturer,
    t."SubPlantEquipModel" as model,
    t."SubPlantEquipStatus" as user_status,
    t."SubPlantEquipAssetTypeCode" as equi_type_code,
    t."SubPlantEquipAssetTypeDescription" as equi_type_name,
    t."PlantEquipReference" as superequi_id,
    t."SiteReference" as site_reference,
    t."PlantCommonName",
    t."SubPlantCommonName",
    t."SubPlantEquipAssetTypeDescription",
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."InstallationReference",
    t."InstallationCommonName",
    t."PlantReference",
    t."ProcessReference",
    t."ProcessGroupReference",
from read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
where
    t."SubPlantEquipRuleDeleted" = '0'
and t."SubPlantEquipReference" is not null;

.print 'Loading ai2_equi_plantitem_landing...'

create or replace table ai2_equi_plantitem_landing as
SELECT
    t."PlantItemEquipReference" as pli_reference,
    t."PlantItemReference" as sai_number,
    t."PlantItemEquipInstalledFromDate" as installed_from_date,
    t."PlantItemEquipManufacturer" as manufacturer,
    t."PlantItemEquipModel" as model,
    t."PlantItemEquipStatus" as user_status,
    t."PlantItemEquipAssetTypeCode" as equi_type_code,
    t."PlantItemEquipAssetTypeDescription" as equi_type_name,
    t."PlantEquipReference" as superequi_id,        -- plant equipment (not sub plant equipment)
    t."SiteReference" as  site_reference,
    t."PlantItemCommonName",
    t."PlantCommonName", 
    t."PlantItemEquipAssetTypeDescription",
    t."PlantReference",
    t."SubPlantReference",
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."InstallationReference",
    t."InstallationCommonName",
    t."SubPlantReference",
    t."PlantReference",
    t."ProcessReference",
    t."ProcessGroupReference",
FROM read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
WHERE
    t."PlantItemEquipRuleDeleted" = '0'
AND t."PlantItemEquipReference" IS NOT NULL;


.print 'Loading ai2_equi_sub_plantitem_landing...'

create or replace table ai2_equi_sub_plantitem_landing as
SELECT
    t."SubPlantItemEquipReference" as pli_reference,
    t."SubPlantItemReference" as sai_number,
    t."SubPlantItemEquipInstalledFromDate" as installed_from_date,
    t."SubPlantItemEquipManufacturer" as manufacturer,
    t."SubPlantItemEquipModel" as model,
    t."SubPlantItemEquipStatus" as user_status,
    t."SubPlantItemEquipAssetTypeCode" as equi_type_code,
    t."SubPlantItemEquipAssetTypeDescription" as equi_type_name,
    t."PlantItemEquipReference" as superequi_id,        -- plantitem equipment
    t."SiteReference" as site_reference,
    t."SubPlantItemCommonName",
    t."SubPlantItemEquipAssetTypeDescription",
    t."PlantItemCommonName",
    t."SubInstallationReference",
    t."SubInstallationCommonName",
    t."InstallationReference",
    t."InstallationCommonName",
    t."PlantItemReference",
    t."SubPlantReference",
    t."PlantReference",
    t."ProcessReference",
    t."ProcessGroupReference",
FROM read_sheet(
    getvariable('ai2_masterdata_srcpath'), 
    sheet='Sheet1', 
    error_as_null=true, 
    nulls=['NULL'], 
    columns={'*FromDate': 'varchar'}) t
WHERE
    t."SubPlantItemEquipRuleDeleted" = '0'
AND t."SubPlantItemEquipReference" IS NOT NULL;



-------------------------------------------------------------------------------
-- final tables

-- ai2_site 

-- Source has duplicates

delete from ai2_site_simple;

.print 'Inserting data into ai2_site_simple...'

insert or replace into ai2_site_simple by name
select 
    t.sai_number as sai_number,
    any_value(t.site_name) as site_name,
from ai2_floc_site_landing t
group by all;


-- ai2_floc

delete from ai2_floc;


.print 'Inserting installation data into ai2_floc...'

insert or replace into ai2_floc by name
select 
    t.sai_reference as sai_number,
    t.common_name,
    any_value(t.user_status) as user_status,
    any_value(t.type_decription) as type_decription,
    null as parent_ref,
    'INSTALLATION' as floc_source_type,
    t.site_reference,
    t.sai_reference as installation_or_subinstallation_number,
    t.common_name as installation_or_subinstallation_name,
    null as process_group_number,
    null as process_number,
    null as plant_number,
    null as sub_plant_number,
    null as plantitem_number,
    null as sub_plantitem_number,
from ai2_floc_installation_landing t
group by all;


.print 'Inserting sub_installation data into ai2_floc...'

insert or replace into ai2_floc by name
select 
    t.sai_reference as sai_number,
    t.common_name,
    any_value(t.user_status) as user_status,
    any_value(t.type_decription) as type_decription,
    any_value(t.parent_ref) as parent_ref,
    'SUB_INSTALLATION' as floc_source_type,
    t.site_reference,
    t.sai_reference as installation_or_subinstallation_number,
    t.common_name as installation_or_subinstallation_name,
    null as process_group_number,
    null as process_number,
    null as plant_number,
    null as sub_plant_number,
    null as plantitem_number,
    null as sub_plantitem_number,
from ai2_floc_sub_installation_landing t
group by all;


.print 'Inserting process_group data into ai2_floc...'

insert or replace into ai2_floc by name
select 
    t.sai_reference as sai_number,
    t.common_name,
    any_value(t.user_status) as user_status,
    any_value(t.type_decription) as type_decription,
    any_value(t.parent_ref) as parent_ref,
    'PROCESS_GROUP' as floc_source_type,
    t.site_reference,
    coalesce(t."SubInstallationReference", 
        t."InstallationReference") as installation_or_subinstallation_number,
    coalesce(t."SubInstallationCommonName", 
        t."InstallationCommonName") as installation_or_subinstallation_name,
    t.sai_reference as process_group_number,
    null as process_number,
    null as plant_number,
    null as sub_plant_number,
    null as plantitem_number,
    null as sub_plantitem_number,        
from ai2_floc_process_group_landing t
group by all;



.print 'Inserting process data into ai2_floc...'

insert or replace into ai2_floc by name
select
    t.sai_reference as sai_number,
    t.common_name,
    any_value(t.user_status) as user_status,
    any_value(t.type_decription) as type_decription,
    any_value(t.parent_ref) as parent_ref,
    'PROCESS' as floc_source_type,
    t.site_reference,
    coalesce(t."SubInstallationReference", 
        t."InstallationReference") as installation_or_subinstallation_number,
    coalesce(t."SubInstallationCommonName", 
        t."InstallationCommonName") as installation_or_subinstallation_name,
    t."ProcessGroupReference" as process_group_number,
    t.sai_reference as process_number,
    null as plant_number,
    null as sub_plant_number,
    null as plantitem_number,
    null as sub_plantitem_number,
from ai2_floc_process_landing t
group by all;


.print 'Inserting plant data into ai2_floc...'

insert or replace into ai2_floc by name
select
    t.sai_reference as sai_number,
    t.common_name,
    any_value(t.user_status) as user_status,
    any_value(t.type_decription) as type_decription,
    any_value(t.parent_ref) as parent_ref,
    'PLANT' as floc_source_type,
    t.site_reference,
    coalesce(t."SubInstallationReference", 
        t."InstallationReference") as installation_or_subinstallation_number,
    coalesce(t."SubInstallationCommonName", 
        t."InstallationCommonName") as installation_or_subinstallation_name,
    t."ProcessGroupReference" as process_group_number,
    t."ProcessReference" as process_number,
    t.sai_reference plant_number,
    null as sub_plant_number,
    null as plantitem_number,
    null as sub_plantitem_number,
from ai2_floc_plant_landing t
group by all;

.print 'Inserting sub_plant data into ai2_floc...'

insert or replace into ai2_floc by name
select
    t.sai_reference as sai_number,
    t.common_name,
    any_value(t.user_status) as user_status,
    any_value(t.type_decription) as type_decription,
    any_value(t.parent_ref) as parent_ref,
    'SUB_PLANT' as floc_source_type,
    t.site_reference,
    coalesce(t."SubInstallationReference", 
        t."InstallationReference") as installation_or_subinstallation_number,
    coalesce(t."SubInstallationCommonName", 
        t."InstallationCommonName") as installation_or_subinstallation_name,
    t."ProcessGroupReference" as process_group_number,
    t."ProcessReference" as process_number,
    t."PlantReference" plant_number,
    t.sai_reference as sub_plant_number,
    null as plantitem_number,
    null as sub_plantitem_number,
from ai2_floc_sub_plant_landing t
group by all;


.print 'Inserting plantitem data into ai2_floc...'

insert or replace into ai2_floc by name
select
    t.sai_reference as sai_number,
    t.common_name,
    any_value(t.user_status) as user_status,
    any_value(t.type_decription) as type_decription,
    any_value(t.parent_ref) as parent_ref,
    'PLANTITEM' as floc_source_type,
    t.site_reference,
    coalesce(t."SubInstallationReference", 
        t."InstallationReference") as installation_or_subinstallation_number,
    coalesce(t."SubInstallationCommonName", 
        t."InstallationCommonName") as installation_or_subinstallation_name,
    t."ProcessGroupReference" as process_group_number,
    t."ProcessReference" as process_number,
    t."PlantReference" plant_number,
    t."SubPlantReference" as sub_plant_number,
    t.sai_reference as plantitem_number,
    null as sub_plantitem_number,
from ai2_floc_plantitem_landing t
group by all;

.print 'Inserting sub_plantitem data into ai2_floc...'

insert or replace into ai2_floc by name
select
    t.sai_reference as sai_number,
    t.common_name,
    any_value(t.user_status) as user_status,
    any_value(t.type_decription) as type_decription,
    any_value(t.parent_ref) as parent_ref,
    'SUB_PLANTITEM' as floc_source_type,
    t.site_reference,
    coalesce(t."SubInstallationReference", 
        t."InstallationReference") as installation_or_subinstallation_number,
    coalesce(t."SubInstallationCommonName", 
        t."InstallationCommonName") as installation_or_subinstallation_name,
    t."ProcessGroupReference" as process_group_number,
    t."ProcessReference" as process_number,
    t."PlantReference" plant_number,
    t."SubPlantReference" as sub_plant_number,
    t."PlantItemReference" as plantitem_number,
    t.sai_reference as sub_plantitem_number,
from ai2_floc_sub_plantitem_landing t
group by all;


-- ai2_equi

delete from ai2_equi;

.print 'Inserting plant data into ai2_equi...'

insert or replace into ai2_equi by name
select 
    t.pli_reference as pli_number,
    split_plant_common_name(t."PlantCommonName", 
        t."ProcessAssetTypeDescription", 
        t."ProcessGroupAssetTypeDescription") as equipment_name,
    make_common_name([t."PlantCommonName", 
        t."PlantEquipAssetTypeDescription"]) as common_name,  -- add "EQUIPMENT: ..."
    t.equi_type_name,
    t.equi_type_code,
    sqlserver_date(t.installed_from_date) as installed_from_date,
    t.manufacturer,
    t.model,
    t.user_status,
    t.sai_number,
    null as superequi_id,
    t.site_reference,
    coalesce(t."SubInstallationReference", 
        t."InstallationReference") as installation_or_subinstallation_number,
    coalesce(t."SubInstallationCommonName", 
        t."InstallationCommonName") as installation_or_subinstallation_name,
    t."ProcessGroupReference" as process_group_number,
    t."ProcessReference" as process_number,
    t.sai_number plant_number,
    null as sub_plant_number,
    null as plantitem_number,
    null as sub_plantitem_number,        
from ai2_equi_plant_landing t;



.print 'Inserting sub_plant data into ai2_equi...'

insert or replace into ai2_equi by name
select 
    t.pli_reference as pli_number,
    split_sub_plant_common_name(t."SubPlantCommonName", 
        t."PlantCommonName") as equipment_name,
    make_common_name([t."SubPlantCommonName", 
        t."SubPlantEquipAssetTypeDescription"]) as common_name,  -- add "EQUIPMENT: ..."
    t.equi_type_name,
    t.equi_type_code,
    sqlserver_date(t.installed_from_date) as installed_from_date,
    t.manufacturer,
    t.model,
    t.user_status,
    t.sai_number,
    t.superequi_id,
    t.site_reference,
    coalesce(t."SubInstallationReference", 
        t."InstallationReference") as installation_or_subinstallation_number,
    coalesce(t."SubInstallationCommonName", 
        t."InstallationCommonName") as installation_or_subinstallation_name,
    t."ProcessGroupReference" as process_group_number,
    t."ProcessReference" as process_number,
    t."PlantReference" plant_number,
    t.sai_number as sub_plant_number,
    null as plantitem_number,
    null as sub_plantitem_number,
from ai2_equi_sub_plant_landing t;



.print 'Inserting plantitem data into ai2_equi...'

insert or replace into ai2_equi by name
select 
    t.pli_reference as pli_number,
    split_sub_plant_common_name(t."PlantItemCommonName", 
        t."PlantCommonName") as equipment_name,
    make_common_name([t."PlantItemCommonName", 
        t."PlantItemEquipAssetTypeDescription"]) as common_name,  -- add "EQUIPMENT: ..."
    t.equi_type_name,
    t.equi_type_code,
    sqlserver_date(t.installed_from_date) as installed_from_date,
    t.manufacturer,
    t.model,
    t.user_status,
    t.sai_number,
    t.superequi_id,
    coalesce(t."SubInstallationReference", 
        t."InstallationReference") as installation_or_subinstallation_number,
    t.site_reference,coalesce(t."SubInstallationCommonName", 
        t."InstallationCommonName") as installation_or_subinstallation_name,
    t."ProcessGroupReference" as process_group_number,
    t."ProcessReference" as process_number,
    t."PlantReference" plant_number,
    t."SubPlantReference" as sub_plant_number,
    t.sai_number as plantitem_number,
    null as sub_plantitem_number,
from ai2_equi_plantitem_landing t;

-- insert part 4 
.print 'Inserting sub_plantitem data into ai2_equi...'

insert or replace into ai2_equi by name
select 
    t.pli_reference as pli_number,
    split_sub_plant_common_name(t."SubPlantItemCommonName", 
        t."PlantItemCommonName") as equipment_name,
    make_common_name([t."SubPlantItemCommonName", 
        t."SubPlantItemEquipAssetTypeDescription"]) as common_name,  -- add "EQUIPMENT: ..."
    t.equi_type_name,
    t.equi_type_code,
    sqlserver_date(t.installed_from_date) as installed_from_date,
    t.manufacturer,
    t.model,
    t.user_status,
    t.sai_number,
    t.superequi_id,
    t.site_reference,
    coalesce(t."SubInstallationReference", 
        t."InstallationReference") as installation_or_subinstallation_number,
    coalesce(t."SubInstallationCommonName", 
        t."InstallationCommonName") as installation_or_subinstallation_name,
    t."ProcessGroupReference" as process_group_number,
    t."ProcessReference" as process_number,
    t."PlantReference" plant_number,
    t."SubPlantReference" as sub_plant_number,
    t."PlantItemReference" as plantitem_number,
    t.sai_number as sub_plantitem_number,        
from ai2_equi_sub_plantitem_landing t;



-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ai2_equi) TO '$(AIB_MasTER_OUTPATH)' (FORMAT parquet, COMPRESSION uncompressed);






 
