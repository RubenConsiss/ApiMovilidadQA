const db = require("./../../../db");
const dbg = false;

//todo se arma el arreglo de tarjetas de acuerdo al contrato de api
const formatTarjetas = (arraySql) => {
  let newArre = [];
  arraySql.forEach((row) => {
    let newData = {
      tarjeta: row.tarjeta,
      tipo: row.tipo,
      status: row.status,
      agregadoPor: row.agregado_por,
      fechaRegistro: row.fecha_registro,
      horaRegistro: row.hora_registro,
      entrega: null,
    };

    //* Si existen tarjetas_entrega_detalle para esa tarjeta.
    if (row.fecha_modificacion != null && row.responsable != null) {
      newData.entrega = {
        fechaModificacion: row.fecha_modificacion,
        horaModificacion: row.hora_modificacion,
        agregadaPor: row.agregada_por,
        responsable: row.responsable,
      };
    }
    newArre.push(newData);
  });
  return newArre;
};
//todo se consulta el stored_procedure de db para traer lista de tarjetas
exports.getTarjetasProcedure = async (
  fecha_inicio,
  fecha_fin,
  cr_plaza,
  cr_tienda
) => {
  return new Promise((resolve, reject) => {
    const stmt = `CALL SP_XXBDO_GET_LISTA_CONTROL_TARJETAS(?, ?, ?, ?)`;
    const entries = [cr_plaza, cr_tienda, fecha_inicio, fecha_fin];
    const options = { sql: stmt, nestTables: false };
    qry = db.query(options, entries, (err, rst) => {
      if (dbg) console.log("[48] ", qry.sql);
      if (err) {
        err.status = 500;
        reject(err);
      }

      const data = formatTarjetas(rst[0]);
      resolve(data);
    });
  });
};

const formatTarjetasTipo = (arraySql) => {
  let newArre = [];
  arraySql.forEach((row) => {
    let newData = {
      id: row.id,
      nombre: row.nombre,
      digitos: row.digitos_iniciales,
      longitud: row.longitud,
      default: row.es_default == 1 ? true : false,
      orden: row.orden,
    };
    newArre.push(newData);
  });
  return newArre;
};

exports.getTipoTarjetas = async () => {
  return new Promise((resolve, reject) => {
    const stmt = `SELECT id, nombre, digitos_iniciales, longitud, es_default, orden FROM xxbdo_tarjetas_tipo WHERE activo=1 AND es_activo=1`;
    const options = { sql: stmt, nestTables: false };
    qry = db.query(options, (err, rst) => {
      if (dbg) console.log("[36] ", qry.sql);
      if (err) {
        err.status = 500;
        reject(err);
      }
      const data = formatTarjetasTipo(rst);
      resolve(data);
    });
  });
};

exports.addTarjeta = async (
  cr_plaza,
  cr_tienda,
  tarjetas_tipo_id,
  agregada_por,
  numeracion,
  fecha_registro,
  usuario,
  ip_address
) => {
  return new Promise((resolve, reject) => {
    const stmt = `CALL SP_XXBDO_ADD_TARJETA(?, ?, ?, ?, ?, ?, ?, ?)`;
    const options = {
      sql: stmt,
      nestTables: false,
    };

    const entries = [
      cr_plaza,
      cr_tienda,
      tarjetas_tipo_id,
      agregada_por,
      numeracion,
      fecha_registro,
      usuario,
      ip_address,
    ];

    qry = db.query(options, entries, (err, rst) => {
      if (dbg) console.log("[121] ", qry.sql);
      if (err) {
        err.status = 500;
        reject(err);
      }

      const data = (rst ? rst[0][0].result : null);
      resolve(data);
    });
  });
};

exports.entregarTarjetas = async (
  cr_plaza,
  cr_tienda,
  fecha_entrega,
  entrega_data,
  usuario,
  ip_address
) => {
  return new Promise((resolve, reject) => {
    const stmt = `CALL SP_XXBDO_ENTREGAR_TARJETAS(?, ?, ?, ?, ?, ?)`;
    const options = {
      sql: stmt,
      nestTables: false,
    };

    entrega = JSON.stringify(entrega_data);

    const entries = [
      cr_plaza,
      cr_tienda,
      fecha_entrega,
      entrega,
      usuario,
      ip_address,
    ];

    qry = db.query(options, entries, (err, rst) => {
      if (dbg) console.log("[160] ", qry.sql);
      if (err) {
        err.status = 500;
        reject(err);
      }
      const data = rst ? rst[0][0] : null;
      resolve(data);
    });
  });
};


const formatTarjetasExhibicion = (arraySql) => {
  let newArre = [];
  arraySql.forEach((row) => {
    let newData = {
      id: row.id,
      tipo: row.tipo,
      num: row.num,
      status: row.status,
    };
    newArre.push(newData);
  });
  return newArre;
};
exports.getTarjetasExhibicion = async (plaza, tienda) => {
  return new Promise((resolve, reject) => {
    const entries = [plaza, tienda];
    const stmt = `CALL SP_XXBDO_GET_ENTREGAR_TARJETAS(?,?)`;
    qry = db.query(stmt, entries, (err, rst) => {
      if (dbg) console.log("[36] ", qry.sql);
      if (err) {
        err.status = 500;
        reject(err);
      }
      const data = formatTarjetasExhibicion(rst[0]);
      resolve(data);
    });
  });
};
