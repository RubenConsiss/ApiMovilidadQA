-- Project: Movilidad En Tienda - BDO 
-- Author: Adrián Zenteno <azlara@gmail.com>
-- Usage: SQL script to migrate HeatMap BDO to Calendar BDO

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- USE `xxbdo`;

ALTER TABLE `xxbdo_checklists` 
ADD COLUMN `titulo_app` VARCHAR(100) NULL DEFAULT NULL AFTER `descripcion`;

UPDATE `xxbdo_checklists` SET `titulo_app` = 'BITACORA v23' WHERE `xxbdo_checklists`.`id` = '3e50f58c-8634-41ce-93b5-c8bebb8bce46';

ALTER TABLE `xxbdo_observaciones` 
CHANGE COLUMN `turno_mañana` `turno_mañana` TINYINT(4) NULL DEFAULT NULL ,
ADD INDEX `XXBDO_OBSERVACIONES_RESPUESTAS_IDX` (`xxbdo_respuestas_id` ASC),
DROP INDEX `xxbdo_respuestas_id` ;

ALTER TABLE `xxbdo_version_estandares` 
CHANGE COLUMN `fecha_inicio` `fecha_inicio` DATE NOT NULL ;

ALTER TABLE `xxbdo_indicadores` 
ADD COLUMN `foto` TEXT NULL DEFAULT NULL AFTER `default`,
ADD COLUMN `detalle` TEXT NULL DEFAULT NULL AFTER `foto`;

