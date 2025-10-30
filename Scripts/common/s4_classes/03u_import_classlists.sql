
CREATE OR REPLACE TABLE s4_classlists_landing.equi_classlist_file AS 
SELECT * FROM read_classlist_export(
    '/home/stephen/_working/work/2025/asset_data_facts/s4_classlists/002_equi_classlist.20251023.xlsx'
);


CREATE OR REPLACE TABLE s4_classlists_landing.floc_classlist_file AS 
SELECT * FROM read_classlist_export(
    '/home/stephen/_working/work/2025/asset_data_facts/s4_classlists/003_floc_classlist.20251023.xlsx'
);
