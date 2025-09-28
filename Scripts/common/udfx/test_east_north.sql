WITH cte AS (
SELECT * FROM 
    (VALUES 
        ('hello world', 'SE4500079875'),
        ('hello world2', 'TA7800566500'),  
        ('three', null),  
    ) t(name, gridref)
) 
SELECT
    cte.*,
    t1.easting,
    t1.northing,
FROM cte
CROSS JOIN main.get_east_north(cte.gridref) t1


-- SELECT
--     t.*,
--     t1.easting,
--     t1.northing,
-- FROM hello_world t
-- CROSS JOIN udfx.get_east_north(t.loc_ref) t1;