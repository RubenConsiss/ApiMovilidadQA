
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

USE `xxbdo`;

CREATE TABLE IF NOT EXISTS `xxbdo_colores` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_checklists_id` VARCHAR(36) NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `hexadecimal` VARCHAR(12) NOT NULL,
  `es_activo` TINYINT(4) NULL DEFAULT 1,
  `orden` BIGINT(20) NULL DEFAULT 0,
  `activo` TINYINT(4) NULL DEFAULT NULL,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(100) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_COLORES_CHECKLISTS_ID_INDX` (`xxbdo_checklists_id` ASC),
  CONSTRAINT `XXBDO_COLORES_CHECKLISTS_ID_FK`
    FOREIGN KEY (`xxbdo_checklists_id`)
    REFERENCES `xxbdo_checklists` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


--
-- Volcado de datos para la tabla `xxbdo_colores`
--

INSERT INTO `xxbdo_colores` VALUES('4274355c-2a84-4817-97fb-d4cf72d11f75', 'c98336f8-cf56-4a30-909a-42b592928219', 'Verde', '#008000', 1, 1, 1, NULL, NULL, '2020-09-22 12:56:25', '2020-09-22 12:56:25');
INSERT INTO `xxbdo_colores` VALUES('586a2916-98aa-44cc-8afa-a1d1200d70d7', 'c98336f8-cf56-4a30-909a-42b592928219', 'Rojo', '#FF0000', 1, 4, 1, NULL, NULL, '2020-09-22 12:54:12', '2020-09-22 12:54:12');
INSERT INTO `xxbdo_colores` VALUES('5b7c4ad7-b291-4a7c-8892-6079d64af9aa', 'c98336f8-cf56-4a30-909a-42b592928219', 'Azul', '#0b0095', 1, 2, 1, NULL, NULL, '2020-09-22 12:56:25', '2020-09-22 12:56:25');
INSERT INTO `xxbdo_colores` VALUES('f26993e4-323a-44fe-adcd-bf7a63247cee', 'c98336f8-cf56-4a30-909a-42b592928219', 'Naranja', '#FFA500', 1, 3, 1, NULL, NULL, '2020-09-22 12:54:12', '2020-09-22 12:54:12');


CREATE TABLE IF NOT EXISTS `xxbdo_evop_drivers` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_checklists_id` VARCHAR(36) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `es_activo` TINYINT(4) NULL DEFAULT 1,
  `orden` BIGINT(20) NULL DEFAULT 0,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_EVOP_DRIVERS_CHECKLISTS_ID_INDX` (`xxbdo_checklists_id` ASC),
  CONSTRAINT `XXBDO_EVOP_DRIVERS_CHECKLISTS_ID_FK`
    FOREIGN KEY (`xxbdo_checklists_id`)
    REFERENCES `xxbdo_checklists` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

--
-- Volcado de datos para la tabla `xxbdo_evop_drivers`
--

INSERT INTO `xxbdo_evop_drivers` VALUES('a9a2e23c-5928-40f0-b6bd-e7845fb1a430', 'c98336f8-cf56-4a30-909a-42b592928219', 'Atención', 1, 1, 1, NULL, NULL, '2020-09-22 12:59:29', '2020-09-22 12:59:29');
INSERT INTO `xxbdo_evop_drivers` VALUES('77d11a16-b4ab-45a2-bf9a-8227975c8018', 'c98336f8-cf56-4a30-909a-42b592928219', 'Abasto', 1, 2, 1, NULL, NULL, '2020-09-22 12:59:29', '2020-09-22 12:59:29');
INSERT INTO `xxbdo_evop_drivers` VALUES('9cbc62a7-48cd-44c0-a82e-066b30dde0d3', 'c98336f8-cf56-4a30-909a-42b592928219', 'Rapidez', 1, 3, 1, NULL, NULL, '2020-09-22 13:00:48', '2020-09-22 13:00:48');
INSERT INTO `xxbdo_evop_drivers` VALUES('330c6232-615d-4f50-8168-8229baa6f55d', 'c98336f8-cf56-4a30-909a-42b592928219', 'Limpieza', 1, 4, 1, NULL, NULL, '2020-09-22 13:00:48', '2020-09-22 13:00:48');
INSERT INTO `xxbdo_evop_drivers` VALUES('bd9c3339-f1ca-4947-a856-a66031656a38', 'c98336f8-cf56-4a30-909a-42b592928219', 'Imagen de tienda', 1, 5, 1, NULL, NULL, '2020-09-22 13:01:51', '2020-09-22 13:01:51');


