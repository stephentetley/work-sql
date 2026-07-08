#!/bin/bash

# Make sure to run this as a dot script...

if ! { [ -n "$1" ] && [ -n "$2" ]; } ; then
    echo "Supply the asset_lake name as param 1"
    echo "Supply the resources root folder as param 2"
    return 1 
fi

if [ ! -d "$2" ]; then
    echo "Folder $2 does not exist."
    return 1 
fi


if { [ ! -z "${WORK_SQL}" ] ; }; then
    
duckdb <<EOF

attach 'ducklake:$1' as asset_lake;


set variable asset_lake_resources = '$2';
.read '$WORK_SQL/Scripts2/asset_lake/01_build_asset_lake_level1.sql'
.read '$WORK_SQL/Scripts2/asset_lake/02_ai2_floc_wide_table.sql'
.read '$WORK_SQL/Scripts2/asset_lake/03_ai2_equi_wide_table.sql'
.read '$WORK_SQL/Scripts2/asset_lake/04_s4_floc_wide_table.sql'
.read '$WORK_SQL/Scripts2/asset_lake/05_s4_equi_wide_table.sql'

EOF

    echo "Created $1"

else
    echo "Must set the env var WORK_SQL"
fi

