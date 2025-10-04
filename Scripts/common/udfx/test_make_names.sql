-- test_make_names

WITH cte AS (
SELECT * FROM 
    (VALUES 
        ('L.O.I.'),
        ('ISOLATORS + SWITCHES'),
    ) t(name)
) 
SELECT
    udfx.make_snake_case_name(cte.name) AS clean_name,
FROM cte;
