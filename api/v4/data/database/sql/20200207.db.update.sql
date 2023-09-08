-- MySQL Workbench Synchronization
-- Generated: 2020-02-20 11:34
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Consiss

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- new Cajero 2 rol:  2d242aa5-9dc8-468f-a798-22e75392d63a
-- old Cajero 2 rol:  aff65697-3d4a-4a25-b989-318f20bc5d22

UPDATE `xxbdo_roles_en_tienda` SET `nombre` = 'Cajero 2x', `descripcion` = 'Rol Cajero 2x', `visible` = '0', `activo` = '0' WHERE `xxbdo_roles_en_tienda`.`id` = 'aff65697-3d4a-4a25-b989-318f20bc5d22'; 

INSERT INTO `xxbdo_roles_en_tienda` (`id`, `nombre`, `descripcion`, `orden`, `visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('2d242aa5-9dc8-468f-a798-22e75392d63a', 'Cajero 2', 'Cajero 2', 7, 1, 1, NULL, NULL, NOW(), NOW());

UPDATE `xxbdo_pendientes` SET registrado_por='2d242aa5-9dc8-468f-a798-22e75392d63a' WHERE registrado_por='aff65697-3d4a-4a25-b989-318f20bc5d22';

UPDATE `xxbdo_pendientes` SET responsable='2d242aa5-9dc8-468f-a798-22e75392d63a' WHERE responsable='aff65697-3d4a-4a25-b989-318f20bc5d22'

UPDATE `xxbdo_respuestas_utensilios` SET agregado_por='2d242aa5-9dc8-468f-a798-22e75392d63a' WHERE agregado_por='aff65697-3d4a-4a25-b989-318f20bc5d22'

DELETE FROM `xxbdo_roles_en_tienda` WHERE `xxbdo_roles_en_tienda`.`id` = 'aff65697-3d4a-4a25-b989-318f20bc5d22';


ALTER TABLE `xxbdo_areas_estandares_indicadores` 
CHANGE COLUMN `orden` `orden` BIGINT(20) NULL DEFAULT NULL ;

ALTER TABLE `xxbdo_utensilios` 
DROP INDEX `XXBDO_UTENSILIOS_CATEGORIAS_ID_IDX` ,
ADD INDEX `XXBDO_UTENSILIOS_CATEGORIAS_ID_INDX` (`xxbdo_utensilios_categorias_id` ASC),
DROP INDEX `XXBDO_UTNSLS_PLAZA_TIENDA_IDX` ,
ADD INDEX `XXBDO_UTNSLS_PLAZA_TIENDA_INDX` (`cr_plaza` ASC, `cr_tienda` ASC),
DROP INDEX `XXBDO_UTNSLS_TIPO_IDX` ;
;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;