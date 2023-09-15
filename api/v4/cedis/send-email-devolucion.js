const nodemailer = require("nodemailer");
const app_configuration = require('config');
const fetch = require('node-fetch');
const moment = require("moment");

/* Local imports */
const db = require("../../../db")
const azureSasToken = require("../../helpers/azure-sas-tokens");
const { contactos } = require("./utils/contactos")
const { htmlTemplate } = require('./utils/template-devolucion')

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
    Route,
    CRTienda,
    NombreTienda,
    Fecha,
    Hora,
    Transferencia,
    IdOrden,
    ListadoArticulosSobrantes,
    TotalSobrantes,
    BolArticulosSobrantes,
    ListadoArticulosFaltantes,
    TotalFaltantes,
    ListadoArticulosDaniados,
    TotalDaniados,
    ListadoArticulosCaducos,
    TotalCaducos,
    BolArticulosDaFaltantes,
    BolArticulosDaniados,
    BolArticulosCaducos,
    supplierId } = req?.body;

    if (
      typeof Route === 'undefined' ||
      typeof CRTienda === 'undefined' ||
      typeof NombreTienda === 'undefined' ||
      typeof Fecha === 'undefined' ||
      typeof Hora === 'undefined' ||
      typeof Transferencia === 'undefined' ||
      typeof IdOrden === 'undefined' ||
      typeof ListadoArticulosSobrantes === 'undefined' ||
      typeof TotalSobrantes === 'undefined' ||
      typeof BolArticulosSobrantes === 'undefined' ||
      typeof ListadoArticulosFaltantes === 'undefined' ||
      typeof TotalFaltantes === 'undefined' ||
      typeof ListadoArticulosDaniados === 'undefined' ||
      typeof TotalDaniados === 'undefined' ||
      typeof ListadoArticulosCaducos === 'undefined' ||
      typeof TotalCaducos === 'undefined' ||
      typeof BolArticulosDaFaltantes === 'undefined' ||
      typeof BolArticulosDaniados === 'undefined' ||
      typeof BolArticulosCaducos === 'undefined' ||
      typeof supplierId === 'undefined'
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

    let qrySelect = `SELECT GROUP_CONCAT(xpc.correo SEPARATOR ',') AS results FROM ${tableContactos} xpc JOIN ${tableProveedores} xp ON xpc.id_proveedor = xp.id WHERE xp.external_id = ? GROUP BY NULL;`
    const [results] = await executeQuery(qrySelect, [supplierId])
    var history = [Transferencia, crplaza, crtienda, "cedis-devolucion", JSON.stringify(req.body)]

    if (!results) {
      return res.status(200).send({
        status: true,
        statusMessange: "Sin correo configurado",
        data: {
          "messageId": null
        }
      })
    }

    let templateInfo = req?.body

    templateInfo = {
      ...templateInfo,
      ListadoArticulosSobrantes: templateInfo?.ListadoArticulosSobrantes.map(item => {
        const uri = item?.Evidencia.split('?')
        const blob = uri[0].replace(`${app_configuration.get('azure.sas.url')}xxbdo-cedis/`, "")

        return {
          ...item,
          Evidencia: generateUrl(blob)
        }
      }),
      ListadoArticulosFaltantes: templateInfo?.ListadoArticulosFaltantes.map(item => {
        const uri = item?.Evidencia.split('?')
        const blob = uri[0].replace(`${app_configuration.get('azure.sas.url')}xxbdo-cedis/`, "")

        return {
          ...item,
          Evidencia: generateUrl(blob)
        }
      }),
      ListadoArticulosDaniados: templateInfo?.ListadoArticulosDaniados.map(item => {
        const uri = item?.Evidencia.split('?')
        const blob = uri[0].replace(`${app_configuration.get('azure.sas.url')}xxbdo-cedis/`, "")

        return {
          ...item,
          Evidencia: generateUrl(blob)
        }
      }),
      ListadoArticulosCaducos: templateInfo?.ListadoArticulosCaducos.map(item => {
        const uri = item?.Evidencia.split('?')
        const blob = uri[0].replace(`${app_configuration.get('azure.sas.url')}xxbdo-cedis/`, "")

        return {
          ...item,
          Evidencia: generateUrl(blob)
        }
      })
    }

    //---- PDF FUE ----
    let file = htmlTemplate(crtienda, crplaza, templateInfo)

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

    let attachments = [{
      filename: `FORMATO_DEVOLUCION_${current}.pdf`,
      content: Buffer.from(file?.stringFile?.data, 'utf-8')
    }];

    let info = await transporter.sendMail({
      from: 'recibomercanciacedis@oxxo.com',
      to: results.results,
      bcc: 'juan.castrosilva@oxxo.com, eirud.juarez@serviciosexternos.com.mx',
      subject: `FORMATO DE ACREDITACIÓN - (${current}) - ${NombreTienda}/${crtienda} - ${crplaza}`,
      attachments: attachments,
      text: `A continuación se comparte el resumen de la acreditación (${NombreTienda})\n\n` +
        `Tienda: ${NombreTienda}\n` +
        `Fecha: ${Fecha}\n` +
        `Hora de Entrega: ${Hora}\n` +
        `Número de Ruta: ${Route}\n` +
        `Transferencia: ${Transferencia}\n\n` +
        `Cualquier duda o comentario.\n\n` +
        `Favor de comunicarse a los siguientes contactos: Mauricio Adrián García Silva (adrian.garcia@oxxo.com), Rosa Yazmin García Martínez (rosa.garciam@oxxo.com)\n\n`
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
      status: false,
      statusMessange: "Correo no enviado",
      data: {
        "messageId": null
      }
    })

  } catch (err) {
    history.push(false)
    await createHistory(history)

    err.status = 500;
    return next(err);
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

function generateUrl(blobPath) {
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
