
DELETE FROM equi_compare_landing.ih08_equi_masterdata;
DELETE FROM equi_compare_landing.ai2_equi_masterdata;

INSERT INTO equi_compare_landing.ih08_equi_masterdata BY NAME
SELECT 
    *
FROM read_ih08_export(
    '/home/stephen/_working/work/2025/equi_compare/lstnut_oct25/lstnut_ih08_with_aib_ref.xlsx'
);




INSERT INTO equi_compare_landing.ai2_equi_masterdata BY NAME
SELECT 
    *
FROM read_ai2_equi_report(
    '/home/stephen/_working/work/2025/equi_compare/lstnut_oct25/AI2UltrasonicLevelInstruments_20251020.xlsx'
);




