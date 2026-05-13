.print 'Running as_fitted_json.sql...'


-- Setup the environment variable `AS_FITTED_GLOBPATH` before running this file
select getenv('AS_FITTED_GLOBPATH') as AS_FITTED_GLOBPATH;



create or replace temporary macro replace_empty(str varchar) as
    case when str = '' then null else str end;


create or replace temporary macro norm_text(str varchar) as
    trim(str).regexp_replace('\s+', ' ', 'g').replace_empty();

create or replace table as_fitted_circuits as
select 
    norm_text(COLUMNS(*)) 
from read_json(getenv('AS_FITTED_GLOBPATH'));


-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM as_fitted_circuits) TO '$(AS_FITTED_OUTPATH)' (FORMAT parquet, COMPRESSION uncompressed);



