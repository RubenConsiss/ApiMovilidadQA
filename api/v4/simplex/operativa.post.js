const db = require("./../../../db")
const bdoDates = require("../../helpers/bdo-dates");
const table = "xxbdo_checklist_operativo";
const moment = require("moment");

exports.simplex_operativa_post = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  const input = req.body?.input || null;

  if (!input) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Field Input is required" })
  }

  const today = moment()
  const current = bdoDates.getWeekAndYearFromDate(today.format("YYYY-MM-DD"));
  const weekRange = bdoDates.formatWeekStartEndDays(current[0], current[1]);
  const currentMonth = today.format("MM")
  const currentYear = today.format("YYYY")
  const isAbleToAction = today.day()

  // if (isAbleToAction !== 1) {
  //   return res.status(400).send({ status: false, statusMessange: "Bad Request", message: "Solo los días Lunes se pueden realizar operaciones" })
  // }

  const monthWeeksRange = bdoDates.getBDOWeeksRangesForDevice(currentYear, currentMonth);
  let idxWeekMonth

  for (let i = 0; i < monthWeeksRange.semanas.length; i++) {
    if (weekRange[1].toLowerCase() == monthWeeksRange.semanas[i].nombre_de_la_semana.toLowerCase()) {
      idxWeekMonth = i + 1;
    }
  }

  let qryUpdate = `UPDATE ${table} SET checks=? WHERE id=?`;
  let qrySelect = `SELECT mes, anio, checks FROM ${table} WHERE id=?`

  try {
    for (let inputIdx in input) {
      const { id, checks } = input[inputIdx]
      if (!id) return res.status(400).send({ status: false, statusMessange: "Bad Request", message: "Campo id requerido" })

      const [result] = await executeQuery(qrySelect, [id])

      if (!result) return res.status(404).send({ status: false, statusMessange: "Internal Error", message: "Dato no encontrado" })

      if (result.mes != currentMonth || result.anio != currentYear) {
        return res.status(400).send({ status: false, statusMessange: "Bad Request", message: "El dato que quiere registrar estan fuera del rango permitido." })
      }

      let checksToUpdate = JSON.parse(result.checks)

      for (let checkIdx in checks) {
        if (checks[checkIdx].valores_del_check.length != monthWeeksRange.semanas.length) {
          return res.status(400).send({ status: false, statusMessange: "Bad Request", message: "Revise que la longitud de los valores del check coincidan con el núnmero de semana del mes en curso." })
        }

        console.log('checksToUpdate', checksToUpdate[checkIdx])

        checksToUpdate[checkIdx].indicaciones = checks[checkIdx]?.nombre == "enfoque" ? checks[checkIdx].indicaciones.map((indicacion, idx) => {
          if ((idx + 1) == idxWeekMonth) {
            return {
              ...indicacion,
              "indicacion": indicacion.indicacion
            }
          }

          return {
            "nombre_de_la_semana": indicacion.nombre_de_la_semana,
            "indicacion": checksToUpdate[checkIdx]?.indicaciones[idx]?.indicacion || "",
          }

        }) : null;

        checksToUpdate[checkIdx].valores_del_check[idxWeekMonth - 1].estatus = checks[checkIdx].valores_del_check[idxWeekMonth - 1].estatus;
      }

      await executeQuery(qryUpdate, [JSON.stringify(checksToUpdate), id])
    }

    return res.status(200).send({
      status: true,
      statusMessange: "Ok",
      data: []
    })

  } catch (err) {
    return res.status(200).send({
      status: false,
      statusMessange: err,
      data: []
    })
  }
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