INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

CREATE SCHEMA IF NOT EXISTS masterdata_landing;

SET VARIABLE aib_master_globpath = '/home/stephen/_working/work/2026/masterdata/02_06/ai2/*.xlsb';


-- SELECT * FROM analyze_sheets([getvariable('aib_master_globpath')], sheets=['Sheet1'], analyze_rows=20);

-- TODO read fixed set of columns and do multiple passes
-- to keep memory usage low
-- *InstalledFromDate string format is `hours:mins:secs` where 
-- hours = number of positive hours from 1899-12-20.
-- Dates before this are stored as '1898-01-01 00:00:00.000' 
-- '%Y-%m-%d %H:%M:%S'
CREATE OR REPLACE TABLE masterdata_landing.ai2_plant_equi AS
SELECT
    t."InstallationCommonName",
    t."SubInstallationCommonName",
    t."PlantEquipReference",
    t."PlantEquipInstalledFromDate",
    t."PlantReference",
    t."PlantCommonName",
    t."PlantEquipManufacturer",
    t."PlantEquipModel",
    t."PlantEquipStatus",
    t."PlantEquipAssetTypeCode",
    t."PlantEquipAssetTypeDescription",
FROM read_sheets([getvariable('aib_master_globpath')], sheets=['Sheet1'], error_as_null=true, nulls=['NULL'], columns={'*FromDate': 'varchar'}) t
WHERE
    t."PlantEquipRuleDeleted" = '0'
AND t."PlantEquipReference" IS NOT NULL;


SET VARIABLE floc_master_globpath = '/home/stephen/_working/work/2026/masterdata/02_06/ih06_masterdata/*.xlsx';

CREATE OR REPLACE TABLE masterdata_landing.s4_floc_data AS
SELECT 
    * 
FROM read_sheets(
    [getvariable('floc_master_globpath')], 
    sheets=['Sheet1'],
    columns={'Start-up date': 'varchar'}
);


SET VARIABLE equi_master_globpath = '/home/stephen/_working/work/2026/masterdata/02_06/ih08_masterdata/*.xlsx';

CREATE OR REPLACE TABLE masterdata_landing.s4_equi_data AS
SELECT 
    * 
FROM read_sheets(
    [getvariable('equi_master_globpath')], 
    sheets=['Sheet1'],
    columns={'Start-up date': 'varchar'}
);

SET VARIABLE equi_aib_globpath = '/home/stephen/_working/work/2026/masterdata/02_06/ih08_aib/*.xlsx';

CREATE OR REPLACE TABLE masterdata_landing.s4_equi_aib_refs_data AS
SELECT 
    * 
FROM read_sheets(
    [getvariable('equi_aib_globpath')], 
    sheets=['Sheet1']
);


CREATE OR REPLACE MACRO sqlserver_date(str) AS (
    coalesce(
        try(strptime(str::VARCHAR, '%Y-%m-%d %H:%M:%S.%g')::DATETIME),
        try(date_add(DATE '1899-12-30', INTERVAL (try_cast(regexp_extract(str::VARCHAR, '^(\d+):\d{2}:\d{2}', 1) AS BIGINT)) HOUR))
    )
);

-- Run date conversion after we have stored data from the ai2 export on disk
-- otherwise we are getting out-of-memory memory issues
WITH cte AS (
    SELECT
        t.PlantEquipReference as uid,
        t.PlantEquipInstalledFromDate AS dstring,
        sqlserver_date(t.PlantEquipInstalledFromDate) AS d1,
    FROM masterdata_landing.ai2_plant_equi t
)
SELECT * FROM cte
WHERE d1 IS NULL;

