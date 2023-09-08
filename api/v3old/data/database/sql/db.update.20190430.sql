
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `xxmet_logs` ADD `app_version` VARCHAR(100) NULL AFTER `app`;

ALTER TABLE `xxmet_logs` CHANGE `app` `app_name` VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;


ALTER TABLE `xxbdo`.`xxbdo_observaciones` 
CHANGE COLUMN `turno_mañana` `turno_mañana` TINYINT(4) NULL DEFAULT NULL ,
ADD INDEX `XXBDO_OBSERVACIONES_RESPUESTAS_IDX` (`xxbdo_respuestas_id` ASC),
DROP INDEX `xxbdo_respuestas_id` ;
;

ALTER TABLE `xxbdo`.`xxbdo_version_estandares` 
CHANGE COLUMN `fecha_inicio` `fecha_inicio` DATE NOT NULL ;

CREATE TABLE IF NOT EXISTS `xxbdo`.`xxbdo_circulo_de_congruencia` (
  `id` INT(11) NOT NULL,
  `xxbdo_respuestas_id` VARCHAR(36) NULL DEFAULT NULL,
  `fecha` DATE NULL DEFAULT NULL,
  `comentario` TEXT NULL DEFAULT NULL,
  `foto` TEXT NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_xxbdo_circulo_de_congruencia_xxbdo_respuestas1_idx` (`xxbdo_respuestas_id` ASC),
  CONSTRAINT `fk_xxbdo_circulo_de_congruencia_xxbdo_respuestas1`
    FOREIGN KEY (`xxbdo_respuestas_id`)
    REFERENCES `xxbdo`.`xxbdo_respuestas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
