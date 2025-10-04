
CREATE OR REPLACE TEMPORARY MACRO get_table_name(name) AS (
    udfx_db.udfx.make_snake_case_name(replace(name :: VARCHAR, 'EQUIPMENT: ', ''))
);

INSERT INTO ai2_classlists.equi_characteristics BY NAME
WITH cte AS (
    SELECT 
        t.* 
    FROM ai2_classlists_landing.equipment_attribute_sets t
    WHERE t.class_derivation = 'Equiclass'
) 
SELECT 
    t1.* EXCLUDE (attribute_set_name),
    get_table_name(t1.class_description) AS class_table_name,
FROM cte t
JOIN ai2_classlists_landing.asset_type_attributes t1 
    ON t1.class_description = t.class_name
    AND t1.attribute_set_name = t.attribute_set_name;