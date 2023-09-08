-- Project: Movilidad En Tienda - BDO 
-- Author: Adrián Zenteno <azlara@gmail.com>
-- Usage: SQL script to migrate HeatMap BDO to Calendar BDO

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

USE `xxbdo`;

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


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
