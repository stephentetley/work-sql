
CREATE SCHEMA IF NOT EXISTS equi_compare;

CREATE OR REPLACE TABLE equi_compare.manufacturer (
    manufacturer VARCHAR NOT NULL,
    normed_manufacturer VARCHAR NOT NULL,
    PRIMARY KEY(manufacturer)
);


CREATE OR REPLACE TABLE equi_compare.model (
    model VARCHAR NOT NULL,
    normed_model VARCHAR NOT NULL,
    PRIMARY KEY(model)
);


-- manuf
CREATE OR REPLACE MACRO read_normed_manufacturer(xlsx_file) AS TABLE
SELECT 
    t."Manufacturer Name" AS 'manufacturer',
    t."Normed Manufacturer Name" AS 'normed_manufacturer',
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=TRUE, Sheet='manuf') AS t;


-- manuf
CREATE OR REPLACE MACRO read_normed_model(xlsx_file) AS TABLE
SELECT 
    t."Model Name" AS 'model',
    t."Normed Model Name" AS 'normed_model',
FROM read_xlsx(xlsx_file :: VARCHAR, all_varchar=TRUE, Sheet='model') AS t;

-- TODO - new file


DELETE FROM equi_compare.manufacturer;
DELETE FROM equi_compare.model;

INSERT INTO equi_compare.manufacturer BY NAME
SELECT 
    *
FROM read_normed_manufacturer(
    '/home/stephen/_working/coding/work/work-sql/data/normalized_manuf_model.xlsx'
);


INSERT INTO equi_compare.model BY NAME
SELECT 
    *
FROM read_normed_model(
    '/home/stephen/_working/coding/work/work-sql/data/normalized_manuf_model.xlsx'
);