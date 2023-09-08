/**
 * 
 * 20201119: Se cambió la funcionalidad para que se permita grabar cc sin obs.
 * 
 POST bdo/v4/detalles

1) servicio POST /detalles para:
1.1) Actualizar observaciones(sólo comentario para modo asesor) 
1.2) Actualizar todos los detalles de la observación para modo líder 
1.3) E insertar circulo al mismo tiempo (modo asesor)

-- Ejemplo de JSON request inicial:
{
    "id":"<uuid4>", //xxbdo_respuestas.id
    "obs":null,
    "cc":null
}

-- Ejemplo de JSON request con objetos de 
-- observacion y circulo de congruencia en modo "asesor":
{
    "id":"<uuid4>", //xxbdo_respuestas.id
    "obs":{
        "id":"<uuid4_de_observacion>",
        "md":"asesor",
        "cmt":"comentario de la observación",
        "rpa":<true/false>, //realizaron_plan_accion
        "rep":<true/false>, //resolvio_problema
        "alp":<true/false> //pendiente_agregado
    },
    "cc":{
        "resa":"T",
        "cmt":"comentario",
        "accion":"accion de la obs",
        "acresp":"responsable de la obs",
        "acfecha":"fecha del accionable",
        "ata":<true/false>,
        "alp":<true/false>
    }
}

-- Ejemplo de JSON request con objetos de 
-- observacion y circulo de congruencia en modo "líder":
{
    "id":"<uuid4>", //xxbdo_respuestas.id
    "obs":{
        "id":"<uuid4_de_observacion>",
        "md":"lider",
        "desc":"descripción de la observación",
        "causa":"causa de la obs",
        "accion":"accion de la obs",
        "acresp":"responsable de la obs",
        "acfecha":"fecha del accionable",
        "ata":<true/false>, //requiere ajuste ATA"
        "rpa":<true/false>, //realizaron_plan_accion
        "rep":<true/false>, //resolvio_problema
        "alp":<true/false> //pendiente_agregado
        "cmt":"comentario de la observación",
        "folio":"folio de la obs",
        "turnom":<true/false>,
        "turnot":<true/false>,
        "turnon":<true/false>
    },
    "cc":null
}
*/

const db = require("./../../../db");
const uuidv4 = require("uuid/v4");
const bdoDates = require("./../../helpers/bdo-dates");
const util = require("util");
const dbg = false;

const agregarPendiente = (fc, rp, rs, ds, req) => {
  return new Promise((resolve, reject) => {
    if (!db) {
      const error = new Error("Conexión a BD no encontrada!");
      error.status = 500;
      reject(error);
    }
    let crplaza = req.tokenData.crplaza;
    let crtienda = req.tokenData.crtienda;
    let fecha_compromiso = fc || null;
    let registrado_por = rp || null;
    let responsable = rs;
    let descripcion = ds || "";
    let ip = req.app_client_ip_address;
    let usuario = req.tokenData.usuario;
    let data = null;
    let stmt = null;
    let status = 500;

    if (bdoDates.isDateLessThanCurrent(fecha_compromiso)) {
      const error = new Error(
        "Fecha compromiso " +
          fecha_compromiso +
          " es menor que la fecha actual!"
      );
      error.status = 400;
      reject(error);
    }

    //TO DO: validar que sea fecha válida, mes 1-12, dia 1-31, año YYYY digitos

    // TO FIX:
    // 1. En el servicio me dejo guardar un pendiente para el mes 13

    rst = formatInsertData(
      crplaza,
      crtienda,
      fecha_compromiso,
      registrado_por,
      responsable,
      descripcion,
      usuario,
      ip
    );
    if (!rst) {
      const error = new Error("Pendiente no se ha registrado!");
      error.status = 400;
      return reject(error);
    }
    stmt = "INSERT INTO xxbdo_pendientes VALUES ?";
    status = 201;
    data = [rst[0]];
    //run query
    qry = db.query(stmt, data, (err, rst2) => {
      if (dbg) console.log("[PP:76] " + qry.sql);
      if (err) {
        err.status = 500;
        reject(err);
      } else {
        resolve("Pendiente agregado a lista de pendientes");
      }
    });
  });
};

