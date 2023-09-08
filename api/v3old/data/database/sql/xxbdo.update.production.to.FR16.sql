-- MySQL Workbench Synchronization
-- Generated: 2019-10-15 15:37
-- Last update: 2019-10-21 11:11
-- Model: BDO
-- Version: 3.0
-- Project: Movilidad en Tienda
-- Author: Adrián Zenteno <azlara@gmail.com>

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- USE `xxbdo_production_201910301530`;

-- ALTER TABLE `xxbdo_login_attempts` DROP INDEX `XXBDO_LOGIN_PLAZA_TIENDA_FECHA_INDX` ;

-- ALTER TABLE `xxbdo_login_attempts` ADD `app_version` VARCHAR(100) NULL AFTER `dispositivo`;

ALTER TABLE `xxbdo_checklists_tiendas` 
ADD COLUMN `xxbdo_version_estandares_id` VARCHAR(36) NULL DEFAULT NULL AFTER `cr_tienda`,
ADD COLUMN `titulo` VARCHAR(100) NULL DEFAULT NULL AFTER `xxbdo_version_estandares_id`,
ADD COLUMN `descripcion` TEXT NULL DEFAULT NULL AFTER `titulo`,
ADD COLUMN `titulo_app` VARCHAR(100) NULL DEFAULT NULL AFTER `descripcion`,
ADD COLUMN `titulo_indicadores_app` VARCHAR(100) NULL DEFAULT NULL AFTER `titulo_app`,
ADD COLUMN `fecha_inicio` DATE NULL DEFAULT NULL AFTER `titulo_indicadores_app`,
ADD COLUMN `fecha_fin` DATE NULL DEFAULT NULL AFTER `fecha_inicio`;

-- query to update new fields in xxbdo_checklist_tiendas, change fecha_fin as required:
update `xxbdo_checklists_tiendas` 
SET titulo='Estándares Operativos Versión 23',
descripcion='Estándares Operativos Versión 23',
titulo_app='BITACORA v23',
titulo_indicadores_app='INDICADORES v23',
xxbdo_version_estandares_id='13d772fa-826b-424f-802e-63da4777e33c',
fecha_inicio='2018-11-01', 
fecha_fin='2019-10-31' 
WHERE `xxbdo_checklists_id`='3e50f58c-8634-41ce-93b5-c8bebb8bce46';

-- for testing purposes, DO NOT RUN IN PRODUCTION!!
 update `xxbdo_checklists_tiendas` 
 SET titulo='Estándares Operativos Versión Nexxo',
 descripcion='Estándares Operativos Versión Nexxo',
 titulo_app='BITACORA NEXXO',
 titulo_indicadores_app='IND NEXXO',
 xxbdo_version_estandares_id='a74a4a3f-20e1-44e3-aadd-354647fd8210',
 fecha_inicio='2019-11-01' 
 WHERE `xxbdo_checklists_id`='7131ed27-5733-47e9-ad86-83cac29e9288';

