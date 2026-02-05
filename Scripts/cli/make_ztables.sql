
-- Setup the variables:
-- `zt_eqobjl_path`
-- `zt_flobjl_path`
-- `zt_flocdes_path`
-- `zt_manuf_model_path`
-- `zt_obj_path`
-- before running this file, e.g.:

-- SET VARIABLE zt_eqobjl_path = '~/_working/work/resources/ztables/zt_eqobj_20260205.XLSX';
-- SET VARIABLE zt_flobjl_path = '~/_working/work/resources/ztables/zt_flobjl_20260205.XLSX';
-- ...

SELECT getvariable('zt_eqobjl_path') AS zt_eqobjl_path;
SELECT getvariable('zt_flobjl_path') AS zt_flobjl_path;
SELECT getvariable('zt_flocdes_path') AS zt_flocdes_path;
SELECT getvariable('zt_manuf_model_path') AS zt_manuf_model_path;
SELECT getvariable('zt_obj_path') AS zt_obj_path;

.read '../common/ztables/01_import_ztable_eqobjl.sql'
.read '../common/ztables/02_import_ztable_flobjl.sql'
.read '../common/ztables/03_import_ztable_flocdes.sql'
.read '../common/ztables/04_import_ztable_manuf_model.sql'
.read '../common/ztables/05_import_ztable_obj.sql'