function formatInsertData(
  crplaza,
  crtienda,
  fecha_compromiso,
  registrado_por,
  responsable,
  descripcion,
  usuario,
  ip
) {
  if (!fecha_compromiso) {
    return;
  } else {
    let data = [];
    let uuid = null;
    let timestamp = null;
    //if(respuestas.length>0) {
    //respuestas.forEach(row => {
    uuid = uuidv4();
    timestamp = bdoDates.getBDOCurrentTimestamp();
    res = [
      uuid,
      crplaza,
      crtienda,
      fecha_compromiso,
      null,
      registrado_por,
      responsable,
      descripcion,
      1,
      usuario,
      ip,
      timestamp,
      timestamp,
    ];
    //
    data.push(res);
    //});
    //}
    return [data];
  }
}

const getRolByName = async (nombre_rol) => {
  return new Promise((resolve, reject) => {
    const stmt = `SELECT id, nombre FROM xxbdo_roles_en_tienda WHERE visible = 1 AND activo = 1 AND nombre='${nombre_rol}'  ORDER BY orden ASC    `;
    qry = db.query(stmt, null, (err, rst) => {
      if (dbg) console.log("[36] ", qry.sql);
      if (err) {
        err.status = 500;
        reject(err);
      }
      
      const data = rst[0];
      resolve(data);
    });
  });
};

const addCC = async (
  respuestas_id,
  circulo_de_congruencia,
  fecha_token,
  usuario,
  ip_address,
  fecha_registro
) => {
  if (dbg) console.log("Start addCC ...");
  return new Promise((resolve, reject) => {
    if (circulo_de_congruencia) {
      response_id = uuidv4();
      stmt = "INSERT INTO `xxbdo_circulo_de_congruencia` VALUES (?)";
      entries = [
        response_id,
        respuestas_id,
        fecha_token,
        circulo_de_congruencia.cmt,
        circulo_de_congruencia.accion || null,
        circulo_de_congruencia.acresp || null,
        circulo_de_congruencia.acfecha || null,
        circulo_de_congruencia.ata ? 1 : 0,
        circulo_de_congruencia.alp
          ? 1
          : circulo_de_congruencia.alp == 0
          ? 0
          : null,
        "", //foto
        1,
        usuario,
        ip_address,
        fecha_registro,
        fecha_registro,
      ];
      qry = db.query(stmt, [entries], (err2, rst2) => {
        if (dbg)
          console.log("[DP:105] Insert circulo de congruencia: ", qry.sql);
        if (err2) {
          err2.status = 500;
          reject(err);
        }

        resolve({ response_code: 201, response_id: response_id });
      });
    } else {
      resolve({ response_code: 200, response_id: null });
    }
  });
};

const updateObservacion = async (
  observacion,
  fecha_actualizacion,
  usuario,
  ip_address
) => {
  if (dbg) console.log("Start updateObservacion ...");
  return new Promise((resolve, reject) => {
    if (observacion) {
      if (["lider", "asesor"].includes(observacion.md)) {
        response_id = observacion.id;
        switch (observacion.md) {
          case "asesor":
            entries = [
              observacion.rpa ? 1 : 0,
              observacion.rep ? 1 : 0,
              observacion.alp ? 1 : observacion.alp == 0 ? 0 : null,
              observacion.obs,
              fecha_actualizacion,
              observacion.id,
            ];

            stmt =
              "UPDATE `xxbdo_observaciones` \
                            SET `realizaron_plan_accion`=?,\
                            `resolvio_problema`=?, \
                            `pendiente_agregado`=?, \
                            `observacion`=?, \
                            `fecha_modificacion`=? \
                            WHERE `id`=?";
            break;
          case "lider":
            entries = [
              observacion.desc,
              observacion.causa,
              observacion.accion,
              observacion.acresp,
              observacion.acfecha,
              observacion.ata,
              observacion.rpa ? 1 : 0,
              observacion.rep ? 1 : 0,
              observacion.alp ? 1 : observacion.alp == 0 ? 0 : null,
              //observacion.cmt,
              observacion.folio,
              observacion.turnom,
              observacion.turnot,
              observacion.turnon,
              usuario,
              ip_address,
              fecha_actualizacion,
              observacion.id,
            ];

            stmt =
              "UPDATE xxbdo_observaciones \
                            SET `descripcion`=?, \
                            `causa`=?, \
                            `accion`=?, \
                            `accion_responsable`=?, \
                            `accion_fecha`=?, \
                            `requiere_ajuste_ata`=?, \
                            `realizaron_plan_accion`=?, \
                            `resolvio_problema`=?, \
                            `pendiente_agregado`=?, \
                            `folio`=?, \
                            `turno_mañana`=?, \
                            `turno_tarde`=?, \
                            `turno_noche`=?, \
                            `usuario`=?, \
                            `ip_address`=?, \
                            fecha_modificacion=? \
                            WHERE id=?"; //`observacion`=?, \
            break;
        }
      } else {
        const error = new Error("modalidad inválida para observación!");
        error.status = 400;
        return next(error);
      }

      qry = db.query(stmt, entries, (err, rst) => {
        if (dbg) console.log("[DP:200] Update observacion: ", qry.sql);
        if (err) {
          err.status = 500;
          reject(err);
        }

        resolve({ response_code: 200, response_id: response_id });
      });
    } else {
      resolve({ response_code: 200, response_id: response_id });
    }
  });
};

