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
-- The variable `aibref_src_xlsx` is set in DuckDb (i.e. not an env vars)
-- The community extension `rusty_sheet` is loaded:
-- D INSTALL rusty_sheet FROM community;
-- D LOAD rusty_sheet;



CREATE OR REPLACE TABLE aibref_source AS
SELECT *
FROM read_sheet(
    getvariable('aibref_src_xlsx'),
    sheet='Sheet1', 
    header=true)
