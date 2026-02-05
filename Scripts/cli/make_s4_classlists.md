# make s4 classlists

Make a script like the one below and invoke DuckDB with a command to read it.

> duckdb my_database_db.duckdb -c ".read FILENAME"

``` {.sql} 

SET VARIABLE equi_classdefs_path = '~/_working/work/resources/s4_classdefs/002_equi_classdefs_20260205.xlsx';
SET VARIABLE floc_classdefs_path = '~/_working/work/resources/s4_classdefs/003_floc_classdefs_20260205.xlsx';

.cd '../../../coding/work/work-sql/Scripts/cli/'
.read make_s4_classlists.sql

```

