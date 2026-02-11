-- DO NOT RUN - TO BE REMOVED

-- udfx - attached, not copied

-- https://duckdb.org/docs/stable/guides/snippets/sharing_macros

ATTACH OR REPLACE DATABASE 
    '~/_working/coding/work/work-sql/databases/udf_db.duckdb' 
AS udfx_db (READ_ONLY);

-- ztables - attached, not copied


ATTACH OR REPLACE DATABASE 
    '~/_working/coding/work/work-sql/databases/ztables_db.duckdb' 
AS ztables_db (READ_ONLY);

-- Run last script to detach these databases

