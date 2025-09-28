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

-- create macros in main schema
-- macros must be completely independent and mustn't depend on other 
-- macros or tables

CREATE OR REPLACE MACRO get_east_north(gridref) AS TABLE 
WITH cte_major AS (
    SELECT * FROM 
        (VALUES 
            ('S', 0,        0), 
            ('T', 500_000,  0),
            ('N', 0,        500_000),
            ('O', 500_000,  500_000),
            ('H', 0,        1_000_000),        
        ) east_north_major(ix, east, north)
), cte_minor AS (
    SELECT * FROM 
        (VALUES 
            ('A', 0,         400_000),
            ('B', 100_000,   400_000),
            ('C', 200_000,   400_000),
            ('D', 300_000,   400_000),
            ('E', 400_000,   400_000),
            ('F', 0,         300_000),
            ('G', 100_000,   300_000),
            ('H', 200_000,   300_000),
            ('J', 300_000,   300_000),
            ('K', 400_000,   300_000),
            ('L', 0,         200_000),
            ('M', 100_000,   200_000),
            ('N', 200_000,   200_000),
            ('O', 300_000,   200_000),
            ('P', 400_000,   200_000),
            ('Q', 0,         100_000),
            ('R', 100_000,   100_000),
            ('S', 200_000,   100_000),
            ('T', 300_000,   100_000),
            ('U', 400_000,   100_000),
            ('V', 0,         0),
            ('W', 100_000,   0),
            ('X', 200_000,   0),
            ('Y', 300_000,   0),
            ('Z', 400_000,   0),    
        ) east_north_minor(ix, east, north)
), cte1 AS (
    SELECT 
        upper(gridref[1]) AS major_letter,
        upper(gridref[2]) AS minor_letter,
        try_cast(gridref[3:7] AS INTEGER) AS east1,
        try_cast(gridref[8:12] AS INTEGER) AS north1,        
), cte2 AS (
    SELECT 
        t_major.east + t_minor.east + cte1.east1 AS easting, 
        t_major.north + t_minor.north + cte1.north1 AS northing,
    FROM cte1
    LEFT JOIN cte_major t_major ON t_major.ix = cte1.major_letter
    LEFT JOIN cte_minor t_minor ON t_minor.ix = cte1.minor_letter
)
SELECT 
    easting,
    northing, 
FROM cte2
;

-- -- Example of how to call....
--
-- ATTACH OR REPLACE DATABASE '/home/stephen/_working/coding/work/work-sql/udfx_in_sql/udfx_db.duckdb' AS udfx;
--
--
-- SELECT
--     t.*,
--     t1.easting,
--     t1.northing,
-- FROM hello_world t
-- CROSS JOIN udfx.get_east_north(t.loc_ref) t1;
--

