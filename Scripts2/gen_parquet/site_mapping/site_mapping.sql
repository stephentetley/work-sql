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
-- The community extension `rusty_sheet` is loaded:
-- D INSTALL rusty_sheet FROM community;
-- D LOAD rusty_sheet;


-- Set the variable `site_mapping_xlsb_path` before running this file


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
    getvariable('site_mapping_xlsb_path'),
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

