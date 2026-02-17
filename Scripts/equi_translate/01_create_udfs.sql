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

.print 'Running 01_create_udfs.sql...'


CREATE SCHEMA IF NOT EXISTS udf;

CREATE OR REPLACE MACRO udf.get_east_north_struct(gridref) AS (
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
    struct_pack(easting := cte2.easting, northing := cte2.northing)
FROM cte2
);


CREATE OR REPLACE MACRO udf.convert_to_millimetres(sz, units) AS 
(WITH 
    cte1 AS (
        SELECT upper(units) AS unitsu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN unitsu = 'MM' OR unitsu = 'MILLIMETRES' THEN sz
            WHEN unitsu = 'CM' OR unitsu = 'CENTIMETRES'  THEN sz * 10.0
            WHEN unitsu = 'M'  OR unitsu = 'METRES' THEN sz * 1000.0
            WHEN unitsu = 'IN' OR unitsu = 'INCH' OR unitsu = 'INCHES' THEN sz * 25.4
            WHEN unitsu = 'FEET' THEN sz * 304.8
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT round(answer, 0) FROM cte2
);

CREATE OR REPLACE MACRO udf.convert_to_metres(sz, units) AS 
(WITH 
    cte1 AS (
        SELECT upper(units) AS unitsu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN unitsu = 'MM' OR unitsu = 'MILLIMETRES' THEN sz * 1000.0
            WHEN unitsu = 'CM' OR unitsu = 'CENTIMETRES'  THEN sz * 100.0
            WHEN unitsu = 'M'  OR unitsu = 'METRES' THEN sz
            WHEN unitsu = 'IN' OR unitsu = 'INCH' OR unitsu = 'INCHES' THEN sz / 39.37
            WHEN unitsu = 'FEET' THEN sz / 3.281
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT round(answer, 0) FROM cte2
);


CREATE OR REPLACE MACRO udf.convert_to_litres_per_second(fl, units) AS 
(WITH 
    cte1 AS (
        SELECT upper(units) AS unitsu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN unitsu = 'L/S' OR unitsu = 'LITRES PER SECOND' THEN fl
            WHEN unitsu = 'L/MIN' OR unitsu = 'LITRE PER MINUTE' THEN fl / 60.0
            WHEN unitsu = 'L/HR'  OR unitsu = 'LITRE PER HOUR' THEN fl / 3600.0
            WHEN unitsu = 'M³/S' OR unitsu = 'CUBIC METRE PER SECOND' THEN fl * 1000
            WHEN unitsu = 'M³/H' OR unitsu = 'CUBIC METRE PER HOUR' THEN fl * 3.6
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT round(answer, 3) FROM cte2
);


CREATE OR REPLACE MACRO udf.convert_to_cubic_metres_per_hour(fl, units) AS 
(WITH 
    cte1 AS (
        SELECT upper(units) AS unitsu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN unitsu = 'L/S' OR unitsu = 'LITRES PER SECOND' THEN fl * 3.6
            WHEN unitsu = 'L/MIN' OR unitsu = 'LITRE PER MINUTE' THEN fl / 16.667
            WHEN unitsu = 'L/HR'  OR unitsu = 'LITRE PER HOUR' THEN fl / 1000.0
            WHEN unitsu = 'M³/S' OR unitsu = 'CUBIC METRE PER SECOND' THEN fl * 3600.0
            WHEN unitsu = 'M³/H' OR unitsu = 'CUBIC METRE PER HOUR' THEN fl
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT round(answer, 3) FROM cte2
);

CREATE OR REPLACE MACRO udf.convert_to_kilowatts(pw, units) AS 
(WITH 
    cte1 AS (
        SELECT upper(units) AS unitsu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN unitsu = 'KW' OR unitsu = 'KILOWATTS' THEN pw
            WHEN unitsu = 'W' OR unitsu = 'WATTS' THEN pw / 1000.0
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT round(answer, 3) FROM cte2
);

CREATE OR REPLACE MACRO udf.get_s4_asset_status(str) AS
(WITH 
    cte1 AS (
        SELECT upper(str) AS stru
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN stru = 'ABANDONED' THEN 'ABND'
            WHEN stru = 'ADOPTABLE' THEN '##ADOPTABLE' 
            WHEN stru = 'AWAITING DISPOSAL' THEN 'ADIS'
            WHEN stru = 'CLOSED' THEN '##CLOSED'
            WHEN stru = 'DECOMMISSIONED' THEN 'DCOM'
            WHEN stru = 'DISPOSED OF' THEN 'DISP'
            WHEN stru = 'NON OPERATIONAL' THEN 'NOP'
            WHEN stru = 'OPERATIONAL' THEN 'OPER'
            WHEN stru = 'PLANNED' THEN '##PLANNED'
            WHEN stru = 'SOLD' THEN 'SOLD'
            WHEN stru = 'TO BE COMMISSIONED' THEN 'TBCM'
            WHEN stru = 'TO BE CONSTRUCTED' THEN '##TO_BE_CONSTRUCTED'
            WHEN stru = 'TRANSFERRED' THEN 'TRAN'
            WHEN stru = 'UNDER CONSTRUCTION' THEN 'UCON'
            ELSE '##ERROR[' || stru || ']'
        END AS answer
        FROM cte1
       ) 
SELECT answer FROM cte2
);

CREATE OR REPLACE MACRO udf.get_weight_limit_tonnes(value) AS 
    TRY_CAST(regexp_extract(value :: VARCHAR, '([0-9]+\.[0-9]+|[0-9]+)[tT]', 1) AS DECIMAL)
;

--SELECT 
--    udf.get_weight_limit_tonnes('1.3t') AS a,
--    udf.get_weight_limit_tonnes('10t') AS b
--    ;
    

CREATE OR REPLACE MACRO udf.format_signal3(smin, smax, units) AS 
(WITH 
    cte1 AS (
        SELECT 
            upper(units) AS unitsu, 
            trunc(TRY_CAST(smin AS DECIMAL)) AS smini,
            trunc(TRY_CAST(smax AS DECIMAL)) AS smaxi,
        )
SELECT smini || ' - ' || smaxi || ' ' || unitsu FROM cte1
);

-- # Enums

-- Leave in duplicated alternatives as it is easier to visually check 
-- them against the source...

CREATE OR REPLACE MACRO udf.acdc_3_to_voltage_units(value) AS 
CASE
    WHEN value = 'AC' OR value = 'ALTERNATING CURRENT' THEN 'VAC'
    WHEN value = 'DC' OR value = 'DIRECT CURRENT' THEN 'VDC'
    ELSE null
END;

-- Excel may try to turn these into dates...
CREATE OR REPLACE MACRO udf.bdfv_757_to_bridge_vehicles_per_day(value) AS 
CASE 
    WHEN value = '0'      OR value = '0'      THEN null
    WHEN value = '1-10'   OR value = '01-Oct' THEN '1 - 10'
    WHEN value = '11-50'  OR value = '11-Nov' THEN '11 - 50'
    WHEN value = '51-100' OR value = '51-100' THEN '51 - 100'
    WHEN value = '101+'   OR value = '101+'   THEN '101 PLUS'
    ELSE null
END;


CREATE OR REPLACE MACRO udf.cafl_435_to_kisk_cat_flap_available(value) AS 
CASE 
    WHEN value = 'C+H' OR value = 'CABLE AND HOSE' THEN 'YES'
    WHEN value = 'CABLE' THEN 'YES'
    WHEN value = 'NONE'  THEN 'NO'
    ELSE null
END;


CREATE OR REPLACE MACRO udf.kosk_471_to_kisk_material(value) AS 
CASE 
    WHEN value = 'GRP'  OR value = 'GRP'   THEN 'GLASS REINFORCED PLASTIC'
    WHEN value = 'STEL' OR value = 'STEEL' THEN 'STEEL'
    WHEN value = 'BRK'  OR value = 'BRICK' THEN 'BRICK'
    ELSE null
END;


CREATE OR REPLACE MACRO udf.lity_388_to_pump_lifting_type(value) AS 
CASE 
    WHEN value = 'BR'  OR value = 'BLUE ROPE' THEN 'BLUE ROPE'
    WHEN value = 'CHN' OR value = 'CHAIN'     THEN 'CHAIN'
    ELSE null
END;

CREATE OR REPLACE MACRO udf.rngu_132_to_anal_range_unit(value) AS 
CASE 
    WHEN value = 'HAZN'    OR value = 'Hazen' THEN 'HAZEN'
    WHEN value = 'M'       OR value = 'm'     THEN 'M'
    WHEN value = 'MBAR'    OR value = 'mbar'  THEN 'MBAR'
    WHEN value = 'MGL'     OR value = 'mg/l'  THEN 'MG/L'
    WHEN value = 'MSCM'    OR value = 'µS/cm' THEN 'MS/CM'
    WHEN value = 'NTU'     OR value = 'NTU'   THEN 'NTU'
    WHEN value = 'PH'      OR value = 'pH'    THEN 'PH'
    WHEN value = 'Deg C'   OR value = 'Deg C' THEN 'DEG C'
    WHEN value = 'Deg F'   OR value = 'Deg F' THEN 'DEG F'
    WHEN value = 'pp/m'    OR value = 'pp/m'  THEN 'PPM'
    WHEN value = 'Bar'     OR value = 'Bar'   THEN 'BAR'
    WHEN value = 'l/h'     OR value = 'l/h'   THEN 'L/H'
    WHEN value = 'l/s'     OR value = 'l/s'   THEN 'L/S'
    WHEN value = 'FTU'     OR value = 'Formazine Turbidity Unit' THEN 'FTU'
    WHEN value = 'Ml/d'    OR value = 'Ml/d'  THEN 'ML/D'
    WHEN value = 'm3/d'    OR value = 'm3/d'  THEN 'M3/D'
    WHEN value = 'm3/h'    OR value = 'm3/h'  THEN 'M3/H'
    WHEN value = 'Percent' OR value = '%'     THEN 'PCT'
    WHEN value = 'Kg/h'    OR value = 'Kg/h'  THEN 'KG/H'
    WHEN value = 'g/l'     OR value = 'g/l'   THEN 'G/L'
    WHEN value = 'mm'      OR value = 'mm'    THEN 'MM'
    WHEN value = 'm/s'     OR value = 'm/s'   THEN 'M/S'
    WHEN value = 'kPa'     OR value = 'kPa'   THEN 'KPA'
    WHEN value = 'cm/s'    OR value = 'cm/s'  THEN 'CM/S'
    WHEN value = 'kg'      OR value = 'kg'    THEN 'KG'
    WHEN value = 'W/m2'    OR value = 'W/m2'  THEN 'W/M2'
    WHEN value = 'mV'      OR value = 'mV'    THEN 'MV'
    WHEN value = 'Nm3Hr'   OR value = 'Nm3/h' THEN 'NM3/H'
    WHEN value = 'Am3/h'   OR value = 'Am3/h' THEN 'AM3/H'
    WHEN value = 'mmH2o'   OR value = 'mmH2o' THEN 'MM H2O'
    ELSE null
END;


CREATE OR REPLACE MACRO udf.swpt_815_to_vepr_swp_type(value) AS 
CASE 
    WHEN value = 'GEN' OR value = 'GENERIC - SAFEGUARD' THEN 'GENERIC'
    WHEN value = 'BES' OR value = 'BESPOKE - IMS'       THEN 'BESPOKE'
    ELSE null
END;


CREATE OR REPLACE MACRO udf.swpt_815_to_vepr_swp_location(value) AS 
CASE 
    WHEN value = 'GEN' OR value = 'GENERIC - SAFEGUARD' THEN 'SAFEGUARD'
    WHEN value = 'BES' OR value = 'BESPOKE - IMS'       THEN 'IMS'
    ELSE null
END;


CREATE OR REPLACE MACRO udf.wlun_337_to_swl_units(value) AS 
CASE 
    WHEN value = 'KG'    OR value = 'KILOGRAM'               THEN 'KG'
    WHEN value = 'KW'    OR value = 'KILOWATT'               THEN 'KW'
    WHEN value = 'T'     OR value = 'TONNE'                  THEN 'TON'
    WHEN value = 'TON'   OR value = 'TON (UK)'               THEN 'TON (UK)'
    WHEN value = 'CWT'   OR value = 'HUNDREDWEIGHT'          THEN 'CWT'
    WHEN value = 'KJ/KG' OR value = 'KILOJOULE PER KILOGRAM' THEN 'KJ/KG'
    WHEN value = 'A'     OR value = 'UAMPERE'                THEN 'A'
    WHEN value = 'KN'    OR value = 'KILONEWTON'             THEN 'KN'
    WHEN value = 'MAN'   OR value = 'MAN'                    THEN 'MAN'
    ELSE null
END;



