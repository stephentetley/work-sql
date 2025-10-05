CREATE OR REPLACE TABLE ai2_classrep.equiclass_telemetry_outstation (
    ai2_reference VARCHAR,
    "Controller Install Date" DATE,
    "Controller Manufacturer" VARCHAR,
    "Controller Replacement Date" DATE,
    "Controller Serial Number" VARCHAR,
    "Installation Wiring Type" VARCHAR,
    "Location On Site" VARCHAR,
    "Modem Install date" DATE,
    "Modem Manufacturer" VARCHAR,
    "Modem Replacement Date" DATE,
    "Modem Serial Number" VARCHAR,
    "Modem Type" VARCHAR,
    "Number of Modbus Slave boards" INTEGER,
    "P AND I Tag No" VARCHAR,
    "PSU Asset Replacement Due Date" DATE,
    "PSU Install Date" DATE,
    "PSU Manufacturer" VARCHAR,
    "PSU Model" VARCHAR,
    "PSU Serial Number" VARCHAR,
    "RTU Asset Life (years)" DECIMAL(28, 6),
    "RTU Asset Replacement Due Date" DATE,
    "RTU Configuration ID" VARCHAR,
    "RTU Data Number" INTEGER,
    "RTU Firmware last updated" DATE,
    "RTU Installation Type" VARCHAR,
    "RTU PLC Type" VARCHAR,
    "RTU Powered" VARCHAR,
    "RTU Type" VARCHAR,
    "Telephone" VARCHAR,
PRIMARY KEY(ai2_reference));

CREATE OR REPLACE TABLE ai2_classrep.equiclass_power_supply (
    ai2_reference VARCHAR,
    "Location On Site" VARCHAR,
    "Current In" DECIMAL(28, 6),
    "Current Out" DECIMAL(28, 6),
    "Rating (Power)" DECIMAL(28, 6),
    "Telephone" VARCHAR,
    "Voltage In" INTEGER,
    "Voltage Out" INTEGER,
    "Rating Units" VARCHAR,
    "Voltage In (AC Or DC)" VARCHAR,
    "Voltage Out (AC Or DC)" VARCHAR,
    "PSU Asset Replacement Due Date" DATE,
    "PSU Asset Life (years)" DECIMAL(28, 6),
    "Battery installation Date" DATE,
    "Criticality Comments" VARCHAR,
PRIMARY KEY(ai2_reference));


CREATE OR REPLACE TABLE ai2_classrep.equiclass_modem (
    ai2_reference VARCHAR,
    "Location On Site" VARCHAR,
    "Telephone Number" VARCHAR,
    "IP Address" VARCHAR,
PRIMARY KEY(ai2_reference));


CREATE OR REPLACE TABLE ai2_classrep.equiclass_network (
    ai2_reference VARCHAR,
    "Location On Site" VARCHAR,
    "Telephone Number" VARCHAR,
    "IP Address" VARCHAR,
PRIMARY KEY(ai2_reference));


CREATE OR REPLACE TABLE ai2_classrep.equiclass_ultrasonic_level_instrument (
    ai2_reference VARCHAR,
    "BT Care" VARCHAR,
    "Criticality Comments" VARCHAR,
    "Date Settings Changed" DATE,
    "High Level Alarm off (m)" DECIMAL(28, 6),
    "High Level Alarm on (m)" DECIMAL(28, 6),
    "High Level Alarm Type" VARCHAR,
    "Intrinsically Safe (Y/N)" VARCHAR,
    "JUT Reference" VARCHAR,
    "Key Process Instrument" VARCHAR,
    "Level Backup Type" VARCHAR,
    "Location On Site" VARCHAR,
    "Process Monitoring Instrument" VARCHAR,
    "Range max" DECIMAL(28, 6),
    "Range min" DECIMAL(28, 6),
    "Range unit" VARCHAR,
    "Relay 1 Function" VARCHAR,
    "Relay 1 off Level (m)" DECIMAL(28, 6),
    "Relay 1 on Level (m)" DECIMAL(28, 6),
    "Relay 2 Function" VARCHAR,
    "Relay 2 off Level (m)" DECIMAL(28, 6),
    "Relay 2 on Level (m)" DECIMAL(28, 6),
    "Relay 3 Function" VARCHAR,
    "Relay 3 off Level (m)" DECIMAL(28, 6),
    "Relay 3 on Level (m)" DECIMAL(28, 6),
    "Relay 4 Function" VARCHAR,
    "Relay 4 off Level (m)" DECIMAL(28, 6),
    "Relay 4 on Level (m)" DECIMAL(28, 6),
    "Relay 5 Function" VARCHAR,
    "Relay 5 off Level (m)" DECIMAL(28, 6),
    "Relay 5 on Level (m)" DECIMAL(28, 6),
    "Relay 6 Function" VARCHAR,
    "Relay 6 off Level (m)" DECIMAL(28, 6),
    "Relay 6 on Level (m)" DECIMAL(28, 6),
    "Set to Snort" VARCHAR,
    "Settings Changed By" VARCHAR,
    "Signal max" DECIMAL(28, 6),
    "Signal min" DECIMAL(28, 6),
    "Signal unit" VARCHAR,
    "Snort run time (secs)" DECIMAL(28, 6),
    "Telephone" VARCHAR,
    "Transducer face to bottom of well (m)" DECIMAL(28, 6),
    "Transducer NGR" VARCHAR,
    "Transducer Serial No" VARCHAR,
    "Transducer Type" VARCHAR,
    "Transmitter NGR" VARCHAR,
    "Working Span (m)" DECIMAL(28, 6),
PRIMARY KEY(ai2_reference));



CREATE OR REPLACE TABLE ai2_classrep.equiclass_flap_valve (
    ai2_reference VARCHAR,
    "Location On Site" VARCHAR,
    "Size" DECIMAL(28, 6),
    "Size Units" VARCHAR,
PRIMARY KEY(ai2_reference));


CREATE OR REPLACE TABLE ai2_classrep.equiclass_non_return_valve (
    ai2_reference VARCHAR,
    "Location On Site" VARCHAR,
    "Size" DECIMAL(28, 6),
    "Size Units" VARCHAR,
PRIMARY KEY(ai2_reference));

