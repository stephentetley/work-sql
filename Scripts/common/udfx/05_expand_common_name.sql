
-- Add rewrites here...

CREATE OR REPLACE MACRO udfx.expand_common_name(common_name) AS (
    replace(common_name :: VARCHAR, '/EQPT:', '/EQUIPMENT:')
            .replace('DIFFERENTIAL PRESSURE FLOW INST', 'DIFFERENTIAL PRESSURE FLOW INSTRUMENT')
);