
-- https://duckdb.org/docs/stable/guides/snippets/sharing_macros

-- udfx - attached, not copied

ATTACH OR REPLACE DATABASE 
    '/home/stephen/_working/coding/work/work-sql/databases/udf_db.duckdb' 
AS udfx_db (READ_ONLY);

-- classlists - attached, not copied

ATTACH OR REPLACE DATABASE 
    '/home/stephen/_working/coding/work/work-sql/databases/classlists_db.duckdb' 
AS classlists_db (READ_ONLY);

-- classlists - attached, not copied

ATTACH OR REPLACE DATABASE 
    '/home/stephen/_working/coding/work/work-sql/databases/ai2_classes_db.duckdb' 
AS ai2_classes_db (READ_ONLY);


