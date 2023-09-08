
const bdoDates = require("./../../helpers/bdo-dates");
const tarjetaController = require("./tarjetas");
const dbg = false;

exports.tarjetasGuardar_post = async (req, res, next) => {
  if(dbg) console.log("Start tarjetasGuardar_post ... ");
  try {
    const { crplaza, crtienda, usuario } = req.tokenData;
    //Validation chain
    req.checkBody('rol')
    .isUUID(4)
    .withMessage('Formato de rol de tienda incorrecto.')
    .trim();
    req.checkBody('tipo')
    .isUUID(4)
    .withMessage('Formato de tipo de tarjeta incorrecto.')
    .trim();
  
    const errors = req.validationErrors();
    if (errors) {
      if(dbg) console.log(util.inspect(errors, {depth: null}));
      res.status(400).json({});
    }

    let agregada_por = req.body.rol || null;
    let tarjetas_tipo_id = req.body.tipo || null;
    let numero_tarjeta = req.body.num || null;
    let ip_address = req.app_client_ip_address;
    let fecha_registro = bdoDates.getBDOCurrentTimestamp();
    let res_code = 400;
    let rst = null;

    if(numero_tarjeta) {
      if(dbg) console.log("tarjeta = ", numero_tarjeta);
      rst = await tarjetaController.addTarjeta(
        crplaza,
        crtienda,
        tarjetas_tipo_id,
        agregada_por,
        numero_tarjeta,
        fecha_registro,
        usuario,
        ip_address
      );

      if(rst) {
        rst = JSON.parse(rst);
        if(rst.id) {
          res_code = 201;
        }
      }
    }

    res.status(res_code).json(rst);

  } catch (err) {
    res.status(400);
  }
};

exports.tarjetasEntregar_post = async (req, res, next) => {
  if(dbg) console.log("Start tarjetasEntregar_post ... ");
  try {
    const { crplaza, crtienda, usuario } = req.tokenData;
    //Validation chain
    req.checkBody('entrega')
    .isUUID(4)
    .withMessage('Formato de rol de tienda incorrecto.')
    .trim();
    req.checkBody('recibe')
    .isUUID(4)
    .withMessage('Formato de tipo de tarjeta incorrecto.')
    .trim();
  
    const errors = req.validationErrors();
    if (errors) {
      if(dbg) console.log(util.inspect(errors, {depth: null}));
      res.status(400);
    }

    let entrega_data = req.body || null;
    let ip_address = req.app_client_ip_address;
    let fecha_entrega = bdoDates.getBDOCurrentTimestamp();
    let res_code = 400;
    let rst = null;

    if(entrega_data) {
      result = await tarjetaController.entregarTarjetas(
        crplaza,
        crtienda,
        fecha_entrega,
        entrega_data,
        usuario,
        ip_address
      );

      if(result) {
        result = JSON.parse(result.result);
        if(result.status=="OK") {
          res_code = 201;
        }
        rst = result;
      }
    }

    res.status(res_code).json(rst);

  } catch (err) {
    res.status(400);
  }
};
