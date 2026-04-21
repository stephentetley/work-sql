.print 'Running outstations_summary.sql...'

CREATE OR REPLACE TABLE s4_equi (
    -- e.g. 'TIGER_STREET_ABC'
    os_name VARCHAR NOT NULL,
    -- e.g. 'SAI00123456'
    od_name VARCHAR,
    -- e.g. 'TIGER STREET/ABC'
    od_comment VARCHAR,
    -- e.g. 'MK5 ...'
    os_comment VARCHAR,
    -- e.g. 'ON'
    on_scan VARCHAR,
    PRIMARY KEY (os_name)
);




-- Set the environment variable `OUTSTATIONS_SUMMARY_TXT_PATH` before running this file
SELECT getenv('OUTSTATIONS_SUMMARY_TXT_PATH') AS OUTSTATIONS_SUMMARY_TXT_PATH;


CREATE OR REPLACE TEMPORARY MACRO norm_text(name VARCHAR) AS
    trim(name).regexp_replace('\s+', ' ', 'g');

CREATE OR REPLACE TEMPORARY MACRO tidy_string(str VARCHAR) AS
    CASE WHEN norm_text(str) = '' THEN NULL ELSE norm_text(str) END;


CREATE OR REPLACE TABLE outstations_landing AS 
SELECT 
    tidy_string(COLUMNS(*))
FROM read_csv(
    getenv(OUTSTATIONS_SUMMARY_TXT_PATH),
    header=true,
    delim='\t'
);


