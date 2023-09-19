const nodemailer = require("nodemailer");
const app_configuration = require('config');
const fetch = require('node-fetch');
const moment = require("moment");

/* Local imports */
const db = require("../../../db")
const azureSasToken = require("../../helpers/azure-sas-tokens");
const { htmlTemplate } = require('./utils/template')
const { htmlTira } = require('./utils/template-tira')

const table = 'xxbdo_evidencia'
const tableContactos = 'xxbdo_proveedores_contactos'
const tableProveedores = 'xxbdo_proveedores'

exports.send_email = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  const { crplaza, crtienda } = req.tokenData;

  const {
    Entregados,
    Faltantes,
    Sobrantes_danados,
    etiquetas_danadas,
    Firma_Faltante,
    Devolucion_mercancia,
    Devolucion_canastillas,
    canastilla_tienda,
    devolucion_contenedores,
    Firma_devoluciones,
    Movimientos,
    Tienda,
    Plaza,
    Nu_Ruta,
    Lider_Tienda,
    Transferencia,
    Fecha,
    Hora_Entrega,
    Fecha_Inicio,
    Hora_Inicio,
    Cedis,
    ticket } = req.body;

  if (!Object.keys(Entregados).length ||
    !Object.keys(Faltantes).length ||
    !Object.keys(Firma_Faltante).length ||
    !Object.keys(Sobrantes_danados).length ||
    !Object.keys(Devolucion_mercancia).length ||
    !Object.keys(Devolucion_canastillas).length ||
    !Object.keys(Devolucion_canastillas).length ||
    !Object.keys(canastilla_tienda).length ||
    !Object.keys(devolucion_contenedores).length ||
    !Object.keys(Firma_devoluciones).length ||
    !Movimientos.length ||
    !Tienda ||
    !Plaza ||
    !Nu_Ruta ||
    !Lider_Tienda ||
    !Transferencia ||
    !Fecha ||
    !Hora_Entrega ||
    !Cedis ||
    !ticket
  ) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "Campos perdidos en el body" })
  }

  try {
    const current = moment().format("YYYY-MM-DD")
    let FechaIni = Fecha_Inicio
    let HoraIni = Hora_Inicio

    if (typeof FechaIni === "undefined")
    {
      FechaIni = " "
    }

    if (typeof HoraIni === "undefined")
    {
      HoraIni = " "
    }
    
    let transporter = await nodemailer.createTransport({
      host: "10.80.2.243",
      port: 25,
      secure: false,
      auth: {
        user: "recibomercanciadirectos@oxxo.com",
        pass: "Ox.321#dire",
      },
    });

    let qrySelect = `SELECT GROUP_CONCAT(xpc.correo SEPARATOR ',') AS results FROM ${tableContactos} xpc JOIN ${tableProveedores} xp ON xpc.id_proveedor = xp.id WHERE xp.external_id = ? GROUP BY NULL;`
    const [results] = await executeQuery(qrySelect, [ticket?.supplierId])
    var history = [Transferencia, crplaza, crtienda, "cedis", JSON.stringify(req.body)]

    if (!results) {
      return res.status(200).send({
        status: true,
        statusMessange: "Sin correo configurado",
        data: {
          "messageId": null
        }
      })
    }

    let file = htmlTemplate(crtienda, crplaza, req.body)
    let tira = htmlTira(crtienda, crplaza, req.body)

    const response = await fetch(app_configuration.get('azure.cloudFunction.htmlConvertPdf'), {
      method: "POST",
      responseType: "arraybuffer",
      responseEncoding: "binary",
      headers: {
        "Content-Type": "application/pdf"
      },
      body: file
    })

    const responseTira = await fetch(app_configuration.get('azure.cloudFunction.htmlConvertPdf'), {
      method: "POST",
      responseType: "arraybuffer",
      responseEncoding: "binary",
      headers: {
        "Content-Type": "application/pdf"
      },
      body: tira
    })

    file = await response.json()
    tira = await responseTira.json()

    let attachments = [
      {
        filename: `FUE_${current}.pdf`,
        content: Buffer.from(file?.stringFile?.data, 'utf-8')
      },
      {
        filename: `TIRA_${current}.pdf`,
        content: Buffer.from(tira?.stringFile?.data, 'utf-8')
      }
    ]

    //---- IMAGENES EVIDENCIAS ----
    qrySelect = `SELECT fcBlob FROM ${table} WHERE fcTransferencia=? AND fcCr_Plaza=? AND fcCr_Tienda=? AND fcSource=?`
    const resultsEvidence = await executeQuery(qrySelect, [Transferencia, crplaza, crtienda, "cedis"])

    if (resultsEvidence.length) {
      resultsEvidence.map(result => {
        if (result?.fcBlob) {
          const uri = buildAttachments(result.fcBlob)
          if (uri) {
            attachments.push({
              filename: result.fcBlob,
              path: uri
            })
          }
        }
      })
    }

    let info = await transporter.sendMail({
      from: 'recibomercanciacedis@oxxo.com',
      to: results.results,
      bcc: 'juan.castrosilva@oxxo.com, eirud.juarez@serviciosexternos.com.mx',
      subject: `FORMATO UNICO DE ENTREGA - (${current}) - ${Tienda}/${crtienda} - ${crplaza}`,
      attachments: attachments,
      text: `A continuación se comparte el resumen de la entrega en tienda (${Tienda})\n\n` +
        `Cedis: ${Cedis}\n` +
        `Plaza: ${crplaza} ${Plaza}\n` +
        `Tienda: ${Tienda}\n` +
        `Fecha de Inicio: ${FechaIni}\n` +
        `Hora de Inicio: ${HoraIni}\n` +
        `Fecha de Entrega: ${Fecha}\n` +
        `Hora de Entrega: ${Hora_Entrega}\n` +
        `Número de Ruta: ${Nu_Ruta}\n` +
        `Transferencia: ${Transferencia}\n\n` +
        `Cualquier duda o comentario.\n\n` +
        `Favor de comunicarse al siguiente contacto: Jorge Loya Bracamonte (jorge.loya@oxxo.com)\n\n`
    });

    if (info.messageId) {
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

    return res.status(200).send({
      status: true,
      statusMessange: "Correo no enviado",
      data: {
        "messageId": null
      }
    })

  } catch (err) {
    return res.status(500).send({
      status: false,
      statusMessange: "Correo no enviado",
      data: {
        "messageId": err
      }
    })
  }
}

async function createHistory(history) {
  const qryInsert = `INSERT INTO xxbdo_historico_correos (transferencia, cr_plaza, cr_tienda, origen, body, estatus) VALUES(?)`

  await executeQuery(qryInsert, [history])

  console.log("[Service: send_email] - History Created")
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

function buildAttachments(blobPath) {
  const token =
    azureSasToken.generateSasToken(
      app_configuration.
        get('azure.sas.blob.containers.cedis.name'),
      blobPath,
      app_configuration.
        get('azure.sas.blob.containers.cedis.sharedAccessPolicy')
    );

  return token?.uri
}
