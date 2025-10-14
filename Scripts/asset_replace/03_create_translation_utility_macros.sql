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


CREATE OR REPLACE MACRO udf_local.lifting_type_to_pums_lifting_type(value) AS 
(WITH 
    cte1 AS (
        SELECT upper(value) AS valueu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN valueu = 'BLUE ROPE' THEN 'BLUE ROPE'
            WHEN valueu = 'CHAIN' THEN 'CHAIN'
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT answer FROM cte2
);

CREATE OR REPLACE MACRO udf_local.voltage_oc_or_dc_to_voltage_units(value) AS 
(WITH 
    cte1 AS (
        SELECT upper(value) AS valueu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN valueu = 'AC' OR valueu = 'ALTERNATING CURRENT' THEN 'VAC'
            WHEN valueu = 'DC' OR valueu = 'DIRECT CURRENT' THEN 'VDC'
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT answer FROM cte2
);


CREATE OR REPLACE MACRO udf_local.cat_flap_available_to_kisk_cat_flap_available(value) AS 
(WITH 
    cte1 AS (
        SELECT upper(value) AS valueu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN valueu = 'C+H' OR valueu = 'CABLE AND HOSE' THEN 'YES'
            WHEN valueu = 'CABLE' THEN 'YES'
            WHEN valueu = 'NONE' THEN 'NO'
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT answer FROM cte2
);


CREATE OR REPLACE MACRO udf_local.kiosk_material_to_kisk_material(value) AS 
(WITH 
    cte1 AS (
        SELECT upper(value) AS valueu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN valueu = 'GRP' OR valueu = 'GRP' THEN 'GLASS REINFORCED PLASTIC'
            WHEN valueu = 'STEL' OR valueu = 'STEEL' THEN 'STEEL'
            WHEN valueu = 'BRK' OR valueu = 'BRICK' THEN 'BRICK'
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT answer FROM cte2
);


CREATE OR REPLACE MACRO udf_local.swp_type_location_to_vper_swp_type(value) AS 
(WITH 
    cte1 AS (
        SELECT upper(value) AS valueu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN valueu = 'GEN' OR valueu = 'GENERIC - SAFEGUARD' THEN 'GENERIC'
            WHEN valueu = 'BES' OR valueu = 'BESPOKE - IMS' THEN 'BESPOKE'
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT answer FROM cte2
);


CREATE OR REPLACE MACRO udf_local.swp_type_location_to_vper_swp_location(value) AS 
(WITH 
    cte1 AS (
        SELECT upper(value) AS valueu
        ),
    cte2 AS ( 
        SELECT 
        CASE 
            WHEN valueu = 'GEN' OR valueu = 'GENERIC - SAFEGUARD' THEN 'SAFEGUARD'
            WHEN valueu = 'BES' OR valueu = 'BESPOKE - IMS' THEN 'IMS'
            ELSE null
        END AS answer
        FROM cte1
       ) 
SELECT answer FROM cte2
);

