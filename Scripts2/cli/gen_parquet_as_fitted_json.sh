#!/bin/bash

# Make sure to run this as a dot script from the CLI
# (but not a dot script from a Makefile)...


if ! { [ -n "$1" ] ; } ; then
    echo "Supply the folder path to Json files as param 1"
    echo "Optionally supply the output folder as param 2"
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
set variable as_fitted_globpath = '$1/*.json';
.read '$WORK_SQL/Scripts2/gen_parquet/as_fitted_json/as_fitted_json.sql'
copy (select * from as_fitted_circuits) to '$dest/as_fitted_circuits.parquet' (format parquet, compression snappy);
EOF

    echo "Created $dest/as_fitted_circuits.parquet"
else
    echo "Must set the env var WORK_SQL"
fi


