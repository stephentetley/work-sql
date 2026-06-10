#!/bin/bash

# Make sure to run this as a dot script...


if ! { [ -n "$1" ] && [ -n "$2" ]; } ; then
    echo "Supply the json glob as param 1"
    echo "Supply the output duckdb filename as param 2"
    return 1 
fi


if { [ ! -z "${WORK_SQL}" ]; }; then
    
duckdb $2 <<EOF

set variable as_fitted_globpath = '$1';

.read '$WORK_SQL/Scripts2/reports/as_fitted2/as_fitted2.sql'

EOF

    echo "Created ???"
else
    echo "Must set the env vars WORK_SQL"
fi



