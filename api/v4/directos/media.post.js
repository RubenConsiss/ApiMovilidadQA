const db = require("../../../db");
const azureSasToken = require("../../helpers/azure-sas-tokens");
const app_configuration = require('config');

const table = 'xxbdo_evidencia'

exports.directos_media_post = async (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  const { crplaza, crtienda } = req.tokenData;

  req.checkParams("transaccion")
    .trim()

  try {
    if (req?.files.length) {
      const blobPath = req?.files[0].blobPath
      const { transaccion } = req.params

      const token =
        azureSasToken.generateSasToken(
          app_configuration.
            get('azure.sas.blob.containers.directos.name'),
          blobPath,
          app_configuration.
            get('azure.sas.blob.containers.directos.sharedAccessPolicy')
        );

      if (!token) {
        return res.status(400).send({
          status: false,
          statusMessange: "No fue posible autenticarse al servicio de azure.",
          uri: uri
        })
      }

      const qryInsert = `INSERT INTO ${table} (fcTransferencia, fcCr_Plaza, fcCr_Tienda, fcUrlEvidencia, fcBlob, fcSource) VALUES(?)`

      await executeQuery(qryInsert, [[transaccion, crplaza, crtienda, token?.uri, blobPath, "directos"]])

      return res.status(200).send({
        status: true,
        statusMessange: "Ok",
        uri: token?.uri
      })
    }
  } catch (err) {
    err.status = 500;
    return next(err);
  }
};

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