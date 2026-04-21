.print 'Running s4_masterdata.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

-- ## CREATE TABLES


CREATE OR REPLACE TABLE s4_equi (
    -- e.g. 101003320
    equipment_id BIGINT NOT NULL,
    -- e.g. 'Outstation'
    equipment_name VARCHAR,
    -- e.g. 'XYZ10-CAA-NET-FBC-SYS01'
    functional_location VARCHAR,
    -- e.g. 101003319
    superequi_id BIGINT,
    -- e.g. 'C'
    category VARCHAR,
    -- e.g. 'PUMP'
    obj_type VARCHAR,
    -- e.g. 'PUMPMO'
    std_class VARCHAR,
    -- e.g. '2017-09-12'
    startup_date DATE,
    -- e.g. 'TO BE DETERMINED'
    manufacturer VARCHAR,
    -- e.g. 'TO BE DETERMINED'
    model VARCHAR,
    -- e.g. 'TO BE DETERMINED'
    specific_model_frame VARCHAR,
    -- e.g. 'TO BE DETERMINED'
    serial_number VARCHAR,
    -- e.g. 'PUM01'
    tech_ident_number VARCHAR,
    -- e.g. 'OPER'
    user_status VARCHAR,
    -- e.g. 3100
    planning_plant VARCHAR,
    -- e.g. 80125
    address_number INTEGER,
    PRIMARY KEY (equipment_id)
);

CREATE OR REPLACE TABLE s4_floc (
    -- e.g. 'XYZ10-CAA-NET-FBC'
    functional_location VARCHAR NOT NULL,
    -- e.g. 'Networks'
    funcloc_name VARCHAR,
    -- e.g. 'C'
    category INTEGER,
    -- e.g. true
    installation_allowed BOOLEAN,
    -- e.g. 'PUMP'
    object_type VARCHAR,
    -- e.g. 145353
    cost_center INTEGER,
    -- e.g. 3100
    planning_plant INTEGER,
    -- e.g. 3110
    maintenance_plant INTEGER,
    -- e.g. 'NW_KEIG'
    maint_work_center VARCHAR,
    -- e.g. 'FLS'
    plant_section VARCHAR,
    -- e.g. '2017-09-12'
    startup_date DATE,
    -- e.g. 'YW-ES'
    structure_indicator VARCHAR,
    -- e.g. 'XYZ10-CAA-NET'
    superior_funcloc VARCHAR,
    -- e.g. 'OPER'
    user_status VARCHAR,
    -- e.g. 3100
    company_code INTEGER,
    -- e.g. 80125
    address_number INTEGER,
    PRIMARY KEY (functional_location)
);


CREATE OR REPLACE TABLE s4_equi_to_plinum (
    s4_equipment_id BIGINT,
    ai2_plinum VARCHAR,
);

CREATE OR REPLACE TABLE s4_equi_to_sainum (
    s4_equipment_id BIGINT,
    ai2_sainum VARCHAR,
);

CREATE OR REPLACE TABLE s4_floc_east_north (
    s4_floc VARCHAR,
    easting INTEGER,
    northing INTEGER,
    PRIMARY KEY (s4_floc)
);

-- read landing data

.print 'Loading s4_floc_data_landing...'

-- Setup the environment variable `S4_FLOC_PARQUET_GLOBPATH` before running this file
SELECT getenv('S4_FLOC_PARQUET_GLOBPATH') AS S4_FLOC_PARQUET_GLOBPATH;


CREATE OR REPLACE TABLE s4_floc_data_landing AS
SELECT 
    * 
FROM read_parquet(getenv('S4_FLOC_PARQUET_GLOBPATH'));


.print 'Loading s4_equi_data_landing...'


-- Setup the environment variable `S4_EQUI_PARQUET_GLOBPATH` before running this file
SELECT getenv('S4_EQUI_PARQUET_GLOBPATH') AS S4_EQUI_PARQUET_GLOBPATH;

CREATE OR REPLACE TABLE s4_equi_data_landing AS
SELECT 
    * 
FROM read_parquet(getenv('S4_EQUI_PARQUET_GLOBPATH'));



.print 'Loading s4_equi_aib_refs_data_landing...'

