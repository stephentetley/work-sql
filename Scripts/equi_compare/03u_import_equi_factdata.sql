

DELETE FROM equi_compare_facts.installation_mapping;
DELETE FROM equi_compare_facts.process_group_names;
DELETE FROM equi_compare_facts.process_names;


INSERT INTO equi_compare_facts.installation_mapping BY NAME
SELECT 
    *
FROM read_installation_mapping(
    '/home/stephen/_working/work/2025/asset_data_facts/Site_FlocMapping_20251021.xlsx'
);

INSERT INTO equi_compare_facts.process_group_names BY NAME
SELECT 
    *
FROM read_process_group_names(
    '/home/stephen/_working/work/2025/asset_data_facts/ai2_metadata/all_process_processgroup_names.xlsx'
);

INSERT INTO equi_compare_facts.process_names BY NAME
SELECT 
    * 
FROM read_process_names(
    '/home/stephen/_working/work/2025/asset_data_facts/ai2_metadata/all_process_processgroup_names.xlsx'
);