CREATE TABLE IF NOT EXISTS `xxbdo_evop_promedios_totales` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_checklists_id` VARCHAR(36) NOT NULL,
  `minimo` INT(11) NOT NULL DEFAULT 0,
  `maximo` INT(11) NOT NULL DEFAULT 0,
  `xxbdo_colores_id` VARCHAR(36) NOT NULL,
  `es_activo` TINYINT(4) NULL DEFAULT 1,
  `orden` BIGINT(20) NULL DEFAULT 0,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_EVOP_PT_COLORES_ID_INDX` (`xxbdo_colores_id` ASC),
  INDEX `XXBDO_EVOP_PT_CHECKLISTS_ID_INDX` (`xxbdo_checklists_id` ASC),
  CONSTRAINT `XXBDO_EVOP_PT_COLORES_ID_FK`
    FOREIGN KEY (`xxbdo_colores_id`)
    REFERENCES `xxbdo_colores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_EVOP_PT_CHECKLISTS_ID_FK`
    FOREIGN KEY (`xxbdo_checklists_id`)
    REFERENCES `xxbdo_checklists` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

--
-- Volcado de datos para la tabla `xxbdo_evop_promedios_totales`
--

INSERT INTO `xxbdo_evop_promedios_totales` VALUES('0f996ded-a846-4f23-b891-6b7ba0aef5c9', 'c98336f8-cf56-4a30-909a-42b592928219', 85, 90, '5b7c4ad7-b291-4a7c-8892-6079d64af9aa', 1, 2, 1, NULL, NULL, '2020-09-22 13:04:52', '2020-09-22 13:04:52');
INSERT INTO `xxbdo_evop_promedios_totales` VALUES('57dc1fbd-aeb3-4570-ac8b-f1d385341538', 'c98336f8-cf56-4a30-909a-42b592928219', 0, 79, '586a2916-98aa-44cc-8afa-a1d1200d70d7', 1, 4, 1, NULL, NULL, '2020-09-22 13:11:31', '2020-09-22 13:11:31');
INSERT INTO `xxbdo_evop_promedios_totales` VALUES('6699413b-5179-4c44-a716-145a5ec4a6fc', 'c98336f8-cf56-4a30-909a-42b592928219', 91, 100, '4274355c-2a84-4817-97fb-d4cf72d11f75', 1, 1, 1, NULL, NULL, '2020-09-22 13:04:52', '2020-09-22 13:04:52');
INSERT INTO `xxbdo_evop_promedios_totales` VALUES('b74a63d1-042a-447a-b4aa-f269611de3c8', 'c98336f8-cf56-4a30-909a-42b592928219', 80, 84, 'f26993e4-323a-44fe-adcd-bf7a63247cee', 1, 3, 1, NULL, NULL, '2020-09-22 13:11:31', '2020-09-22 13:11:31');


