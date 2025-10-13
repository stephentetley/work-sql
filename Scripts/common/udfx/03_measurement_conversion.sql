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


CREATE OR REPLACE MACRO udfx.convert_to_mm(sz, units) AS 
(WITH 
    cte1 AS (
        SELECT upper(units) AS unitsu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN unitsu = 'MM' OR unitsu = 'MILLIMETRES' THEN sz
            WHEN unitsu = 'CM' OR unitsu = 'CENTIMETRES'  THEN sz * 10
            WHEN unitsu = 'M'  OR unitsu = 'METRES' THEN sz * 1000.0
            WHEN unitsu = 'INCHES' THEN sz * 25.4
            WHEN unitsu = 'FEET' THEN sz * 304.8
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT round(answer, 0) FROM cte2
);

