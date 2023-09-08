
const express = require("express");
const apiRoutesV1 = require('./v1');
//Add folder of new api version here, example:
const apiRoutesV2 = require('./v2');
const apiRoutesV3 = require('./v3');
const apiRoutesV4 = require('./v4');
const api = express();

// Versión V1: Vista de calendario, indicadores
api.use('/v1', apiRoutesV1);

//Versión V2: Vista de calendario, circulo de congruencia:
api.use('/v2', apiRoutesV2);

//Versión V3: 
//1. Nueva columna "app_version" en tabla xxbdo_login_attempts.
//2. Actualización webservice /authorize para recibir "appver" y loguear app version en tabla xxbdo_login_attempts.
//3. Asignar checklist específico al nivel de tienda, cambios en tabla xxbdo_checklists_tiendas, nuevas columnas:
//   `xxbdo_version_estandares_id`, `titulo`, `descripcion`,`titulo_app`,`titulo_indicadores_app`, `fecha_inicio`, `fecha_fin`.
//4. Nueva tabla "xxbdo_configuracion" para guardar parámetros globales de configuración de módulo de pendientes y utensilios.
//5. Nuevo set de webservices(GET/POST/PUT) para módulo de /pendientes.
//6. Definición de web services para módulo de utensilios en progreso.
api.use('/v3', apiRoutesV3);

//Versión V4:
//1. Rediseño completo para bitácora v24
//2. Unificación de Estándares e Indicadores v24.
//3. Nueva BDO API v4 para soportar BDO v23, vNexxo y v24.
//4. Nuevo módulo de configuración de módulos, rediseño servicio bdo/v4/appconfig
//5. Rediseño módulo de Indicadores.
//6. Nuevo servicio para reporte semanal dashboard de checklist diario.
api.use('/v4', apiRoutesV4);

module.exports = api;