CREATE TABLE IF NOT EXISTS `xxbdo_circulo_de_congruencia` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_respuestas_id` VARCHAR(36) NOT NULL,
  `fecha` DATE NULL DEFAULT NULL,
  `comentario` TEXT NULL DEFAULT NULL,
  `foto` TEXT NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_CC_RESPUESTAS_ID_IDX` (`xxbdo_respuestas_id` ASC),
  CONSTRAINT `XXBDO_CC_RESPUESTAS_ID_FK`
    FOREIGN KEY (`xxbdo_respuestas_id`)
    REFERENCES `xxbdo_respuestas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

UPDATE `xxbdo_indicadores` SET `tipo_dato` = 'int' WHERE `xxbdo_indicadores`.`id` = 'b49f07bc-93e7-4eab-b3f6-ae65bb60d91c'; 
UPDATE `xxbdo_indicadores` SET `tipo_dato` = 'int' WHERE `xxbdo_indicadores`.`id` = 'e7f384e5-43e9-4c0f-9662-023b5c564e98'; 

-- Equipos capacitados
UPDATE `xxbdo_indicadores` SET `detalle` = 'Porcetaje de empleados capacitados (empleados capacitados / total de empleados en tienda)' WHERE `xxbdo_indicadores`.`id` = '6e0a3a59-542b-4e51-90d8-fc92bc21ecd1'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Porcetaje de empleados capacitados (empleados capacitados / total de empleados en tienda)' WHERE `xxbdo_indicadores`.`id` = 'c16be293-3f3a-4b98-81b1-4d5334cff7f6';

-- Equipos completos
UPDATE `xxbdo_indicadores` SET `detalle` = 'Porcentaje de equipos completos (Empleados en tienda / Empleados que debe de tener la tienda)' WHERE `xxbdo_indicadores`.`id` = 'b8f0756f-0a2f-42e1-b23b-ad2f2ac5857d'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Porcentaje de equipos completos (Empleados en tienda / Empleados que debe de tener la tienda)' WHERE `xxbdo_indicadores`.`id` = 'fc5bb88c-0753-4b89-b2ba-25a69a81c62f';

-- Ev Donas a Granel
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la evaluación de Donas a Granel realizada por IMMEX' WHERE `xxbdo_indicadores`.`id` = '35584e3e-6cdd-4587-a1ef-d4d6799bfb7e'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la evaluación de Donas a Granel realizada por IMMEX' WHERE `xxbdo_indicadores`.`id` = 'a2738a70-7352-4b7b-a63f-663fdb2ee89e';

-- Ev Oper Puntos Cuarto Frio
UPDATE `xxbdo_indicadores` SET `descripcion` = 'Ev. Operativa Puntos Cuarto Frío (Indicador de tipo Puntos)', `detalle` = 'Resultado de las preguntas 12, 14,15,16,17,22 y 27 de la Evaluación Operativa mensual realizada por el Asesor Tienda' WHERE `xxbdo_indicadores`.`id` = '222eb7fa-71f4-44be-9057-edf33fd98cc7'; 
UPDATE `xxbdo_indicadores` SET `descripcion` = 'Ev. Operativa Puntos Cuarto Frío (Indicador de tipo Puntos)', `detalle` = 'Resultado de las preguntas 12, 14,15,16,17,22 y 27 de la Evaluación Operativa mensual realizada por el Asesor Tienda' WHERE `xxbdo_indicadores`.`id` = '7bb169b8-ace1-48ae-99ef-7f8e0fcc84b6';

-- Ev Oper Sección Abasto: de tipo porcentaje a puntos
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la sección \"Abasto\" de la Evaluación Operativa mensual realizada por el Asesor Tienda.' WHERE `xxbdo_indicadores`.`id` = 'a1a7f344-3e3a-456a-b06e-f45e834f8071'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la sección \"Abasto\" de la Evaluación Operativa mensual realizada por el Asesor Tienda.' WHERE `xxbdo_indicadores`.`id` = 'b1e27dfd-e37a-455e-b668-ccda29db8e9f';

-- Ev Oper Seccion Atención: de tipo porcentaje a puntos
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la sección \"Atención\" de la Evaluación Operativa mensual realizada por el Asesor Tienda.' WHERE `xxbdo_indicadores`.`id` = 'bbfe5636-4304-4b9d-810a-178fad1130e6'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la sección \"Atención\" de la Evaluación Operativa mensual realizada por el Asesor Tienda.' WHERE `xxbdo_indicadores`.`id` = 'dcc1ddeb-fde3-43ce-9bb7-4220c520c74b';

-- Ev Oper Sec Limpieza: de tipo porcentaje a puntos
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la sección \"Limpieza\" de la Evaluación Operativa mensual realizada por el Asesor Tienda.' WHERE `xxbdo_indicadores`.`id` = '222968a6-d9ea-46de-aa5c-c9412167972d'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la sección \"Limpieza\" de la Evaluación Operativa mensual realizada por el Asesor Tienda.' WHERE `xxbdo_indicadores`.`id` = 'e022a745-cb30-4de4-a9bd-8662cb0e87eb';

-- Ev Oper Sec Rapidez: de tipo porcentaje a puntos
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la sección \"Rapidez\" de la Evaluación Operativa mensual realizada por el Asesor Tienda.' WHERE `xxbdo_indicadores`.`id` = '469f5845-1498-4ae8-a0c2-d30e2b806e09'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la sección \"Rapidez\" de la Evaluación Operativa mensual realizada por el Asesor Tienda.' WHERE `xxbdo_indicadores`.`id` = '75e5a7b3-af5d-4b94-af3a-3a824b7251a8';

-- Exhibicion Real Americano
UPDATE `xxbdo_indicadores` SET `detalle` = 'Porcentaje de Exhibición Real de Café Americano' WHERE `xxbdo_indicadores`.`id` = '5f128883-45d3-42b0-bfc5-07790eac9215'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Porcentaje de Exhibición Real de Café Americano' WHERE `xxbdo_indicadores`.`id` = 'e0b20727-8bb6-4c0c-8532-12b2ee5f645d';

-- Exhibicion Real Roller
UPDATE `xxbdo_indicadores` SET `detalle` = 'Porcentaje de Exhibición Real de Roller' WHERE `xxbdo_indicadores`.`id` = '2cd8037e-e777-4db4-8fa5-9ce702b5343f'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Porcentaje de Exhibición Real de Roller' WHERE `xxbdo_indicadores`.`id` = 'f183a0ef-15fd-420c-a626-16bf0e3c09bb';

-- MEP PP 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de Promociones Perfectas de la evaluación de MEP (Promoxxo) mensual realizada por IMMEX' WHERE `xxbdo_indicadores`.`id` = 'ae77c68b-3e63-4f96-9426-aec3f553b845'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de Promociones Perfectas de la evaluación de MEP (Promoxxo) mensual realizada por IMMEX' WHERE `xxbdo_indicadores`.`id` = 'e18639a5-9296-4e7e-a2bf-69ba62149852';

-- MEP POP
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de los criterios de POP de la evaluación de MEP (Promoxxo) realizada por IMMEX' WHERE `xxbdo_indicadores`.`id` = '36884fb6-18b7-4657-80f2-45b1123785bc'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de los criterios de POP de la evaluación de MEP (Promoxxo) realizada por IMMEX' WHERE `xxbdo_indicadores`.`id` = '6568ab1b-2ff9-40ad-8b09-5663ddddcf5a';

-- Planogramas
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la evaluación de Planogramas mensual realizada por IMMEX' WHERE `xxbdo_indicadores`.`id` = '4d3ffb1b-5449-48d0-8611-18c90441c5df'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de la evaluación de Planogramas mensual realizada por IMMEX' WHERE `xxbdo_indicadores`.`id` = '5de6ee9f-7186-4ee2-978c-b71727e3e0d8';

-- Resultado de inventario: de money a porcentaje
UPDATE `xxbdo_indicadores` SET `tipo_dato` = 'pct', `default` = '0', `detalle` = 'Resultado de Inventario mensual' WHERE `xxbdo_indicadores`.`id` = 'ad3846a4-15b3-47a0-a775-2e1a5ce2e20f'; 
UPDATE `xxbdo_indicadores` SET `tipo_dato` = 'pct', `default` = '0', `detalle` = 'Resultado de Inventario mensual' WHERE `xxbdo_indicadores`.`id` = 'c5ec27ae-0f43-40e5-b04c-db5dc73b3102';

-- Rotacion
UPDATE `xxbdo_indicadores` SET `detalle` = 'Cantidad de bajas de empleados en el mes.' WHERE `xxbdo_indicadores`.`id` = '2c09cdc0-4e93-4f28-9d78-0158c8a566c6'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Cantidad de bajas de empleados en el mes.' WHERE `xxbdo_indicadores`.`id` = 'af34c7db-879f-462a-9939-a78abdecb67e';

-- Scorecard etiqueteo
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de las preguntas7, 11, 14 y 17 de la Evaluación Operativa mensual realizada por el Asesor Tienda' WHERE `xxbdo_indicadores`.`id` = 'dca1fb28-6625-4574-b533-83799252ab12'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Resultado de las preguntas7, 11, 14 y 17 de la Evaluación Operativa mensual realizada por el Asesor Tienda' WHERE `xxbdo_indicadores`.`id` = 'e0f79432-a0e5-47c9-9692-9cd59a039d0c';

-- Usuarios activos: de int a pct
UPDATE `xxbdo_indicadores` SET `tipo_dato` = 'pct', `detalle` = 'Porcentaje de Usuarios activos en Servicios Fianancieros' WHERE `xxbdo_indicadores`.`id` = '0f73ad1b-0a6e-4c60-ba77-7c17ccb20b97'; 
UPDATE `xxbdo_indicadores` SET `tipo_dato` = 'pct', `detalle` = 'Porcentaje de Usuarios activos en Servicios Fianancieros' WHERE `xxbdo_indicadores`.`id` = '7af2d792-0453-4cca-ba4c-243edcc06526';

-- Venta Sugerida: de tipo money a pct
UPDATE `xxbdo_indicadores` SET `detalle` = 'Venta sugerida (Indicador de tipo porcentaje)', `tipo_dato` = 'pct', `default` = '0', `descripcion` = 'Porcentaje de venta sugerida del periodo promocional vigente' WHERE `xxbdo_indicadores`.`id` = '59a7c719-36af-415f-a176-558bbf2f3794'; 
UPDATE `xxbdo_indicadores` SET `detalle` = 'Venta sugerida (Indicador de tipo porcentaje)', `tipo_dato` = 'pct', `default` = '0', `descripcion` = 'Porcentaje de venta sugerida del periodo promocional vigente' WHERE `xxbdo_indicadores`.`id` = 'bd28758f-5bd5-43f6-b47c-d5437e0f3d95';

update `xxbdo_indicadores` set descripcion = detalle;

update `xxbdo_indicadores` set detalle='';

-- Ultimos ajustes a indicadores de Miguel Zavala
UPDATE `xxbdo_indicadores` SET `orden` = '1' WHERE `xxbdo_indicadores`.`id` = '5e9e6b32-8d7a-43ad-8145-2ba627f2b67d';
UPDATE `xxbdo_indicadores` SET `descripcion` = 'Número de conteo de articulos realizados en los preinventarios' WHERE `xxbdo_indicadores`.`id` = '5e9e6b32-8d7a-43ad-8145-2ba627f2b67d';

UPDATE `xxbdo_indicadores` SET `orden` = '2', `tipo_dato` = 'pct', `default` = '0.00', `descripcion` = 'Porcentaje de articulos que se cubrieron en el conteo de articulos en el preinventario' WHERE `xxbdo_indicadores`.`id` = 'b49f07bc-93e7-4eab-b3f6-ae65bb60d91c';

UPDATE `xxbdo_indicadores` SET `orden` = '4', `default` = '0.00' WHERE `xxbdo_indicadores`.`id` = '5f128883-45d3-42b0-bfc5-07790eac9215';

UPDATE `xxbdo_indicadores` SET `orden` = '5', `default` = '0.00' WHERE `xxbdo_indicadores`.`id` = '2cd8037e-e777-4db4-8fa5-9ce702b5343f'; 

UPDATE `xxbdo_indicadores` SET `orden` = '6', `activo` = '0' WHERE `xxbdo_indicadores`.`id` = '5c5bd2dc-c4fe-42cd-affa-52d693389d5b'; 

UPDATE `xxbdo_indicadores` SET `orden` = '7', `activo` = '0' WHERE `xxbdo_indicadores`.`id` = 'ee838814-41d5-43a0-a289-48357aa68fb8'; 

UPDATE `xxbdo_indicadores` SET `orden` = '8', `default` = '0.00' WHERE `xxbdo_indicadores`.`id` = '59a7c719-36af-415f-a176-558bbf2f3794'; 

UPDATE `xxbdo_indicadores` SET `orden` = '9', `default` = '0.00', `descripcion` = 'Porcentaje de Usuarios activos en Servicios Financieros' WHERE `xxbdo_indicadores`.`id` = '7af2d792-0453-4cca-ba4c-243edcc06526';

UPDATE `xxbdo_indicadores` SET `activo` = '0' WHERE `xxbdo_indicadores`.`id` = '202b995f-f4fe-4805-8a61-1ec28fcc7c73';

UPDATE `xxbdo_indicadores` SET `activo` = '0' WHERE `xxbdo_indicadores`.`id` = '65ba78bd-2292-4161-8f65-81dfc132dc28';

-- Indicadores Mensuales:
UPDATE `xxbdo_indicadores` SET `descripcion` = 'Ev. Operativa Sección Atención (Indicador de tipo Puntos o Puntaje)', `orden` = '1', `tipo_dato` = 'pnt', `default` = '1' WHERE `xxbdo_indicadores`.`id` = 'bbfe5636-4304-4b9d-810a-178fad1130e6';

UPDATE `xxbdo_indicadores` SET `orden` = '2' WHERE `xxbdo_indicadores`.`id` = 'ad340633-9e7d-412f-a0b8-7b4f905a69ec';

UPDATE `xxbdo_indicadores` SET `descripcion` = 'Ev. Operativa Sección Rapidez (indicador de tipo Puntaje del 1 al 100)', `orden` = '3', `tipo_dato` = 'pnt', `default` = '1' WHERE `xxbdo_indicadores`.`id` = '469f5845-1498-4ae8-a0c2-d30e2b806e09';

UPDATE `xxbdo_indicadores` SET `descripcion` = 'Resultado de Inventario (Indicador de tipo Porcentaje, ejemplo: 0.00)', `orden` = '4', `default` = '0.00' WHERE `xxbdo_indicadores`.`id` = 'ad3846a4-15b3-47a0-a775-2e1a5ce2e20f';

UPDATE `xxbdo_indicadores` SET `orden` = '5' WHERE `xxbdo_indicadores`.`id` = '4fd79d79-9e95-4b1e-85f0-bdd750214c8f'; 

UPDATE `xxbdo_indicadores` SET `descripcion` = 'Equipos Completos (Indicador de tipo Porcentaje, ejemplo: 0.00)', `orden` = '6', `default` = '0.00' WHERE `xxbdo_indicadores`.`id` = 'fc5bb88c-0753-4b89-b2ba-25a69a81c62f'; 

UPDATE `xxbdo_indicadores` SET `descripcion` = 'Equipos Capacitados (Indicador de tipo Porcentaje, ejemplo: 0.00)', `orden` = '7', `default` = '0.00' WHERE `xxbdo_indicadores`.`id` = 'c16be293-3f3a-4b98-81b1-4d5334cff7f6'; 

UPDATE `xxbdo_indicadores` SET `descripcion` = 'Rotación (Indicador de tipo numérico sin decimales)', `orden` = '8' WHERE `xxbdo_indicadores`.`id` = '2c09cdc0-4e93-4f28-9d78-0158c8a566c6'; 

UPDATE `xxbdo_indicadores` SET `descripcion` = 'Ev. Operativa Sección Limpieza (Indicador de tipo Puntaje del 1 al 100)', `orden` = '9', `tipo_dato` = 'pnt', `default` = '1' WHERE `xxbdo_indicadores`.`id` = '222968a6-d9ea-46de-aa5c-c9412167972d'; 

UPDATE `xxbdo_indicadores` SET `descripcion` = 'Planogramas (Charola/Mueble) (Indicador de tipo Porcentaje, ejemplo: 0.00)', `orden` = '10', `default` = '0.00' WHERE `xxbdo_indicadores`.`id` = '5de6ee9f-7186-4ee2-978c-b71727e3e0d8'; 

UPDATE `xxbdo_indicadores` SET `descripcion` = 'MEP P.P. (Indicador de tipo Porcentaje, ejemplo: 0.00)', `orden` = '11', `default` = '0.00' WHERE `xxbdo_indicadores`.`id` = 'ae77c68b-3e63-4f96-9426-aec3f553b845'; 

UPDATE `xxbdo_indicadores` SET `orden` = '12' WHERE `xxbdo_indicadores`.`id` = 'ddd7944c-088a-49df-a7ea-f128fea386c8'; 

UPDATE `xxbdo_indicadores` SET `descripcion` = 'Ev. Operativa Sección Abasto (Indicador de tipo Puntaje del 1 al 100)', `orden` = '13', `tipo_dato` = 'pnt', `default` = '1' WHERE `xxbdo_indicadores`.`id` = 'b1e27dfd-e37a-455e-b668-ccda29db8e9f'; 

UPDATE `xxbdo_indicadores` SET `orden` = '14' WHERE `xxbdo_indicadores`.`id` = 'e0f79432-a0e5-47c9-9692-9cd59a039d0c'; 

UPDATE `xxbdo_indicadores` SET `descripcion` = 'Ev. Donas a Granel (Indicador de tipo Porcentaje, ejemplo: 0.00)', `orden` = '15', `default` = '0.00' WHERE `xxbdo_indicadores`.`id` = 'a2738a70-7352-4b7b-a63f-663fdb2ee89e'; 

UPDATE `xxbdo_indicadores` SET `descripcion` = 'Ev. Operativa Puntos Cuarto Frío (Indicador de tipo Puntaje del 1 al 100)', `orden` = '15', `tipo_dato` = 'pnt', `default` = '1' WHERE `xxbdo_indicadores`.`id` = '222eb7fa-71f4-44be-9057-edf33fd98cc7'; 
UPDATE `xxbdo_indicadores` SET `orden` = '16' WHERE `xxbdo_indicadores`.`id` = '222eb7fa-71f4-44be-9057-edf33fd98cc7'; 

UPDATE `xxbdo_indicadores` SET `descripcion` = 'MEP POP (Indicador de tipo Porcentaje, ejemplo: 0.00)', `orden` = '17', `default` = '0.00' WHERE `xxbdo_indicadores`.`id` = '6568ab1b-2ff9-40ad-8b09-5663ddddcf5a'; 


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
