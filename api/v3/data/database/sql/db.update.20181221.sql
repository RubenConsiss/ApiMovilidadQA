-- MySQL Workbench Synchronization
-- Generated: 2018-12-21 10:34
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Consiss

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `xxbdo_v6`.`xxbdo_estandares` 
CHANGE COLUMN `cr_plaza` `cr_plaza` VARCHAR(10) NULL DEFAULT NULL ,
CHANGE COLUMN `cr_tienda` `cr_tienda` VARCHAR(10) NULL DEFAULT NULL ;

ALTER TABLE `xxbdo_v6`.`xxbdo_respuestas` 
CHANGE COLUMN `cr_plaza` `cr_plaza` VARCHAR(10) NOT NULL ,
CHANGE COLUMN `cr_tienda` `cr_tienda` VARCHAR(10) NOT NULL ;

ALTER TABLE `xxbdo_v6`.`xxbdo_observaciones` 
DROP COLUMN `resolvio_problema`,
DROP COLUMN `realizaron_plan_accion`,
DROP COLUMN `requiere_ajuste_ata`,
ADD COLUMN `requiere_ajuste_ata` TINYINT(4) NULL DEFAULT NULL AFTER `accion_fecha`,
ADD COLUMN `realizaron_plan_accion` TINYINT(4) NULL DEFAULT NULL AFTER `requiere_ajuste_ata`,
ADD COLUMN `resolvio_problema` TINYINT(4) NULL DEFAULT NULL AFTER `realizaron_plan_accion`;

ALTER TABLE `xxbdo_v6`.`xxbdo_tiendas` 
CHANGE COLUMN `cr_plaza` `cr_plaza` VARCHAR(10) NOT NULL ,
CHANGE COLUMN `cr_tienda` `cr_tienda` VARCHAR(10) NOT NULL ;

ALTER TABLE `xxbdo_v6`.`xxbdo_indicadores` 
ADD COLUMN `tipo_dato` VARCHAR(10) NULL DEFAULT NULL AFTER `tipo_indicador`,
ADD COLUMN `default` TEXT NULL DEFAULT NULL AFTER `tipo_dato`,
CHANGE COLUMN `tipo` `tipo_indicador` CHAR(1) NOT NULL ;

ALTER TABLE `xxbdo_v6`.`xxbdo_evaluacion_indicadores` 
DROP COLUMN `fecha_fin`,
DROP COLUMN `fecha_inicio`,
ADD COLUMN `fecha_respuesta` DATE NULL DEFAULT NULL AFTER `xxbdo_indicadores_id`,
ADD COLUMN `semana` INT(11) NULL DEFAULT NULL AFTER `fecha_respuesta`,
ADD COLUMN `mes` INT(11) NULL DEFAULT NULL AFTER `semana`,
ADD COLUMN `año` INT(11) NULL DEFAULT NULL AFTER `mes`,
CHANGE COLUMN `cr_plaza` `cr_plaza` VARCHAR(10) NOT NULL ,
CHANGE COLUMN `cr_tienda` `cr_tienda` VARCHAR(10) NOT NULL ,
CHANGE COLUMN `evaluacion` `evaluacion` TEXT NULL DEFAULT NULL ,
DROP INDEX `XXBDO_EVAL_INDS_RANGO_FECHAS_IDX` ;
;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
