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

zt_eqobj=`find "$1" -maxdepth 1 -type f -iname "zt_eqobj*.xlsx" | head -1`
zt_flobjl=`find "$1" -maxdepth 1 -type f -iname "zt_flobjl*.xlsx" | head -1`
zt_flocdes=`find "$1" -maxdepth 1 -type f -iname "zt_flocdes*.xlsx" | head -1`
zt_manuf=`find "$1" -maxdepth 1 -type f -iname "zt_manuf*.xlsx" | head -1`
zt_objtype_manuf=`find "$1" -maxdepth 1 -type f -iname "zt_objtype_manuf*.xlsx" | head -1`

if ! { [ -n "$zt_eqobj" ] && [ -n "$zt_flobjl" ]  && [ -n "$zt_flocdes" ]  && [ -n "$zt_manuf" ]  && [ -n "$zt_objtype_manuf" ]; } ; then
    echo "The source directory does not contain the full set of ztables"
    return 1 
fi


if [[ ! -z "${WORK_SQL}" ]]; then
    
duckdb <<EOF
install excel;
load excel;

set variable ztable_eqobj_xls_path = '$zt_eqobj';
set variable ztable_flobjl_xls_path = '$zt_flobjl';
set variable ztable_flocdes_xls_path = '$zt_flocdes';
set variable ztable_manuf_xls_path = '$zt_manuf';
set variable ztable_objtype_manuf_xls_path = '$zt_objtype_manuf';


.read '$WORK_SQL/Scripts2/gen_parquet/ztables/ztables.sql'
copy (select * from ztable_eqobj) to '$dest/ztable_eqobj.parquet' (format parquet, compression snappy);
copy (select * from ztable_flobjl) to '$dest/ztable_flobjl.parquet' (format parquet, compression snappy);
copy (select * from ztable_flocdes) to '$dest/ztable_flocdes.parquet' (format parquet, compression snappy);
copy (select * from ztable_manuf) to '$dest/ztable_manuf.parquet' (format parquet, compression snappy);
copy (select * from ztable_objtype_manuf) to '$dest/ztable_objtype_manuf.parquet' (format parquet, compression snappy);
EOF

    destfiles=`find "$dest" -maxdepth 1 -type f -iname "ztable*.parquet"`

    echo "Wrote:"
    echo "$destfiles"
else
    echo "Must set the env var WORK_SQL"
fi


