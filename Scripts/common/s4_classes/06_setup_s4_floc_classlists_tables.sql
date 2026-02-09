
DELETE FROM s4_classlists.floc_enums;
INSERT INTO s4_classlists.floc_enums BY NAME
SELECT 
    simplify_class_name(t1.class_name) AS class_name,
    t1.char_name AS char_name,    
    t.enum_value AS enum_value,
    t.descrip AS enum_description,
FROM s4_classlists_landing.floc_classlist_file t
JOIN s4_classlists_landing.floc_char_ranges t1 
    ON t.row_ix >= t1.start_index AND t.row_ix <= t1.end_index
WHERE t.enum_value IS NOT NULL;


DELETE FROM s4_classlists.floc_characteristics;
INSERT INTO s4_classlists.floc_characteristics BY NAME
SELECT DISTINCT ON (t1.class_name, t.char_name)
    simplify_class_name(t1.class_name) AS class_name,
    t.char_name AS char_name,
    t1.class_descrip AS class_description,
    t.descrip AS char_description,
    if (t2.enum_value IS NULL, t.datatype, 'ENUM') AS char_type,
    t.datatype_length as char_length,
    t.datatype_precision as char_precision,
FROM s4_classlists_landing.floc_classlist_file t
JOIN s4_classlists_landing.floc_class_ranges t1 
    ON t.row_ix >= t1.start_index AND t.row_ix <= t1.end_index
LEFT JOIN s4_classlists.floc_enums t2
    ON t2.class_name = simplify_class_name(t1.class_name) AND t2.char_name = t.char_name
WHERE t.char_name IS NOT NULL
ORDER BY class_name, char_name;



