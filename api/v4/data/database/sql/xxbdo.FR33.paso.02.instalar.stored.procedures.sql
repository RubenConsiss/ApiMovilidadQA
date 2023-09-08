-- Queries para insertar stored procedures:

-- al correr en BD de pruebas, cambiar a: USE xxbdo_<dbname>;
-- al correr en BD production, USE xxbdo;
USE `xxbdo`;

DELIMITER $$

CREATE FUNCTION `uuid_v4` ()
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
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE `SP_XXBDO_CLONE_VERSION_BDO` (
    IN _version_bdo_to_clone_id VARCHAR(36), 
    IN _end_date_version_bdo_to_expire VARCHAR(10), 
    IN _start_date_new_version_bdo VARCHAR(10),
    IN _titulo VARCHAR(45), 
    IN _titulo_app VARCHAR(100), 
    IN _descripcion VARCHAR(45), 
    IN _titulo_indicadores_app VARCHAR(100)
    )
    COMMENT 'Clonar version de BDO.'
BEGIN
    DECLARE _valid_start_date INT DEFAULT 0;
    DECLARE _checklist_to_expire_id VARCHAR(36) DEFAULT NULL;
    DECLARE _new_version_id VARCHAR(36) DEFAULT NULL;
    DECLARE _new_checklist_id VARCHAR(36) DEFAULT NULL;

    START TRANSACTION;

    IF LENGTH(_version_bdo_to_clone_id)<36 OR 
    LENGTH(_titulo)<1 OR
    LENGTH(_titulo_app)<1 OR 
    LENGTH(_descripcion)<1 OR 
    LENGTH(_titulo_indicadores_app)<1 OR 
    LENGTH(_end_date_version_bdo_to_expire)<10 OR 
    LENGTH(_start_date_new_version_bdo)<10 THEN 
        SELECT "ERROR" AS `status`, 
        NOW() AS `inicio`, 
        NOW() AS `fin`, 
        "Corrija los datos de entrada e intente nuevamente." AS `mensaje`;
    ELSE
        BEGIN
            SELECT COUNT(*) INTO _valid_start_date 
            FROM `xxbdo_version_estandares` 
            WHERE DATE(_start_date_new_version_bdo) 
            BETWEEN `fecha_inicio` 
            AND IFNULL(`fecha_fin`, IFNULL(`fecha_fin`, DATE(_end_date_version_bdo_to_expire)));

            IF _valid_start_date>0 THEN
                SELECT "ERROR" AS `status`, 
                NOW() AS `inicio`, 
                NOW() AS `fin`, 
                "La fecha de inicio de la nueva versión no es válida, corrija e intente nuevamente." AS `mensaje`;
            ELSE
                BEGIN
                    -- timestamp inicio proceso
                    SET @inicio_proceso = NOW();

                    -- Obtener checklist_id de version a expirar
                    SELECT `id` INTO _checklist_to_expire_id 
                    FROM `xxbdo_checklists` 
                    WHERE `xxbdo_version_estandares_id` = _version_bdo_to_clone_id 
                    LIMIT 1;

                    -- query para cerrar BDO version Nexxo, change fecha_fin as required:
                    UPDATE `xxbdo_version_estandares` 
                    SET `es_default` = '0', 
                    `fecha_fin` = _end_date_version_bdo_to_expire  
                    WHERE `xxbdo_version_estandares`.`id` = _version_bdo_to_clone_id;

                    -- query para cerrar checklist vesion Nexxo:
                    UPDATE `xxbdo_checklists` 
                    SET `es_default` = '0', 
                    `fecha_fin` = _end_date_version_bdo_to_expire  
                    WHERE `xxbdo_checklists`.`id` = _checklist_to_expire_id;

                    -- Obtener ids para nueva version y checklist
                    SELECT uuid_V4() AS ncid, 
                    uuid_V4() AS nvid 
                    INTO _new_checklist_id, 
                    _new_version_id;

                    -- query para crear nueva version
                    INSERT INTO `xxbdo_version_estandares` 
                    SELECT _new_version_id AS `nid`,
                    _titulo, 
                    _titulo_app, 
                    _descripcion, 
                    1, 
                    _start_date_new_version_bdo, 
                    NULL, 
                    1, 
                    NULL, 
                    NULL, 
                    NOW(), 
                    NOW();

                    -- query para crear nuevo checklist
                    INSERT INTO `xxbdo_checklists` 
                    SELECT _new_checklist_id, 
                    _new_version_id, 
                    _titulo, 
                    _descripcion, 
                    _titulo_app, 
                    _titulo_indicadores_app, 
                    _start_date_new_version_bdo, 
                    NULL, 
                    1, 
                    1, 
                    NULL, 
                    NULL, 
                    NOW(), 
                    NOW();

                    -- query para clonar areas
                    CREATE TABLE `xxbdo_areas_temp` 
                    SELECT `id` AS `prev_id`, 
                    uuid_V4() AS `new_id`, 
                    _new_version_id AS `new_version_id`, 
                    `xxbdo_areas_grupos_id`, 
                    `titulo`, 
                    `descripcion`, 
                    `orden`, 
                    1 AS `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_areas` 
                    WHERE `xxbdo_version_estandares_id` = _version_bdo_to_clone_id;

                    -- query para clonar areas
                    INSERT INTO `xxbdo_areas` 
                    SELECT `new_id`, 
                    `new_version_id`, 
                    `xxbdo_areas_grupos_id`, 
                    `titulo`, 
                    `descripcion`, 
                    `orden`, 
                    `activo`, 
                    `usuario`, 
                    `ip_address`, 
                    `fecha_creacion`, 
                    `fecha_modificacion` 
                    FROM `xxbdo_areas_temp`;

                    -- query para clonar estandares, tabla temporal
                    CREATE TABLE `xxbdo_estandares_temp` 
                    SELECT `id` AS `prev_eid`, 
                    uuid_V4() AS `new_eid`, 
                    _new_version_id AS `new_vid`,
                    (SELECT `foto` FROM `xxbdo_estandares_fotos` 
                    WHERE `xxbdo_estandares_id`=`xxbdo_estandares`.`id`) AS efoto, 
                    `tipo`, 
                    `cr_plaza`, 
                    `cr_tienda`, 
                    `estandar`, 
                    `titulo`, 
                    `orden`, 
                    `detalle`, 
                    `descripcion`, 
                    `es_`, 
                    `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_estandares` 
                    WHERE `xxbdo_version_estandares_id` = _version_bdo_to_clone_id;

                    -- query para clonar estandares
                    INSERT INTO `xxbdo_estandares`
                    SELECT `new_eid`, 
                    `new_vid`, 
                    `tipo`, 
                    `cr_plaza`, 
                    `cr_tienda`, 
                    `estandar`, 
                    `titulo`, 
                    `orden`, 
                    `detalle`, 
                    `descripcion`, 
                    `es_`, 
                    `activo`, 
                    `usuario`, 
                    `ip_address`, 
                    `fecha_creacion`, 
                    `fecha_modificacion` 
                    FROM `xxbdo_estandares_temp`;

                    -- query para clonar `xxbdo_estandares_fotos`
                    INSERT INTO `xxbdo_estandares_fotos` 
                    SELECT uuid_V4() AS `nid`, 
                    `new_eid`, 
                    `efoto`, 
                    1 AS `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_estandares_temp` 
                    WHERE `efoto` IS NOT NULL;

                    -- query para clonar indicadores, tabla temporal
                    CREATE TABLE `xxbdo_indicadores_temp` 
                    SELECT  `id` AS `prev_id`, 
                    uuid_V4() AS `new_id`, 
                    _new_version_id AS `new_vid`, 
                    `tipo`, 
                    `cr_plaza`, 
                    `cr_tienda`, 
                    `titulo`, 
                    `descripcion`, 
                    `xxbdo_indicadores_frecuencias_id`, 
                    `orden`, 
                    `tipo_dato`, 
                    `default`, 
                    `foto`, 
                    `detalle`, 
                    1 AS `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_indicadores` 
                    WHERE `xxbdo_version_estandares_id`= _version_bdo_to_clone_id;

                    -- query para clonar indicadores
                    INSERT INTO `xxbdo_indicadores` 
                    SELECT `new_id`, 
                    `new_vid`, 
                    `tipo`, 
                    `cr_plaza`, 
                    `cr_tienda`, 
                    `titulo`, 
                    `descripcion`, 
                    `xxbdo_indicadores_frecuencias_id`, 
                    `orden`, 
                    `tipo_dato`, 
                    `default`, 
                    `foto`, 
                    `detalle`, 
                    `activo`, 
                    `usuario`, 
                    `ip_address`, 
                    `fecha_creacion`, 
                    `fecha_modificacion` 
                    FROM `xxbdo_indicadores_tmp`;

                    -- query para crear tabla temporal areas_estandares
                    CREATE TABLE `xxbdo_areas_estandares_temp` 
                    SELECT `id` AS `prev_aeid`, 
                    uuid_V4() AS `new_aeid`, 
                    `xxbdo_areas_id` AS `xxbdo_areas_prev_id`, 
                    NULL AS `xxbdo_areas_new_id`, 
                    `xxbdo_estandares_id` AS `xxbdo_estandares_prev_id`, 
                    NULL AS `xxbdo_estandares_new_id`, 
                    `valor`, 
                    `orden`, 
                    `dias_activos`, 
                    `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_areas_estandares` 
                    WHERE `xxbdo_areas_id` 
                    IN ( SELECT `id` 
                        FROM `xxbdo_areas` 
                        WHERE `xxbdo_version_estandares_id` = _version_bdo_to_clone_id
                    );

                    -- query para actualizar areas_estandares.areas_id
                    UPDATE `xxbdo_areas_estandares_temp`,
                    `xxbdo_areas_temp` 
                    SET `xxbdo_areas_estandares_temp`.`xxbdo_areas_new_id` = `xxbdo_areas_temp`.`new_id` 
                    WHERE `xxbdo_areas_estandares_temp`.`xxbdo_areas_prev_id` = `xxbdo_areas_temp`.`prev_id`;

                    -- query para actualizar areas_estandares.estandares_id
                    UPDATE `xxbdo_areas_estandares_temp`,
                    `xxbdo_estandares_temp` 
                    SET `xxbdo_areas_estandares_temp`.`xxbdo_estandares_new_id` = `xxbdo_estandares_temp`.`new_eid` 
                    WHERE `xxbdo_areas_estandares_temp`.`xxbdo_estandares_prev_id` = `xxbdo_estandares_temp`.`prev_eid`;
                    
                    -- query para crear tabla temporal areas_estandares
                    INSERT INTO `xxbdo_areas_estandares` 
                    SELECT `new_aeid`, 
                    `xxbdo_areas_new_id`, 
                    `xxbdo_estandares_new_id`, 
                    `valor`, 
                    `orden`, 
                    `dias_activos`, 
                    `activo`, 
                    `usuario`, 
                    `ip_address`, 
                    `fecha_creacion`, 
                    `fecha_modificacion`
                    FROM `xxbdo_areas_estandares_temp`; 

                    -- query para clonar `xxbdo_checklists_has_areas_estandares`
                    --
                    INSERT INTO `xxbdo_checklists_has_areas_estandares` 
                    SELECT _new_checklist_id AS xxbdo_checklists_id, 
                    id AS area_estandares_id, 
                    1 AS es_, 
                    1 AS activo, 
                    NULL as usuario, 
                    NULL as ip_address, 
                    NOW() as fecha_creacion, 
                    NOW() as fecha_modificacion 
                    FROM `xxbdo_areas_estandares` 
                    WHERE xxbdo_estandares_id IN ( 
                        SELECT id FROM `xxbdo_estandares` 
                        WHERE xxbdo_version_estandares_id = _new_version_id 
                        AND cr_plaza IS NULL 
                    );

                    -- queries para cambiar checklist default de tiendas:
                    UPDATE `xxbdo_checklists_tiendas` 
                    SET es_default = 0,
                    fecha_fin = _end_date_version_bdo_to_expire 
                    WHERE xxbdo_checklists_id = _checklist_to_expire_id;

                    -- Insertar registros en `xxbdo_checklists_tiendas` 
                    INSERT INTO `xxbdo_checklists_tiendas` 
                    SELECT _new_checklist_id AS `xxbdo_checklists_id`,
                    `cr_plaza`, 
                    `cr_tienda`, 
                    _new_version_id AS `xxbdo_version_estandares_id`, 
                    _titulo AS `titulo`, 
                    _descripcion AS `descripcion`, 
                    _titulo_app AS `titulo_app`, 
                    _titulo_indicadores_app AS `titulo_indicadores_app`, 
                    _start_date_new_version_bdo AS `fecha_inicio`, 
                    NULL AS `fecha_fin`, 
                    1 AS `es_default`, 
                    1 AS `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_tiendas`;

                    -- query para insertar registros en xxbdo_tiendas_has_areas_estandares:
                    INSERT INTO `xxbdo_tiendas_has_areas_estandares` 
                    SELECT `xxbdo_checklists_tiendas`.`cr_plaza`, 
                    `xxbdo_checklists_tiendas`.`cr_tienda`, 
                    `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`, 
                    `xxbdo_checklists_has_areas_estandares`.`xxbdo_areas_estandares_id`,
                    NULL AS `grupos_id`,
                    1 AS `es_`,
                    1 AS `activo`,
                    NULL AS `usuario`, 
                    NULL AS `ip_address`,
                    NOW() AS `fecha_creacion`,
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_checklists_tiendas`,
                    `xxbdo_checklists_has_areas_estandares`  
                    WHERE `xxbdo_checklists_tiendas`.`xxbdo_checklists_id` = _new_checklist_id 
                    AND `xxbdo_checklists_has_areas_estandares`.`xxbdo_checklists_id` = `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`;

                    -- Crear registros en tabla `xxbdo_areas_estandares_indicadores`
                    CREATE TABLE `xxbdo_areas_estandares_indicadores_temp`
                    SELECT `id` AS `prev_aeiid`, 
                    uuid_V4() AS `new_aeiid`, 
                    `xxbdo_areas_estandares_id` AS `xxbdo_areas_estandares_prev_id`, 
                    NULL AS `xxbdo_areas_estandares_new_id`,
                    `xxbdo_indicadores_id` AS `prev_indicadores_id`, 
                    NULL AS `new_indicadores_id`,
                    `orden`, 
                    `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_areas_estandares_indicadores`;

                    -- query para actualizar areas_estandares_indicadores.areas_estandares_id
                    UPDATE `xxbdo_areas_estandares_indicadores_temp`,
                    `xxbdo_areas_estandares_temp` 
                    SET `xxbdo_areas_estandares_indicadores_temp`.`xxbdo_areas_estandares_new_id` = `xxbdo_areas_estandares_temp`.`new_aeid` 
                    WHERE `xxbdo_areas_estandares_indicadores_temp`.`xxbdo_areas_estandares_prev_id` = `xxbdo_areas_estandares_temp`.`prev_aeid`;

                    -- query para actualizar areas_estandares_indicadores.indicadores_id
                    UPDATE `xxbdo_areas_estandares_indicadores_temp`,
                    `xxbdo_indicadores_temp` 
                    SET `xxbdo_areas_estandares_indicadores_temp`.`new_indicadores_id` = `xxbdo_indicadores_temp`.`new_id` 
                    WHERE `xxbdo_areas_estandares_indicadores_temp`.`prev_indicadores_id` = `xxbdo_indicadores_temp`.`prev_id`;

                    -- Insertar registros en `xxbdo_areas_estandares_indicadores`
                    INSERT INTO `xxbdo_areas_estandares_indicadores` 
                    SELECT `new_aeiid`, 
                    `xxbdo_areas_estandares_new_id`,
                    `new_indicadores_id`,
                    `orden`, 
                    `activo`, 
                    `usuario`, 
                    `ip_address`, 
                    `fecha_creacion`, 
                    `fecha_modificacion` 
                    FROM `xxbdo_areas_estandares_indicadores_temp`;

                    -- Crear registros en tabla `xxbdo_checklists_has_areas_estandares_indicadores`
                    INSERT INTO `xxbdo_checklists_has_areas_estandares_indicadores` 
                    SELECT _new_checklist_id AS checklists_id, 
                    `id` AS `areas_estandares_indicadores_id`, 
                    1 AS `es_`, 
                    1 AS `activo`, 
                    NULL as `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_areas_estandares_indicadores` 
                    WHERE `xxbdo_indicadores_id` IN ( 
                        SELECT `id` FROM `xxbdo_indicadores` 
                        WHERE `xxbdo_version_estandares_id` = _new_version_id  
                        AND `cr_plaza` IS NULL );

                    -- query para insertar registros en xxbdo_tiendas_has_areas_estandares_indicadores:
                    INSERT INTO `xxbdo_tiendas_has_areas_estandares_indicadores` 
                    SELECT `xxbdo_checklists_tiendas`.`cr_plaza`, 
                    `xxbdo_checklists_tiendas`.`cr_tienda`, 
                    `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`, 
                    `xxbdo_checklists_has_areas_estandares_indicadores`.`xxbdo_areas_estandares_indicadores_id`,
                    1 AS `es_`,
                    1 AS `activo`,
                    NULL AS `usuario`, 
                    NULL AS `ip_address`,
                    NOW() AS `fecha_creacion`,
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_checklists_tiendas`,
                    `xxbdo_checklists_has_areas_estandares_indicadores`  
                    WHERE `xxbdo_checklists_tiendas`.`xxbdo_checklists_id` = _new_checklist_id 
                    AND `xxbdo_checklists_has_areas_estandares_indicadores`.`xxbdo_checklists_id` = `xxbdo_checklists_tiendas`.`xxbdo_checklists_id`;

                    -- query para crear tabla estandares_alertas_temp
                    CREATE TABLE `xxbdo_estandares_alertas_temp` 
                    SELECT `id` AS `prev_id`, 
                    uuid_V4() AS `new_id`, 
                    `xxbdo_estandares_id` AS `xxbdo_estandares_prev_id`, 
                    NULL AS `xxbdo_estandares_new_id`, 
                    `minimo_fallas`, 
                    `es_consecutivo`, 
                    `orden`, 
                    `es_activa`, 
                    `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_estandares_alertas`;

                    -- query para actualizar areas_estandares.estandares_id
                    UPDATE `xxbdo_estandares_alertas_temp`,
                    `xxbdo_estandares_temp` 
                    SET `xxbdo_estandares_alertas_temp`.`xxbdo_estandares_new_id` = `xxbdo_estandares_temp`.`new_eid` 
                    WHERE `xxbdo_estandares_alertas_temp`.`xxbdo_estandares_prev_id` = `xxbdo_estandares_temp`.`prev_eid`;

                    -- query para clonar tabla estandares_alertas
                    INSERT INTO `xxbdo_estandares_alertas` 
                    SELECT `new_id`, 
                    `xxbdo_estandares_new_id`, 
                    `minimo_fallas`, 
                    `es_consecutivo`, 
                    `orden`, 
                    `es_activa`, 
                    `activo`, 
                    `usuario`, 
                    `ip_address`, 
                    `fecha_creacion`, 
                    `fecha_modificacion` 
                    FROM `xxbdo_estandares_alertas_temp`;

                    -- query para clonar `xxbdo_evop_configuracion`
                    INSERT INTO `xxbdo_evop_configuracion`
                    SELECT uuid_V4() AS `new_id`, 
                    _new_checklist_id AS `xxbdo_checklists_new_id`, 
                    `opcion`, 
                    `minimo`, 
                    `maximo`, 
                    `xxbdo_colores_id`, 
                    `es_activo`, 
                    `orden`, 
                    `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_evop_configuracion` 
                    WHERE `xxbdo_checklists_id` = _checklist_to_expire_id;

                    -- query para crear tabla temporal `xxbdo_evop_drivers_temp` 
                    CREATE TABLE `xxbdo_evop_drivers_temp` 
                    SELECT `id` AS `prev_id`, 
                    uuid_V4() AS `new_id`, 
                    `xxbdo_checklists_id` AS `xxbdo_checklists_prev_id`, 
                    _new_checklist_id AS `xxbdo_checklists_new_id`, 
                    `nombre`, 
                    `es_activo`, 
                    `orden`, 
                    `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_evop_drivers` 
                    WHERE `xxbdo_checklists_id` = _checklist_to_expire_id;

                    -- query para clonar tabla `xxbdo_evop_drivers`
                    INSERT INTO `xxbdo_evop_drivers` 
                    SELECT `new_id`, 
                    `xxbdo_checklists_new_id`, 
                    `nombre`, 
                    `es_activo`, 
                    `orden`, 
                    `activo`, 
                    NULL AS `usuario`, 
                    NULL AS `ip_address`, 
                    NOW() AS `fecha_creacion`, 
                    NOW() AS `fecha_modificacion` 
                    FROM `xxbdo_evop_drivers_temp`;

                    -- query para crear tabla temporal `xxbdo_evop_ponderacion_estandares_temp`
                    CREATE TABLE `xxbdo_evop_ponderacion_estandares_temp` 
                    SELECT `id` AS `prev_id`, 
                    uuid_V4() AS `new_id`, 
                    `xxbdo_checklists_id` AS `xxbdo_checklists_prev_id`, 
                    _new_checklist_id AS `xxbdo_checklists_new_id`, 
                    `xxbdo_estandares_id` AS `xxbdo_estandares_prev_id`, 
                    NULL AS `xxbdo_estandares_new_id`, 
                    `xxbdo_evop_drivers_id` AS `xxbdo_evop_drivers_prev_id`, 
                    NULL AS `xxbdo_evop_drivers_new_id`, 
                    `ponderacion`, 
                    `es_activo`, 
                    `orden`, 
                    `activo`, 
                    `usuario`, 
                    `ip_address`, 
                    `fecha_creacion`, 
                    `fecha_modificacion` 
                    FROM `xxbdo_evop_ponderacion_estandares` 
                    WHERE `xxbdo_checklists_id` = _checklist_to_expire_id;

                    -- query para actualizar `xxbdo_evop_ponderacion_estandares_temp`.xxbdo_estandares_id
                    UPDATE `xxbdo_evop_ponderacion_estandares_temp`,
                    `xxbdo_estandares_temp` 
                    SET `xxbdo_evop_ponderacion_estandares_temp`.`xxbdo_estandares_new_id` = `xxbdo_estandares_temp`.`new_eid` 
                    WHERE `xxbdo_evop_ponderacion_estandares_temp`.`xxbdo_estandares_prev_id` = `xxbdo_estandares_temp`.`prev_eid`;

                    -- query para actualizar `xxbdo_evop_ponderacion_estandares_temp`.`xxbdo_evop_drivers_id`
                    UPDATE `xxbdo_evop_ponderacion_estandares_temp`,
                    `xxbdo_evop_drivers_temp` 
                    SET `xxbdo_evop_ponderacion_estandares_temp`.`xxbdo_evop_drivers_new_id` = `xxbdo_evop_drivers_temp`.`new_eid` 
                    WHERE `xxbdo_evop_ponderacion_estandares_temp`.`xxbdo_evop_drivers_prev_id` = `xxbdo_evop_drivers_temp`.`prev_eid`;

                    -- query para clonar tabla `xxbdo_evop_ponderacion_estandares`
                    INSERT INTO `xxbdo_evop_ponderacion_estandares` 
                    SELECT `new_id`, 
                    `xxbdo_checklists_new_id`, 
                    `xxbdo_estandares_new_id`, 
                    `xxbdo_evop_drivers_new_id`, 
                    `ponderacion`, 
                    `es_activo`, 
                    `orden`, 
                    `activo`, 
                    `usuario`, 
                    `ip_address`, 
                    `fecha_creacion`, 
                    `fecha_modificacion` 
                    FROM `xxbdo_evop_ponderacion_estandares_temp`;

                    -- query para crear tabla temporal
                    CREATE TABLE `xxbdo_evop_promedios_drivers_temp`
                    SELECT `id` AS `prev_id`, 
                    uuid_V4() AS `new_id`, 
                    `xxbdo_checklists_id` AS `xxbdo_checklists_prev_id`, 
                    _new_checklist_id AS `xxbdo_checklists_new_id`, 
                    `xxbdo_evop_drivers_id` AS `xxbdo_evop_drivers_prev_id`, 
                    NULL AS `xxbdo_evop_drivers_new_id`, 
                    `minimo`, 
                    `maximo`, 
                    `xxbdo_colores_id`, 
                    `es_activo`, 
                    `orden`, 
                    `activo`, 
                    `usuario`, 
                    `ip_address`, 
                    `fecha_creacion`, 
                    `fecha_modificacion` 
                    FROM `xxbdo_evop_promedios_drivers` 
                    WHERE `xxbdo_checklists_id` = _checklist_to_expire_id;

                    -- query para actualizar `xxbdo_evop_promedios_drivers_temp`.`xxbdo_evop_drivers_id`
                    UPDATE `xxbdo_evop_promedios_drivers_temp`,
                    `xxbdo_evop_drivers_temp` 
                    SET `xxbdo_evop_promedios_drivers_temp`.`xxbdo_evop_drivers_new_id` = `xxbdo_evop_drivers_temp`.`new_eid` 
                    WHERE `xxbdo_evop_promedios_drivers_temp`.`xxbdo_evop_drivers_prev_id` = `xxbdo_evop_drivers_temp`.`prev_eid`;

                    -- query para clonar tabla `xxbdo_evop_promedios_drivers`
                    INSERT INTO `xxbdo_evop_promedios_drivers`
                    SELECT `new_id`, 
                    `xxbdo_checklists_new_id`, 
                    `xxbdo_evop_drivers_new_id`, 
                    `minimo`, 
                    `maximo`, 
                    `xxbdo_colores_id`, 
                    `es_activo`, 
                    `orden`, 
                    `activo`, 
                    `usuario`, 
                    `ip_address`, 
                    `fecha_creacion`, 
                    `fecha_modificacion` 
                    FROM `xxbdo_evop_promedios_drivers_temp`;

                    -- fin del proceso
                    SELECT "OK" AS `status`, 
                    @inicio_proceso AS `inicio`, 
                    NOW() AS `fin`, 
                    "Proceso terminado exitosamente." AS `mensaje`;
                END;
            END IF;
        END;
    END IF;
END$$


