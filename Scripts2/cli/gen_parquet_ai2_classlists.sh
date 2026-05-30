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

asset_types_attributes=`find "$1" -maxdepth 1 -type f -iname "AI2AssetTypeAttributes*.xlsx" | head -1`
equipment_attribute_sets=`find "$1" -maxdepth 1 -type f -iname "equipment_attribute_sets*.xlsx" | head -1`

if ! { [ -n "$asset_types_attributes" ] && [ -n "$equipment_attribute_sets" ]; } ; then
    echo "The source directory does not contain the full set of s4 classdefs"
    return 1 
fi


if [[ ! -z "${WORK_SQL}" ]]; then
    
duckdb <<EOF
INSTALL excel;
LOAD excel;

set variable asset_types_attributes_path = '$asset_types_attributes';
set variable equipment_attribute_sets_path = '$equipment_attribute_sets';

.read '$WORK_SQL/Scripts2/gen_parquet/ai2_classlists/ai2_classlists.sql'
copy (select * from ai2_equi_classes) to '$dest/ai2_equi_classlist.parquet' (format parquet, compression snappy);
EOF

    echo "Wrote ai2_equi_classlist.parquet"
else
    echo "Must set the env var WORK_SQL"
fi


