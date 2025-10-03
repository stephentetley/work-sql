-- Needs a filter to only pick up 'MODEM'...
CREATE OR REPLACE MACRO classrep_modem() AS TABLE (
WITH cte1 AS (
    SELECT 
        t1.*, 
    FROM  
        ai2_classrep.equi_masterdata t
    JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
    WHERE t.equipment_type = 'EQUIPMENT: MODEM'
), cte2 AS (
    PIVOT cte1 
    ON attr_name IN ("Location On Site")
    USING any_value(attr_value)
    GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_modem;
INSERT OR IGNORE INTO ai2_classrep.equiclass_modem BY NAME
SELECT * FROM classrep_modem();

-- Needs a filter to only pick up 'NETWORK'...
CREATE OR REPLACE MACRO classrep_network() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: NETWORK'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_network;
INSERT OR IGNORE INTO ai2_classrep.equiclass_network BY NAME
SELECT * FROM classrep_network();


-- Needs a filter to only pick up 'POWER SUPPLY'...
CREATE OR REPLACE MACRO classrep_power_supply() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: POWER SUPPLY'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_power_supply;
INSERT OR IGNORE INTO ai2_classrep.equiclass_power_supply BY NAME
SELECT * FROM classrep_power_supply();

-- Needs a filter to only pick up 'TELEMETRY OUTSTATION'...
CREATE OR REPLACE MACRO classrep_telemetry_oustation() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: TELEMETRY OUTSTATION'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_telemetry_outstation;
INSERT OR IGNORE INTO ai2_classrep.equiclass_telemetry_outstation BY NAME
SELECT * FROM classrep_telemetry_oustation();




-- Needs a filter to only pick up 'ultrasonic_level_instrument'...
CREATE OR REPLACE MACRO classrep_ultrasonic_level_instrument() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: ULTRASONIC LEVEL INSTRUMENT'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site", 
                    "Range max", "Range min", "Range unit", 
                    "Relay 1 Function", "Relay 1 off Level (m)", "Relay 1 on Level (m)", 
                    "Relay 2 Function", "Relay 2 off Level (m)", "Relay 2 on Level (m)",
                    "Relay 3 Function", "Relay 3 off Level (m)", "Relay 3 on Level (m)",
                    "Relay 4 Function", "Relay 4 off Level (m)", "Relay 4 on Level (m)",
                    "Relay 5 Function", "Relay 5 off Level (m)", "Relay 5 on Level (m)",
                    "Relay 6 Function", "Relay 6 off Level (m)", "Relay 6 on Level (m)",
                    "Signal max", "Signal min", "Signal unit",
                    "Transducer Serial No", "Transducer Type"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_ultrasonic_level_instrument;
INSERT OR IGNORE INTO ai2_classrep.equiclass_ultrasonic_level_instrument BY NAME
SELECT * FROM classrep_ultrasonic_level_instrument();

-- Needs a filter to only pick up 'flap_valve'...
CREATE OR REPLACE MACRO classrep_flap_valve() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: FLAP VALVE'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site", 
                    "Size", "Size Units"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_flap_valve;
INSERT OR IGNORE INTO ai2_classrep.equiclass_flap_valve BY NAME
SELECT * FROM classrep_flap_valve();

-- Needs a filter to only pick up 'non_return_valve'...
CREATE OR REPLACE MACRO classrep_non_return_valve() AS TABLE (
WITH cte1 AS (
SELECT 
    t1.*, 
FROM  
    ai2_classrep.equi_masterdata t
JOIN ai2_eav.equipment_eav t1 ON t1.ai2_reference = t.ai2_reference
WHERE t.equipment_type = 'EQUIPMENT: NON RETURN VALVE'
), cte2 AS (
PIVOT cte1 
ON attr_name IN ("Location On Site", "Size", "Size Units"
                    )
USING any_value(attr_value)
GROUP BY ai2_reference
)
SELECT * from cte2
);

DELETE FROM ai2_classrep.equiclass_non_return_valve;
INSERT OR IGNORE INTO ai2_classrep.equiclass_non_return_valve BY NAME
SELECT * FROM classrep_non_return_valve();

