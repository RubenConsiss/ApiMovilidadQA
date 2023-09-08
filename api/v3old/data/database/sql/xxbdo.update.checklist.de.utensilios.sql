-- MySQL Workbench Synchronization
-- Generated: 2019-10-15 16:54
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Consiss

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


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

--
-- Volcado de datos para la tabla `xxbdo_utensilios_categorias`
--
INSERT INTO `xxbdo_utensilios_categorias` (`id`, `nombre`, `descripcion`, `orden`, `visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('0b713f50-055a-4b10-ae40-8239c8426253', 'LIMPIEZA', 'Utensilios de Limpieza', 3, 1, 1, NULL, NULL, '2019-08-14 14:00:00', '2019-08-14 14:00:00'),
('55451e2c-b9c1-418c-a444-3392b422aaf7', 'COMIDA RÁPIDA', 'Utensilios de comida rápida', 1, 1, 1, NULL, NULL, '2019-08-14 13:00:00', '2019-08-14 13:00:00'),
('7cd81a27-7486-4392-bf1f-8468c13d6ec2', 'HABILITADORES', 'Utensilios habilitadores', 2, 1, 1, NULL, NULL, '2019-08-14 13:00:00', '2019-08-14 13:00:00'),
('ac29e1a0-e0a8-4495-b6eb-806a77a36f30', 'PAPELERIA', 'Utensilios de Papelería', 4, 1, 1, NULL, NULL, '2019-08-14 14:00:00', '2019-08-14 14:00:00'),
('b0860623-1b5b-42fc-9ad9-2445d200fd10', 'VARIOS', 'Utensilios no catalogados', 5, 1, 1, NULL, NULL, '2019-08-14 14:00:00', '2019-08-14 14:00:00');


CREATE TABLE IF NOT EXISTS `xxbdo_utensilios` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_utensilios_categorias_id` VARCHAR(36) NOT NULL,
  `cr_plaza` VARCHAR(10) NULL DEFAULT NULL,
  `cr_tienda` VARCHAR(10) NULL DEFAULT NULL,
  `tipo` CHAR(1) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `uso` TEXT NULL DEFAULT NULL,
  `orden` INT(11) NULL DEFAULT NULL,
  `seleccionable` TINYINT(4) NULL DEFAULT 1,
  `foto` TEXT NULL DEFAULT NULL,
  `codigo` VARCHAR(40) NULL DEFAULT NULL,
  `via_de_solicitud` TEXT NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_UTENSILIOS_CATEGORIAS_ID_IDX` (`xxbdo_utensilios_categorias_id` ASC),
  INDEX `XXBDO_UTNSLS_PLAZA_TIENDA_IDX` (`cr_plaza` ASC, `cr_tienda` ASC),
  INDEX `XXBDO_UTNSLS_TIPO_IDX` (`tipo` ASC) VISIBLE,
  INDEX `XXBDO_UTNSLS_TIPO_INDX` (`tipo` ASC) VISIBLE,
  CONSTRAINT `XXBDO_UTENSILIOS_CATEGORIAS_ID_FK`
    FOREIGN KEY (`xxbdo_utensilios_categorias_id`)
    REFERENCES `xxbdo_utensilios_categorias` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- falta completar el catalogo
--
-- Volcado de datos para la tabla `xxbdo_utensilios`
--
INSERT INTO `xxbdo_utensilios` (`id`, `xxbdo_utensilios_categorias_id`, `cr_plaza`, `cr_tienda`, `tipo`, `nombre`, `descripcion`, `uso`, `orden`, `seleccionable`, `foto`, `codigo`, `via_de_solicitud`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('009f1b13-2e06-4f12-9eb4-69bddc72be8f', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Tapete check out', 'Tapete check out', 'Utilizado por el cajero durante su estancia en caja', 1, 1, '4b45b704-ba2f-401f-b8b7-d00993bcb2e2.PNG', '18634', 'ATL > Recursos humanos > Solicitud de tapete de check out', 1, NULL, NULL, '2019-10-08 14:00:00', '2019-10-08 16:00:00'),
('42e37349-5492-4b9e-819a-067a8515e55a', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Bote de basura para mueble de Comida Rápida', 'Bote de basura para mueble de Comida Rápida', 'Colocar basura de comida rápida', 1, 1, '46f361d4-21ec-4b2b-b452-ba40f076d9d8.PNG', '2251-2252', 'ATL > Mercadeo > Equipamiento > Utensilios de comida rápida > Solicitud de utensilio de comida rápida con Stock en plaza > Bote de basura para mueble de comida rápida', 1, NULL, NULL, '2019-10-08 12:00:00', '2019-10-08 12:00:00'),
('6a7d5eca-f41c-4008-89c9-c1dd52cfb29a', '0b713f50-055a-4b10-ae40-8239c8426253', NULL, NULL, 'U', 'Botella con atomizador', 'Botella con atomizador', 'Dispensar productos de limpieza como jabón o quitachicles', 1, 1, '19d01533-af80-42ca-bed1-568c568aa869.PNG', 'NA', 'Realizar merma para que se envíe vía CEDIS', 1, NULL, NULL, '2019-10-08 16:00:00', '2019-10-08 17:00:00'),
('a18e4771-1386-4902-80e0-cc060e5dca5d', '7cd81a27-7486-4392-bf1f-8468c13d6ec2', NULL, NULL, 'U', 'Cajonera para alimento del personal de tienda', 'Cajonera para alimento del personal de tienda', 'Utilizado para guardar los alimentos del personal de tienda', 2, 1, '63b0cbd7-7627-44f3-afda-423aca838f30.PNG', '22648', 'ATL > Recursos Humanos > Solicitud de reposición de cajonera de alimentos', 1, NULL, NULL, '2019-10-08 14:00:00', '2019-10-08 16:00:00'),
('ccca3bb5-0106-4b41-acb6-7a202a73dc31', 'b0860623-1b5b-42fc-9ad9-2445d200fd10', '10MDA', '50JAI', 'V', 'Xbox', 'Xbox', 'Renta de Xbox por hora', 1, 1, '', 'NA', 'NA', 1, NULL, NULL, '2019-10-08 14:00:00', '2019-10-08 16:00:00'),
('d1695a82-6494-40f1-a577-2ec4522c39fd', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Cepillo para limpieza de termo', 'Cepillo para limpieza de termo', 'Limpieza de termo', 3, 1, '029b7d69-5781-48be-bfed-3d886e4ca7fc.PNG', '5430', 'ATL > Mercadeo > Equipamiento > Utensilios de comida rápida > Solicitud de utensilio de comida rápida con Stock en plaza > Cepillo para limpieza de jarra y termo', 1, NULL, NULL, '2019-10-08 13:00:00', '2019-10-08 15:00:00'),
('e90dcdbd-c7ec-4f58-a6b3-757253a7af79', '55451e2c-b9c1-418c-a444-3392b422aaf7', NULL, NULL, 'U', 'Caja para café con 3 cajones', 'Caja para café con 3 cajones', 'Resguardar bolsas de café en uso', 2, 1, 'becfbd76-ed4a-4793-9fbf-8b5fc7df4cd5.PNG', '5428', 'ATL > Mercadeo > Equipamiento > Utensilios de comida rápida > Solicitud de utensilio de comida rápida sin Stock en plaza > caja para café con 3 cajones', 1, NULL, NULL, '2019-10-08 12:00:00', '2019-10-08 14:00:00');


CREATE TABLE IF NOT EXISTS `xxbdo_respuestas_utensilios` (
  `id` VARCHAR(36) NOT NULL,
  `cr_plaza` VARCHAR(10) NOT NULL,
  `cr_tienda` VARCHAR(10) NOT NULL,
  `fecha_respuesta` DATE NOT NULL,
  `xxbdo_utensilios_id` VARCHAR(36) NOT NULL,
  `mes` INT(11) NULL DEFAULT NULL,
  `año` INT(11) NULL DEFAULT NULL,
  `respuesta` VARCHAR(2) NULL DEFAULT NULL,
  `folio` VARCHAR(50) NULL DEFAULT NULL,
  `agregado_por` VARCHAR(36) NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_RESPTS_UTNSLS_UTNSLS_ID_INDX` (`xxbdo_utensilios_id` ASC),
  INDEX `XXBDO_RESPTS_UTNSLS_RLS_TNDA_INDX` (`agregado_por` ASC),
  CONSTRAINT `XXBDO_RESPTS_UTNSLS_UTNSLS_ID_FK`
    FOREIGN KEY (`xxbdo_utensilios_id`)
    REFERENCES `xxbdo_utensilios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_xxbdo_respuestas_utensilios_xxbdo_roles_en_tienda1`
    FOREIGN KEY (`agregado_por`)
    REFERENCES `xxbdo_roles_en_tienda` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
