CREATE SCHEMA IF NOT EXISTS udf_local;


CREATE OR REPLACE MACRO udf_local.get_s4_asset_status(str) AS
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


CREATE OR REPLACE MACRO udf_local.format_signal3(smin, smax, units) AS 
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

CREATE OR REPLACE MACRO udf_local.acdc_3_to_voltage_units(value) AS 
CASE
    WHEN value = 'AC' OR value = 'ALTERNATING CURRENT' THEN 'VAC'
    WHEN value = 'DC' OR value = 'DIRECT CURRENT' THEN 'VDC'
    ELSE null
END;

-- to complete... returns number
CREATE OR REPLACE MACRO udf_local.bdwl_736_to_bridge_weight_limit(value) AS 
CASE 
    WHEN value = '1'  OR value = '1.5(tonnes)' THEN 1.5
    ELSE null
END;


CREATE OR REPLACE MACRO udf_local.cafl_435_to_kisk_cat_flap_available(value) AS 
CASE 
    WHEN value = 'C+H' OR value = 'CABLE AND HOSE' THEN 'YES'
    WHEN value = 'CABLE' THEN 'YES'
    WHEN value = 'NONE'  THEN 'NO'
    ELSE null
END;


CREATE OR REPLACE MACRO udf_local.kosk_471_to_kisk_material(value) AS 
CASE 
    WHEN value = 'GRP'  OR value = 'GRP'   THEN 'GLASS REINFORCED PLASTIC'
    WHEN value = 'STEL' OR value = 'STEEL' THEN 'STEEL'
    WHEN value = 'BRK'  OR value = 'BRICK' THEN 'BRICK'
    ELSE null
END;


CREATE OR REPLACE MACRO udf_local.lity_388_to_pump_lifting_type(value) AS 
CASE 
    WHEN value = 'BR'  OR value = 'BLUE ROPE' THEN 'BLUE ROPE'
    WHEN value = 'CHN' OR value = 'CHAIN'     THEN 'CHAIN'
    ELSE null
END;

CREATE OR REPLACE MACRO udf_local.rngu_132_to_anal_range_unit(value) AS 
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


CREATE OR REPLACE MACRO udf_local.swpt_815_to_vepr_swp_type(value) AS 
CASE 
    WHEN value = 'GEN' OR value = 'GENERIC - SAFEGUARD' THEN 'GENERIC'
    WHEN value = 'BES' OR value = 'BESPOKE - IMS'       THEN 'BESPOKE'
    ELSE null
END;


CREATE OR REPLACE MACRO udf_local.swpt_815_to_vepr_swp_location(value) AS 
CASE 
    WHEN value = 'GEN' OR value = 'GENERIC - SAFEGUARD' THEN 'SAFEGUARD'
    WHEN value = 'BES' OR value = 'BESPOKE - IMS'       THEN 'IMS'
    ELSE null
END;


CREATE OR REPLACE MACRO udf_local.wlun_337_to_swl_units(value) AS 
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




