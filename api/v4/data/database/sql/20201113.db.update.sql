
-- -----------------------------------------------------
-- Name: SP_XXBDO_GET_LISTA_CONTROL_TARJETAS
-- Description: 
-- Input: cr_plaza, cr_tienda, fecha_inicio, fecha_fin
-- Output: Multiple rows:
-- 
-- Example: 
-- CALL SP_XXBDO_GET_LISTA_CONTROL_TARJETAS("10MON", "50VAZ", "2020-11-10", "2020-11-15");
-- -----------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS `SP_XXBDO_GET_LISTA_CONTROL_TARJETAS`//
CREATE PROCEDURE `SP_XXBDO_GET_LISTA_CONTROL_TARJETAS`(
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

END//

-- esta es la ultima prueba:
--    SELECT `xxbdo_tarjetas`.`numeracion` AS `tarjeta`, 
--    `xxbdo_tarjetas_tipo`.`nombre` AS `tipo`, 
--    `xxbdo_tarjetas_status`.`nombre` AS `status`,  
--    `xxbdo_roles_en_tienda`.`nombre` AS `agregada_por`, 
--    `xxbdo_tarjetas_status`.`opcion`,  
--    `xxbdo_tarjetas_status`.`color`,  
--    `xxbdo_tarjetas_status`.`es_tachado`,  
--    DATE_FORMAT(`xxbdo_tarjetas`.`fecha_registro`, "%Y-%m-%d") AS `fecha_registro`, 
--    DATE_FORMAT(`xxbdo_tarjetas`.`fecha_registro`, "%H:%i:%s") AS `hora_registro`, 
--    tabla2.`detalle_fecha` AS `fecha_modificacion`, 
--    tabla2.`detalle_hora` AS `hora_modificacion`, 
--    tabla2.`detalle_nombre_responsable` AS `responsable` 
--    FROM (`xxbdo_tarjetas`, 
--    `xxbdo_tarjetas_status`, 
--    `xxbdo_tarjetas_tipo`, 
--    `xxbdo_roles_en_tienda`) 
--    LEFT JOIN (
-- SELECT detalles.`xxbdo_tarjetas_entrega_id`,
-- `xxbdo_tarjetas_entrega`.`quien_entrega`,
-- `xxbdo_roles_en_tienda`.`nombre` AS `detalle_nombre_responsable`, 
-- DATE_FORMAT(`xxbdo_tarjetas_entrega`.`fecha_entrega`, "%Y-%m-%d") AS `detalle_fecha`, 
-- DATE_FORMAT(`xxbdo_tarjetas_entrega`.`fecha_entrega`, "%H:%i:%s") AS `detalle_hora`, 
-- detalles.`xxbdo_tarjetas_id`, 
-- detalles.`xxbdo_tarjetas_status_id`, 
-- `xxbdo_tarjetas_status`.`nombre` AS `status`
-- FROM (`xxbdo_tarjetas_entrega_detalle` detalles,
-- `xxbdo_tarjetas_entrega`,
-- `xxbdo_tarjetas_status`,
-- `xxbdo_roles_en_tienda`) 
-- LEFT JOIN `xxbdo_tarjetas_entrega_detalle` detalle 
-- ON (
--     detalles.`xxbdo_tarjetas_id` = detalle.`xxbdo_tarjetas_id` 
--     AND detalles.fecha_creacion < detalle.fecha_creacion
-- ) 
-- WHERE detalles.`xxbdo_tarjetas_entrega_id` = `xxbdo_tarjetas_entrega`.`id` 
-- AND detalles.`xxbdo_tarjetas_status_id` 
-- IN (SELECT `id` FROM `xxbdo_tarjetas_status` WHERE `opcion` IN("OK", "F", "X")) 
--  AND `xxbdo_tarjetas_entrega`.`cr_plaza` = "10MON" 
--   AND `xxbdo_tarjetas_entrega`.`cr_tienda` = "50VAZ" 
-- AND `xxbdo_tarjetas_entrega`.`quien_entrega` = `xxbdo_roles_en_tienda`.`id` 
-- AND detalles.`xxbdo_tarjetas_status_id` = `xxbdo_tarjetas_status`.`id` 
-- AND detalle.`xxbdo_tarjetas_id` IS NULL
--    ) tabla2 
--    ON (tabla2.`xxbdo_tarjetas_id` = `xxbdo_tarjetas`.`id`)
--    WHERE `xxbdo_tarjetas`.`cr_plaza`= "10MON"  
--    AND `xxbdo_tarjetas`.`cr_tienda`= "50VAZ" 
--    AND DATE(`xxbdo_tarjetas`.`fecha_registro`) 
--    BETWEEN DATE("2020-11-01") 
--    AND DATE("2020-11-15") 
--    AND `xxbdo_tarjetas`.`es_activo` = 1 
--    AND `xxbdo_tarjetas`.`activo` = 1 
--    AND `xxbdo_tarjetas_tipo`.`id` = `xxbdo_tarjetas`.`xxbdo_tarjetas_tipo_id` 
--    AND `xxbdo_tarjetas_status`.`id` = `xxbdo_tarjetas`.`xxbdo_tarjetas_status_id` 
--    AND `xxbdo_tarjetas`.`agregada_por` = `xxbdo_roles_en_tienda`.`id`;


-- query para obtener solo el ultimo registro del detalle de tarjeta:
-- CREATE OR REPLACE VIEW vista_xxbdo_tarjetas_entrega_detalle AS
-- SELECT detalles.`xxbdo_tarjetas_id`, 
-- detalles.`xxbdo_tarjetas_status_id`, 
-- `xxbdo_tarjetas_status`.`nombre` AS `status`,
-- detalles.`xxbdo_tarjetas_entrega_id`,
-- `xxbdo_tarjetas_entrega`.`quien_entrega`,
-- `xxbdo_roles_en_tienda`.`nombre` AS `detalle_nombre_responsable`, 
-- DATE_FORMAT(`xxbdo_tarjetas_entrega`.`fecha_entrega`, "%Y-%m-%d") AS `detalle_fecha`, 
-- DATE_FORMAT(`xxbdo_tarjetas_entrega`.`fecha_entrega`, "%H:%i:%s") AS `detalle_hora` 
-- FROM (`xxbdo_tarjetas_entrega_detalle` detalles,
-- `xxbdo_tarjetas_entrega`,
-- `xxbdo_tarjetas_status`,
-- `xxbdo_roles_en_tienda`) 
-- LEFT JOIN `xxbdo_tarjetas_entrega_detalle` detalle 
-- ON (
--     detalles.`xxbdo_tarjetas_id` = detalle.`xxbdo_tarjetas_id` 
--     AND detalles.fecha_creacion < detalle.fecha_creacion
-- ) 
-- WHERE detalles.`xxbdo_tarjetas_entrega_id` = `xxbdo_tarjetas_entrega`.`id` 
-- AND detalles.`xxbdo_tarjetas_status_id` IN(SELECT `id` FROM `xxbdo_tarjetas_status` WHERE `opcion` IN("OK", "F", "X")) 
-- AND `xxbdo_tarjetas_entrega`.`quien_entrega` = `xxbdo_roles_en_tienda`.`id` 
-- AND detalles.`xxbdo_tarjetas_status_id` = `xxbdo_tarjetas_status`.`id` 
-- AND detalle.`xxbdo_tarjetas_id` IS NULL ;


-- ------------------------------------------

    -- query inicial dummy
--    SELECT `xxbdo_tarjetas`.`numeracion` AS `tarjeta`, 
--    `xxbdo_tarjetas_tipo`.`nombre` AS `tipo`, 
--    `xxbdo_tarjetas_status`.`nombre` AS `status`,  
--    `xxbdo_roles_en_tienda`.`nombre` AS `agregada_por`, 
--    `xxbdo_tarjetas_status`.`opcion`,  
--    `xxbdo_tarjetas_status`.`color`,  
--    `xxbdo_tarjetas_status`.`es_tachado`,  
--    DATE_FORMAT(`xxbdo_tarjetas`.`fecha_registro`, "%Y-%i-%d") AS `fecha_registro`, 
--    DATE_FORMAT(`xxbdo_tarjetas`.`fecha_registro`, "%T") AS `hora_registro`, 
--    NULL AS `fecha_modificacion`, 
--    NULL AS `hora_modificacion`, 
--    NULL AS `responsable` 
--    FROM `xxbdo_tarjetas`, 
--    `xxbdo_tarjetas_status`, 
--    `xxbdo_tarjetas_tipo`, 
--    `xxbdo_roles_en_tienda` 
--    WHERE `xxbdo_tarjetas`.`cr_plaza`= _cr_plaza  
--    AND `xxbdo_tarjetas`.`cr_tienda`= _cr_tienda 
--    AND DATE(`xxbdo_tarjetas`.`fecha_registro`) 
--    BETWEEN DATE(_fecha_inicio) 
--    AND DATE(_fecha_fin) 
--    AND `xxbdo_tarjetas`.`es_activo` = 1 
--    AND `xxbdo_tarjetas`.`activo` = 1 
--    AND `xxbdo_tarjetas_tipo`.`id` = `xxbdo_tarjetas`.`xxbdo_tarjetas_tipo_id` 
--   AND `xxbdo_tarjetas_status`.`id` = `xxbdo_tarjetas`.`xxbdo_tarjetas_status_id` 
--    AND `xxbdo_tarjetas`.`agregada_por` = `xxbdo_roles_en_tienda`.`id`;


-- query inicial obtener detalles de tarjeta:
-- SELECT `xxbdo_tarjetas_id`, 
-- `xxbdo_roles_en_tienda`.`nombre` AS `responsable`, 
-- `xxbdo_tarjetas_entrega`.`fecha_entrega`,
--  `xxbdo_tarjetas_status`.`nombre` AS `status`
-- FROM `xxbdo_tarjetas_entrega_detalle`,
-- `xxbdo_tarjetas_entrega`,
-- `xxbdo_tarjetas_status`,
-- `xxbdo_roles_en_tienda` 
-- WHERE `xxbdo_tarjetas_entrega_id` = `xxbdo_tarjetas_entrega`.`id` 
-- AND `xxbdo_tarjetas_status_id` IN(SELECT `id` FROM `xxbdo_tarjetas_status` WHERE `opcion` IN("OK", "F")) 
-- AND `xxbdo_tarjetas_entrega`.`quien_entrega` = `xxbdo_roles_en_tienda`.`id` 
-- AND `xxbdo_tarjetas_entrega_detalle`.`xxbdo_tarjetas_status_id` = `xxbdo_tarjetas_status`.`id`

