# Load Exports

Loading exports into the DB seems to tax my current machine.
Best to do it one table at a time until I upgrade

~~~ {.duckdb}

.read Scripts/equi_masterdata/do_not_add_to_github/00_set_path_variables.sql
.read Scripts/01_load_exports/equi_masterdata/01b_load_export_data.sql
.read Scripts/01_load_exports/equi_masterdata/02u_load_export_data2.sql
.read Scripts/01_load_exports/equi_masterdata/03u_load_export_data3.sql

~~~