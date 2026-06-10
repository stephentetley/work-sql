#!/bin/bash

# Make sure to run this as a dot script from the CLI
# (but not a dot script from a Makefile)...

if ! { [ -n "$1" ] && [ -n "$2" ]; } ; then
    echo "Supply the outstations report path as param 1 (tab separated text)"
    echo "Optionally supply the output folder as param 2"
    return 1 
fi

if ! test -f $1; then
    echo "File $1 does not exist."
    return 1 
fi

if [[ "$1" != *.txt ]]; then
    echo "File $1 must be a *.txt file"
    return 1;
fi

if [ -z "$2" ] ; then
    dest="."
else
    dest=$2
fi

if [[ ! -z "${WORK_SQL}" ]]; then
    
duckdb <<EOF
set variable outstations_summary_txt_path = '$1';
.read '$WORK_SQL/Scripts2/gen_parquet/rts_outstations/rts_outstations.sql'
copy (select * from rts_outstations) to '$dest/rts_outstations.parquet' (format parquet, compression snappy);
EOF

    echo "Created $dest/rts_outstations.parquet"
else
    echo "Must set the env var WORK_SQL"
fi


