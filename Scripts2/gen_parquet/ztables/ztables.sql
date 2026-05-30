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
-- The variable `site_mapping_xlsb_path` is set in DuckDb (i.e. not an env var)
-- The core extension `excel` is loaded:
-- D INSTALL excel;
-- D LOAD excel;


-- Set the variables
--  `ztable_eqobj_xls_path` 
--  `ztable_flobjl_xls_path` 
--  `ztable_flocdes_xls_path` 
--  `ztable_manuf_xls_path` 
--  `ztable_objtype_manuf_xls_path` 
-- before running this file

-- ## CREATE TABLES

CREATE OR REPLACE TABLE ztable_eqobj (
    object_type VARCHAR NOT NULL,
    object_type_1 VARCHAR NOT NULL,
    equipment_category VARCHAR,
    remarks VARCHAR
);


CREATE OR REPLACE TABLE ztable_flobjl (
    structure_indicator VARCHAR NOT NULL,
    object_type VARCHAR NOT NULL,
    object_type_1 VARCHAR NOT NULL,
    remarks VARCHAR,
);

CREATE OR REPLACE TABLE ztable_flocdes (
    object_type VARCHAR NOT NULL,
    standard_floc_description VARCHAR,
);

CREATE OR REPLACE TABLE ztable_manuf (
    manufacturer VARCHAR NOT NULL,
    model VARCHAR NOT NULL,
);

CREATE OR REPLACE TABLE ztable_objtype_manuf (
    object_type VARCHAR NOT NULL,
    manufacturer VARCHAR NOT NULL,
    remarks VARCHAR,
);

-- ## ZTABLE_EQOBJL



INSERT INTO ztable_eqobj
SELECT
    t."Object Type" AS 'object_type',
    t."Object Type_1" AS 'object_type_1',
    t."Equipment category" AS 'equipment_category',
    t."Remarks" AS 'remarks',
FROM read_xlsx(
    getvariable('ztable_eqobj_xls_path'), 
    all_varchar=true) AS t;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ztable_eqobjl) TO '$(ZTABLE_EQOBJL_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);

-- ## ZTABLE_FLOBJL

INSERT INTO ztable_flobjl
SELECT
    t."Structure indicator" AS 'structure_indicator',
    t."Object Type" AS 'object_type',
    t."Object Type_1" AS 'object_type_1',
    t."Remarks" AS 'remarks',
FROM read_xlsx(
    getvariable('ztable_flobjl_xls_path'), 
    all_varchar=true) AS t;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ztable_flobjl) TO '$(ZTABLE_FLOBJL_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);

-- ## ZTABLE_FLOCDES


INSERT INTO ztable_flocdes
SELECT 
    t."Object Type" AS 'object_type',
    t."Standard FLoc Description" AS 'standard_floc_description',
FROM read_xlsx(
    getvariable('ztable_flocdes_xls_path'), 
    all_varchar=true) AS t;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ztable_flocdes) TO '$(ZTABLE_FLOCDES_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);


-- ## ZTABLE_MANUF


INSERT INTO ztable_manuf
SELECT 
    t."Manufacturer" AS 'manufacturer',
    t."Model Number" AS 'model',
FROM read_xlsx(
    getvariable('ztable_manuf_xls_path'), 
    all_varchar=true) AS t;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ztable_manuf) TO '$(ZTABLE_MANUF_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);


-- ## ZTABLE_OBJTYPE_MANUF

INSERT INTO ztable_objtype_manuf
SELECT 
    t."Object Type" AS 'object_type',
    t."Manufacturer" AS 'manufacturer',
    t."Remarks" AS 'remarks',
FROM read_xlsx(
    getvariable('ztable_objtype_manuf_xls_path'), 
    all_varchar=true) AS t;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ztable_objtype_manuf) TO '$(ZTABLE_OBJTYPE_MANUF_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);








