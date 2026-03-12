-- Sample code - the real code is generated at runtime

INSERT OR REPLACE INTO panel_or_dist_board_surveys_landing BY NAME
            SELECT * FROM read_survey_simple('Site DB-1 (As Fitted).xlsx', 'MCC-10 P1of2');
