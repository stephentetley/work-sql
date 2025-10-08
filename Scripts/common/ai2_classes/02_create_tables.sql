

CREATE SCHEMA IF NOT EXISTS ai2_classlists;
CREATE SCHEMA IF NOT EXISTS ai2_classlists_landing;

CREATE OR REPLACE MACRO decode_data_type(dtype) AS 
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



CREATE OR REPLACE MACRO read_asset_types_attributes(xlsx_file) AS TABLE
SELECT 
    t."Code" AS class_name,
    t."Description" AS class_description,
    t."AttributeSet" AS attribute_set_name,
    t."Attribute Name" AS attribute_name,
    t."Attribute Description" AS attribute_description,
    IF(t."Data Type Name" = 'NULL' AND t."LookupTypeId" <> 'NULL', 'ENUM', t."Data Type Name") AS data_type,
    decode_data_type(data_type) AS ddl_data_type,
    t."Lookup Type Name" AS enum_name,
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true, sheet='AssetTypesAttributes') t
WHERE t."Code" LIKE 'EQPT%'
AND t."AssetTypeDeletionFlag" = '0'
AND t."AttributeNameDeletionFlag" = '0';



CREATE OR REPLACE MACRO read_equipment_attribute_sets(xlsx_file) AS TABLE
SELECT 
    t."Attribute Description" AS class_name,
    t."Attribute Set"  attribute_set_name,
    t."Class Derivation" AS class_derivation,
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true, sheet='Sheet1') t;



CREATE OR REPLACE TABLE ai2_classlists.equi_characteristics (
    class_name VARCHAR NOT NULL,
    class_description VARCHAR,
    class_table_name VARCHAR,
    attribute_name VARCHAR NOT NULL,
    attribute_description VARCHAR,
    data_type VARCHAR,
    ddl_data_type VARCHAR,
    enum_name VARCHAR,
    PRIMARY KEY(class_name, attribute_name)
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


