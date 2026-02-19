.print 'Running 01_create_tables.sql...'

CREATE SCHEMA IF NOT EXISTS ai2_classlists;
CREATE SCHEMA IF NOT EXISTS ai2_classlists_landing;

CREATE OR REPLACE TABLE ai2_classlists.equi_characteristics (
    -- e.g. 'EQPTBBA'
    class_name VARCHAR NOT NULL,
    -- e.g. 'EQUIPMENT: DRY WELL'
    class_description VARCHAR NOT NULL,
    -- e.g. 'DRY WELL'
    class_description2 VARCHAR NOT NULL,
    -- e.g. 'Equiclass'
    class_derivation VARCHAR NOT NULL,
    -- e.g. 'Eq Dry Well'
    attribute_set_name VARCHAR,
    -- e.g. 'DRY_WELL'
    class_table_name VARCHAR,
    -- e.g. 'LocationOnSite'
    attribute_name VARCHAR NOT NULL,
    -- e.g. 'Location On Site'
    attribute_description VARCHAR,
    -- e.g. 'CHAR18'
    data_type VARCHAR,
    -- e.g. 'VARCHAR'
    ddl_data_type VARCHAR,
    -- e.g. 'SZUN'
    enum_name VARCHAR,
    PRIMARY KEY(class_name, attribute_set_name, attribute_name)
);


CREATE OR REPLACE VIEW ai2_classlists.vw_equiclass_characteristics AS
SELECT * 
FROM ai2_classlists.equi_characteristics t
WHERE t.attribute_description NOT IN (
    'Asset Name',
    'Asset Reference',
    'Asset Status',
    'Common Name',
    'Criticality Comments',
    'Installed From Date',
    'Manufacturer',
    'Memo Line 1',
    'Memo Line 2',
    'Memo Line 3',
    'Memo Line 4',
    'Memo Line 5',
    'Model Name',
    'P AND I Tag No',
    'Serial No',
    'Specific Model/Frame',
);


