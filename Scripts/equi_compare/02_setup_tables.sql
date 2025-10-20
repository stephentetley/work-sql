

CREATE SCHEMA IF NOT EXISTS equi_compare_landing;
CREATE SCHEMA IF NOT EXISTS equi_compare;


-- No primary key - expect two records with just aib_ref different...
CREATE OR REPLACE TABLE equi_compare_landing.ih08_equi_masterdata (
    equi_id VARCHAR NOT NULL,
    equi_name VARCHAR,
    funcloc VARCHAR,
    pandi_tag VARCHAR,
    standard_class VARCHAR,
    manufacturer VARCHAR,
    model VARCHAR,
    specific_model VARCHAR,
    serial_number VARCHAR,
    startup_date DATE,
    asset_status VARCHAR,
    aib_ref VARCHAR
);

CREATE OR REPLACE TABLE equi_compare_landing.ai2_equi_masterdata (
    pli_num VARCHAR NOT NULL,
    sai_num VARCHAR,
    floc_common_name VARCHAR,
    status VARCHAR,
    equipment_type VARCHAR,
    install_date DATE,
    manufacturer VARCHAR,
    model VARCHAR, 
    pandi_tag VARCHAR,
    serial_number VARCHAR,
    specific_model VARCHAR,
);

CREATE OR REPLACE TEMPORARY MACRO read_ih08_export(xlsx_file) AS TABLE
SELECT 
    t."Equipment" AS equi_id,
    t."Description of technical object" AS equi_name,
    t."Functional Location" AS funcloc,
    t."Technical identification no." AS pandi_tag,
    t."Standard Class" AS standard_class,
    t."Manufacturer of Asset" AS manufacturer,
    t."Model number" AS model,
    t."Manufacturer part number" AS specific_model,
    t."Manufacturer's Serial Number" AS serial_number,
    TRY_CAST(excel_text(t."Start-up date" :: DECIMAL, 'yyyy-mm-dd') AS DATE) AS startup_date,
    t."User Status" AS asset_status,
    t."AI2 AIB Reference" AS aib_ref,
FROM 
    read_xlsx(xlsx_file :: VARCHAR, all_varchar=TRUE, Sheet='Sheet1') AS t;



CREATE OR REPLACE TEMPORARY MACRO read_ai2_equi_report(xlsx_file) AS TABLE
SELECT 
    t."Reference" AS sai_num,
    t."CommonName" AS floc_common_name,
    t."Status" AS status,
    t."EquipmentReference" AS pli_num,
    t."EquipmentName" AS equipment_type,
    TRY_CAST(excel_text(t."InstalledFromDate" :: DECIMAL, 'yyyy-mm-dd') AS DATE) AS install_date,
    t."Manufacturer" AS manufacturer,
    t."Model" AS model, 
    t."P AND I Tag No" AS pandi_tag,
    t."Serial No" AS serial_number,
    t."Specific Model/Frame" AS specific_model,
FROM 
    read_xlsx(xlsx_file :: VARCHAR, all_varchar=TRUE, Sheet='Sheet1') AS t;



