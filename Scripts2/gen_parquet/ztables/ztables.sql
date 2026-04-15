.print 'Running site_mapping.sql...'

INSTALL excel;
LOAD excel;

-- ## CREATE TABLES

CREATE OR REPLACE TABLE ztable_eqobjl (
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

-- Setup the environment variable `ZTABLE_EQOBJL_XLS_PATH` before running this file
SELECT getenv('ZTABLE_EQOBJL_XLS_PATH') AS ZTABLE_EQOBJL_XLS_PATH;


INSERT INTO ztable_eqobjl
SELECT
    t."Object Type" AS 'object_type',
    t."Object Type_1" AS 'object_type_1',
    t."Equipment category" AS 'equipment_category',
    t."Remarks" AS 'remarks',
FROM read_xlsx(getenv('ZTABLE_EQOBJL_XLS_PATH'), all_varchar=true) AS t;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ztable_eqobjl) TO '$(ZTABLE_EQOBJL_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);

-- ## ZTABLE_FLOBJL

-- Setup the environment variable `ZTABLE_FLOBJL_XLS_PATH` before running this file
SELECT getenv('ZTABLE_FLOBJL_XLS_PATH') AS ZTABLE_FLOBJL_XLS_PATH;


INSERT INTO ztable_flobjl
SELECT
    t."Structure indicator" AS 'structure_indicator',
    t."Object Type" AS 'object_type',
    t."Object Type_1" AS 'object_type_1',
    t."Remarks" AS 'remarks',
FROM read_xlsx(getenv('ZTABLE_FLOBJL_XLS_PATH'), all_varchar=true) AS t;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ztable_flobjl) TO '$(ZTABLE_FLOBJL_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);

-- ## ZTABLE_FLOCDES

-- Setup the environment variable `ZTABLE_FLOCDES_XLS_PATH` before running this file
SELECT getenv('ZTABLE_FLOCDES_XLS_PATH') AS ZTABLE_FLOCDES_XLS_PATH;


INSERT INTO ztable_flocdes
SELECT 
    t."Object Type" AS 'object_type',
    t."Standard FLoc Description" AS 'standard_floc_description',
FROM read_xlsx(getenv('ZTABLE_FLOCDES_XLS_PATH'), all_varchar=true) AS t;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ztable_flocdes) TO '$(ZTABLE_FLOCDES_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);


-- ## ZTABLE_MANUF

-- Setup the environment variable `ZTABLE_MANUF_XLS_PATH` before running this file
SELECT getenv('ZTABLE_MANUF_XLS_PATH') AS ZTABLE_MANUF_XLS_PATH;


INSERT INTO ztable_manuf
SELECT 
    t."Manufacturer" AS 'manufacturer',
    t."Model Number" AS 'model',
FROM read_xlsx(getenv('ZTABLE_MANUF_XLS_PATH'), all_varchar=true) AS t;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ztable_manuf) TO '$(ZTABLE_MANUF_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);


-- ## ZTABLE_OBJTYPE_MANUF

-- Setup the environment variable `ZTABLE_OBJTYPE_MANUF_XLS_PATH` before running this file
SELECT getenv('ZTABLE_OBJTYPE_MANUF_XLS_PATH') AS ZTABLE_OBJTYPE_MANUF_XLS_PATH;


INSERT INTO ztable_objtype_manuf
SELECT 
    t."Object Type" AS 'object_type',
    t."Manufacturer" AS 'manufacturer',
    t."Remarks" AS 'remarks',
FROM read_xlsx(getenv('ZTABLE_OBJTYPE_MANUF_XLS_PATH'), all_varchar=true) AS t;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ztable_objtype_manuf) TO '$(ZTABLE_OBJTYPE+MANUF_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);








