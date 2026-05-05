    -- 
-- Copyright 2025 Stephen Tetley
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

.print "Running 03_setup_floc_create_tables.sql..."

CREATE SCHEMA IF NOT EXISTS excel_uploader_floc_create;



-- The tables and views follow a pattern - the table contains just the fields 
-- a client needs to fill out, the view corresponds to a sheet in the uploader
-- xlsx file

CREATE OR REPLACE TABLE excel_uploader_floc_create.change_request_header (
    usmd_crequest VARCHAR,
    change_request_decription VARCHAR,
);

CREATE OR REPLACE VIEW excel_uploader_floc_create.vw_change_request_header AS
SELECT 
    t.usmd_crequest AS "Change Request",
    t.change_request_decription AS "Change Request Description",
    cast(null AS VARCHAR) AS "Priority",
    cast(null AS VARCHAR) AS "Due Date",
FROM excel_uploader_floc_create.change_request_header t;
    
    

CREATE OR REPLACE TABLE excel_uploader_floc_create.change_request_notes (
    usmd_note VARCHAR NOT NULL,
);


-- functional_location is just the fields client code needs to fill out...
CREATE OR REPLACE TABLE excel_uploader_floc_create.functional_location (
    functional_location VARCHAR NOT NULL,
    floc_description VARCHAR NOT NULL,
    category VARCHAR,
    str_indicator VARCHAR,
    object_type VARCHAR,
    start_up_date DATETIME,
    maint_plant VARCHAR,
    plant_section VARCHAR,
    position INTEGER,
    status_profile VARCHAR,
    user_status VARCHAR,
    status_of_an_object VARCHAR,
    PRIMARY KEY (functional_location)
);



-- No Primary Key - multiples allowed
CREATE OR REPLACE TABLE excel_uploader_floc_create.classification (
    functional_location VARCHAR NOT NULL,
    class_name VARCHAR NOT NULL,
    characteristics VARCHAR NOT NULL,
    char_value VARCHAR,
);


CREATE OR REPLACE TABLE excel_uploader_floc_create.batch_worklist (
    functional_location VARCHAR NOT NULL,
    batch_number INTEGER,
);

-- Views


CREATE OR REPLACE VIEW excel_uploader_floc_create.vw_functional_location AS
SELECT 
    t1.batch_number AS batch_number,
    t.functional_location AS "Functional Location",
    t.floc_description AS "Description",
    t.category AS "FunctLocCat",
    t.str_indicator AS "StrIndicator",
    cast(null AS VARCHAR) AS "Inactive",
    t.object_type AS "Object type",
    cast(null AS VARCHAR) AS "AuthorizGroup",
    cast(null AS DECIMAL(13,3)) AS "Gross Weight",
    cast(null AS VARCHAR) AS "Unit of weight",
    cast(null AS VARCHAR) AS "Inventory no",
    cast(null AS VARCHAR) AS "Size/dimens",
    strftime(t.start_up_date, '%d.%m.%Y') AS "Start-up date",
    cast(null AS DECIMAL(14,3)) AS "AcquisitionValue",
    cast(null AS VARCHAR) AS "Currency",
    cast(null AS VARCHAR) AS "Acquistion date",
    cast(null AS VARCHAR) AS "Manufacturer",
    cast(null AS VARCHAR) AS "Model number",
    cast(null AS VARCHAR) AS "ManufPartNo",
    cast(null AS VARCHAR) AS "ManufSerialNo",
    cast(null AS VARCHAR) AS "ManufCountry",
    strftime(t.start_up_date, '%Y') AS "ConstructYear",
    strftime(t.start_up_date, '%m') AS "ConstructMth",
    t.maint_plant AS "MaintPlant",
    cast(null AS VARCHAR) AS "Location", 
    cast(null AS VARCHAR) AS "Room",
    t.plant_section AS "Plant section",
    cast(null AS VARCHAR) AS "Work center",
    cast(null AS VARCHAR) AS "ABC indic",
    cast(null AS VARCHAR) AS "Sort field",
    cast(null AS VARCHAR) AS "Business Area",
    cast(null AS VARCHAR) AS "Asset",
    cast(null AS VARCHAR) AS "Sub-number",
    cast(null AS VARCHAR) AS "Cost Center",
    cast(null AS VARCHAR) AS "WBS Element",
    cast(null AS VARCHAR) AS "StandgOrder",
    cast(null AS VARCHAR) AS "SettlementOrder",
    cast(null AS VARCHAR) AS "Planning plant",
    cast(null AS VARCHAR) AS "Planner group",
    cast(null AS VARCHAR) AS "Main WorkCtr",
    cast(null AS VARCHAR) AS "Plnt WorkCenter",
    cast(null AS VARCHAR) AS "Catalog profile",
    cast(null AS VARCHAR) AS "SupFunctLoc",
    printf('%04d', t.position) AS "Position",
    cast(null AS VARCHAR) AS "Ref. Location",
    IF(t.category IN ('5', '6'), 'X', null) AS "Installation Allowed",
    cast(null AS VARCHAR) AS "Single Inst.",
    cast(null AS VARCHAR) AS "Construction type",
    t.status_profile AS "Status Profile",
    t.user_status AS "User Status",
    t.status_of_an_object AS "Status of an object",
    cast(null AS VARCHAR) AS "Status without stsno",
    cast(null AS VARCHAR) AS "Begin guarantee(C)",
    cast(null AS VARCHAR) AS "Warranty end(C)",
    cast(null AS VARCHAR) AS "Master Warranty(C)",
    cast(null AS VARCHAR) AS "InheritWarranty(C)",
    cast(null AS VARCHAR) AS "Pass on warranty(C)",
    cast(null AS VARCHAR) AS "Begin guarantee(V)",
    cast(null AS VARCHAR) AS "Warranty end(V)",
    cast(null AS VARCHAR) AS "Master Warranty(V)",
    cast(null AS VARCHAR) AS "InheritWarranty(V)",
    cast(null AS VARCHAR) AS "Pass on warranty(V)",
    cast(null AS VARCHAR) AS "Sales Org",
    cast(null AS VARCHAR) AS "Distr. Channel",
    cast(null AS VARCHAR) AS "Division",
    cast(null AS VARCHAR) AS "Sales Office",
    cast(null AS VARCHAR) AS "Sales Group",
FROM excel_uploader_floc_create.functional_location t
JOIN excel_uploader_floc_create.batch_worklist t1 ON t1.functional_location = t.functional_location
ORDER BY t.category, t.functional_location;

CREATE OR REPLACE VIEW excel_uploader_floc_create.vw_classification AS
SELECT 
    t1.batch_number AS batch_number,
    t.functional_location AS "Functional Location",
    t.class_name AS "Class",
    t.characteristics AS "Characteristics",
    t.char_value AS "Char Value",
FROM excel_uploader_floc_create.classification t
JOIN excel_uploader_floc_create.batch_worklist t1 ON t1.functional_location = t.functional_location
ORDER BY t.functional_location, t.class_name, t.characteristics;


