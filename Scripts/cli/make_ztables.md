# make ztables

Make a script like this and invoke DuckDB with a command to read it.

> duckdb my_database_class_db.duckdb -c ".read cli_make_ztables.sql"

``` {.sql} 

SET VARIABLE zt_eqobjl_path = '~/_working/work/resources/ztables/zt_eqobj_20260205.XLSX';
SET VARIABLE zt_flobjl_path = '~/_working/work/resources/ztables/zt_flobjl_20260205.XLSX';
SET VARIABLE zt_flocdes_path = '~/_working/work/resources/ztables/zt_flocdes_20260205.XLSX';
SET VARIABLE zt_manuf_model_path = '~/_working/work/resources/ztables/zt_manuf_20260205.XLSX';
SET VARIABLE zt_obj_path = '~/_working/work/resources/ztables/zt_objtype_manuf_20260205.XLSX';

.cd '../../../coding/work/work-sql/Scripts/cli/'
.read make_ztables.sql

```