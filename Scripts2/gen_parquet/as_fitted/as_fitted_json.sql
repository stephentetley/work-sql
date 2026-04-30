.print 'Running as_fitted_json.sql...'


-- Setup the environment variable `AS_FITTED_GLOBPATH` before running this file
SELECT getenv('AS_FITTED_GLOBPATH') AS AS_FITTED_GLOBPATH;


create or replace table motor_checklists as
with cte as (
    select unnest(motor_checklists, recursive:=true) 
    from read_json(
            getenv('AS_FITTED_GLOBPATH'), 
            auto_detect=true, 
            maximum_depth=-1)
) select * replace (unnest(items) as items) from cte;

create or replace table test_sheets as
with cte1 as (
    select unnest(test_sheets, recursive:=true) 
    from read_json(
        getenv('AS_FITTED_GLOBPATH'), 
        auto_detect=true, 
        maximum_depth=-1)
), cte2 as (
    select * exclude(circuit_or_cables), unnest(circuit_or_cables, recursive:=true) from cte1
) select * from cte2;

-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM motor_checklists) TO '$(MOTOR_CHECKLISTS_OUTPATH)' (FORMAT parquet, COMPRESSION uncompressed);

-- COPY (SELECT * FROM test_sheets) TO '$(TEST_SHEETS_OUTPATH)' (FORMAT parquet, COMPRESSION uncompressed);


