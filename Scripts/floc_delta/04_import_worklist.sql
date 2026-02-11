.print 'Running 04_import_worklist.sql...'

.print 'Loading floc_delta_worklist...'
SELECT getvariable('floc_delta_worklist') AS equi_master_globpath;

CREATE OR REPLACE TABLE floc_delta_landing.worklist AS
SELECT * FROM read_floc_delta_worklist(
    getvariable('floc_delta_worklist')
);


