-- Delete from equiclass tables before _any_ writes
-- An equiclass table may have more than one source

DELETE FROM s4_classrep.equiclass_lstnut;
DELETE FROM s4_classrep.equiclass_netwmb;
DELETE FROM s4_classrep.equiclass_netwmo;
DELETE FROM s4_classrep.equiclass_netwtl;
DELETE FROM s4_classrep.equiclass_podetu;
DELETE FROM s4_classrep.equiclass_valvfl;
DELETE FROM s4_classrep.equiclass_valvnr;


-- TODO generating this is tricky as `asset_replace_gen` doesn't know 
-- which macros exist...

INSERT OR REPLACE INTO s4_classrep.equiclass_lstnut BY NAME
SELECT * FROM ultrasonic_level_instrument_to_lstnut();


INSERT OR REPLACE INTO s4_classrep.equiclass_netwmb BY NAME
SELECT * FROM network_to_netwmb();

INSERT OR REPLACE INTO s4_classrep.equiclass_netwmo BY NAME
SELECT * FROM modem_to_netwmo();


INSERT OR REPLACE INTO s4_classrep.equiclass_netwtl BY NAME
SELECT * FROM telemetry_outstation_to_netwtl();

INSERT OR REPLACE INTO s4_classrep.equiclass_podetu BY NAME
SELECT * FROM power_supply_to_podetu();

INSERT OR REPLACE INTO s4_classrep.equiclass_valvfl BY NAME
SELECT * FROM flap_valve_to_valvfl();

INSERT OR REPLACE INTO s4_classrep.equiclass_valvnr BY NAME
SELECT * FROM non_return_valve_to_valvnr();
