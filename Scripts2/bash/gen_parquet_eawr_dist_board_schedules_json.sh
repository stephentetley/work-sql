#!/bin/bash

# Make sure to run this as a dot script from the CLI
# (but not a dot script from a Makefile)...


if ! { [ -n "$1" ] ; } ; then
    echo "Supply the folder path to Json files as param 1"
    echo "Optionally file as param 2"
    return 1 
fi

if [ ! -d "$1" ]; then
    echo "Folder $1 does not exist."
    return 1 
fi

if [ -z "$2" ] ; then
    dest="."
else
    dest=$2
fi

if [[ ! -z "${WORK_SQL}" ]]; then
    
duckdb <<EOF
set variable eawr_dist_board_schedules_globpath = '$1/*.json';
.read '$WORK_SQL/Scripts2/gen_parquet/eawr_test_sheets_json/eawr_dist_board_json.sql'
copy (select * from eawr_dist_board_load) to '$2' (format parquet, compression snappy);
EOF

    echo "Created $2"
else
    echo "Must set the env var WORK_SQL"
fi


