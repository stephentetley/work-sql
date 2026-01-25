# Load Exports

Loading exports into the DB seems to tax my current machine 
with it often having memory errors or read errors (one file 
may be slightly malformed).
It seems best to load one table at a time from the CLI rather 
than DBeaver until I upgrade my PC.

~~~ {.duckdb}

.read Scripts/equi_masterdata/do_not_add_to_github/00_set_path_variables.sql
.read Scripts/equi_masterdata/01_load_exports/01b_load_export_data.sql
.read Scripts/equi_masterdata/01_load_exports/02u_load_export_data2.sql
.read Scripts/equi_masterdata/01_load_exports/03u_load_export_data3.sql

~~~

