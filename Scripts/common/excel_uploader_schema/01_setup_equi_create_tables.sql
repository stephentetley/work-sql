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

.print "Running 01_setup_equi_create_tables.sql..."


CREATE SCHEMA IF NOT EXISTS excel_uploader_equi_create;



-- The tables and views follow a pattern - the table contains just the fields 
-- a client needs to fill out, the view corresponds to a sheet in the uploader
-- xlsx file

CREATE OR REPLACE TABLE excel_uploader_equi_create.change_request_header (
    usmd_crequest VARCHAR,
    change_request_decription VARCHAR,
);

CREATE OR REPLACE VIEW excel_uploader_equi_create.vw_change_request_header AS
SELECT 
    t.usmd_crequest AS "Change Request",
    t.change_request_decription AS "Change Request Description",
    cast(null AS VARCHAR) AS "Priority",
    cast(null AS VARCHAR) AS "Due Date",
FROM excel_uploader_equi_create.change_request_header t;
    
    

CREATE OR REPLACE TABLE excel_uploader_equi_create.change_request_notes (
    usmd_note VARCHAR NOT NULL,
);


-- equipment is just the fields client code needs to fill out...
CREATE OR REPLACE TABLE excel_uploader_equi_create.equipment_data (
    equi VARCHAR NOT NULL,
    category VARCHAR,
    equi_description VARCHAR NOT NULL,
    object_type VARCHAR,
    gross_weight DECIMAL,
    unit_of_weight VARCHAR,
    start_up_date DATETIME,
    manufacturer VARCHAR,
    model_number VARCHAR,
    manuf_part_no VARCHAR,
    manuf_serial_number VARCHAR,
    maint_plant VARCHAR,
    catalog_profile VARCHAR,
    functional_loc VARCHAR,
    superord_equip VARCHAR,
    position INTEGER,
    tech_ident_no VARCHAR,
    status_profile VARCHAR,
    status_of_an_object VARCHAR,
    status_without_stsno VARCHAR,
    PRIMARY KEY (equi)
);



-- No Primary Key - multiples allowed
CREATE OR REPLACE TABLE excel_uploader_equi_create.classification (
    equi VARCHAR NOT NULL,
    class_name VARCHAR NOT NULL,
    characteristics VARCHAR NOT NULL,
    char_value VARCHAR,
);

CREATE OR REPLACE TABLE excel_uploader_equi_create.batch_worklist (
    equi VARCHAR NOT NULL,
    batch_number INTEGER,
    PRIMARY KEY (equi)
);

-- Views



CREATE OR REPLACE VIEW excel_uploader_equi_create.vw_equipment_data AS
SELECT 
    t1.batch_number AS batch_number,
    t.equi AS "Equipment",
    t.category AS "EquipCategory",
    t.equi_description AS "Description (medium)",
    cast(null AS VARCHAR) AS "Valid From",
    cast(null AS VARCHAR) AS "Inactive",
    t.object_type AS "Object type",
    cast(null AS VARCHAR) AS "AuthorizGroup",
    t.gross_weight AS "Gross Weight",
    t.unit_of_weight AS "Unit of weight",
    cast(null AS VARCHAR) AS "Inventory no",
    cast(null AS VARCHAR) AS "Size/dimens",
    strftime(t.start_up_date, '%d.%m.%Y') AS "Start-up date",
    cast(null AS DECIMAL(14,3)) AS "AcquisitionValue",
    cast(null AS VARCHAR) AS "Currency",
    cast(null AS VARCHAR) AS "Acquistion date",
    t.manufacturer AS "Manufacturer",
    t.model_number AS "Model number",
    t.manuf_part_no AS "ManufPartNo",
    t.manuf_serial_number AS "ManufSerialNo",
    cast(null AS VARCHAR) AS "ManufCountry",
    strftime(t.start_up_date, '%Y') AS "ConstructYear",
    strftime(t.start_up_date, '%m') AS "ConstructMth",
    t.maint_plant AS "MaintPlant",
    cast(null AS VARCHAR) AS "Plant section",
    cast(null AS VARCHAR) AS "Location",
    cast(null AS VARCHAR) AS "Room",
    cast(null AS VARCHAR) AS "ABC indic",
    cast(null AS VARCHAR) AS "Work center",
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
    t.catalog_profile AS "Catalog profile",
    t.functional_loc AS "Functional loc.",
    t.superord_equip AS "Superord.Equip.",
    printf('%04d', t.position) AS "Position",
    t.tech_ident_no AS "TechIdentNo.",
    cast(null AS VARCHAR) AS "Construction type Ma",
    cast(null AS VARCHAR) AS "Material",
    cast(null AS VARCHAR) AS "Material Serial Numb",
    cast(null AS VARCHAR) AS "Config.material",
    t.status_profile AS "Status Profile",
    t.status_of_an_object AS "Status of an object",
    t.status_without_stsno AS "Status without stsno",
    cast(null AS VARCHAR) AS "Sales Org",
    cast(null AS VARCHAR) AS "Distr. Channel",
    cast(null AS VARCHAR) AS "Division",
    cast(null AS VARCHAR) AS "Sales Office",
    cast(null AS VARCHAR) AS "Sales Group",
    cast(null AS VARCHAR) AS "License no.",
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
    cast(null AS VARCHAR) AS "Vendor",
    cast(null AS VARCHAR) AS "Customer",
    cast(null AS VARCHAR) AS "End customer",
    cast(null AS VARCHAR) AS "CurCustomer",
    cast(null AS VARCHAR) AS "Operator",
    cast(null AS VARCHAR) AS "Delivery date",
FROM excel_uploader_equi_create.equipment_data t
JOIN excel_uploader_equi_create.batch_worklist t1 ON t1.equi = t.equi
ORDER BY t.equi;


CREATE OR REPLACE VIEW excel_uploader_equi_create.vw_classification AS
SELECT 
    t1.batch_number AS batch_number,
    t.equi AS "Equipment",
    t.class_name AS "Class",
    t.characteristics AS "Characteristics",
    t.char_value AS "Char Value",
FROM excel_uploader_equi_create.classification t
JOIN excel_uploader_equi_create.batch_worklist t1 ON t1.equi = t.equi
ORDER BY t.equi, t.class_name, t.characteristics;





