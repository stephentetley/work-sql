
-- TODO generating this is tricky as `asset_replace_gen` doesn't know 
-- which macros exist...
-- Probably I need to curate this as a speadsheet table - 
-- (tanslation_macro, equiclass_ table)



INSERT OR REPLACE INTO s4_classrep.equiclass_lstnut BY NAME
SELECT * FROM ultrasonic_level_instrument_to_lstnut();


INSERT OR REPLACE INTO s4_classrep.equiclass_netwmb BY NAME
SELECT * FROM network_to_netwmb('ai2_classrep');

INSERT OR REPLACE INTO s4_classrep.equiclass_netwmo BY NAME
SELECT * FROM modem_to_netwmo('ai2_classrep');


INSERT OR REPLACE INTO s4_classrep.equiclass_netwtl BY NAME
SELECT * FROM telemetry_outstation_to_netwtl('ai2_classrep');

INSERT OR REPLACE INTO s4_classrep.equiclass_podetu BY NAME
SELECT * FROM power_supply_to_podetu('ai2_classrep');

INSERT OR REPLACE INTO s4_classrep.equiclass_valvfl BY NAME
SELECT * FROM flap_valve_to_valvfl('ai2_classrep');

INSERT OR REPLACE INTO s4_classrep.equiclass_valvnr BY NAME
SELECT * FROM non_return_valve_to_valvnr('ai2_classrep');
