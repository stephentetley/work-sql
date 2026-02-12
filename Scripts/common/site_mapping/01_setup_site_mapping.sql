.print 'Running 01_setup_site_mapping.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE SCHEMA IF NOT EXISTS site_mapping;

.print 'Loading site_mapping...'
SELECT getvariable('site_mapping_path') AS site_mapping_path;




CREATE OR REPLACE TABLE site_mapping.installation_to_site (
    ai2_site_id VARCHAR,
    ai2_site_name VARCHAR,
    ai2_installation_id VARCHAR,
    ai2_installation_name VARCHAR,
    s4_site_funcloc VARCHAR,
    s4_site_name VARCHAR,
    asset_status VARCHAR,
);

INSERT INTO site_mapping.installation_to_site BY NAME
SELECT 
    t."AI2_SiteReference" AS ai2_site_id,  
    t."SITE_NAME" AS ai2_site_name,  
    t."AI2_InstallationReference" AS ai2_installation_id,
    t."AI2_InstallationCommonName" AS ai2_installation_name,
    t."S/4 Hana Floc Lvl1_Code" AS s4_site_funcloc,
    t."S/4 Hana Floc Description" AS s4_site_name,
    t."Asset Status 02/01/2025" AS asset_status,    
FROM read_sheet(
    getvariable('site_mapping_path'),
    sheet = 'inst to SAP migration',
    nulls = ['NULL', '#N/A'],
    columns = {
        'AI2_SiteReference': 'varchar', 
        'SITE_NAME': 'varchar',
        'AI2_InstallationReference': 'varchar',
        'AI2_InstallationCommonName': 'varchar',
        'S/4 Hana Floc Lvl1_Code': 'varchar',
        'S/4 Hana Floc Description': 'varchar',
        'Asset Status 02/01/2025': 'varchar',
    },
    error_as_null = true
) t;