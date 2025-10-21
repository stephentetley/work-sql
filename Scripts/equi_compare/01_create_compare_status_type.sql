-- run only once

DROP TYPE IF EXISTS compare_status;
CREATE TYPE compare_status AS ENUM ('in_both', 'no_pli_aib_ref', 'not_in_ai2_extract', 'not_in_s4_extract');


