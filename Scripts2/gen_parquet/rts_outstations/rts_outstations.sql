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
-- The variables `outstations_summary_txt_path` set in DuckDb (i.e. not env vars)


CREATE OR REPLACE TABLE rts_outstations (
    -- e.g. 'TIGER_STREET_ABC'
    os_name VARCHAR NOT NULL,
    -- e.g. 'SAI00123456'
    od_name VARCHAR,
    -- e.g. 'TIGER STREET/ABC'
    od_comment VARCHAR,
    -- e.g. 'MK5 ...'
    os_comment VARCHAR,
    -- e.g. 'ON'
    on_scan VARCHAR,
    PRIMARY KEY (os_name)
);


CREATE OR REPLACE TEMPORARY MACRO norm_text(name VARCHAR) AS
    trim(name).regexp_replace('\s+', ' ', 'g');

CREATE OR REPLACE TEMPORARY MACRO tidy_string(str VARCHAR) AS
    CASE WHEN norm_text(str) = '' THEN NULL ELSE norm_text(str) END;


CREATE OR REPLACE TABLE outstations_landing AS 
SELECT 
    tidy_string(COLUMNS(*))
FROM read_csv(
    getvariable(outstations_summary_txt_path),
    header=true,
    delim='\t'
);


