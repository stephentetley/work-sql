#!/bin/bash

# Make sure to run this as a dot script from the CLI
# (but not a dot script from a Makefile)...

if ! { [ -n "$1" ] && [ -n "$2" ]; } ; then
    echo "Supply the Excel site mapping path as param 1 (*.xlsb)"
    echo "Supply the output Parquet filename as param 2"
    return 1 
fi

if ! test -f $1; then
    echo "File $1 does not exist."
    return 1 
fi

if [[ "$1" != *.xlsb ]]; then
    echo "File $1 must be a *.xlsb file"
    return 1;
fi

if [[ ! -z "${WORK_SQL}" ]]; then
    
duckdb <<EOF
install rusty_sheet FROM community;
load rusty_sheet;

set variable site_mapping_xlsb_path = '$1';
.read '$WORK_SQL/Scripts2/gen_parquet/site_mapping/site_mapping.sql'
copy (select * from ai2_to_s4_site_mapping) to '$2' (format parquet, compression snappy);
EOF

    echo "Created $2"
else
    echo "Must set the env var WORK_SQL"
fi