CREATE TABLE IF NOT EXISTS `xxbdo_evop_ponderacion_estandares` (
  `id` VARCHAR(36) NOT NULL,
  `xxbdo_estandares_id` VARCHAR(36) NOT NULL,
  `xxbdo_evop_drivers_id` VARCHAR(36) NOT NULL,
  `ponderacion` INT(11) NOT NULL DEFAULT 0,
  `es_activo` TINYINT(4) NULL DEFAULT 1,
  `orden` BIGINT(20) NULL DEFAULT 0,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_EVOP_PE_DRIVERS_ID_INDX` (`xxbdo_evop_drivers_id` ASC),
  INDEX `XXBDO_EVOP_PE_ESTANDARES_ID_INDX` (`xxbdo_estandares_id` ASC),
  CONSTRAINT `XXBDO_EVOP_PE_DRIVERS_ID_FK`
    FOREIGN KEY (`xxbdo_evop_drivers_id`)
    REFERENCES `xxbdo_evop_drivers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_EVOP_PE_ESTANDARES_ID_FK`
    FOREIGN KEY (`xxbdo_estandares_id`)
    REFERENCES `xxbdo_estandares` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- Driver Atencion: a9a2e23c-5928-40f0-b6bd-e7845fb1a430
INSERT INTO `xxbdo_evop_ponderacion_estandares` (`id`, `xxbdo_estandares_id`, `xxbdo_evop_drivers_id`, `ponderacion`, `es_activo`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) 
VALUES 
-- std 1 : 10f81bf8-ff1b-415e-8fda-c420f1dbf914
('05311f6a-ff81-4cc0-8bab-02d3d6972cf1', '10f81bf8-ff1b-415e-8fda-c420f1dbf914', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '10', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 2
('c34025cb-2b05-4a1c-b0d5-711b935e9195', '63dbc878-8105-40d6-8cb9-2acfddce1640', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '18', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 3
('8a01ce2f-3a28-4122-a16b-fbbfb24a7bc5', '139e7f1b-ca27-4000-96c2-3e5b4dda3c3e', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 4
('9ec0f581-ed39-49f9-8b13-f0f9ea4a8af2', '390d1816-4beb-4884-b156-10374f142e1b', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 5
('50f43811-1e9a-41ed-89bc-a4d6d1420c52', '8fb4955e-688a-4e01-bbe4-872218262a1d', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 6a
('158061e3-4ce1-47c0-8e3f-2433bbacb81e', '5ae71d28-c4f9-4968-a3ce-c60908fc8bdf', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 6b
('9835cf38-fce1-4ff9-9be1-62edcacbb911', '7e0ae661-3de5-40af-9047-72e7f2481db7', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 7
('f0c8cfca-d627-4e5d-aaff-40358344f3f6', '152ce08f-b465-44f8-9560-32e09a67865f', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 8
('28c6cab1-1cfd-4bc7-8093-bb6a964351b5', '942567f1-9891-4cf1-bdb9-eafb8339f0e3', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 9
('b96c1651-501a-4ac0-9d44-53c0764c2d57', '6bcfaf2f-40a7-44bf-b554-d07c644196b9', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 10
('5cd92dc0-fece-4d88-9172-47753d36a95c', 'fc921750-4a86-4c65-a663-b3d9ac0fa155', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 11
('561af86e-3f0f-4537-a197-6380b53fb5c5', '88622a43-736e-4bdc-87d2-08b0da8ad325', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 12
('c0e2a922-dd7b-433f-81f1-d7604e6e96e4', 'b1b19ac7-b4b5-4d82-bd95-9d674f24de3d', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 13
('5315c872-d470-4c92-ad78-a3022c7eea50', 'f52971ec-e16e-46f7-a1fe-ced9410059b3', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '2', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 14
('b062aadf-2269-41c3-9e6d-268e777c5b39', 'ff0647e5-6b8a-4e64-83f6-90e986c90fee', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 18
('75582734-241e-4a3d-a2b4-cc347056fd82', 'a4b72428-0295-40e7-bc9d-bcaf6df4470e', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 19
('730417a5-dd4f-4163-a710-b48b3d0582ad', '25e13971-255b-4a0e-b735-0ec52f58199c', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56');


-- Abasto: 77d11a16-b4ab-45a2-bf9a-8227975c8018
INSERT INTO `xxbdo_evop_ponderacion_estandares` (`id`, `xxbdo_estandares_id`, `xxbdo_evop_drivers_id`, `ponderacion`, `es_activo`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) 
VALUES 
-- std 1
('491bfe30-cb61-476e-b8c7-fc9ff473ff0a', '10f81bf8-ff1b-415e-8fda-c420f1dbf914', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 2
('b0cba605-9efd-4d1d-b4a9-983411cb3a18', '63dbc878-8105-40d6-8cb9-2acfddce1640', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 3
('1f1f05b6-2c68-4021-9c00-70410ade5f2a', '139e7f1b-ca27-4000-96c2-3e5b4dda3c3e', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 4
('64a7ba31-c4e3-45e2-a73a-cbd5f0b90c59', '390d1816-4beb-4884-b156-10374f142e1b', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 5
('40b71b9b-c757-4185-bf3b-fcebe8d32481', '8fb4955e-688a-4e01-bbe4-872218262a1d', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 6a
('b3bb2966-a1ab-40c1-9560-2faf5ff18cfb', '5ae71d28-c4f9-4968-a3ce-c60908fc8bdf', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 6b
('cc195e66-a737-44b1-8015-413f1d8e5690', '7e0ae661-3de5-40af-9047-72e7f2481db7', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 7
('778af8a9-036e-4c68-ac5f-59dce7a7d8bf', '152ce08f-b465-44f8-9560-32e09a67865f', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '5', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 8
('732e34c3-e76e-4df4-a61f-21013064007f', '942567f1-9891-4cf1-bdb9-eafb8339f0e3', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '7', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 9
('7284e84d-91b8-440f-97ee-a857a4e7a2e6', '6bcfaf2f-40a7-44bf-b554-d07c644196b9', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '6', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 10
('5464260d-4a6e-4352-b43d-4bf4b02a68c7', 'fc921750-4a86-4c65-a663-b3d9ac0fa155', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '3', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 11
('a5ff88d0-445a-46b4-a28d-f620b142679a', '88622a43-736e-4bdc-87d2-08b0da8ad325', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '4', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 12
('c5465d62-b6e8-40f1-bd9b-8b269f292cab', 'b1b19ac7-b4b5-4d82-bd95-9d674f24de3d', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 13
('a360ce3f-12dc-4a99-9c53-ff5afeafbc35', 'f52971ec-e16e-46f7-a1fe-ced9410059b3', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 14
('05675311-cc46-4632-9d85-91481ce221e3', 'ff0647e5-6b8a-4e64-83f6-90e986c90fee', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 18
('a419a394-4f56-4539-b190-be267e955dff', 'a4b72428-0295-40e7-bc9d-bcaf6df4470e', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 19
('782d7bae-c06c-446d-a6c5-382122e960d7', '25e13971-255b-4a0e-b735-0ec52f58199c', '77d11a16-b4ab-45a2-bf9a-8227975c8018', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56');


-- Rapidez: 9cbc62a7-48cd-44c0-a82e-066b30dde0d3
INSERT INTO `xxbdo_evop_ponderacion_estandares` (`id`, `xxbdo_estandares_id`, `xxbdo_evop_drivers_id`, `ponderacion`, `es_activo`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) 
VALUES 
-- std 1
('c50e2b4f-f728-4c71-833b-ac4cc5f6112d', '10f81bf8-ff1b-415e-8fda-c420f1dbf914', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 2
('d0f36203-1735-41e8-ac6f-57120f008c61', '63dbc878-8105-40d6-8cb9-2acfddce1640', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '5', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 3
('e66923de-c51f-44bc-9015-1a986170beff', '139e7f1b-ca27-4000-96c2-3e5b4dda3c3e', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 4
('a782a304-5ba2-403d-9f11-1339091ade1b', '390d1816-4beb-4884-b156-10374f142e1b', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '2', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 5
('c6318512-9a6f-4d83-b425-e39ee270f515', '8fb4955e-688a-4e01-bbe4-872218262a1d', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '2', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 6a
('a3696e16-e7b6-4620-bf21-aa58f9acefb6', '5ae71d28-c4f9-4968-a3ce-c60908fc8bdf', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 6b
('5268554e-90ae-488f-8b09-f3615399dd20', '7e0ae661-3de5-40af-9047-72e7f2481db7', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 7
('001c80c1-af32-49fa-b111-006ac0fadb5e', '152ce08f-b465-44f8-9560-32e09a67865f', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '3', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 8
('4f0cd648-03cc-4e1a-884e-a8557af74753', '942567f1-9891-4cf1-bdb9-eafb8339f0e3', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 9
('f9ee5819-e167-4064-89e5-cf56ba8dc8bc', '6bcfaf2f-40a7-44bf-b554-d07c644196b9', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 10
('f0eb0001-3711-4c3b-b9eb-21c60405e539', 'fc921750-4a86-4c65-a663-b3d9ac0fa155', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 11
('86b7ffe6-fbe8-4dba-b7d9-98b1ac4c91be', '88622a43-736e-4bdc-87d2-08b0da8ad325', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 12
('6b0646b1-f17e-4592-bf65-c54f5463f30f', 'b1b19ac7-b4b5-4d82-bd95-9d674f24de3d', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 13
('c2a30c8e-2ced-41eb-a243-cc0caf38c296', 'f52971ec-e16e-46f7-a1fe-ced9410059b3', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 14
('9913c41e-e7f3-4d6a-9895-2a8c12ceda23', 'ff0647e5-6b8a-4e64-83f6-90e986c90fee', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 18
('08fbe116-1d30-448c-bc55-e373a7f21af0', 'a4b72428-0295-40e7-bc9d-bcaf6df4470e', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 19
('980c79fa-b80b-4039-8ef2-90780e6e9086', '25e13971-255b-4a0e-b735-0ec52f58199c', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56');


-- Limpieza: 330c6232-615d-4f50-8168-8229baa6f55d
INSERT INTO `xxbdo_evop_ponderacion_estandares` (`id`, `xxbdo_estandares_id`, `xxbdo_evop_drivers_id`, `ponderacion`, `es_activo`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) 
VALUES 
-- std 1
('e93df216-7822-4c0b-928d-eff5e87d2a32', '10f81bf8-ff1b-415e-8fda-c420f1dbf914', '330c6232-615d-4f50-8168-8229baa6f55d', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 2
('38ae1e48-c511-4aff-b802-41a88777718e', '63dbc878-8105-40d6-8cb9-2acfddce1640', '330c6232-615d-4f50-8168-8229baa6f55d', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 3
('290c3466-366e-4a01-bdd1-bc72fe6ec59c', '139e7f1b-ca27-4000-96c2-3e5b4dda3c3e', '330c6232-615d-4f50-8168-8229baa6f55d', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 4
('4ebd8a2f-bb0b-4ba9-bb2b-67c8e131180b', '390d1816-4beb-4884-b156-10374f142e1b', '330c6232-615d-4f50-8168-8229baa6f55d', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 5
('3148cbe8-829f-4c2c-8b34-de37d50277c9', '8fb4955e-688a-4e01-bbe4-872218262a1d', '330c6232-615d-4f50-8168-8229baa6f55d', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 6a
('6176660d-b272-4d99-b5b4-9c0b1ad29df9', '5ae71d28-c4f9-4968-a3ce-c60908fc8bdf', '330c6232-615d-4f50-8168-8229baa6f55d', '9', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 6b
('5a51017d-71c4-4021-b589-c19e3f8f2d37', '7e0ae661-3de5-40af-9047-72e7f2481db7', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '9', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 7
('dc989840-f867-4a2e-9e97-6d58513c4041', '152ce08f-b465-44f8-9560-32e09a67865f', '330c6232-615d-4f50-8168-8229baa6f55d', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 8
('02cc23da-e1f8-4839-b53a-6ae4d41c7b2e', '942567f1-9891-4cf1-bdb9-eafb8339f0e3', '330c6232-615d-4f50-8168-8229baa6f55d', '3', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 9
('22292d22-7378-443f-9590-480aa8cfdbf3', '6bcfaf2f-40a7-44bf-b554-d07c644196b9', '330c6232-615d-4f50-8168-8229baa6f55d', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 10
('d5959cca-7b1b-43c2-a02e-0cb0ac6bbe3c', 'fc921750-4a86-4c65-a663-b3d9ac0fa155', '330c6232-615d-4f50-8168-8229baa6f55d', '2', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 11
('e2277bac-91a2-423c-b45a-37b96a416676', '88622a43-736e-4bdc-87d2-08b0da8ad325', '330c6232-615d-4f50-8168-8229baa6f55d', '1', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 12
('435792d7-e5ce-4a3c-aa93-8c198f226fe9', 'b1b19ac7-b4b5-4d82-bd95-9d674f24de3d', '330c6232-615d-4f50-8168-8229baa6f55d', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 13
('7c7ca3c1-f4cc-48a3-b785-8284521fe038', 'f52971ec-e16e-46f7-a1fe-ced9410059b3', '330c6232-615d-4f50-8168-8229baa6f55d', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 14
('08521665-9aa3-4e05-9dc6-b91bec1e5a4d', 'ff0647e5-6b8a-4e64-83f6-90e986c90fee', '330c6232-615d-4f50-8168-8229baa6f55d', '1', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 18
('673656bc-399b-40cf-b826-26d764846141', 'a4b72428-0295-40e7-bc9d-bcaf6df4470e', '330c6232-615d-4f50-8168-8229baa6f55d', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 19
('782fa7d2-79c8-4a86-96e8-3b4e38d166af', '25e13971-255b-4a0e-b735-0ec52f58199c', '330c6232-615d-4f50-8168-8229baa6f55d', '2', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56');


-- Imagen de tienda: bd9c3339-f1ca-4947-a856-a66031656a38
INSERT INTO `xxbdo_evop_ponderacion_estandares` (`id`, `xxbdo_estandares_id`, `xxbdo_evop_drivers_id`, `ponderacion`, `es_activo`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) 
VALUES 
-- std 1
('d3b4305a-acf7-4697-a62f-04523271b111', '10f81bf8-ff1b-415e-8fda-c420f1dbf914', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 2
('2e2d13db-a768-4006-812b-d671db25d636', '63dbc878-8105-40d6-8cb9-2acfddce1640', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 3
('c33388e7-9dc8-4e18-9ea2-e48412c77ba0', '139e7f1b-ca27-4000-96c2-3e5b4dda3c3e', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 4
('2b2b1ccc-f9c0-44d9-88de-e11a57c58b85', '390d1816-4beb-4884-b156-10374f142e1b', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 5
('64720d61-d9e0-42a2-8351-97b2a2b37f25', '8fb4955e-688a-4e01-bbe4-872218262a1d', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 6a
('f6b0bbe9-2a8c-4c0f-9aaf-a6f411103104', '5ae71d28-c4f9-4968-a3ce-c60908fc8bdf', 'bd9c3339-f1ca-4947-a856-a66031656a38', '2', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 6b
('032f0865-1680-4b2f-952b-adc02c379f35', '7e0ae661-3de5-40af-9047-72e7f2481db7', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', '2', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 7
('6a7b6577-894f-4e45-8434-1781554cfd25', '152ce08f-b465-44f8-9560-32e09a67865f', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 8
('fe5da180-75c1-4870-b3c8-28fbb43da05b', '942567f1-9891-4cf1-bdb9-eafb8339f0e3', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 9
('ee182102-d296-402a-81d8-77ed900a76b9', '6bcfaf2f-40a7-44bf-b554-d07c644196b9', 'bd9c3339-f1ca-4947-a856-a66031656a38', '2', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 10
('ee08555e-cc2c-45b2-9fc6-3781491d5f33', 'fc921750-4a86-4c65-a663-b3d9ac0fa155', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 11
('69a75c2e-f942-4e26-860e-ca2809745abb', '88622a43-736e-4bdc-87d2-08b0da8ad325', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 12
('812ee638-6167-4be0-a3c5-93b9b837b4fd', 'b1b19ac7-b4b5-4d82-bd95-9d674f24de3d', 'bd9c3339-f1ca-4947-a856-a66031656a38', '5', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 13
('d12c837d-1085-4f6f-8ebb-66b19c88d264', 'f52971ec-e16e-46f7-a1fe-ced9410059b3', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 14
('4ade93dc-cc0c-4e06-849d-68993e2d65f8', 'ff0647e5-6b8a-4e64-83f6-90e986c90fee', 'bd9c3339-f1ca-4947-a856-a66031656a38', '0', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 18
('e57077f5-ef38-4a92-b414-6b0914673990', 'a4b72428-0295-40e7-bc9d-bcaf6df4470e', 'bd9c3339-f1ca-4947-a856-a66031656a38', '4', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56'),
-- std 19
('c5043546-ba34-4cbc-806d-c60c6478289d', '25e13971-255b-4a0e-b735-0ec52f58199c', 'bd9c3339-f1ca-4947-a856-a66031656a38', '2', '1', '1', '1', NULL, NULL, '2020-09-22 14:05:56', '2020-09-22 14:05:56');


CREATE TABLE IF NOT EXISTS `xxbdo_evop_promedios_drivers` (
  `id` INT(11) NOT NULL,
  `xxbdo_evop_drivers_id` VARCHAR(36) NOT NULL,
  `minimo` INT(11) NOT NULL DEFAULT 0,
  `maximo` INT(11) NOT NULL DEFAULT 0,
  `xxbdo_colores_id` VARCHAR(36) NOT NULL,
  `es_activo` TINYINT(4) NULL DEFAULT 1,
  `orden` BIGINT(20) NULL DEFAULT 0,
  `activo` TINYINT(4) NULL DEFAULT 1,
  `usuario` VARCHAR(100) NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_modificacion` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `XXBDO_EVOP_PD_DRIVERS_ID_INDX` (`xxbdo_evop_drivers_id` ASC),
  INDEX `XXBDO_EVOP_PD_COLORES_ID_INDX` (`xxbdo_colores_id` ASC),
  CONSTRAINT `XXBDO_EVOP_PD_DRIVERS_ID_FK`
    FOREIGN KEY (`xxbdo_evop_drivers_id`)
    REFERENCES `xxbdo_evop_drivers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `XXBDO_EVOP_PD_COLORES_ID_FK`
    FOREIGN KEY (`xxbdo_colores_id`)
    REFERENCES `xxbdo_colores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

--
-- Volcado de datos para la tabla `xxbdo_evop_promedios_drivers`
--

INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('02ed8487-4615-48d6-8e1c-673b1a43be96', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', 27, 30, '4274355c-2a84-4817-97fb-d4cf72d11f75', 1, 1, 1, NULL, NULL, '2020-09-22 13:26:56', '2020-09-22 13:26:56');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('09f9b515-b3b3-45e3-8914-f57f9c6542d9', 'bd9c3339-f1ca-4947-a856-a66031656a38', 0, 11, '586a2916-98aa-44cc-8afa-a1d1200d70d7', 1, 4, 1, NULL, NULL, '2020-09-22 13:36:44', '2020-09-22 13:36:44');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('0e0831f9-5562-471f-b59f-d57d24a8c826', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', 0, 24, '586a2916-98aa-44cc-8afa-a1d1200d70d7', 1, 4, 1, NULL, NULL, '2020-09-22 13:36:44', '2020-09-22 13:36:44');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('1aad5af3-7986-479a-8d8d-f9438bf9dc71', '77d11a16-b4ab-45a2-bf9a-8227975c8018', 23, 25, '4274355c-2a84-4817-97fb-d4cf72d11f75', 1, 1, 1, NULL, NULL, '2020-09-22 13:26:56', '2020-09-22 13:26:56');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('23335f69-6f77-47ba-853d-6dece8f161f9', '77d11a16-b4ab-45a2-bf9a-8227975c8018', 22, 22, '5b7c4ad7-b291-4a7c-8892-6079d64af9aa', 1, 2, 1, NULL, NULL, '2020-09-22 13:26:56', '2020-09-22 13:26:56');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('31a6dc1e-ab87-4e2b-9a72-2e08a5e03fd3', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', 10, 10, '5b7c4ad7-b291-4a7c-8892-6079d64af9aa', 1, 2, 1, NULL, NULL, '2020-09-22 13:26:56', '2020-09-22 13:26:56');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('3afae6b4-7225-4082-babe-ee5dc1cd19d3', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', 11, 12, '4274355c-2a84-4817-97fb-d4cf72d11f75', 1, 1, 1, NULL, NULL, '2020-09-22 13:26:56', '2020-09-22 13:26:56');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('49d5c9c1-3325-4cc4-8dad-ef1abece782a', '330c6232-615d-4f50-8168-8229baa6f55d', 15, 15, '5b7c4ad7-b291-4a7c-8892-6079d64af9aa', 1, 2, 1, NULL, NULL, '2020-09-22 13:26:56', '2020-09-22 13:26:56');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('4b3a407e-0d46-4202-99ba-7497b834a0c1', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', 9, 9, 'f26993e4-323a-44fe-adcd-bf7a63247cee', 1, 3, 1, NULL, NULL, '2020-09-22 13:36:44', '2020-09-22 13:36:44');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('56559ddf-c7e0-487d-a861-bfa93a307719', '330c6232-615d-4f50-8168-8229baa6f55d', 14, 14, 'f26993e4-323a-44fe-adcd-bf7a63247cee', 1, 3, 1, NULL, NULL, '2020-09-22 13:36:44', '2020-09-22 13:36:44');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('65ee2059-6c61-4c73-bc20-310c3f2549d0', '9cbc62a7-48cd-44c0-a82e-066b30dde0d3', 0, 8, '586a2916-98aa-44cc-8afa-a1d1200d70d7', 1, 4, 1, NULL, NULL, '2020-09-22 13:36:44', '2020-09-22 13:36:44');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('6b847da7-50b7-4236-a389-2ea0fc769179', 'bd9c3339-f1ca-4947-a856-a66031656a38', 14, 15, '4274355c-2a84-4817-97fb-d4cf72d11f75', 1, 1, 1, NULL, NULL, '2020-09-22 13:26:56', '2020-09-22 13:26:56');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('7a2ee0d1-3b77-4e0d-9bcc-c4b1423c831b', '77d11a16-b4ab-45a2-bf9a-8227975c8018', 0, 20, '586a2916-98aa-44cc-8afa-a1d1200d70d7', 1, 4, 1, NULL, NULL, '2020-09-22 13:36:44', '2020-09-22 13:36:44');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('9203b0ca-4386-42e0-b6b9-af46a86e09d6', '330c6232-615d-4f50-8168-8229baa6f55d', 0, 13, '586a2916-98aa-44cc-8afa-a1d1200d70d7', 1, 4, 1, NULL, NULL, '2020-09-22 13:36:44', '2020-09-22 13:36:44');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('ab5063d6-7a41-432d-9653-120796237f46', '77d11a16-b4ab-45a2-bf9a-8227975c8018', 21, 21, 'f26993e4-323a-44fe-adcd-bf7a63247cee', 1, 3, 1, NULL, NULL, '2020-09-22 13:36:44', '2020-09-22 13:36:44');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('ad86052e-4eb0-4cdc-a74f-86c6cc003697', 'bd9c3339-f1ca-4947-a856-a66031656a38', 12, 12, 'f26993e4-323a-44fe-adcd-bf7a63247cee', 1, 3, 1, NULL, NULL, '2020-09-22 13:36:44', '2020-09-22 13:36:44');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('ada0ad51-6e3f-436c-b9ed-cd8528df8cbc', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', 25, 25, 'f26993e4-323a-44fe-adcd-bf7a63247cee', 1, 3, 1, NULL, NULL, '2020-09-22 13:36:44', '2020-09-22 13:36:44');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('cf8d36b3-ae22-42a9-bed3-6e95fd018888', 'bd9c3339-f1ca-4947-a856-a66031656a38', 13, 13, '5b7c4ad7-b291-4a7c-8892-6079d64af9aa', 1, 2, 1, NULL, NULL, '2020-09-22 13:26:56', '2020-09-22 13:26:56');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('e73c5e79-049d-411e-ac00-f28c4a38ac27', '330c6232-615d-4f50-8168-8229baa6f55d', 16, 18, '4274355c-2a84-4817-97fb-d4cf72d11f75', 1, 1, 1, NULL, NULL, '2020-09-22 13:26:56', '2020-09-22 13:26:56');
INSERT INTO `xxbdo_evop_promedios_drivers` VALUES('f13be40b-3501-45ff-862b-ea9fce51deab', 'a9a2e23c-5928-40f0-b6bd-e7845fb1a430', 26, 26, '5b7c4ad7-b291-4a7c-8892-6079d64af9aa', 1, 2, 1, NULL, NULL, '2020-09-22 13:26:56', '2020-09-22 13:26:56');



ALTER TABLE `xxbdo_estandares_alertas` 
ADD CONSTRAINT `XXBDO_ESTANDARES_ALERTAS_STDS_ID_FK`
  FOREIGN KEY (`xxbdo_estandares_id`)
  REFERENCES `xxbdo_estandares` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


