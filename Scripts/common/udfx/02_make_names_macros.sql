-- 
-- Copyright 2025 Stephen Tetley
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


-- https://duckdb.org/docs/stable/guides/snippets/sharing_macros.html

CREATE OR REPLACE MACRO udfx.make_snake_case_name(name) AS (
    lower(name :: VARCHAR).trim().regexp_replace('[^[:word:]]+', '_', 'g').regexp_replace('_$', '')
);


CREATE OR REPLACE MACRO udfx.get_equipment_path_from_common_name(common_name) AS (
    replace(common_name :: VARCHAR, '/EQPT:', '/EQUIPMENT:').regexp_extract( '(.*)/EQUIPMENT:', 1)
);

CREATE OR REPLACE MACRO udfx.get_equipment_name_from_common_name(common_name) AS (
    replace(common_name :: VARCHAR, '/EQPT:', '/EQUIPMENT:').regexp_extract( '.*/([^[/]+)/EQUIPMENT:', 1)
);

CREATE OR REPLACE MACRO udfx.get_equipment_type_from_common_name(common_name) AS (
    replace(common_name :: VARCHAR, '/EQPT:', '/EQUIPMENT:').regexp_extract('.*/EQUIPMENT: (.*)$', 1)
);