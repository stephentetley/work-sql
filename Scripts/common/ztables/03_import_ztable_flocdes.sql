CREATE SCHEMA IF NOT EXISTS s4_ztables;



CREATE OR REPLACE TABLE s4_ztables.flocdes (
    object_type VARCHAR NOT NULL,
    standard_floc_description VARCHAR,
);



--  flocdes
CREATE OR REPLACE MACRO read_ztable_flocdes(xlsx_file) AS TABLE
SELECT 
    t."Object Type" AS 'object_type',
    t."Standard FLoc Description" AS 'standard_floc_description',
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=true) AS t;


-- Setup the variables `zt_flocdes_path` before running this file
-- SET VARIABLE zt_flocdes_path = 'path/to/zt_flocdes_20260205.XLSX';

INSERT INTO s4_ztables.flocdes
FROM read_ztable_flocdes(
    getvariable('zt_flocdes_path')
);
