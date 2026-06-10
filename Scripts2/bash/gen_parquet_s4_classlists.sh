#!/bin/bash

# Make sure to run this as a dot script from the CLI
# (but not a dot script from a Makefile)...

if [ -z "$1" ] ; then
    echo "Supply the source folder containing Excel files"
    echo "Supply the output folder"
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

floc_classdefs=`find "$1" -maxdepth 1 -type f -iname "*floc_classdefs*.xlsx" | head -1`
equi_classdefs=`find "$1" -maxdepth 1 -type f -iname "*equi_classdefs*.xlsx" | head -1`

if ! { [ -n "$floc_classdefs" ] && [ -n "$equi_classdefs" ]; } ; then
    echo "The source directory does not contain the full set of s4 classdefs"
    return 1 
fi


if [[ ! -z "${WORK_SQL}" ]]; then
    
duckdb <<EOF
INSTALL rusty_sheet FROM community;
LOAD rusty_sheet;

set variable floc_classlist_xlsx_path = '$floc_classdefs';
set variable equi_classlist_xlsx_path = '$equi_classdefs';

.read '$WORK_SQL/Scripts2/gen_parquet/s4_classlists/s4_classlists.sql'
copy (select * from s4_floc_classes) to '$dest/s4_floc_classes.parquet' (format parquet, compression snappy);
copy (select * from s4_floc_enums) to '$dest/s4_floc_enums.parquet' (format parquet, compression snappy);
copy (select * from s4_equi_classes) to '$dest/s4_equi_classes.parquet' (format parquet, compression snappy);
copy (select * from s4_equi_enums) to '$dest/s4_equi_enums.parquet' (format parquet, compression snappy);
EOF

    destfiles=`find "$dest" -maxdepth 1 -type f -iname "s4_*.parquet"`

    echo "Wrote:"
    echo "$destfiles"
else
    echo "Must set the env var WORK_SQL"
fi


