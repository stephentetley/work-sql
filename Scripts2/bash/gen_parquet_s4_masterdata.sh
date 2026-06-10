#!/bin/bash

# Make sure to run this as a dot script from the CLI
# (but not a dot script from a Makefile)...

# This is complicated because read_xlsx does not support globs
# rusty_sheet supports globs but seems to have an error with
# the sheeets we use


if [ -z "$1" ] ; then
    echo "Supply the folder containg the xlsx files render to parquet as param 1"
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


set variable s4_floc_parquet_globpath = '$1/floc_*.parquet';
set variable s4_equi_parquet_globpath = '$1/equi_*.parquet';
set variable s4_equi_aib_ref_parquet_globpath = '$1/aibref_equi_*.parquet';

.read '$WORK_SQL/Scripts2/gen_parquet/s4_masterdata/s4_masterdata.sql'
copy (select * from s4_equi) to '$dest/s4_masterdata_equi.parquet' (FORMAT parquet, COMPRESSION snappy);
copy (select * from s4_floc) to '$dest/s4_masterdata_floc.parquet' (FORMAT parquet, COMPRESSION snappy);
copy (select * from s4_equi_to_plinum) to '$dest/s4_masterdata_equi_to_plinum.parquet' (FORMAT parquet, COMPRESSION snappy);
copy (select * from s4_equi_to_sainum) to '$dest/s4_masterdata_equi_to_sainum.parquet' (FORMAT parquet, COMPRESSION snappy);
copy (select * from s4_floc_east_north) to '$dest/s4_masterdata_floc_east_north.parquet' (FORMAT parquet, COMPRESSION snappy);
EOF

    destfiles=`find "$dest" -maxdepth 1 -type f -iname "s4_masterdata*.parquet"`

    echo "Wrote:"
    echo "$destfiles"
else
    echo "Must set the env var WORK_SQL"
fi


