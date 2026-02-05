
-- Setup the variables `equi_classdefs_path` and `floc_classdefs_path` 
-- before running this file

CREATE OR REPLACE TABLE s4_classlists_landing.equi_classlist_file AS 
SELECT * FROM read_classlist_export(    
    getvariable('equi_classdefs_path')
);


CREATE OR REPLACE TABLE s4_classlists_landing.floc_classlist_file AS 
SELECT * FROM read_classlist_export( 
    getvariable('floc_classdefs_path')
);
