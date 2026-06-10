#!/bin/bash

# Make sure to run this as a dot script from the CLI
# (but not a dot script from a Makefile)...

# This is complicated because read_xlsx does not support globs
# rusty_sheet supports globs but seems to have an error with
# the sheeets we use


if ! { [ -n "$1" ] && [ -n "$2" ]; } ; then
    echo "Supply the root source folder as param 1"
    echo "Supply the output folder as param 2"
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


function masterdataparquet 
{
    local srcname=$3
    local destname="$dest/$1_$2.parquet"
    echo "$srcname => $destname"

duckdb <<EOF
INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;
set variable masterdata_src_xlsx = '$srcname';
.read '$WORK_SQL/Scripts2/gen_parquet/s4_masterdata/masterdata_to_parquet.sql'
copy (select * from masterdata_source) to '$destname' (format parquet, compression snappy);
EOF
}

function aibrefparquet 
{
    local srcname=$2
    local destname="$dest/aibref_equi_$1.parquet"
    echo "$srcname => $destname"

duckdb <<EOF
INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;
set variable aibref_src_xlsx = '$srcname';
.read '$WORK_SQL/Scripts2/gen_parquet/s4_masterdata/aibref_to_parquet.sql'
copy (select * from aibref_source) to '$destname' (format parquet, compression snappy);
EOF
}


if [[ ! -z "${WORK_SQL}" ]]; then

    flocfiles=`find "$1/floc" -maxdepth 1 -type f -iname "*.xlsx"`
    equifiles=`find "$1/equi" -maxdepth 1 -type f -iname "*.xlsx"`
    equiaibreffiles=`find "$1/equi_aibref" -maxdepth 1 -type f -iname "*.xlsx"`

    i=1;
    for srcfile in $flocfiles
    do 
        masterdataparquet "floc" $i $srcfile 
        ((i++))
    done

    i=1;
    for srcfile in $equifiles
    do 
        masterdataparquet "equi" $i $srcfile 
        ((i++))
    done

    i=1;
    for srcfile in $equiaibreffiles
    do 
        aibrefparquet $i $srcfile 
        ((i++))
    done

else
    echo "Must set the env var WORK_SQL"
fi