const updateRespuestas = async (
  respuestas_id,
  respuesta_asesor,
  fecha_modificacion
) => {
  if (dbg) console.log("Start updateRespuestas ...");
  return new Promise((resolve, reject) => {
    entries = [respuesta_asesor, fecha_modificacion, respuestas_id];
    stmt =
      "UPDATE xxbdo_respuestas \
            SET respuesta_asesor=?, \
            fecha_modificacion=? \
            WHERE id=?";

    qry = db.query(stmt, entries, (err3, rst3) => {
      if (dbg)
        console.log("[DP:228] Actualizar respuesta de asesor: ", qry.sql);
      if (err3) {
        err3.status = 500;
        reject(err);
      }

      resolve(true);
    });
  });
};

exports.detalles_post = async (req, res, next) => {
  if (dbg) console.log("Start detalles_post ...");
  if (!db) {
    const error = new Error("Conexión a BD no encontrada!");
    error.status = 500;
    return next(error);
  }

  req
    .checkBody("id")
    .isUUID(4)
    .withMessage("Formato de id(UUID4) invalido!")
    .trim();

  const errors = req.validationErrors();
  if (errors) {
    if (dbg) console.log(util.inspect(errors, { depth: null }));
    const error = new Error("ID de respuesta es requerido!");
    error.status = 400;
    return next(error);
  }

  let crplaza = req.tokenData.crplaza;
  let crtienda = req.tokenData.crtienda;
  let fecha_token = req.tokenData.fecha;
  let respuestas_id = req.body.id || null;
  let observacion = req.body.obs || null;
  let circulo_de_congruencia = req.body.cc || null;
  let ip_address = req.app_client_ip_address;
  let usuario = req.tokenData.usuario;
  let fecha_registro = bdoDates.getBDOCurrentTimestamp();
  let response_code = 400;
  let response_id = null;
  let respuesta_asesor = null;

  if (!crplaza || !crtienda) {
    const error = new Error("Información de token inválido!");
    error.status = response_code;
    res.status(response_code);
  }
  if (respuestas_id) {
    if (observacion) {
      rst = await updateObservacion(
        observacion,
        fecha_registro,
        usuario,
        ip_address
      );

      if (rst) {
        response_code = rst.response_code;
        response_id = rst.response_id;
      }
    }

    if (circulo_de_congruencia) {
      if (circulo_de_congruencia.resa) {
        rst = await addCC(
          respuestas_id,
          circulo_de_congruencia,
          fecha_token,
          usuario,
          ip_address,
          fecha_registro
        );

        respuesta_asesor = circulo_de_congruencia.resa;
        if (rst) {
          response_code = rst.response_code;
          response_id = rst.response_id;
        }
        if (circulo_de_congruencia.alp) {
          //TODO Entonces se debe agregar a la lista de pendientes
          try {
            const fc = circulo_de_congruencia.acfecha;
            const rp = await getRolByName("Asesor");
            const rs = await getRolByName(circulo_de_congruencia.acresp);
            const ds = circulo_de_congruencia.accion;
            let respListaPendientes = await agregarPendiente(
              fc,
              rp.id,
              rs.id,
              ds,
              req
            );
            
          } catch (e) {
            console.log(e);
          }
        }
      }
    }

    if (respuesta_asesor) {
      rst = await updateRespuestas(
        respuestas_id,
        respuesta_asesor,
        fecha_registro
      );
    }

    if (dbg)
      console.log("return response ", response_code, " id = ", response_id);
    res.status(response_code).json({ id: response_id });
  } else {
    const error = new Error("Respuesta ID es requerido!");
    error.status = 400;
    res.status(response_code);
  }
};
