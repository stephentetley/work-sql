#!/bin/bash

if [ -z "$1" ]; then
    echo "Supply the output SQLite filename as param $1"
    return 1 
fi

if [[ ! -z "${WORK_SQL}" ]]; then
    
duckdb <<EOF
attach '$1' as sqlite_db (type sqlite);
.read '$WORK_SQL/Scripts2/excel_uploader/create_sqlite_tables.sql'
detach sqlite_db
EOF

    echo "Created $1"
else
    echo "Must set the env var WORK_SQL and the param $1 to the SQLite output file"
fi


