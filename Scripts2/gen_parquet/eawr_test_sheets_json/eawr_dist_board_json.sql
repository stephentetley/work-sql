--
-- Copyright 2026 Stephen Tetley
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
-- http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 


-- Preliminaries: 
-- The variable `eawr_dist_board_schedules_globpath` is set in DuckDb (i.e. not env var)
-- As fitted files have already been parsed/analyzed and saved as JSON.



-- create or replace temporary macro replace_empty(str varchar) as
--     case when str = '' then null else str end;

-- create or replace temporary macro norm_text(str varchar) as
--     trim(str).regexp_replace('\s+', ' ', 'g').replace_empty();

create or replace table eawr_dist_board_load as
select 
    *,
from read_json(
    getvariable('eawr_dist_board_schedules_globpath')
);


-- Can't have a COPY statement with variables, do this in script, makefile...
-- COPY (SELECT * FROM as_fitted_circuits) TO '$(AS_FITTED_OUTPATH)' (FORMAT parquet, COMPRESSION uncompressed);



