
--Creacion de tabla tarjeta tipo
CREATE TABLE `xxbdo_tarjetas_tipo` (
  `id` varchar(36) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `digitos_iniciales` varchar(16) DEFAULT NULL,
  `longitud` int(11) NOT NULL,
  `es_default` tinyint(4) DEFAULT '0',
  `orden` bigint(20) DEFAULT NULL,
  `es_activo` tinyint(4) DEFAULT '1',
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `xxbdo_tarjetas_tipo`
  ADD PRIMARY KEY (`id`);
COMMIT;


--Volcado de tabla tarjeta tipo

INSERT INTO `xxbdo_tarjetas_tipo` (`id`, `nombre`, `descripcion`, `digitos_iniciales`, `longitud`, `es_default`, `orden`, `es_activo`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES
('4682d43d-8db8-4453-8d97-26afa488cee0', 'Saldazo', 'Tarjeta Saldazo', '476684', 16, 1, 1, 1, 1, NULL, NULL, '2020-11-12 13:40:59', '2020-11-12 13:40:59');



--Creacion de tabla tarjeta status

CREATE TABLE `xxbdo_tarjetas_status` (
  `id` varchar(36) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `opcion` varchar(2) NOT NULL,
  `descripcion` text,
  `color` varchar(12) NOT NULL,
  `orden` bigint(20) DEFAULT NULL,
  `es_default` tinyint(4) DEFAULT '0',
  `es_tachado` tinyint(4) DEFAULT '0',
  `es_activo` tinyint(4) DEFAULT '1',
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `xxbdo_tarjetas_status`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_TARJETAS_STATUS_OPCION_IDX` (`opcion`);
COMMIT;



--Volcado de tabla tarjeta tipo

INSERT INTO `xxbdo_tarjetas_status` (`id`, `nombre`, `opcion`, `descripcion`, `color`, `orden`, `es_default`, `es_tachado`, `es_activo`, `activo`, `usuario`, `fecha_creacion`, `fecha_modificacion`) VALUES
('442b6ea6-838f-48ca-accc-a7eea7372bb6', 'Vendida / Activada', 'OK', 'Desc', '#008000', 2, 0, 1, 1, 1, NULL, '2020-11-12 13:32:39', '2020-11-12 13:32:39'),
('4857a6dd-10ed-4a4a-90ea-e8722bb3a9a7', 'En Exhibición', 'E', 'Desc', '#FFFF00', 1, 1, 0, 1, 1, NULL, '2020-11-12 13:32:39', '2020-11-12 13:32:39'),
('b7034196-2f15-453d-83e0-6567dc71c627', 'Falla / Robo', 'X', 'Desc', '#FF0000', 3, 0, 0, 1, 1, NULL, '2020-11-12 13:32:39', '2020-11-12 13:32:39');



--Creacion de tabla tarjetas

CREATE TABLE `xxbdo_tarjetas` (
  `id` varchar(36) NOT NULL,
  `cr_plaza` varchar(10) NOT NULL,
  `cr_tienda` varchar(10) NOT NULL,
  `xxbdo_tarjetas_tipo_id` varchar(36) NOT NULL,
  `agregada_por` varchar(36) NOT NULL,
  `xxbdo_tarjetas_status_id` varchar(36) NOT NULL,
  `fecha_registro` timestamp NOT NULL,
  `numeracion` varchar(36) NOT NULL,
  `es_activo` tinyint(4) DEFAULT '1',
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `xxbdo_tarjetas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `XXBDO_TARJETAS_NUMERACION_IDX` (`numeracion`),
  ADD KEY `XXBDO_TARJETAS_TARJETA_TIPO_ID_IDX` (`xxbdo_tarjetas_tipo_id`),
  ADD KEY `XXBDO_TARJETAS_TARJETA_STATUS_ID_IDX` (`xxbdo_tarjetas_status_id`),
  ADD KEY `XXBDO_TARJETAS_AGREGADA_POR_ID_IDX` (`agregada_por`);


ALTER TABLE `xxbdo_tarjetas`
  ADD CONSTRAINT `XXBDO_TARJETAS_AGREGADA_POR_ID_FK` FOREIGN KEY (`agregada_por`) REFERENCES `xxbdo_roles_en_tienda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `XXBDO_TARJETAS_TARJETA_STATUS_ID_FK` FOREIGN KEY (`xxbdo_tarjetas_status_id`) REFERENCES `xxbdo_tarjetas_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `XXBDO_TARJETAS_TARJETA_TIPO_ID_FK` FOREIGN KEY (`xxbdo_tarjetas_tipo_id`) REFERENCES `xxbdo_tarjetas_tipo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

--Creacion de tabla tarjetas entregas

CREATE TABLE `xxbdo_tarjetas_entrega` (
  `id` varchar(36) NOT NULL,
  `cr_plaza` varchar(10) NOT NULL,
  `cr_tienda` varchar(10) NOT NULL,
  `quien_entrega` varchar(36) NOT NULL,
  `quien_recibe` varchar(36) NOT NULL,
  `fecha_entrega` timestamp NOT NULL,
  `es_activo` tinyint(4) DEFAULT '1',
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `xxbdo_tarjetas_entrega`
  ADD PRIMARY KEY (`id`),
  ADD KEY `XXBDO_TARJETAS_ENTREGA_QUIEN_ENTREGA_ID_IDX` (`quien_entrega`),
  ADD KEY `XXBDO_TARJETAS_ENTREGA_QUIEN_RECIBE_ID_IDX` (`quien_recibe`);


ALTER TABLE `xxbdo_tarjetas_entrega`
  ADD CONSTRAINT `XXBDO_TARJETAS_ENTREGA_QUIEN_ENTREGA_ID_FK` FOREIGN KEY (`quien_entrega`) REFERENCES `xxbdo_roles_en_tienda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `XXBDO_TARJETAS_ENTREGA_QUIEN_RECIBE_ID_FK` FOREIGN KEY (`quien_recibe`) REFERENCES `xxbdo_roles_en_tienda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;


--Creacion de tabla tarjetas entregas detalles

CREATE TABLE `xxbdo_tarjetas_entrega_detalle` (
  `xxbdo_tarjetas_entrega_id` varchar(36) NOT NULL,
  `xxbdo_tarjetas_id` varchar(36) NOT NULL,
  `xxbdo_tarjetas_status_id` varchar(36) NOT NULL,
  `activo` tinyint(4) DEFAULT '1',
  `usuario` varchar(100) DEFAULT NULL,
  `ip_address` varchar(64) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_modificacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `xxbdo_tarjetas_entrega_detalle`
  ADD PRIMARY KEY (`xxbdo_tarjetas_entrega_id`,`xxbdo_tarjetas_id`),
  ADD KEY `XXBDO_TARJETAS_ENTREGA_DETALLE_STATUS_ID_IDX` (`xxbdo_tarjetas_status_id`),
  ADD KEY `XXBDO_TARJETAS_ENTREGA_DETALLE_TARJETA_ID_IDX` (`xxbdo_tarjetas_id`);


ALTER TABLE `xxbdo_tarjetas_entrega_detalle`
  ADD CONSTRAINT `XXBDO_TARJETAS_ENTREGA_DETALLE_ENTREGA_ID_FK` FOREIGN KEY (`xxbdo_tarjetas_entrega_id`) REFERENCES `xxbdo_tarjetas_entrega` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `XXBDO_TARJETAS_ENTREGA_DETALLE_STATUS_ID_FK` FOREIGN KEY (`xxbdo_tarjetas_status_id`) REFERENCES `xxbdo_tarjetas_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `XXBDO_TARJETAS_ENTREGA_DETALLE_TARJETA_ID_FK` FOREIGN KEY (`xxbdo_tarjetas_id`) REFERENCES `xxbdo_tarjetas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;




--importacion de funcion para generar uuid_v4()

-- -----------------------------------------------------------------------------------------
-- To solve "ERROR 1419: You do not have the SUPER privilege and binary logging is enabled"
-- creating a function in Azure MySQL, enable the following server parameter is required: 
-- log_bin_trust_function_creators=1
-- References: 
-- https://docs.microsoft.com/en-us/azure/mysql/howto-troubleshoot-common-errors
-- https://docs.microsoft.com/en-us/azure/mysql/concepts-limits

-- -----------------------------------------------------------------------------------------

DELIMITER //
CREATE FUNCTION uuid_v4()
    RETURNS CHAR(36)
    NO SQL  
BEGIN
    -- 1th and 2nd block are made of 6 random bytes
    SET @h1 = HEX(RANDOM_BYTES(4));
    SET @h2 = HEX(RANDOM_BYTES(2));

    -- 3th block will start with a 4 indicating the version, remaining is random
    SET @h3 = SUBSTR(HEX(RANDOM_BYTES(2)), 2, 3);

    -- 4th block first nibble can only be 8, 9 A or B, remaining is random
    SET @h4 = CONCAT(HEX(FLOOR(ASCII(RANDOM_BYTES(1)) / 64) + 8),
                SUBSTR(HEX(RANDOM_BYTES(2)), 2, 3));

    -- 5th block is made of 6 random bytes
    SET @h5 = HEX(RANDOM_BYTES(6));

    -- Build the complete UUID
    RETURN LOWER(CONCAT(
        @h1, '-', @h2, '-4', @h3, '-', @h4, '-', @h5
    ));
END//


--fin de importacion de funcion
--Se deben agregar los sp 




DELIMITER $$
CREATE  PROCEDURE `SP_XXBDO_ADD_TARJETA`(
    IN _cr_plaza VARCHAR(10),
    IN _cr_tienda VARCHAR(10),
    IN _tarjetas_tipo_id VARCHAR(36),
    IN _agregada_por VARCHAR(36),
    IN _numeracion VARCHAR(24),
    IN _fecha_registro VARCHAR(20),
    IN _usuario VARCHAR(100),
    IN _ip_address VARCHAR(64)
    )
    COMMENT 'Agregar nueva tarjeta'
BEGIN
    DECLARE _tarjetas_status_id VARCHAR(36) DEFAULT NULL;
    DECLARE DuplicatedEntry CONDITION FOR 1062; 
    DECLARE EXIT HANDLER 
    FOR DuplicatedEntry 
    BEGIN 
        ROLLBACK;
        SELECT JSON_OBJECT("id", NULL, "mensaje", "Número de tarjeta ya existente.") AS result;
    END;

    START TRANSACTION;

    SET @nid = uuid_v4();

    SELECT id INTO _tarjetas_status_id 
    FROM xxbdo_tarjetas_status 
    WHERE es_default=1 
    AND es_activo=1 
    AND activo=1 
    LIMIT 1;

    INSERT INTO xxbdo_tarjetas VALUES (
        @nid,
        _cr_plaza,
        _cr_tienda,
        _tarjetas_tipo_id,
        _agregada_por, 
        _tarjetas_status_id,
        _fecha_registro, 
        _numeracion,
        1, 
        1, 
        _usuario,
        _ip_address,
        _fecha_registro,
        _fecha_registro
    );
    SELECT JSON_OBJECT("id", @nid) AS result;

    COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE  PROCEDURE `SP_XXBDO_ENTREGAR_TARJETAS`(
    IN _cr_plaza VARCHAR(10),
    IN _cr_tienda VARCHAR(10),
    IN _fecha_entrega VARCHAR(20),
    IN _tarjetas_data JSON,
    IN _usuario VARCHAR(100),
    IN _ip_address VARCHAR(64)
    )
    COMMENT 'Proceso de entregar tarjetas'
BEGIN
    DECLARE _quien_entrega VARCHAR(36);
    DECLARE _quien_recibe VARCHAR(36);
    DECLARE _tarjetas LONGTEXT;
    DECLARE i INT UNSIGNED DEFAULT 0;
    DECLARE v_current_item LONGTEXT;
    DECLARE EXIT HANDLER 
    FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT JSON_OBJECT(
            "status", "ERROR",
            "mensaje", "No es posible procesar entrega de tarjetas.",
            "num_tarjetas", NULL
        ) AS result;
    END;

    START TRANSACTION;

    SET @entrega_id = uuid_v4();
    SET _quien_entrega = _tarjetas_data ->> "$.entrega";
    SET _quien_recibe = _tarjetas_data ->> "$.recibe";
    SET _tarjetas = _tarjetas_data ->> "$.tarjetas";
    SET @num_tarjetas = JSON_LENGTH(_tarjetas);

    -- validar datos de entrada
    IF LENGTH(_quien_entrega)>35 
    AND LENGTH(_quien_recibe)>35 
    AND @num_tarjetas > 0 THEN 
            -- insertar registro de entrega
        INSERT INTO `xxbdo_tarjetas_entrega` VALUES (
            @entrega_id, 
            _cr_plaza, 
            _cr_tienda, 
            _quien_entrega, 
            _quien_recibe, 
            _fecha_entrega, 
            1, 
            1, 
            _usuario, 
            _ip_address, 
            _fecha_entrega, 
            _fecha_entrega
        );

        -- loop from 0 to the last item
        WHILE i < @num_tarjetas DO
            -- get the current item and build an SQL statement
            -- to pass it to a callback procedure
            SET v_current_item := JSON_EXTRACT(_tarjetas, CONCAT('$[', i, ']'));

            SELECT REPLACE(v_current_item,'\\','') INTO v_current_item;
            SELECT REPLACE(v_current_item,'"{','{') INTO v_current_item;
            SELECT REPLACE(v_current_item,'}"','}') INTO v_current_item;

            SET @tarjeta_id = v_current_item ->> "$.id";
            SET @tarjeta_status_id = v_current_item ->> "$.status";

            -- insertar detalle de tarjeta
            INSERT INTO `xxbdo_tarjetas_entrega_detalle` VALUES (
                @entrega_id, 
                @tarjeta_id, 
                @tarjeta_status_id, 
                1, 
                _usuario, 
                _ip_address, 
                _fecha_entrega, 
                _fecha_entrega
            );

            -- update status tarjeta
            UPDATE `xxbdo_tarjetas` 
            SET `xxbdo_tarjetas_status_id` = @tarjeta_status_id, 
            `usuario` = _usuario,
            `ip_address` = _ip_address,
            `fecha_modificacion` = _fecha_entrega 
            WHERE `xxbdo_tarjetas`.`id` = @tarjeta_id;

            SET i := i + 1;
        END WHILE;  

        -- resultado final
        SELECT JSON_OBJECT(
            "status", "OK", 
            "mensaje", "Proceso de entrega de tarjetas completado exitósamente.",
            "num_tarjetas", @num_tarjetas
        ) AS result;

    ELSE
        -- datos de entrada incorrectos
        SELECT JSON_OBJECT(
            "status", "ERROR",
            "mensaje", "Datos de entrada incorrectos.",
            "num_tarjetas", NULL
        ) AS result;
    END IF;

    COMMIT;

END$$
DELIMITER ;

DELIMITER $$
CREATE  PROCEDURE `SP_XXBDO_GET_ENTREGAR_TARJETAS`(IN `cr_plaza` VARCHAR(40), IN `cr_tienda` VARCHAR(40))
    NO SQL
SELECT xxbdo_tarjetas.id, xxbdo_tarjetas_tipo.nombre as "tipo", numeracion as "num", xxbdo_tarjetas_status.id as "status" FROM xxbdo_tarjetas INNER JOIN xxbdo_tarjetas_status on xxbdo_tarjetas.xxbdo_tarjetas_status_id=xxbdo_tarjetas_status.id INNER JOIN xxbdo_tarjetas_tipo on xxbdo_tarjetas_tipo_id= xxbdo_tarjetas_tipo.id WHERE cr_plaza=cr_plaza AND cr_tienda=cr_tienda AND xxbdo_tarjetas_status.opcion="E" AND xxbdo_tarjetas.activo=1 AND xxbdo_tarjetas.es_activo=1$$
DELIMITER ;

DELIMITER $$
CREATE  PROCEDURE `SP_XXBDO_GET_LISTA_CONTROL_TARJETAS`(
    IN _cr_plaza VARCHAR(10),
    IN _cr_tienda VARCHAR(10),
    IN _fecha_inicio VARCHAR(20),
    IN _fecha_fin VARCHAR(20)
    )
    COMMENT 'Obtener lista de control de tarjetas'
BEGIN

    SELECT `xxbdo_tarjetas`.`numeracion` AS `tarjeta`, 
    `xxbdo_tarjetas_tipo`.`nombre` AS `tipo`, 
    `xxbdo_tarjetas_status`.`nombre` AS `status`,  
    `xxbdo_roles_en_tienda`.`nombre` AS `agregada_por`, 
    `xxbdo_tarjetas_status`.`opcion`,  
    `xxbdo_tarjetas_status`.`color`,  
    `xxbdo_tarjetas_status`.`es_tachado`,  
    DATE_FORMAT(`xxbdo_tarjetas`.`fecha_registro`, "%Y-%m-%d") AS `fecha_registro`, 
    DATE_FORMAT(`xxbdo_tarjetas`.`fecha_registro`, "%H:%i:%s") AS `hora_registro`, 
    responsable.`detalle_fecha` AS `fecha_modificacion`, 
    responsable.`detalle_hora` AS `hora_modificacion`, 
    responsable.`detalle_nombre_responsable` AS `responsable` 
    FROM (`xxbdo_tarjetas`, 
    `xxbdo_tarjetas_status`, 
    `xxbdo_tarjetas_tipo`, 
    `xxbdo_roles_en_tienda`) 
    LEFT JOIN (
    SELECT 
    -- detalles.`xxbdo_tarjetas_entrega_id`,
    -- `xxbdo_tarjetas_entrega`.`quien_entrega`,
    `xxbdo_roles_en_tienda`.`nombre` AS `detalle_nombre_responsable`, 
    DATE_FORMAT(`xxbdo_tarjetas_entrega`.`fecha_entrega`, "%Y-%m-%d") AS `detalle_fecha`, 
    DATE_FORMAT(`xxbdo_tarjetas_entrega`.`fecha_entrega`, "%H:%i:%s") AS `detalle_hora`, 
    detalles.`xxbdo_tarjetas_id`, 
    detalles.`xxbdo_tarjetas_status_id`, 
    `xxbdo_tarjetas_status`.`nombre` AS `status`
    FROM (`xxbdo_tarjetas_entrega_detalle` detalles,
    `xxbdo_tarjetas_entrega`,
    `xxbdo_tarjetas_status`,
    `xxbdo_roles_en_tienda`) 
    LEFT JOIN `xxbdo_tarjetas_entrega_detalle` detalle 
    ON (
        detalles.`xxbdo_tarjetas_id` = detalle.`xxbdo_tarjetas_id` 
        AND detalles.fecha_creacion < detalle.fecha_creacion
    ) 
    WHERE detalles.`xxbdo_tarjetas_entrega_id` = `xxbdo_tarjetas_entrega`.`id` 
    AND detalles.`xxbdo_tarjetas_status_id` 
    IN (SELECT `id` FROM `xxbdo_tarjetas_status` WHERE `opcion` IN("OK", "X")) 
    AND `xxbdo_tarjetas_entrega`.`cr_plaza` = _cr_plaza 
    AND `xxbdo_tarjetas_entrega`.`cr_tienda` = _cr_tienda 
    AND `xxbdo_tarjetas_entrega`.`quien_entrega` = `xxbdo_roles_en_tienda`.`id` 
    AND detalles.`xxbdo_tarjetas_status_id` = `xxbdo_tarjetas_status`.`id` 
    AND detalle.`xxbdo_tarjetas_id` IS NULL
    ) responsable 
    ON (responsable.`xxbdo_tarjetas_id` = `xxbdo_tarjetas`.`id`)
    WHERE `xxbdo_tarjetas`.`cr_plaza`= _cr_plaza  
    AND `xxbdo_tarjetas`.`cr_tienda`= _cr_tienda 
    AND DATE(`xxbdo_tarjetas`.`fecha_registro`) 
    BETWEEN DATE(_fecha_inicio) 
    AND DATE(_fecha_fin) 
    AND `xxbdo_tarjetas`.`es_activo` = 1 
    AND `xxbdo_tarjetas`.`activo` = 1 
    AND `xxbdo_tarjetas_tipo`.`id` = `xxbdo_tarjetas`.`xxbdo_tarjetas_tipo_id` 
    AND `xxbdo_tarjetas_status`.`id` = `xxbdo_tarjetas`.`xxbdo_tarjetas_status_id` 
    AND `xxbdo_tarjetas`.`agregada_por` = `xxbdo_roles_en_tienda`.`id` 
    ORDER BY `xxbdo_tarjetas_status`.`orden`,
    `xxbdo_tarjetas`.`fecha_registro`;

END$$
DELIMITER ;


--fin de update