-- Sample code - the real code is generated at runtime

INSERT OR REPLACE INTO motor_surveys_landing BY NAME
            SELECT * FROM read_survey_simple('Site DB-1 (As Fitted).xlsx', 'Motor Checklist 2');
