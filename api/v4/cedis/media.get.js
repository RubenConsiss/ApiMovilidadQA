const db = require("../../../db");
const azureSasToken = require("../../helpers/azure-sas-tokens");
const app_configuration = require('config');

exports.cedis_media_get = (req, res, next) => {
  if (!db) {
    const error = new Error('Conexion a BD no encontrada!');
    error.status = 500;
    return next(error);
  }

  if (!req?.tokenData?.crplaza || !req?.tokenData?.crtienda) {
    return res.status(400).json({ status: false, statusMessange: "Bad Request", message: "crplaza o crtienda invalidos" })
  }

  try {
    req.checkParams("transaccion")
      .trim()

    req.checkParams("file")
      .trim()

    const { transaccion, file } = req.params;

    const blobPath = transaccion + '/' + file

    const token =
      azureSasToken.generateSasToken(
        app_configuration.
          get('azure.sas.blob.containers.cedis.name'),
        blobPath,
        app_configuration.
          get('azure.sas.blob.containers.cedis.sharedAccessPolicy')
      );

    if (!token) {
      return res.status(400).send({
        status: false,
        statusMessange: "No fue posible autenticarse al servicio de azure.",
        uri: uri
      })
    }

    return res.status(200).send({
      status: true,
      statusMessange: "Ok",
      uri: token?.uri
    })

  } catch (error) {
    err.status = 500;
    return next(err);
  }
};