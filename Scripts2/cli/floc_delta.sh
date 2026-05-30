#!/bin/bash

# Make sure to run this as a dot script...


if ! { [ -n "$1" ] && [ -n "$2" ]; } ; then
    echo "Supply the Excel worklist path as param 1"
    echo "Supply the output SQLite filename as param 2"
    return 1 
fi

if ! test -f $1; then
    echo "File $1 does not exist."
    return 1 
fi


if { [ ! -z "${WORK_SQL}" ] && [ ! -z "${ASSET_LAKE_CONNECT_STRING}" ]; }; then
    
duckdb <<EOF
attach '$ASSET_LAKE_CONNECT_STRING' as asset_lake (READ_ONLY);
attach '$2' as sqlite_db (type sqlite);

.print 'Create sqlite tables'
.read '$WORK_SQL/Scripts2/excel_uploader/create_sqlite_tables.sql'

.print 'Create floc_delta tables'
.read '/home/stephen/_working/coding/work/work-sql/Scripts2/floc_delta/01_create_floc_delta_tables.sql'

.print 'Import worklist'
set variable floc_delta_worklist = $1;
.read '/home/stephen/_working/coding/work/work-sql/Scripts2/floc_delta/02_import_worklist.sql'

.print 'Calculate new flocs'
.read '/home/stephen/_working/coding/work/work-sql/Scripts2/floc_delta/03_floc_delta_insert_into.sql'

.print 'Write new flocs to sqlite'
.read '/home/stephen/_working/coding/work/work-sql/Scripts2/floc_delta/04_excel_uploader_insert_into.sql'


detach sqlite_db;
detach asset_lake;
EOF

    echo "Created $2"
else
    echo "Must set the env vars WORK_SQL and ASSET_LAKE_CONNECT_STRING"
fi



