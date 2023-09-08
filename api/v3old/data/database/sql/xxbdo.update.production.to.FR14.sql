-- Author: Adrián Zenteno Lara
-- Project: Movilidad en Tienda
-- Status: In progress, IT IS NOT COMPLETED

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- ALTER TABLE `xxbdo_api_logs` CHANGE `r_id` `req_id` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, CHANGE `r_type` `req_type` VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, CHANGE `r_level` `req_level` VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, CHANGE `r_message` `req_message` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, CHANGE `r_url` `req_url` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, CHANGE `r_method` `req_method` VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, CHANGE `r_headers` `req_headers` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, CHANGE `r_body` `req_body` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, CHANGE `r_files` `req_files` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, CHANGE `r_status` `res_status` VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
ALTER TABLE `xxbdo_api_logs` ADD `res_body` TEXT NULL AFTER `r_status`;


CREATE TABLE IF NOT EXISTS `xxbdo_pendientes` (
  `id` VARCHAR(36) NOT NULL,
  `cr_plaza` VARCHAR(10) NOT NULL,
  `cr_tienda` VARCHAR(10) NOT NULL,
  `fecha_compromiso` DATE NULL DEFAULT NULL,
  `fecha_terminacion` DATE NULL DEFAULT NULL,
  `hora_terminacion` TIME NULL DEFAULT NULL,
  `registrado_por` VARCHAR(100) NULL DEFAULT NULL,
  `responsable` VARCHAR(100) NULL DEFAULT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo_utensilios` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_utensilios_categorias_id` VARCHAR(36) NULL DEFAULT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `orden` INT(11) NULL DEFAULT NULL,
  `seleccionable` TINYINT(4) NULL DEFAULT 1,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_UTENSILIOS_CATEGORIAS_ID_IDX` (`xxbdo_utensilios_categorias_id` ASC),
  CONSTRAINT `XXBDO_UTENSILIOS_CATEGORIAS_ID_FK`
    FOREIGN KEY (`xxbdo_utensilios_categorias_id`)
    REFERENCES `xxbdo_utensilios_categorias` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo_production_201907031031_2`.`xxbdo_checklist_utensilios` (
  `id` INT(11) NOT NULL,
  `cr_plaza` VARCHAR(10) NOT NULL,
  `cr_tienda` VARCHAR(10) NOT NULL,
  `fecha_respuesta` DATE NULL DEFAULT NULL,
  `xxbdo_utensilios_id` VARCHAR(36) NOT NULL,
  `en_existencia` TINYINT(4) NULL DEFAULT NULL,
  `en_condiciones` TINYINT(4) NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_CHKLIST_UTENSILIOS_ID_IDX` (`xxbdo_utensilios_id` ASC) VISIBLE,
  CONSTRAINT `XXBDO_CHKLST_UTL_UTENSILIOS_ID_FK`
    FOREIGN KEY (`xxbdo_utensilios_id`)
    REFERENCES `xxbdo_utensilios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo_checklist_utensilios_folios` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_checklist_utensilios_id` INT(11) NOT NULL,
  `folio` VARCHAR(50) NOT NULL,
  `comentario` TEXT NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_CHKLST_UTL_FOLIOS_ID_IDX` (`xxbdo_checklist_utensilios_id` ASC) INVISIBLE,
  CONSTRAINT `XXBDO_CHKLST_UTL_FOLIOS_UTL_ID_FK`
    FOREIGN KEY (`xxbdo_checklist_utensilios_id`)
    REFERENCES `xxbdo_checklist_utensilios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo_utensilios_categorias` (
  `id` VARCHAR(36) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `orden` INT(11) NULL DEFAULT NULL,
  `visible` TINYINT(4) NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `NM_UT_UNIQUE` (`nombre` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
