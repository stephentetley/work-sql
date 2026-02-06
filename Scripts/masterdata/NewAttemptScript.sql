INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

SET VARIABLE aib_master_globpath = '/home/stephen/_working/work/2026/masterdata/02_06/ai2/*.xlsb';


SELECT * FROM analyze_sheets([getvariable('aib_master_globpath')], sheets=['Sheet1'], analyze_rows=20);

-- TODO read fixed set of columns and do multiple passes
-- to keep memory usage low
-- *InstalledFromDate string format is `hours:mins:secs` where 
-- hours = number of positive hours from 1899-12-20.
-- Dates before this are stored as '1898-01-01 00:00:00.000' 
-- '%Y-%m-%d %H:%M:%S'
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

SELECT 
    * 
FROM read_sheets(
    [getvariable('floc_master_globpath')], 
    sheets=['Sheet1'],
    columns={'Start-up date': 'varchar'}
);


SET VARIABLE equi_master_globpath = '/home/stephen/_working/work/2026/masterdata/02_06/ih08_masterdata/*.xlsx';

SELECT 
    * 
FROM read_sheets(
    [getvariable('equi_master_globpath')], 
    sheets=['Sheet1'],
    columns={'Start-up date': 'varchar'}
);

SET VARIABLE equi_aib_globpath = '/home/stephen/_working/work/2026/masterdata/02_06/ih08_aib/*.xlsx';

SELECT 
    * 
FROM read_sheets(
    [getvariable('equi_aib_globpath')], 
    sheets=['Sheet1']
);

