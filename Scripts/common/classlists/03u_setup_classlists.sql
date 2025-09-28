

EXECUTE load_classlist('/home/stephen/_working/work/2025/asset_data_facts/s4_classlists/002_equi_classlist.20250822.xlsx');
EXECUTE norm_classlist(1);
EXECUTE fill_equi_characteristics(1);
EXECUTE fill_equi_enums(1);
EXECUTE delete_classlist_landing;
EXECUTE delete_classlist_normed;
EXECUTE load_classlist('/home/stephen/_working/work/2025/asset_data_facts/s4_classlists/003_floc_classlist.20250822.xlsx');
EXECUTE norm_classlist(1);
EXECUTE fill_floc_characteristics(1);
EXECUTE fill_floc_enums(1);