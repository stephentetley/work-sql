-- Delete from equiclass tables before _any_ writes
-- An equiclass table may have more than one source

DELETE FROM s4_classrep.equiclass_lstnut;
DELETE FROM s4_classrep.equiclass_netwmb;
DELETE FROM s4_classrep.equiclass_netwmo;
DELETE FROM s4_classrep.equiclass_netwtl;
DELETE FROM s4_classrep.equiclass_podetu;
DELETE FROM s4_classrep.equiclass_valvfl;
DELETE FROM s4_classrep.equiclass_valvnr;

