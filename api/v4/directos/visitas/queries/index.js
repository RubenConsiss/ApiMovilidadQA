const table = "xxbdo_directos_proveedor_sin_recibir";

module.exports.INSERT_QUERY = `INSERT INTO ${table} (cr_plaza, cr_tienda, fecha, nombre_proveedor, numero_proveedor, estatus) VALUES(?)`;
module.exports.READ_QUERY = `SELECT id, cr_plaza, cr_tienda, fecha, nombre_proveedor, numero_proveedor, estatus FROM ${table}`