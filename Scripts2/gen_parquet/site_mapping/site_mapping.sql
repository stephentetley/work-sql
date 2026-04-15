.print 'Running site_mapping.sql...'

INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;


-- Setup the environment variable `SITE_MAPPING_XLSB_PATH` before running this file
SELECT getenv('SITE_MAPPING_XLSB_PATH') AS SITE_MAPPING_XLSB_PATH;





CREATE OR REPLACE TABLE ai2_to_s4_site_mapping (
    ai2_site_id VARCHAR NOT NULL,
    ai2_site_name VARCHAR,
    ai2_installation_id VARCHAR,
    ai2_installation_name VARCHAR,
    s4_site_funcloc VARCHAR,
    s4_site_name VARCHAR,
    asset_status VARCHAR,
);

INSERT INTO ai2_to_s4_site_mapping BY NAME
SELECT 
    t."AI2_SiteReference" AS ai2_site_id,  
    t."SITE_NAME" AS ai2_site_name,  
    t."AI2_InstallationReference" AS ai2_installation_id,
    t."AI2_InstallationCommonName" AS ai2_installation_name,
    t."S/4 Hana Floc Lvl1_Code" AS s4_site_funcloc,
    t."S/4 Hana Floc Description" AS s4_site_name,
    t."Asset Status 02/01/2025" AS asset_status,    
FROM read_sheet(
    getenv('SITE_MAPPING_XLSB_PATH'),
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
) t
WHERE t."AI2_SiteReference" IS NOT NULL;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM ai2_to_s4_site_mapping) TO '$(SITE_MAPPING_OUTPATH)' (FORMAT parquet, COMPRESSION snappy);

