.print 'Running ai2_classlists.sql...' 

INSTALL excel;
LOAD excel;

CREATE OR REPLACE TABLE ai2_equi_classes (
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

CREATE OR REPLACE TEMPORARY MACRO decode_data_type(dtype) AS 
CASE 
    WHEN (dtype :: VARCHAR) = 'AIYEAR4' THEN 'INTEGER'
    WHEN dtype = 'BOOL' THEN 'BOOLEAN'
    WHEN regexp_matches(dtype, 'CHAR[0-9]*') THEN 'VARCHAR'
    WHEN regexp_matches(dtype, 'DATETIME[0-9]*') THEN 'DATETIME'
    WHEN regexp_matches(dtype, 'DECIMAL[0-9]*') THEN 'DECIMAL(18, 3)'
    WHEN dtype = 'ENUM' THEN 'VARCHAR'
    WHEN regexp_matches(dtype, 'FLOAT[0-9]*') THEN 'DECIMAL(18, 3)'
    WHEN regexp_matches(dtype, 'INT(EGER)?[0-9]*') THEN 'INTEGER'
    WHEN regexp_matches(dtype, 'NUMERIC[0-9]*') THEN 'DECIMAL(18, 3)'
    WHEN regexp_matches(dtype, 'VARCHAR[0-9]*') THEN 'VARCHAR'
    ELSE 'VARCHAR'
END;

-- Setup the environment variable `ASSET_TYPES_ATTRIBUTES_PATH` before running this file
SELECT getenv('ASSET_TYPES_ATTRIBUTES_PATH') AS ASSET_TYPES_ATTRIBUTES_PATH;

CREATE OR REPLACE TABLE asset_type_attributes_landing AS
SELECT 
    t."Code" AS class_name,
    t."Description" AS class_description,
    replace(t."Description", 'EQUIPMENT: ', '') AS class_description2,
    t."AttributeSet" AS attribute_set_name,
    t."Attribute Name" AS attribute_name,
    t."Attribute Description" AS attribute_description,
    IF(t."Data Type Name" = 'NULL' AND t."LookupTypeId" <> 'NULL', 'ENUM', t."Data Type Name") AS data_type,
    decode_data_type(data_type) AS ddl_data_type,
    t."Lookup Type Name" AS enum_name,
FROM read_xlsx(getenv('ASSET_TYPES_ATTRIBUTES_PATH'), all_varchar=true, sheet='AssetTypesAttributes') t
WHERE t."Code" LIKE 'EQPT%'
AND t."AssetTypeDeletionFlag" = '0'
AND t."AttributeNameDeletionFlag" = '0';


-- Setup the environment variable `EQUIPMENT_ATTRIBUTE_SETS_PATH` before running this file
SELECT getenv('EQUIPMENT_ATTRIBUTE_SETS_PATH') AS EQUIPMENT_ATTRIBUTE_SETS_PATH;

CREATE OR REPLACE TABLE equi_attribute_sets_landing AS
SELECT 
    t."Attribute Description" AS class_name,
    t."Attribute Set"  attribute_set_name,
    t."Class Derivation" AS class_derivation,
FROM read_xlsx(getenv('EQUIPMENT_ATTRIBUTE_SETS_PATH'), all_varchar=true, sheet='Sheet1') t;

CREATE OR REPLACE TEMPORARY MACRO get_table_name(name) AS (
    replace(name :: VARCHAR, 'EQUIPMENT: ', '').
        trim().
        regexp_replace('[^[:word:]]+', '_', 'g').
        regexp_replace('_$', '')
);

INSERT OR REPLACE INTO ai2_equi_classes BY NAME
WITH cte AS (
    SELECT 
        t.* 
    FROM equi_attribute_sets_landing t
    WHERE t.class_derivation IN ('Equiclass', 'Equimixin') 
) 
SELECT 
    t1.*,
    t.class_derivation as class_derivation,
    CASE 
        WHEN t.class_derivation = 'Equiclass' THEN get_table_name(t1.class_description)
        WHEN t.class_derivation = 'Equimixin' THEN get_table_name(t1.attribute_set_name)
        ELSE null 
    END AS class_table_name,
FROM cte t
JOIN asset_type_attributes_landing t1 
    ON t1.class_description = t.class_name
    AND t1.attribute_set_name = t.attribute_set_name;
    
    
