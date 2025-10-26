CREATE SCHEMA IF NOT EXISTS file_download;
CREATE SCHEMA IF NOT EXISTS file_download_landing;


CREATE OR REPLACE MACRO read_funcloc(file_name) AS TABLE
SELECT 
    * RENAME("*FUNCLOC" AS "FUNCLOC")
FROM read_csv(
    file_name::VARCHAR, 
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
        'INBDT': 'DATE',
        'DATBI_FLO': 'DATE',
        'CGWLEN_FL': 'DATE',
        'VGWLEN_FL': 'DATE',
        'ADRNR': 'VARCHAR',
        'ALKEY': 'INTEGER',
    },
    nullstr = ['00.00.0000', '00.00.00', '']
);


CREATE OR REPLACE MACRO read_classfloc(file_name) AS TABLE
SELECT 
    * RENAME("*FUNCLOC" AS "FUNCLOC")
FROM read_csv(
    file_name::VARCHAR, 
    dateformat='%d.%m.%Y',
    types = {
        '*FUNCLOC': 'VARCHAR',
        'CLASSTYPE': 'VARCHAR',
        'CLINT': 'INTEGER',
    },
    nullstr = ['00.00.0000', '00.00.00', '']
);

CREATE OR REPLACE MACRO read_valuafloc(file_name) AS TABLE
SELECT 
    * RENAME("*FUNCLOC" AS "FUNCLOC")
FROM read_csv(
    file_name::VARCHAR, 
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

CREATE OR REPLACE MACRO read_equi(file_name) AS TABLE
SELECT 
    * RENAME("*EQUI" AS "EQUI")
FROM read_csv(
    file_name::VARCHAR, 
    dateformat='%d.%m.%Y',
    types = {
        '*EQUI': 'VARCHAR',
        'ABCK_EILO': 'VARCHAR',
        'ANSWT': 'DECIMAL',
        'ANSDT': 'DATE',
        'CGWLDT_EQ': 'DATE',
        'VGWLDT_EQ': 'DATE',
        'AULDT_EQI': 'DATE',
        'BRGEW': 'DECIMAL',
        'INBDT': 'DATE',
        'DATA_EEQZ': 'DATE',
        'DATB_EEQZ': 'DATE',
        'DATBI_EIL': 'DATE',
        'CGWLEN_EQ': 'DATE',
        'VGWLEN_EQ': 'DATE',
        'ADRNR': VARCHAR,
        'INSTIME': 'TIME',
        'INSDATE': 'DATE',
    },
    nullstr = ['00.00.0000', '00.00.00', '']
);


CREATE OR REPLACE MACRO read_classequi(file_name) AS TABLE
SELECT 
    * RENAME("*EQUI" AS "EQUI")
FROM read_csv(
    file_name::VARCHAR, 
    dateformat='%d.%m.%Y',
    types = {
        '*EQUI': 'VARCHAR',
        'CLASSTYPE': 'VARCHAR',
        'CLINT': 'INTEGER',
    },
    nullstr = ['00.00.0000', '00.00.00', '']
);

CREATE OR REPLACE MACRO read_valuaequi(file_name) AS TABLE
SELECT 
    * RENAME("*EQUI" AS "EQUI")
FROM read_csv(
    file_name::VARCHAR, 
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


