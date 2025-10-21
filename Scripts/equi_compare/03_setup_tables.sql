
CREATE SCHEMA IF NOT EXISTS equi_compare_facts;
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



CREATE OR REPLACE VIEW equi_compare_landing.vw_ih08_equi_masterdata AS 
WITH cte1 AS (
SELECT 
    equi_id, 
    aib_ref AS pli_num 
FROM equi_compare_landing.ih08_equi_masterdata
WHERE aib_ref LIKE 'PLI%'
), cte2 AS (
SELECT 
    equi_id, 
    aib_ref AS sai_num 
FROM equi_compare_landing.ih08_equi_masterdata
WHERE aib_ref NOT LIKE 'PLI%'
)
SELECT DISTINCT ON (t.equi_id)
    t.* EXCLUDE(aib_ref), 
    t1.pli_num as pli_num,
    t2.sai_num as sai_num,
FROM equi_compare_landing.ih08_equi_masterdata t
LEFT JOIN cte1 t1 ON t1.equi_id = t.equi_id
LEFT JOIN cte2 t2 ON t2.equi_id = t.equi_id;


CREATE OR REPLACE TABLE equi_compare_facts.installation_mapping (
    ai2_installation VARCHAR NOT NULL,
    s4_site VARCHAR,
    s4_site_name VARCHAR,
);

CREATE OR REPLACE TEMPORARY MACRO read_installation_mapping(xlsx_file) AS TABLE
SELECT 
    t."AI2_InstallationCommonName" AS ai2_installation,
    t."S/4 Hana Floc Lvl1_Code" AS s4_site,
    t."S/4 Hana Floc Description" AS s4_site_name,
FROM 
    read_xlsx(xlsx_file :: VARCHAR, all_varchar=TRUE, Sheet='inst to SAP migration') AS t;


CREATE OR REPLACE TABLE equi_compare_facts.process_group_names (
    process_group_name VARCHAR NOT NULL,
    path_fragment VARCHAR NOT NULL,
    PRIMARY KEY (process_group_name)
);


CREATE OR REPLACE MACRO read_process_group_names(xlsx_file) AS TABLE
SELECT 
    t."ProcessGroupAssetTypeDescription" AS process_group_name,
    '/' || process_group_name || '/' AS path_fragment,
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=TRUE, sheet='process_group') AS t;


CREATE OR REPLACE TABLE equi_compare_facts.process_names (
    process_name VARCHAR NOT NULL,
    path_fragment VARCHAR NOT NULL,
    PRIMARY KEY (process_name)
);

CREATE OR REPLACE MACRO read_process_names(xlsx_file) AS TABLE
SELECT 
    t."ProcessAssetTypeDescription" AS process_name,
    '/' || process_name || '/' AS path_fragment,
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=TRUE, sheet='process') AS t;


CREATE OR REPLACE VIEW equi_compare.vw_ai2_common_name_decoded AS
WITH cte AS (
    SELECT 
        t.floc_common_name AS common_name, 
        t1.process_group_name AS process_group_name,
        t1.path_fragment AS pg_needle,
        instr(t.floc_common_name, pg_needle) AS pg_start,
        t2.process_name AS process_name,
        t2.path_fragment AS p_needle,
        instr(t.floc_common_name, p_needle) AS p_start,
        left(t.floc_common_name, coalesce(pg_start, p_start) - 1) AS inst_name,
    FROM equi_compare_landing.ai2_equi_masterdata t
    LEFT JOIN equi_compare_facts.process_group_names t1 ON contains(t.floc_common_name, t1.path_fragment)
    LEFT JOIN equi_compare_facts.process_names t2 ON contains(t.floc_common_name, t2.path_fragment)
)
SELECT 
    t1.s4_site,
    t.common_name, 
    t.inst_name, 
    t.process_group_name, 
    t.process_name,
FROM cte t
LEFT JOIN equi_compare_facts.installation_mapping t1 ON t1.ai2_installation = t.inst_name;


CREATE OR REPLACE VIEW equi_compare.vw_equi_compare_status AS
(
    SELECT 
        t.equi_id AS s4_equi_id,
        NULL AS ai2_pli_num,
        'no_pli_aib_ref'::compare_status AS equi_compare_status,
    FROM equi_compare_landing.vw_ih08_equi_masterdata t
    WHERE t.pli_num NOT LIKE 'PLI%'
)
UNION
(
    SELECT 
        NULL AS s4_equi_id,
        t.pli_num AS ai2_pli_num,
        'not_in_s4_extract'::compare_status AS equi_compare_status,
    FROM equi_compare_landing.ai2_equi_masterdata t
    ANTI JOIN equi_compare_landing.vw_ih08_equi_masterdata USING (pli_num)
)
UNION
(
    SELECT 
        t.equi_id AS s4_equi_id,
        t.pli_num AS ai2_pli_num,
        'not_in_ai2_extract'::compare_status AS equi_compare_status,
    FROM equi_compare_landing.vw_ih08_equi_masterdata t
    ANTI JOIN equi_compare_landing.ai2_equi_masterdata USING (pli_num)
    WHERE t.pli_num IS NOT NULL
)
UNION
(
    SELECT 
        t.equi_id AS s4_equi_id,
        t.pli_num AS ai2_pli_num,
        'in_both'::compare_status AS equi_compare_status,
    FROM equi_compare_landing.vw_ih08_equi_masterdata t
    SEMI JOIN equi_compare_landing.ai2_equi_masterdata USING (pli_num)
    WHERE t.pli_num IS NOT NULL
);



