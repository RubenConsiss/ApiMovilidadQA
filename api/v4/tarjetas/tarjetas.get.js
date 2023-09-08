const bdoDates = require("./../../helpers/bdo-dates");
const tarjetasStatusController = require("./tarjetasStatus");
const tarjetaController = require("./tarjetas");
const rolesController= require("./roles");
const moment = require("moment");
const response = {
  dt: null,
  sl: null,
  inicio: null,
  fin: null,
  status: null,
  tarjetas: [],
};

const response_guardar={
  fecha:null,
  roles:[],
  tarjetas:[]
}

const response_entregar = {
  fecha: null,
  roles: [],
  status: [],
  tarjetas: [],
};

exports.tarjetas_get = async (req, res, next) => {
  try {
    let fecha_inicio_consulta = bdoDates.getBDOCurrentDate();
    let fecha_fin_consulta = bdoDates.getBDOCurrentDate();
    const fecha_consulta = req.params.fecha_consulta || null;
    const statusList = await tarjetasStatusController.getStatusList();
    const { crplaza, crtienda } = req.tokenData;
    // TODO si no se paso la fecha de consulta quiere decir que la consulta sera del dia actual
    if (fecha_consulta) {
      fecha_inicio_consulta = bdoDates.firstOfTheWeek(moment(fecha_consulta));
      fecha_fin_consulta = bdoDates.lastOfWeek(moment(fecha_consulta));
    }
    const tarjetasArray = await tarjetaController.getTarjetasProcedure(
      fecha_inicio_consulta,
      fecha_fin_consulta,
      crplaza,
      crtienda
    );
    response.sl = fecha_consulta;
    response.inicio = fecha_inicio_consulta;
    response.fin = fecha_fin_consulta;
    response.dt = bdoDates.getBDOCurrentDate();
    response.status = statusList;
    response.tarjetas = tarjetasArray;
    res.status(200).json(response);
  } catch (err) {
    console.log(err);
    res.status(400).json(err)
  }
};


exports.tarjetasGuardar_get= async(req,res,next)=>{
try{
  //* Se asigna la fecha actual al response
  response_guardar.fecha= bdoDates.getBDOCurrentDate();
  response_guardar.roles= await rolesController.getRolesList();
  response_guardar.tarjetas= await tarjetaController.getTipoTarjetas();
  res.status(200).json(response_guardar);
}catch(err){
  res.status(400).json(err);
}
}


exports.tarjetasEntregar_get= async(req,res,next)=>{
  try {
    const { crplaza, crtienda } = req.tokenData;
    response_entregar.status= await tarjetasStatusController.getStatusList();
    response_entregar.fecha= bdoDates.getBDOCurrentDate();
    response_entregar.roles= await rolesController.getRolesList();
    response_entregar.tarjetas= await tarjetaController.getTarjetasExhibicion(crplaza, crtienda);
  res.status(200).json(response_entregar)  
  } catch (error) {
    res.status(400)
  }
}
  