-- test_measurement_conversion

WITH cte AS (
SELECT * FROM 
    (VALUES 
        (1),
        (2),
    ) t(sz_inches)
) 
SELECT
    cte.sz_inches AS inches,
    udfx.convert_to_mm(cte.sz_inches, 'INCHES') AS mm,
FROM cte;


WITH cte AS (
SELECT * FROM 
    (VALUES 
        (1),
        (2.9),
        (10.6666667)
    ) t(sz_meters)
) 
SELECT
    cte.sz_meters AS metres,
    udfx.convert_to_mm(cte.sz_meters, 'METRES') AS mm,
FROM cte;
