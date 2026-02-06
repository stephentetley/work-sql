INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

-- Needs variable `ai2_masterdata_path` setting


-- Looks like the source data has malformed pre-1900 dates...
CREATE OR REPLACE TABLE masterdata_landing.ai2_export_all AS
SELECT *
FROM read_sheet(
    getvariable('ai2_masterdata_path'),
    sheet='Sheet1',
    nulls = ['NULL'],
    error_as_null=true,
    columns={'*FromDate': 'VARCHAR'}
);




