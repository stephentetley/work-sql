.print 'Running 04_setup_equi_classes.sql...'

CREATE OR REPLACE TEMPORARY MACRO get_table_name(name) AS (
    replace(name :: VARCHAR, 'EQUIPMENT: ', '').
        trim().
        regexp_replace('[^[:word:]]+', '_', 'g').
        regexp_replace('_$', '')
);

INSERT OR REPLACE INTO ai2_classlists.equi_characteristics BY NAME
WITH cte AS (
    SELECT 
        t.* 
    FROM ai2_classlists_landing.equipment_attribute_sets t
    WHERE t.class_derivation IN ('Equiclass', 'Equimixin') 
) 
SELECT 
    t1.*,
    t.class_derivation as class_derivation,
    CASE 
        WHEN t.class_derivation = 'Equiclass' THEN get_table_name(t1.class_description)
        WHEN t.class_derivation = 'Equimixin' THEN get_table_name(t1.attribute_set_name)
        ELSE null 
    END AS class_table_name,
FROM cte t
JOIN ai2_classlists_landing.asset_type_attributes t1 
    ON t1.class_description = t.class_name
    AND t1.attribute_set_name = t.attribute_set_name;
    
