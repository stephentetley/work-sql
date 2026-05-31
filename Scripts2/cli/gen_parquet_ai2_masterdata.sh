#!/bin/bash

# Make sure to run this as a dot script from the CLI
# (but not a dot script from a Makefile)...

if [ -z "$1" ] ; then
    echo "Supply the Excel ai2 export as param 1 (*.xlsb)"
    echo "Supply the output folder"
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

if [ -z "$2" ] ; then
    dest="."
else
    dest=$2
fi


if [[ ! -z "${WORK_SQL}" ]]; then
    
duckdb <<EOF
INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

set variable ai2_masterdata_srcpath = '$1';

.read '$WORK_SQL/Scripts2/gen_parquet/ai2_masterdata/ai2_masterdata.sql'
copy (select * from ai2_floc) to '$dest/ai2_masterdata_floc.parquet' (format parquet, compression snappy);
copy (select * from ai2_equi) to '$dest/ai2_masterdata_equi.parquet' (format parquet, compression snappy);
copy (select * from ai2_site_simple) to '$dest/ai2_masterdata_site_simple.parquet' (format parquet, compression snappy);
EOF

    destfiles=`find "$dest" -maxdepth 1 -type f -iname "ai2_masterdata*.parquet"`

    echo "Wrote:"
    echo "$destfiles"
else
    echo "Must set the env var WORK_SQL"
fi


