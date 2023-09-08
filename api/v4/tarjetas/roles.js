const db = require("./../../../db");
//todo se arma el arreglo de roles en tienda de acuerdo al contrato de api
const formatRoles = (arraySql) => {
  let newArre = [];
  arraySql.forEach((row) => {
    newArre.push({
      id: row.id,
      nm: row.nombre,
    });
  });
  return newArre;
};
//todo se obtienen de db la lista de roles en tienda
exports.getRolesList = async () => {
  return new Promise((resolve, reject) => {
    const stmt = `SELECT id, nombre FROM xxbdo_roles_en_tienda WHERE visible = 1 AND activo = 1 ORDER BY orden ASC   `;
    qry = db.query(stmt, null, (err, rst) => {
      if (dbg) console.log("[36] ", qry.sql);
      if (err) {
        err.status = 500;
        reject(err);
      }
      const data = formatRoles(rst);
      resolve(data);
    });
  });
};
