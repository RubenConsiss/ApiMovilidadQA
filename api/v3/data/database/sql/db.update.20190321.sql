
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `xxbdo`.`xxbdo_estandares` 
CHANGE COLUMN `cr_plaza` `cr_plaza` VARCHAR(10) NULL DEFAULT NULL ,
CHANGE COLUMN `cr_tienda` `cr_tienda` VARCHAR(10) NULL DEFAULT NULL ;

ALTER TABLE `xxbdo`.`xxbdo_respuestas` 
CHANGE COLUMN `cr_plaza` `cr_plaza` VARCHAR(10) NOT NULL ,
CHANGE COLUMN `cr_tienda` `cr_tienda` VARCHAR(10) NOT NULL ;

ALTER TABLE `xxbdo`.`xxbdo_tiendas` 
CHANGE COLUMN `cr_plaza` `cr_plaza` VARCHAR(10) NOT NULL ,
CHANGE COLUMN `cr_tienda` `cr_tienda` VARCHAR(10) NOT NULL ;

CREATE TABLE IF NOT EXISTS `xxbdo`.`xxbdo_indicadores` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_version_estandares_id` VARCHAR(36) NOT NULL,
  `tipo` CHAR(1) NULL DEFAULT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `xxbdo_frecuencia_indicadores_id` VARCHAR(36) NOT NULL,
  `orden` SMALLINT(6) NULL DEFAULT NULL,
  `tipo_dato` VARCHAR(10) NULL DEFAULT NULL,
  `default` TEXT NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_INDICADORES_VER_STDS_ID_IDX` (`xxbdo_version_estandares_id` ASC),
  INDEX `XXBDO_INDICADORES_FRECUENCIA_INDICADORES_ID_IDX` (`xxbdo_frecuencia_indicadores_id` ASC),
  CONSTRAINT `XXBDO_INDICADORES_VER_STDS_ID_FK`
    FOREIGN KEY (`xxbdo_version_estandares_id`)
    REFERENCES `xxbdo`.`xxbdo_version_estandares` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_INDICADORES_FRECUENCIA_INDICADORES_ID_FK`
    FOREIGN KEY (`xxbdo_frecuencia_indicadores_id`)
    REFERENCES `xxbdo`.`xxbdo_frecuencia_indicadores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo`.`xxbdo_respuestas_indicadores` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_checklists_id` VARCHAR(36) NOT NULL,
  `cr_plaza` VARCHAR(10) NOT NULL,
  `cr_tienda` VARCHAR(10) NOT NULL,
  `fecha_respuesta` DATE NULL DEFAULT NULL,
  `xxbdo_areas_estandares_indicadores_id` VARCHAR(36) NOT NULL,
  `xxbdo_frecuencia_indicadores_id` VARCHAR(36) NOT NULL,
  `tipo` CHAR(1) NULL DEFAULT NULL,
  `meta` TEXT NULL DEFAULT NULL,
  `respuesta` TEXT NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_EVAL_IND_CHECKLISTS_ID_IDX` (`xxbdo_checklists_id` ASC),
  INDEX `XXBDO_RESPUESTAS_INDICADORES_AREAS_STDS_ID_IDX` (`xxbdo_areas_estandares_indicadores_id` ASC),
  INDEX `XXBDO_RESPUESTAS_INDICADORES_TIPO_IND_ID_IDX` (`xxbdo_frecuencia_indicadores_id` ASC),
  CONSTRAINT `XXBDO_EVAL_IND_CHECKLISTS_ID_FK`
    FOREIGN KEY (`xxbdo_checklists_id`)
    REFERENCES `xxbdo`.`xxbdo_checklists` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_RESPUESTAS_INDICADORES_AREAS_STDS_ID_FK`
    FOREIGN KEY (`xxbdo_areas_estandares_indicadores_id`)
    REFERENCES `xxbdo`.`xxbdo_areas_estandares_indicadores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_RESPUESTAS_INDICADORES_TIPO_IND_ID_FK`
    FOREIGN KEY (`xxbdo_frecuencia_indicadores_id`)
    REFERENCES `xxbdo`.`xxbdo_frecuencia_indicadores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo`.`xxbdo_areas_estandares_indicadores` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_areas_estandares_id` VARCHAR(36) NOT NULL,
  `xxbdo_indicadores_id` VARCHAR(36) NOT NULL,
  `orden` SMALLINT(6) NULL DEFAULT NULL,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_AREAS_STDS_IND_INDICADORES_ID_IDX` (`xxbdo_indicadores_id` ASC),
  INDEX `XXBDO_AREAS_STDS_IND_AREA_STDS_ID_IDX` (`xxbdo_areas_estandares_id` ASC),
  CONSTRAINT `XXBDO_AREAS_STDS_IND_INDICADORES_ID_FK`
    FOREIGN KEY (`xxbdo_indicadores_id`)
    REFERENCES `xxbdo`.`xxbdo_indicadores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_AREAS_STDS_IND_AREAS_STDS_ID_FK`
    FOREIGN KEY (`xxbdo_areas_estandares_id`)
    REFERENCES `xxbdo`.`xxbdo_areas_estandares` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo`.`xxbdo_frecuencia_indicadores` (
  `id` VARCHAR(36) NOT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `descripcion` TEXT NULL DEFAULT NULL,
  `fecha_inicio` DATE NULL DEFAULT NULL,
  `hora_inicio` TIME NULL DEFAULT NULL,
  `frecuencia_en_dias` INT(11) NULL DEFAULT 0,
  `orden` SMALLINT(6) NULL DEFAULT 0,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo`.`xxbdo_checklists_has_areas_estandares_indicadores` (
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
    REFERENCES `xxbdo`.`xxbdo_checklists` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_CHECKLISTS_HAS_AREAS_STDS_IND_ID_FK`
    FOREIGN KEY (`xxbdo_areas_estandares_indicadores_id`)
    REFERENCES `xxbdo`.`xxbdo_areas_estandares_indicadores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `xxbdo`.`xxbdo_tiendas_has_areas_estandares_indicadores` (
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
    REFERENCES `xxbdo`.`xxbdo_checklists` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_TIENDAS_HAS_AREAS_STDS_IND_ID_FK`
    FOREIGN KEY (`xxbdo_areas_estandares_indicadores_id`)
    REFERENCES `xxbdo`.`xxbdo_areas_estandares_indicadores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- queries para actualizar staging FR-10 a FR-11 Indicadores:
DELETE FROM `xxbdo_checklists_tiendas` 
WHERE `cr_tienda` IN 
(SELECT `cr_tienda` FROM `xxbdo_tiendas` where cr_tienda not in(SELECT `cr_tienda` FROM `xxbdo_respuestas` WHERE 1));

DELETE FROM `xxbdo_tiendas_has_areas_estandares` 
WHERE `cr_tienda` IN 
(SELECT `cr_tienda` FROM `xxbdo_tiendas` where cr_tienda not in(SELECT `cr_tienda` FROM `xxbdo_respuestas` WHERE 1));

DELETE FROM `xxbdo_tiendas` 
where cr_tienda not in(SELECT `cr_tienda` FROM `xxbdo_respuestas` WHERE 1);

--
-- Volcado de datos para la tabla `xxbdo_indicadores_frecuencias`
--
INSERT INTO `xxbdo_indicadores_frecuencias` (`id`, `titulo`, `descripcion`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('M', 'Mensual', 'Indicadores de Frecuencia de llenado Mensual', NULL, 1, NULL, NULL, '2019-03-06 06:00:00', '2019-03-06 06:00:00'),
('S', 'Semanal', 'Indicadores de Frecuencia Semanal', NULL, 1, NULL, NULL, '2019-03-06 06:00:00', '2019-03-06 06:00:00');

--
-- Volcado de datos para la tabla `xxbdo_indicadores`
--
INSERT INTO `xxbdo_indicadores` (`id`, `xxbdo_version_estandares_id`, `tipo`, `cr_plaza`, `cr_tienda`, `titulo`, `descripcion`, `xxbdo_indicadores_frecuencias_id`, `orden`, `tipo_dato`, `default`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('202b995f-f4fe-4805-8a61-1ec28fcc7c73', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Ev. 5S + 1', 'Ev. 5S + 1', 'S', NULL, 'int', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('222968a6-d9ea-46de-aa5c-c9412167972d', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Ev. Operativa Sección Limpieza', 'Ev. Operativa Sección Limpieza (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('222eb7fa-71f4-44be-9057-edf33fd98cc7', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Ev. Operativa Puntos Cuarto Frío', 'Ev. Operativa Puntos Cuarto Frío (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('2c09cdc0-4e93-4f28-9d78-0158c8a566c6', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Rotación', 'Rotación', 'M', NULL, 'int', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('2cd8037e-e777-4db4-8fa5-9ce702b5343f', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Exhibición Real Roller', 'Exhibición Real Roller (Indicador de tipo Porcentaje)', 'S', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('469f5845-1498-4ae8-a0c2-d30e2b806e09', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Ev. Operativa Sección Rapidez', 'Ev. Operativa Sección Rapidez (indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('4fd79d79-9e95-4b1e-85f0-bdd750214c8f', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Scorecard preinventarios/ Entrega de Valores', 'Scorecard preinventarios/ Entrega de Valores (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('59a7c719-36af-415f-a176-558bbf2f3794', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Venta sugerida', 'Venta sugerida (Indicador de tipo monetario)', 'S', NULL, 'money', '0.00', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('5c5bd2dc-c4fe-42cd-affa-52d693389d5b', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Veracidad de Inventarios', 'Veracidad de Inventarios', 'S', NULL, 'int', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('5de6ee9f-7186-4ee2-978c-b71727e3e0d8', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Planogramas (Charola/Mueble)', 'Planogramas (Charola/Mueble) (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('5e9e6b32-8d7a-43ad-8145-2ba627f2b67d', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Conteos', 'Conteos', 'S', NULL, 'int', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('5f128883-45d3-42b0-bfc5-07790eac9215', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Exhibición Real Americano', 'Exhibición Real Americano (Indicador de tipo porcentaje)', 'S', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('6568ab1b-2ff9-40ad-8b09-5663ddddcf5a', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'MEP POP', 'MEP POP (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('65ba78bd-2292-4161-8f65-81dfc132dc28', '13d772fa-826b-424f-802e-63da4777e33c', 'L', '10MON', '50AMV', 'Ticket de Venta Promedio', 'Ticket de Venta Promedio en Tienda (Indicador de tipo monetario)', 'S', NULL, 'money', '0.00', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('7af2d792-0453-4cca-ba4c-243edcc06526', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Usuarios activos', 'Usuarios activos', 'S', NULL, 'int', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('a2738a70-7352-4b7b-a63f-663fdb2ee89e', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Ev. Donas a Granel', 'Ev. Donas a Granel (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('ad340633-9e7d-412f-a0b8-7b4f905a69ec', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Protocolo de Servicio', 'Protocolo de Servicio', 'M', NULL, 'int', '0', 0, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('ad3846a4-15b3-47a0-a775-2e1a5ce2e20f', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Resultado de Inventario', 'Resultado de Inventario (Indicador de tipo monetario)', 'M', NULL, 'money', '0.00', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('ae77c68b-3e63-4f96-9426-aec3f553b845', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'MEP P.P.', 'MEP P.P. (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('b1e27dfd-e37a-455e-b668-ccda29db8e9f', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Ev. Operativa Sección Abasto', 'Ev. Operativa Sección Abasto (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('b49f07bc-93e7-4eab-b3f6-ae65bb60d91c', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Cobertura', 'Cobertura (Indicador de tipo porcentaje)', 'S', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('bbfe5636-4304-4b9d-810a-178fad1130e6', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Ev. Operativa Sección Atención', 'Ev. Operativa Sección Atención', 'M', NULL, 'int', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('c16be293-3f3a-4b98-81b1-4d5334cff7f6', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Equipos Capacitados', 'Equipos Capacitados (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('db3ba55e-145b-4429-8050-42c195d15ab7', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Vector Gente', 'Vector Gente', 'S', NULL, 'int', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('ddd7944c-088a-49df-a7ea-f128fea386c8', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Scorecard Calidad de Producto', 'Scorecard Calidad de Producto (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('e0f79432-a0e5-47c9-9692-9cd59a039d0c', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Scorecard Etiqueteo', 'Scorecard Etiqueteo (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('ee838814-41d5-43a0-a289-48357aa68fb8', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, '% Cumplimiento a devoluciones diarias', 'Porcentaje de cumplimiento a devoluciones diarias (Indicador de tipo Porcentaje)', 'S', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00'),
('fc5bb88c-0753-4b89-b2ba-25a69a81c62f', '13d772fa-826b-424f-802e-63da4777e33c', 'I', NULL, NULL, 'Equipos Completos', 'Equipos Completos (Indicador de tipo Porcentaje)', 'M', NULL, 'pct', '0', 1, NULL, NULL, '2018-10-25 05:00:00', '2018-10-25 05:00:00');

--
-- Volcado de datos para la tabla `xxbdo_areas_estandares_indicadores`
--
INSERT INTO `xxbdo_areas_estandares_indicadores` (`id`, `xxbdo_areas_estandares_id`, `xxbdo_indicadores_id`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('03433451-9c6f-45b4-b5b4-abe261d783dc', '8a4b9e51-197d-4725-b42e-aeca39598b2a', '6568ab1b-2ff9-40ad-8b09-5663ddddcf5a', 24, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('10645f92-5cb0-4c2e-9bf7-616de4ac5afe', '8c5843a4-4ee9-4a9c-a497-e880a0029a95', '65ba78bd-2292-4161-8f65-81dfc132dc28', 3, 1, NULL, NULL, '2019-03-25 17:00:56', '2019-03-25 17:00:56'),
('1e88d131-dec3-4014-b61e-b08ae66f35ad', 'fe70e125-ab5d-400d-8bc9-00acf4727a66', 'b1e27dfd-e37a-455e-b668-ccda29db8e9f', 16, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('22ce4f3a-808c-46a9-ad57-dcec4b172e22', '3f36624d-56d0-487e-bad7-fdabf644f027', '5c5bd2dc-c4fe-42cd-affa-52d693389d5b', 20, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('24c8cfb5-c62c-4eb2-9323-90c5740dca57', 'c580fa9e-b53f-4cdd-820c-f98e85dedbe2', '4fd79d79-9e95-4b1e-85f0-bdd750214c8f', 7, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('25e1acfd-a819-49ef-89d9-877c927c0ee7', 'f33edcf7-8d8d-4049-a26f-1770bd0b197d', '202b995f-f4fe-4805-8a61-1ec28fcc7c73', 27, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('28fe2251-7417-4d36-b8b1-cc7b1e49277a', 'c580fa9e-b53f-4cdd-820c-f98e85dedbe2', '5e9e6b32-8d7a-43ad-8145-2ba627f2b67d', 4, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('38792cd8-6404-4850-95e3-c57f430f7182', 'fe70e125-ab5d-400d-8bc9-00acf4727a66', 'ddd7944c-088a-49df-a7ea-f128fea386c8', 15, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('3a1f97fe-8efe-4b53-808d-d737e296dd81', '9825f468-d2cc-4805-ab47-804cea7e659e', 'ae77c68b-3e63-4f96-9426-aec3f553b845', 14, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('4d18ecd9-5ffb-46a2-b56e-b0cfaef18c37', '8fe04362-c309-4549-8d50-9b25a8e364c7', 'e0f79432-a0e5-47c9-9692-9cd59a039d0c', 17, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('686fcba0-f0c2-49d4-9c94-56871ddd2bee', '5a6f7661-afb3-497a-8e39-10d176cc42bb', 'bbfe5636-4304-4b9d-810a-178fad1130e6', 1, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('6c4e8f4b-237e-45a9-bfa0-4b6d291eca75', '8c5843a4-4ee9-4a9c-a497-e880a0029a95', 'ad340633-9e7d-412f-a0b8-7b4f905a69ec', 2, 0, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('8059b8d9-c9b8-4cd1-b953-2c360af5827a', '6e1b34ef-2eee-41f4-a1d0-79227af1de5d', '7af2d792-0453-4cca-ba4c-243edcc06526', 26, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('85501381-f779-45b4-acaa-91d97693d7a6', 'bc37070e-525d-4900-8732-c5b90c60f5b3', '222eb7fa-71f4-44be-9057-edf33fd98cc7', 23, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('8de6905e-8cc5-4d9d-b13b-7b8a1137c8ee', 'acc00d84-4e1d-4ad9-be75-a84ac091ccc6', 'db3ba55e-145b-4429-8050-42c195d15ab7', 10, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('93f43e13-b366-4006-bf96-d08f72296ba0', '3079d111-f116-4845-8eb5-85b759b92e4f', 'c16be293-3f3a-4b98-81b1-4d5334cff7f6', 9, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('9dbdd38b-bff6-459f-87a4-b3d6c3eeaee1', 'c580fa9e-b53f-4cdd-820c-f98e85dedbe2', 'ad3846a4-15b3-47a0-a775-2e1a5ce2e20f', 6, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('9e17146e-1152-4f56-92b9-eb0190d20f6c', '87af5596-f2e0-409b-b757-bcaa2f7d0a0d', '222968a6-d9ea-46de-aa5c-c9412167972d', 12, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('a616a9f9-3aae-42b4-8299-c76e497ce45d', '3079d111-f116-4845-8eb5-85b759b92e4f', 'fc5bb88c-0753-4b89-b2ba-25a69a81c62f', 8, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('b2e3724a-b7c3-4c0e-bd3b-dcf8ed0c18ec', '3f36624d-56d0-487e-bad7-fdabf644f027', 'a2738a70-7352-4b7b-a63f-663fdb2ee89e', 22, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('b8e6349e-b29d-4a0d-8daa-80c4c8b3a216', '9825f468-d2cc-4805-ab47-804cea7e659e', '5de6ee9f-7186-4ee2-978c-b71727e3e0d8', 13, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('c00c8799-2e22-4b3e-92a1-98d264bcbde8', 'acc00d84-4e1d-4ad9-be75-a84ac091ccc6', '2c09cdc0-4e93-4f28-9d78-0158c8a566c6', 11, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('d98faa09-ddab-4d64-ae0e-e77297c09cec', '6e1b34ef-2eee-41f4-a1d0-79227af1de5d', '59a7c719-36af-415f-a176-558bbf2f3794', 25, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('ea10c7b1-4d37-4bf7-97d2-f50223f87cfc', 'c580fa9e-b53f-4cdd-820c-f98e85dedbe2', 'b49f07bc-93e7-4eab-b3f6-ae65bb60d91c', 5, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('edaf6de7-181b-4433-be39-57bfe196dcfe', '8c5843a4-4ee9-4a9c-a497-e880a0029a95', '469f5845-1498-4ae8-a0c2-d30e2b806e09', 3, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('f0d7813d-734d-4256-8ad3-eb22044132d6', '3f36624d-56d0-487e-bad7-fdabf644f027', 'ee838814-41d5-43a0-a289-48357aa68fb8', 21, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('f24e27ae-13ec-496c-9c57-68afe65e4cc4', '3f36624d-56d0-487e-bad7-fdabf644f027', '2cd8037e-e777-4db4-8fa5-9ce702b5343f', 19, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54'),
('f51628d3-d0a1-4440-996f-f4c6450195c0', '3f36624d-56d0-487e-bad7-fdabf644f027', '5f128883-45d3-42b0-bfc5-07790eac9215', 18, 1, NULL, NULL, '2019-01-04 23:13:54', '2019-01-04 23:13:54');

--
-- Volcado de datos para la tabla `xxbdo_tiendas_has_areas_estandares_indicadores`
--
INSERT INTO `xxbdo_tiendas_has_areas_estandares_indicadores` (`cr_plaza`, `cr_tienda`, `xxbdo_checklists_id`, `xxbdo_areas_estandares_indicadores_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '03433451-9c6f-45b4-b5b4-abe261d783dc', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '1e88d131-dec3-4014-b61e-b08ae66f35ad', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '22ce4f3a-808c-46a9-ad57-dcec4b172e22', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '24c8cfb5-c62c-4eb2-9323-90c5740dca57', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '25e1acfd-a819-49ef-89d9-877c927c0ee7', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '28fe2251-7417-4d36-b8b1-cc7b1e49277a', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '38792cd8-6404-4850-95e3-c57f430f7182', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '3a1f97fe-8efe-4b53-808d-d737e296dd81', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '4d18ecd9-5ffb-46a2-b56e-b0cfaef18c37', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '686fcba0-f0c2-49d4-9c94-56871ddd2bee', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '6c4e8f4b-237e-45a9-bfa0-4b6d291eca75', 1, 0, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8059b8d9-c9b8-4cd1-b953-2c360af5827a', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '85501381-f779-45b4-acaa-91d97693d7a6', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8de6905e-8cc5-4d9d-b13b-7b8a1137c8ee', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '93f43e13-b366-4006-bf96-d08f72296ba0', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '9dbdd38b-bff6-459f-87a4-b3d6c3eeaee1', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', '9e17146e-1152-4f56-92b9-eb0190d20f6c', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'a616a9f9-3aae-42b4-8299-c76e497ce45d', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'b2e3724a-b7c3-4c0e-bd3b-dcf8ed0c18ec', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'b8e6349e-b29d-4a0d-8daa-80c4c8b3a216', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'c00c8799-2e22-4b3e-92a1-98d264bcbde8', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'd98faa09-ddab-4d64-ae0e-e77297c09cec', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'ea10c7b1-4d37-4bf7-97d2-f50223f87cfc', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'edaf6de7-181b-4433-be39-57bfe196dcfe', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f0d7813d-734d-4256-8ad3-eb22044132d6', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f24e27ae-13ec-496c-9c57-68afe65e4cc4', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('10MON', '50AMV', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f51628d3-d0a1-4440-996f-f4c6450195c0', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53');

--
-- Volcado de datos para la tabla `xxbdo_checklists_has_areas_estandares_indicadores`
--
INSERT INTO `xxbdo_checklists_has_areas_estandares_indicadores` (`xxbdo_checklists_id`, `xxbdo_areas_estandares_indicadores_id`, `es_visible`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '03433451-9c6f-45b4-b5b4-abe261d783dc', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '1e88d131-dec3-4014-b61e-b08ae66f35ad', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '22ce4f3a-808c-46a9-ad57-dcec4b172e22', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '24c8cfb5-c62c-4eb2-9323-90c5740dca57', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '25e1acfd-a819-49ef-89d9-877c927c0ee7', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '28fe2251-7417-4d36-b8b1-cc7b1e49277a', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '38792cd8-6404-4850-95e3-c57f430f7182', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '3a1f97fe-8efe-4b53-808d-d737e296dd81', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '4d18ecd9-5ffb-46a2-b56e-b0cfaef18c37', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '686fcba0-f0c2-49d4-9c94-56871ddd2bee', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '6c4e8f4b-237e-45a9-bfa0-4b6d291eca75', 1, 0, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8059b8d9-c9b8-4cd1-b953-2c360af5827a', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '85501381-f779-45b4-acaa-91d97693d7a6', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '8de6905e-8cc5-4d9d-b13b-7b8a1137c8ee', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '93f43e13-b366-4006-bf96-d08f72296ba0', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '9dbdd38b-bff6-459f-87a4-b3d6c3eeaee1', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', '9e17146e-1152-4f56-92b9-eb0190d20f6c', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'a616a9f9-3aae-42b4-8299-c76e497ce45d', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'b2e3724a-b7c3-4c0e-bd3b-dcf8ed0c18ec', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'b8e6349e-b29d-4a0d-8daa-80c4c8b3a216', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'c00c8799-2e22-4b3e-92a1-98d264bcbde8', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'd98faa09-ddab-4d64-ae0e-e77297c09cec', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'ea10c7b1-4d37-4bf7-97d2-f50223f87cfc', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'edaf6de7-181b-4433-be39-57bfe196dcfe', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f0d7813d-734d-4256-8ad3-eb22044132d6', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f24e27ae-13ec-496c-9c57-68afe65e4cc4', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53'),
('3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'f51628d3-d0a1-4440-996f-f4c6450195c0', 1, 1, NULL, NULL, '2019-03-11 23:08:53', '2019-03-11 23:08:53');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
