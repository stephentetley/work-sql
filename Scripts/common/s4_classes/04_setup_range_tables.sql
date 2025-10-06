
CREATE OR REPLACE TABLE s4_classlists_landing.equi_class_ranges (
    class_name VARCHAR NOT NULL, 
    class_descrip VARCHAR,
    start_index INTEGER, 
    end_index INTEGER, 
    PRIMARY KEY(class_name)
);

CREATE OR REPLACE TABLE s4_classlists_landing.equi_char_ranges (
    class_name VARCHAR NOT NULL, 
    char_name VARCHAR NOT NULL,
    char_descrip VARCHAR,
    start_index INTEGER, 
    end_index INTEGER, 
    PRIMARY KEY(class_name, char_name)
);



DELETE FROM s4_classlists_landing.equi_class_ranges;

INSERT INTO s4_classlists_landing.equi_class_ranges BY NAME 
WITH cte1 AS (
SELECT 
    row_number() OVER () AS class_index,
    row_ix AS start_index, 
    class_name, 
    descrip AS class_descrip 
FROM s4_classlists_landing.equi_classlist_file
WHERE class_name IS NOT NULL
), cte2 AS (
SELECT 
    t.class_name, 
    t.class_descrip, 
    t.start_index, 
    t1.start_index - 1 AS end_index, 
FROM cte1 t
JOIN cte1 t1 ON t1.class_index-1 = t.class_index
)
SELECT * FROM cte2;

-- find last class range 
INSERT INTO s4_classlists_landing.equi_class_ranges BY NAME
WITH cte1 AS (
    SELECT 
        max(row_ix) AS start_index,
    FROM s4_classlists_landing.equi_classlist_file 
    WHERE class_name IS NOT NULL
), cte2 AS (
    SELECT max(row_ix) AS end_index FROM s4_classlists_landing.equi_classlist_file 
), cte3 AS (
SELECT 
    class_name, 
    descrip AS class_descrip, 
FROM s4_classlists_landing.equi_classlist_file t
JOIN cte1 t1 ON t.row_ix = t1.start_index
)
SELECT cte3.class_name, cte3.class_descrip, cte1.start_index, cte2.end_index FROM cte1, cte2, cte3 
;


DELETE FROM s4_classlists_landing.equi_char_ranges;

INSERT INTO s4_classlists_landing.equi_char_ranges BY NAME
WITH cte1 AS (
SELECT 
    row_number() OVER () AS char_index,
    row_ix AS start_index, 
    char_name, 
    descrip AS char_descrip,
FROM s4_classlists_landing.equi_classlist_file
WHERE char_name IS NOT NULL
), cte2 AS (
SELECT 
    t2.class_name,
    t.char_name, 
    t.char_descrip, 
    t.start_index, 
    t1.start_index - 1 AS end_index, 
FROM cte1 t
JOIN cte1 t1 ON t1.char_index-1 = t.char_index
JOIN s4_classlists_landing.equi_class_ranges t2 ON t.start_index >= t2.start_index AND t.start_index <= t2.end_index
)
SELECT * FROM cte2
ORDER BY cte2.start_index;


-- find last char range 
INSERT INTO s4_classlists_landing.equi_char_ranges BY NAME
WITH cte1 AS (
    SELECT 
        max(row_ix) AS start_index,
    FROM s4_classlists_landing.equi_classlist_file  
    WHERE char_name IS NOT NULL
), cte2 AS (
    SELECT max(row_ix) AS end_index FROM s4_classlists_landing.equi_classlist_file 
), cte3 AS (
SELECT 
    t2.class_name AS class_name, 
    t.char_name AS char_name, 
    t.descrip AS char_descrip, 
FROM s4_classlists_landing.equi_classlist_file t
JOIN cte1 t1 ON t.row_ix = t1.start_index
JOIN s4_classlists_landing.equi_class_ranges t2 ON t.row_ix >= t2.start_index AND t.row_ix <= t2.end_index
)
SELECT cte3.class_name, cte3.char_name, cte3.char_descrip, cte1.start_index, cte2.end_index FROM cte1, cte2, cte3
;



--SELECT 
--    t1.class_name AS class_name,
--    t1.descrip AS class_desciption,
--    t.* EXCLUDE (class_name)
--FROM s4_classlists_landing.equi_classlist_file t
--JOIN s4_classlists_landing.equi_class_ranges t1 ON t.row_ix >= t1.start_index AND t.row_ix <= t1.end_index
--WHERE char_name IS NOT NULL 
--ORDER BY t.row_ix;
