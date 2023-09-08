const db = require("./../../../db");
//todo se arma el arreglo de tarjetas_status de acuerdo al contrato de api
const formatStatus = (arraySql) => {
  let newArre = [];
  arraySql.forEach((row) => {
    newArre.push({
      id: row.id,
      nm: row.nombre,
      opc: row.opcion,
    });
  });
  return newArre;
};
//todo se obtienen de db la lista de status
exports.getStatusList = async () => {
  return new Promise((resolve, reject) => {
    const stmt = `SELECT id, nombre, opcion FROM xxbdo_tarjetas_status WHERE es_activo = 1 AND activo = 1 ORDER BY orden ASC`;
    qry = db.query(stmt, null, (err, rst) => {
      if (dbg) console.log("[36] ", qry.sql);
      if (err) {
        err.status = 500;
        reject(err);
      }
      if (rst) {
        const data = formatStatus(rst);
        resolve(data);
      } else {
        reject(400);
      }
    });
  });
};
