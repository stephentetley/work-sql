#!/bin/bash

duckdb << EOF
attach '$1' as sqlite_db (type sqlite);
.read '$WORK_SQL/Scripts2/excel_uploader/create_sqlite_tables.sql'
detach sqlite_db
EOF

echo "Created $1"

