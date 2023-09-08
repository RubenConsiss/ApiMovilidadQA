-- MySQL Workbench Synchronization
-- Generated: 2019-03-11 16:40
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Consiss

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `xxbdo_tipo_indicadores` 
ADD COLUMN `orden` SMALLINT(6) NULL DEFAULT NULL AFTER `descripcion`, RENAME TO  `xxbdo_frecuencia_indicadores` ;

ALTER TABLE `xxbdo_indicadores` 
ADD COLUMN `tipo` CHAR(1) NULL DEFAULT NULL AFTER `xxbdo_version_estandares_id`,
ADD COLUMN `orden` SMALLINT(6) NULL DEFAULT NULL AFTER `xxbdo_frecuencia_indicadores_id`,
CHANGE COLUMN `xxbdo_tipo_indicadores_id` `xxbdo_frecuencia_indicadores_id` VARCHAR(36) NOT NULL ,
DROP INDEX `XXBDO_INDICADORES_TIPO_INDICADORES_ID_IDX` ,
ADD INDEX `XXBDO_INDICADORES_FRECUENCIA_INDICADORES_ID_IDX` (`xxbdo_frecuencia_indicadores_id` ASC);
;

ALTER TABLE `xxbdo_respuestas_indicadores` 
ADD COLUMN `tipo` CHAR(1) NULL DEFAULT NULL AFTER `xxbdo_frecuencia_indicadores_id`,
CHANGE COLUMN `xxbdo_tipo_indicadores_id` `xxbdo_frecuencia_indicadores_id` VARCHAR(36) NOT NULL ;

ALTER TABLE `xxbdo_tiendas_has_areas_estandares` 
DROP INDEX `XXBDO_TIENDAS_HAS_AREAS_STDS_ID_IDX` ,
ADD INDEX `XXBDO_TIENDAS_HAS_AREAS_STDS_ID_IDX` (`xxbdo_areas_estandares_id` ASC);
;

ALTER TABLE `xxbdo_areas_estandares_indicadores` 
CHANGE COLUMN `orden` `orden` SMALLINT(6) NULL DEFAULT NULL ;


CREATE TABLE IF NOT EXISTS `xxbdo_checklists_has_areas_estandares_indicadores` (
  `xxbdo_checklists_id` VARCHAR(36) NOT NULL,
  `xxbdo_areas_estandares_indicadores_id` VARCHAR(36) NOT NULL,
  `es_visible` TINYINT(4) NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`xxbdo_checklists_id`, `xxbdo_areas_estandares_indicadores_id`),
  INDEX `XXBDO_CHECKLISTS_HAS_AREAS_STDS_IND_ID_IDX` (`xxbdo_areas_estandares_indicadores_id` ASC),
  INDEX `XXBDO_CHECKLISTS_HAS_AREAS_STDS_IND_CHECKLISTS_ID_IDX` (`xxbdo_checklists_id` ASC),
  CONSTRAINT `XXBDO_CHECKLISTS_HAS_AREAS_STDS_IND_CHECKLISTS_ID_FK`
    FOREIGN KEY (`xxbdo_checklists_id`)
    REFERENCES `xxbdo_checklists` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_CHECKLISTS_HAS_AREAS_STDS_IND_ID_FK`
    FOREIGN KEY (`xxbdo_areas_estandares_indicadores_id`)
    REFERENCES `xxbdo_areas_estandares_indicadores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

ALTER TABLE `xxbdo_indicadores` 
ADD CONSTRAINT `XXBDO_INDICADORES_FRECUENCIA_INDICADORES_ID_FK`
  FOREIGN KEY (`xxbdo_frecuencia_indicadores_id`)
  REFERENCES `xxbdo_frecuencia_indicadores` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `xxbdo_respuestas_indicadores` 
ADD CONSTRAINT `XXBDO_RESPUESTAS_INDICADORES_TIPO_IND_ID_FK`
  FOREIGN KEY (`xxbdo_frecuencia_indicadores_id`)
  REFERENCES `xxbdo_frecuencia_indicadores` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


CREATE TABLE IF NOT EXISTS `xxbdo_tiendas_has_areas_estandares_indicadores` (
  `cr_plaza` VARCHAR(10) NOT NULL,
  `cr_tienda` VARCHAR(10) NOT NULL,
  `xxbdo_checklists_id` VARCHAR(36) NOT NULL,
  `xxbdo_areas_estandares_indicadores_id` VARCHAR(36) NOT NULL,
  `es_visible` TINYINT(4) NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`xxbdo_checklists_id`, `xxbdo_areas_estandares_indicadores_id`, `cr_plaza`, `cr_tienda`),
  INDEX `XXBDO_TIENDAS_AREAS_STDS_INDICADORES_ID_IDX` (`xxbdo_areas_estandares_indicadores_id` ASC),
  INDEX `XXBDO_TIENDAS_AREAS_STDS_IND_CHECKLISTS_ID_IDX` (`xxbdo_checklists_id` ASC),
  CONSTRAINT `XXBDO_TIENDAS_HAS_AREAS_STDS_IND_CHECKLISTS_FK`
    FOREIGN KEY (`xxbdo_checklists_id`)
    REFERENCES `xxbdo_checklists` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_TIENDAS_HAS_AREAS_STDS_IND_ID_FK`
    FOREIGN KEY (`xxbdo_areas_estandares_indicadores_id`)
    REFERENCES `xxbdo_areas_estandares_indicadores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

ALTER TABLE `xxbdo_tiendas_has_areas_estandares` 
DROP INDEX `XXBDO_TIENDAS_HAS_AREAS_STDS_ID_IDX` ,
ADD INDEX `XXBDO_TIENDAS_HAS_AREAS_STDS_ID_IDX` (`xxbdo_areas_estandares_id` ASC);


INSERT INTO `xxbdo_tiendas_has_areas_estandares_indicadores` 
SELECT '10MON' as plaza, 
'50AMV' as tienda, 
`xxbdo_checklists_id`, 
`xxbdo_areas_estandares_indicadores_id`, 
`es_visible`, 
`activo`, 
`usuario`, 
`ip_address`, 
`fecha_creacion`, 
`fecha_modificacion` 
FROM `xxbdo_checklists_has_areas_estandares_indicadores`;

ALTER TABLE `xxbdo_fr12`.`xxbdo_tiendas_has_areas_estandares` 
DROP INDEX `XXBDO_TIENDAS_HAS_AREAS_STDS_ID_IDX` ,
ADD INDEX `XXBDO_TIENDAS_HAS_AREAS_STDS_ID_IDX` (`xxbdo_areas_estandares_id` ASC);
;

ALTER TABLE `xxbdo_frecuencia_indicadores` 
ADD COLUMN `fecha_inicio` TIMESTAMP NULL AFTER `descripcion`,
ADD COLUMN `frecuencia_en_dias` INT(11) NOT NULL DEFAULT 0 AFTER `fecha_inicio`,
CHANGE COLUMN `orden` `orden` SMALLINT(6) NULL DEFAULT 0 ,
CHANGE COLUMN `activo` `activo` TINYINT(4) NULL DEFAULT 1 ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
