INSERT INTO excel_uploader_equi_create.classification BY NAME
(
SELECT * FROM get_excel_loader_characteristics_for('LSTNUT', s4_classrep.equiclass_lstnut)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('NETWMB', s4_classrep.equiclass_netwmb)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('NETWMO', s4_classrep.equiclass_netwmo)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('NETWTL', s4_classrep.equiclass_netwtl)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('PODETU', s4_classrep.equiclass_podetu)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('VALVFL', s4_classrep.equiclass_valvfl)
UNION BY NAME
SELECT * FROM get_excel_loader_characteristics_for('VALVNR', s4_classrep.equiclass_valvnr)
);