-- Setup the environment variable `S4_EQUI_AIBREF_PARQUET_GLOBPATH` before running this file
SELECT getenv('S4_EQUI_AIBREF_PARQUET_GLOBPATH') AS S4_EQUI_AIBREF_PARQUET_GLOBPATH;


CREATE OR REPLACE TABLE s4_equi_aib_refs_data_landing AS
SELECT 
    * 
FROM read_parquet(getenv('S4_EQUI_AIBREF_PARQUET_GLOBPATH'));


.print 'Inserting s4_equi_data_landing data into s4_equi...'

DELETE FROM s4_equi;
INSERT OR REPLACE INTO s4_equi BY NAME
SELECT 
    try_cast(t."Equipment" AS BIGINT) AS equipment_id,
    t."Description of technical object" AS equipment_name,
    t."Functional Location" AS functional_location,
    try_cast(t."Superord. Equipment" AS BIGINT) AS superequi_id,
    t."Equipment category" AS category,
    t."Object Type" AS obj_type,
    t."Standard Class" AS std_class,
    try(strptime(t."Start-up date", '%Y-%m-%d')::DATE) AS startup_date,
    t."Manufacturer of Asset" AS manufacturer,
    t."Model number" AS model,
    t."Manufacturer part number" AS specific_model_frame,
    t."Manufacturer's Serial Number" AS serial_number,
    t."Technical identification no." AS tech_ident_number,
    t."User Status" AS user_status,
    try_cast(t."Planning Plant" AS INTEGER) AS planning_plant,
    try_cast(t."Address number" AS INTEGER) AS address_number,
FROM s4_equi_data_landing t;

.print 'Inserting s4_floc_data_landing data into s4_floc...'

DELETE FROM s4_floc;
INSERT OR REPLACE INTO s4_floc BY NAME
SELECT 
    t."Functional Location" AS functional_location,
    t."Description of functional location" AS funcloc_name,
    try_cast(t."FunctLocCategory" AS INTEGER) AS category,
    IF(t."Installation allowed" = 'X', true, false) AS installation_allowed, -- BOOLEAN
    t."Object Type" AS object_type,
    try_cast(t."Cost Center" AS INTEGER) AS cost_center,
    try_cast(t."Planning Plant" AS INTEGER) AS planning_plant,
    try_cast(t."Maintenance Plant" AS INTEGER) AS maintenance_plant,
    t."Main Work Center" AS maint_work_center,
    t."Plant Section" AS plant_section,
    try(strptime(t."Start-up date", '%Y-%m-%d')::DATE) AS startup_date,
    t."Structure indicator" AS structure_indicator,
    t."Superior functional location" AS superior_funcloc,
    t."User Status" AS user_status,
    try_cast(t."Company Code" AS INTEGER) AS company_code,
    try_cast(t."Address number" AS INTEGER) AS address_number,
FROM s4_floc_data_landing t;

.print 'Inserting s4_equi_aib_refs_data_landing data into s4_equi_to_plinum...'

DELETE FROM s4_equi_to_plinum;
INSERT INTO s4_equi_to_plinum BY NAME
SELECT
    t."Equipment" AS s4_equipment_id,
    t."AI2 AIB Reference" AS ai2_plinum,
FROM s4_equi_aib_refs_data_landing t
WHERE t."AI2 AIB Reference" LIKE 'PLI%';

.print 'Inserting s4_equi_aib_refs_data_landing data into s4_equi_to_sainum...'

DELETE FROM s4_equi_to_sainum;
INSERT INTO s4_equi_to_sainum BY NAME
SELECT 
    t."Equipment" AS s4_equipment_id,
    t."AI2 AIB Reference" AS ai2_sainum,
FROM s4_equi_aib_refs_data_landing t
WHERE t."AI2 AIB Reference" IS NOT NULL
AND t."AI2 AIB Reference" NOT LIKE 'PLI%';



.print 'Inserting s4_floc_data easting northing data into s4_floc_east_north...'

DELETE FROM s4_floc_east_north;
INSERT OR REPLACE INTO s4_floc_east_north BY NAME
SELECT 
    t."Functional Location" AS s4_floc,
    t."Easting" AS easting,
    t."Northing" AS northing,
FROM s4_floc_data_landing t
WHERE t."Easting" IS NOT NULL
AND t."Northing" IS NOT NULL;




