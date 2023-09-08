const moment = require("moment");
const db = require("../../../db")
const table = "xxbdo_checklist_utensilios";
const tableJoin = "xxbdo_checklist_respuestas_utensilios";
exports.simplex_utensilios_get = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  const { crplaza, crtienda } = req.tokenData;

  req.checkParams("anio")
    .trim()
    .isNumeric()
    .withMessage('Tipo de dato inválido para el parámetro :anio. Debe representar un valor numérico.')
    .isLength({ min: 4, max: 4 })
    .withMessage('Longitudad inválida para el parámetro :anio. Debe ser longitud de 4.')

  req.checkParams("mes")
    .trim()
    .isNumeric()
    .withMessage('Tipo de dato inválido para el parámetro :mes. Debe representar un valor numérico')
    .isLength({ min: 2, max: 2 })
    .withMessage('Longitudad inválida para el parámetro :mes. Debe ser longitud de 2.')

  const { anio, mes } = req.params;
  let qrySelect = `SELECT ut.id, rut.id AS rut_id, ut.nombre, ut.descripcion, ut.codigo, ut.categoria, rut.folio, rut.respuesta, rut.mes, rut.año AS anio, rut.cr_plaza, rut.cr_tienda FROM ${table} AS ut LEFT JOIN ${tableJoin} AS rut
    ON ut.id = rut.xxbdo_utensilios_id AND rut.mes=? AND rut.año=? AND rut.cr_plaza=? AND rut.cr_tienda=?`

  try {
    let results = await executeQuery(qrySelect, [mes, anio, crplaza, crtienda]);
    results = formatResponse(results);
    await createHistory(results, anio, mes, crplaza, crtienda);

    return res.status(200).send({
      status: true,
      statusMessange: "Ok",
      data: results
    })
  } catch (err) {
    err.status = 500;
    return next(err);
  }
}

async function createHistory(results, anio, mes, crplaza, crtienda) {
  let qrySelect = `SELECT respuesta, folio, mes, año FROM ${tableJoin} WHERE cr_plaza=? AND cr_tienda=? AND xxbdo_utensilios_id=? AND mes < ? AND año <= ? ORDER BY año DESC, mes DESC LIMIT 6`

  for (let index = 0; index < results.length; index++) {
    let element = results[index].utensilios;
    let history = [];
    for (let j = 0; j < element.length; j++) {
      const helperDate = moment(`${anio}-${mes}-01`)
      let results = await executeQuery(qrySelect, [crplaza, crtienda, element[j].id, mes, anio]);

      history = results.map(r => {
        return {
          ...r
        }
      })

      for (let i = 0; i < 5; i++) {
        const prev = helperDate.subtract('1', 'months')
        const prevMonth = prev.format("M")
        const prevYear = prev.format("YYYY")

        const exist = history.filter(h => (h.mes == prevMonth && h["año"] == prevYear))

        if (!exist.length) {
          history.push(
            {
              "respuesta": null,
              "folio": null,
              "mes": prevMonth,
              "año": prevYear
            }
          )
        }
      }

      element[j] = {
        ...element[j],
        history: history
      }
    }
  }
}

function formatResponse(rows, add) {
  let rowsParsed = []
  let response = [];

  for (let i = 0; i < rows.length; i++) {
    rowsParsed = [...rowsParsed, {
      id: rows[i]?.id || null,
      respuesta_id: rows[i]?.rut_id || null,
      nombre: rows[i]?.nombre || null,
      descripcion: rows[i]?.descripcion || null,
      folio: rows[i]?.folio || null,
      respuesta: rows[i]?.respuesta || null,
      categoria: rows[i]?.categoria || null
    }]
  }

  rowsParsed = rowsParsed.reduce(function (r, a) {
    r[a?.categoria] = r[a?.categoria] || [];
    r[a?.categoria].push(a);
    return r;
  }, Object.create(null));

  Object.keys(rowsParsed).forEach(function (key, index) {
    response.push({
      "categoria": key,
      "utensilios": rowsParsed[key]
    })
  });

  return response;
}

async function executeQuery(stament, query) {
  return new Promise((resolve, reject) => {
    db.query(stament, query, (err, rows) => {
      if (err) {
        reject(err);
      }

      resolve(rows);
    })
  })
}