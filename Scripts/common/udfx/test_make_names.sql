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




WITH cte AS (
SELECT * FROM 
    (VALUES 
        ('HOME/XYZ/WORKING/EQUIPMENT: GENERATOR'),
        ('ISOLATORS + SWITCHES'),
        ('HOME/XYZ/1/ISOLATORS + SWITCHES/EQPT: ISOLATOR'),
    ) t(name)
) 
SELECT
    name AS full_name,
    udfx.get_equipment_path_from_common_name(cte.name) AS path,
    udfx.get_equipment_name_from_common_name(cte.name) AS name,
    udfx.get_equipment_type_from_common_name(cte.name) AS type,
FROM cte;