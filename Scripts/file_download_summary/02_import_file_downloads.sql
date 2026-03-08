
.print 'Running 02_import_file_downloads.sql...'

CREATE SCHEMA IF NOT EXISTS file_download_landing;

-- Setup the environment variable `FUNCLOC_DOWNLOAD` before running this file
SELECT getenv('FUNCLOC_DOWNLOAD') AS FUNCLOC_DOWNLOAD;


CREATE OR REPLACE TABLE file_download_landing.funcloc AS
SELECT 
    * RENAME("*FUNCLOC" AS "FUNCLOC")
FROM read_csv(
    getenv('FUNCLOC_DOWNLOAD'), 
    dateformat='%d.%m.%Y',
    types = {
        '*FUNCLOC': 'VARCHAR',
        'ABCKZFLOC': 'VARCHAR',
        'ANSWT': 'DECIMAL',
        'ANSDT': 'DATE',
        'CGWLDT_FL': 'DATE',
        'VGWLDT_FL': 'DATE',
        'KOST_FLOC': 'INTEGER',
        'FLTYP': 'INTEGER',
        'BRGEW': 'DECIMAL',
        'SWERK_FL': 'INTEGER',
        'PLNT_FLOC': 'INTEGER',
        'WERGWFLOC': 'INTEGER',
        'POSNR': 'INTEGER',
        'INBDT': 'DATE',
        'DATBI_FLO': 'DATE',
        'CGWLEN_FL': 'DATE',
        'VGWLEN_FL': 'DATE',
        'BAUMM': 'INTEGER',
        'BAUJJ': 'INTEGER',
        'KOKR_FLOC': 'INTEGER',
        'ADRNR': 'VARCHAR',
        'ALKEY': 'INTEGER',
    },
    nullstr = ['00.00.0000', '00.00.00', '']
);

-- Setup the environment variable `CLASSFLOC_DOWNLOAD` before running this file
SELECT getenv('CLASSFLOC_DOWNLOAD') AS CLASSFLOC_DOWNLOAD;

CREATE OR REPLACE TABLE file_download_landing.classfloc AS
SELECT 
    * RENAME("*FUNCLOC" AS "FUNCLOC")
FROM read_csv(
    getenv('CLASSFLOC_DOWNLOAD'), 
    dateformat='%d.%m.%Y',
    types = {
        '*FUNCLOC': 'VARCHAR',
        'CLASSTYPE': 'VARCHAR',
        'CLINT': 'INTEGER',
    },
    nullstr = ['00.00.0000', '00.00.00', '']
);


-- Setup the environment variable `VALUAFLOC_DOWNLOAD` before running this file
SELECT getenv('VALUAFLOC_DOWNLOAD') AS VALUAFLOC_DOWNLOAD;

CREATE OR REPLACE TABLE file_download_landing.valuafloc AS
SELECT 
    * RENAME("*FUNCLOC" AS "FUNCLOC")
FROM read_csv(
    getenv('VALUAFLOC_DOWNLOAD'), 
    dateformat='%d.%m.%Y',
    types = {
        '*FUNCLOC': 'VARCHAR',
        'CHARID': 'VARCHAR',
        'ATWRT': 'VARCHAR',
        'CLASSTYPE': 'VARCHAR',
        'ATCOD': 'INTEGER',
        'TEXTBEZ': 'INTEGER',
        'ATZIS': 'INTEGER',
        'VALCNT': 'INTEGER',
        'ATSRT': 'INTEGER',
        'ATFLV': 'DECIMAL',
        'ATFLB': 'DECIMAL',
    },
    nullstr = ['00.00.0000', '00.00.00', '']
);




-- Setup the environment variable `EQUI_DOWNLOAD` before running this file
SELECT getenv('EQUI_DOWNLOAD') AS EQUI_DOWNLOAD;

CREATE OR REPLACE TABLE file_download_landing.equi AS
SELECT 
    * RENAME("*EQUI" AS "EQUI")
FROM read_csv(
    getenv('EQUI_DOWNLOAD'), 
    dateformat='%d.%m.%Y',
    types = {
        '*EQUI': 'VARCHAR',
        'ABCK_EILO': 'VARCHAR',
        'ANSWT': 'DECIMAL',
        'ANSDT': 'DATE',
        'CGWLDT_EQ': 'DATE',
        'VGWLDT_EQ': 'DATE',
        'BUKR_EILO': 'INTEGER',
        'BAUMM_EQI': 'INTEGER',
        'BAUJJ': 'INTEGER',
        'KOKR_EILO': 'INTEGER',
        'AULDT_EQI': 'DATE',
        'BRGEW': 'DECIMAL',
        'SWER_EILO': 'INTEGER',
        'PPLA_EEQZ': 'INTEGER',
        'HEQN_EEQZ': 'INTEGER',
        'INBDT': 'DATE',
        'DATA_EEQZ': 'DATE',
        'DATB_EEQZ': 'DATE',
        'DATBI_EIL': 'DATE',
        'CGWLEN_EQ': 'DATE',
        'VGWLEN_EQ': 'DATE',
        'ADRNR': 'VARCHAR',
        'INSTIME': 'TIME',
        'INSDATE': 'DATE',
    },
    nullstr = ['00.00.0000', '00.00.00', '']
);


-- Setup the environment variable `CLASSEQUI_DOWNLOAD` before running this file
SELECT getenv('CLASSEQUI_DOWNLOAD') AS CLASSEQUI_DOWNLOAD;

CREATE OR REPLACE TABLE file_download_landing.classequi AS
SELECT 
    * RENAME("*EQUI" AS "EQUI")
FROM read_csv(
    getenv('CLASSEQUI_DOWNLOAD'), 
    dateformat='%d.%m.%Y',
    types = {
        '*EQUI': 'VARCHAR',
        'CLASSTYPE': 'VARCHAR',
        'CLINT': 'INTEGER',
    },
    nullstr = ['00.00.0000', '00.00.00', '']
);

-- Setup the environment variable `VALUAEQUI_DOWNLOAD` before running this file
SELECT getenv('VALUAEQUI_DOWNLOAD') AS VALUAEQUI_DOWNLOAD;

CREATE OR REPLACE TABLE file_download_landing.valuaequi AS
SELECT 
    * RENAME("*EQUI" AS "EQUI")
FROM read_csv(
    getenv('VALUAEQUI_DOWNLOAD'), 
    dateformat='%d.%m.%Y',
    types = {
        '*EQUI': 'VARCHAR',
        'CHARID': 'VARCHAR',
        'ATWRT': 'VARCHAR',
        'CLASSTYPE': 'VARCHAR',
        'ATCOD': 'INTEGER',
        'TEXTBEZ': 'INTEGER',
        'ATZIS': 'INTEGER',
        'VALCNT': 'INTEGER',
        'ATSRT': 'INTEGER',
        'ATFLV': 'DECIMAL',
        'ATFLB': 'DECIMAL',
    },
    nullstr = ['00.00.0000', '00.00.00', '']
);
