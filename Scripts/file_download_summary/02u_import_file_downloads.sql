



CREATE OR REPLACE TABLE file_download_landing.equi AS
SELECT 
    *
FROM read_equi(
    '/home/stephen/_working/work/2024/file_download/woo54/equi_download.txt'
);


CREATE OR REPLACE TABLE file_download_landing.classequi AS
SELECT 
    *
FROM read_classequi(
    '/home/stephen/_working/work/2024/file_download/woo54/classequi_download.txt'
);

CREATE OR REPLACE TABLE file_download_landing.valuaequi AS
SELECT 
    *
FROM read_valuaequi(
    '/home/stephen/_working/work/2024/file_download/woo54/valuaequi_download.txt'
);

CREATE OR REPLACE TABLE file_download_landing.funcloc AS
SELECT 
    *
FROM read_funcloc(
    '/home/stephen/_working/work/2024/file_download/woo54/floc_download.txt'
);

CREATE OR REPLACE TABLE file_download_landing.classfloc AS
SELECT 
    *
FROM read_classfloc(
    '/home/stephen/_working/work/2024/file_download/woo54/classfloc_download.txt'
);

CREATE OR REPLACE TABLE file_download_landing.valuafloc AS
SELECT 
    *
FROM read_valuafloc(
    '/home/stephen/_working/work/2024/file_download/woo54/valuafloc_download.txt'
);