CREATE TABLE IF NOT EXISTS `xxbdo_roles_en_tienda` (
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
  UNIQUE INDEX `XXBDO_ROLES_EN_TIENDA_NOMBRE_UNQ` (`nombre` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

--
-- Volcado de datos para la tabla `xxbdo_roles_en_tienda`
--
INSERT INTO `xxbdo_roles_en_tienda` (`id`, `nombre`, `descripcion`, `orden`, `visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('42af79a1-6646-4a47-a13e-9eff84149ebc', 'Encargado 3', 'Encargado 3', 5, 1, 1, NULL, NULL, NOW(), NOW()),
('5360e586-a3e3-46f7-924f-648d23087d58', 'Piso 3', 'Piso 3', 11, 1, 1, NULL, NULL, NOW(), NOW()),
('63c3c962-b684-48d7-b2b2-6e236eddb4fa', 'Cajero 3', 'Cajero 3', 8, 1, 1, NULL, NULL, NOW(), NOW()),
('64b0937d-77dc-4c68-af63-f5332df91466', 'Asesor', 'Asesor', 1, 1, 1, NULL, NULL, NOW(), NOW()),
('6975ca63-6138-47d0-9456-677bc94b02d7', 'Piso 2', 'Piso 2', 10, 1, 1, NULL, NULL, NOW(), NOW()),
('6b87c16b-eaaf-488b-bdcd-3f3801c8ef4e', 'Cajero 1', 'Cajero 1', 6, 1, 1, NULL, NULL, NOW(), NOW()),
('72624c71-2115-4ea6-b6e7-a69d7dfcd7e0', 'Lider', 'Líder', 2, 1, 1, NULL, NULL, NOW(), NOW()),
('8eb2b5e9-8af6-4ebc-bfa1-81f85e46bce2', 'Piso 1', 'Piso 1', 9, 1, 1, NULL, NULL, NOW(), NOW()),
('940a7f29-8e22-4005-bee3-372fa2e8d79f', 'Encargado 2', 'Encargado 2', 4, 1, 1, NULL, NULL, NOW(), NOW()),
('99aaade2-e42d-4f1d-a5f3-d41f9b0271aa', 'Encargado 1', 'Encargado 1', 3, 1, 1, NULL, NULL, NOW(), NOW()),
('aff65697-3d4a-4a25-b989-318f20bc5d22', 'Cajero 2', 'Cajero 2', 7, 1, 1, NULL, NULL, NOW(), NOW());


CREATE TABLE IF NOT EXISTS `xxbdo_configuracion` (
  `id` VARCHAR(36) NOT NULL,
  `modulo` VARCHAR(100) NOT NULL,
  `parametro` VARCHAR(100) NOT NULL,
  `valor` TEXT NULL DEFAULT NULL,
  `orden` INT(11) NULL DEFAULT NULL,
  `es_visible` TINYINT(4) NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_CONFIG_MOD_PARAM_INDX` (`modulo` ASC, `parametro` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

--
-- Volcado de datos para la tabla `xxbdo_configuracion`
--
INSERT INTO `xxbdo_configuracion` (`id`, `modulo`, `parametro`, `valor`, `orden`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('558f0f16-fcad-404e-9526-007d252e8cbc', 'utensilios', 'num_maximo_utensilios_nuevos_permitidos_por_mes', '3', 3, 1, 1, NULL, NULL, NOW(), NOW()),
('88480b66-a38e-4905-a4c4-16e1c9c8bd85', 'utensilios', 'numero_meses_vista_inicial_checklist_utensilios', '6', 1, 1, 1, NULL, NULL, NOW(), NOW()),
('88f85919-4037-4e2b-94ea-27f3f30dc697', 'pendientes', 'numero_dias_visibles_hacia_atras_fecha_seleccionada', '7', 1, 1, 1, NULL, NULL, NOW(), NOW()),
('ae5feba3-3dea-40d1-bd46-b9440c19464f', 'utensilios', 'num_maximo_de_folios_por_utensilio', '2', 3, 1, 1, NULL, NULL, NOW(), NOW()),
('e6174c19-30ed-490f-bcde-624a0b40107e', 'utensilios', 'dia_limite_mensual_para_envio_checklist_utensilios', '7', 2, 1, 1, NULL, NULL, NOW(), NOW());


CREATE TABLE `xxbdo_pendientes` (
  `id` varchar(36) NOT NULL,
  `cr_plaza` varchar(10) NOT NULL,
  `cr_tienda` varchar(10) NOT NULL,
  `fecha_compromiso` date NOT NULL,
  `fecha_terminacion` timestamp NULL DEFAULT NULL,
  `registrado_por` varchar(36) NOT NULL,
  `responsable` varchar(36) NOT NULL,
  `descripcion` text,
  `activo` tinyint(4) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indices de la tabla `xxbdo_pendientes`
--
ALTER TABLE `xxbdo_pendientes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_PENDIENTES_REG_POR_INDX` (`registrado_por`),
  ADD KEY `XXBDO_PENDIENTES_RESP_INDX` (`responsable`),
  ADD KEY `XXBDO_PENDIENTES_FILTRO_INDX` (`cr_plaza`,`cr_tienda`,`fecha_compromiso`,`fecha_terminacion`);

--
-- Filtros para la tabla `xxbdo_pendientes`
--
ALTER TABLE `xxbdo_pendientes`
  ADD CONSTRAINT `XXBDO_PENDIENTES_REG_POR_FK` FOREIGN KEY (`registrado_por`) REFERENCES `xxbdo_roles_en_tienda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `XXBDO_PENDIENTES_RESP_FK` FOREIGN KEY (`responsable`) REFERENCES `xxbdo_roles_en_tienda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;