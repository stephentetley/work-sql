
WITH cte AS (
SELECT * FROM 
    (VALUES 
        ('SITE/XYZ/FILTERS/PRESSURE FLOW METER/EQUIPMENT: GAUGE PRESSURE'),
        ('SITE/XYZ/PUMPING/NITRATE MONITOR/EQUIPMENT: NITRATE INSTRUMENT'),
        ('SITE/XYZ/FILTERS/DIFFERENTIAL PRESSURE FLOW INSTRUMENT/EQPT: DIFFERENTIAL PRESSURE FLOW INST'),
    ) t(name)
) 
SELECT
    udfx.expand_common_name(cte.name) AS path,
    udfx.get_equipment_type_from_common_name(path) AS equi_type,
FROM cte;


