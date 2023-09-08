const db = require("../../../db")
const nodemailer = require("nodemailer");
const app_configuration = require('config');
const { htmlTemplate } = require('./utils/template')
const moment = require("moment");
const fetch = require('node-fetch');

exports.send_email = async (req, res, next) => {
  const tableContactos = 'xxbdo_proveedores_contactos'
  const tableProveedores = 'xxbdo_proveedores'

  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  console.log("[Service: send_email] - Incoming")

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  const { crplaza, crtienda } = req.tokenData;

  const {
    Detalle_Entrega,
    Firma_Acuerdos,
    Tienda,
    Plaza,
    Lider_Tienda,
    Fecha_Admva,
    Hora_Entrega,
    Nombre_proveedor,
    Numero_proveedor,
    Remision,
    Monto_total,
    Cifra,
    Orden_de_compra,
    Incidencias } = req.body;

  if (!Detalle_Entrega?.length ||
    !Object.keys(Firma_Acuerdos).length ||
    !Tienda ||
    !Plaza ||
    !Lider_Tienda ||
    !Fecha_Admva ||
    !Hora_Entrega ||
    !Nombre_proveedor ||
    !Numero_proveedor ||
    !Remision ||
    !Monto_total ||
    !Cifra ||
    !Orden_de_compra ||
    !Incidencias
  ) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Campos perdidos en el body" })
  }

  try {
    const current = moment().format("YYYY-MM-DD")

    let transporter = await nodemailer.createTransport({
      host: "10.80.2.243",
      port: 25,
      secure: false,
      auth: {
        user: "recibomercanciadirectos@oxxo.com",
        pass: "Ox.321#dire",
      },
    });

    const qrySelect = `SELECT GROUP_CONCAT(xpc.correo SEPARATOR ',') AS results FROM ${tableContactos} xpc JOIN ${tableProveedores} xp ON xpc.id_proveedor = xp.id WHERE xp.external_id = ? GROUP BY NULL;`
    const [results] = await executeQuery(qrySelect, [Numero_proveedor])
    var history = [Orden_de_compra, crplaza, crtienda, "directos", JSON.stringify(req.body)]

    if (!results) {
      history.push(false)
      await createHistory(history)

      return res.status(200).send({
        status: true,
        statusMessange: "Ok",
        data: {
          "messageId": null
        }
      })
    }

    let file = htmlTemplate(crtienda, crplaza, req.body)

    console.log("[Service: send_email] - Template Generated")

    const response = await fetch(app_configuration.get('azure.cloudFunction.htmlConvertPdf'), {
      method: "POST",
      responseType: "arraybuffer",
      responseEncoding: "binary",
      headers: {
        "Content-Type": "application/pdf"
      },
      body: file
    })

    file = await response.json()

    console.log("[Service: send_email] - File decoded")

    const attachments = [{
      filename: `CEP_${current}.pdf`,
      content: Buffer.from(file?.stringFile?.data, 'utf-8')
    }]

    console.log("[Service: send_email] - File attached")

    let bcc = "juan.castrosilva@oxxo.com, eirud.juarez@serviciosexternos.com.mx, samely.herrera@sygno.mx, jose.antonio@sygno.com.mx"

    if (Numero_proveedor == "1940") {
      bcc = bcc + ", hector.gonzalez@grupoti.onmicrosoft.com"
    }

    if (Numero_proveedor == "2086") {
      bcc = bcc + ", ilse.martinez@neoris.com"
    }

    if (Numero_proveedor == "20805") {
      bcc = bcc + ", diana.castro@grupotimex.onmicrosoft.com"
    }

    let info = await transporter.sendMail({
      from: 'recibomercanciadirectos@oxxo.com',
      to: results.results,
      bcc: bcc,
      subject: `COMPROBANTE ENTREGA - (${current}) - ${Tienda}/${crtienda} - ${Numero_proveedor}/${Nombre_proveedor}`,
      attachments: attachments,
      text: `Estimado socio comercial a continuación se comparte el resumen de la entrega correspondiente al día de hoy.\n\n` +
        `Nombre Proveedor: ${Nombre_proveedor}\n` +
        `Plaza: ${Plaza}\n` +
        `Tienda: ${Tienda}\n` +
        `Fecha: ${Fecha_Admva}\n` +
        `Orden de Compra: ${Orden_de_compra}\n` +
        `Remisión: ${Remision}\n` +
        `Monto Total: ${Monto_total}\n` +
        `Cifra: ${Cifra}\n` +
        `Detalle de Entrega:\n` +
        `\t\t- Observaciones Proveedor: ${Firma_Acuerdos.Observaciones_Proveedor}\n` +
        `\t\t- Observaciones Personal Tienda: ${Firma_Acuerdos.Observaciones_Personal_tienda}\n\n` +
        `Cualquier duda o comentario.\n\n` +
        `Favor de comunicarse al siguiente contacto: Juan Ernesto Castro Silva (juan.castrosilva@oxxo.com)\n\n` +
        `Nota: Este comprobante no es un comprobante fiscal.\n\n`
    });

    console.log("[Service: send_email] - Mail sended")

    if (info?.messageId) {
      history.push(true)
      await createHistory(history)
      return res.status(200).send({
        status: true,
        statusMessange: "Ok",
        data: {
          "messageId": info?.messageId
        }
      })
    }

    history.push(false)
    await createHistory(history)

  } catch (err) {
    history.push(false)
    await createHistory(history)

    err.status = 500;
    return next(err);
  }
}

async function createHistory(history) {
  const qryInsert = `INSERT INTO xxbdo_historico_correos(transferencia, cr_plaza, cr_tienda, origen, body, estatus) VALUES(?)`

  await executeQuery(qryInsert, [history])

  console.log("[Service: send_email] - History Created")
}

async function executeQuery(stament, query) {
  return new Promise((resolve, reject) => {
    db.query(stament, query, (err, rows) => {
      if (err) {
        reject(err);
      }

      console.log("[Service: send_email.executeQuery]", stament)

      resolve(rows);
    })
  })
}