#!/bin/bash

# Make sure to run this as a dot script...

if [ -z "$1" ] ; then
    dest="."
else
    dest=$1
fi



if { [ ! -z "${WORK_SQL}" ] && [ ! -z "${ASSET_LAKE_CONNECT_STRING}" ]; }; then
    
duckdb <<EOF
load ducklake;

attach '$ASSET_LAKE_CONNECT_STRING' as asset_lake (READ_ONLY);

.read '$WORK_SQL/Scripts2/wide_tables/ai2_floc_wide_table.sql'
.read '$WORK_SQL/Scripts2/wide_tables/ai2_equi_wide_table.sql'
.read '$WORK_SQL/Scripts2/wide_tables/s4_floc_wide_table.sql'
.read '$WORK_SQL/Scripts2/wide_tables/s4_equi_wide_table.sql'

copy (select * from ai2_equi_wide_table) TO '$dest/ai2_equi_wide_table.parquet' (FORMAT parquet, COMPRESSION snappy);
copy (select * from ai2_floc_wide_table) TO '$dest/ai2_floc_wide_table.parquet' (FORMAT parquet, COMPRESSION snappy);
copy (select * from s4_equi_wide_table)  TO '$dest/s4_equi_wide_table.parquet' (FORMAT parquet, COMPRESSION snappy);
copy (select * from s4_floc_wide_table)  TO '$dest/s4_floc_wide_table.parquet' (FORMAT parquet, COMPRESSION snappy);

detach asset_lake;
EOF
    destfiles=`find "$dest" -maxdepth 1 -type f -iname "*wide_table.parquet"`

    echo "Wrote:"
    echo "$destfiles"

else
    echo "Must set the env vars WORK_SQL and ASSET_LAKE_CONNECT_STRING"
fi