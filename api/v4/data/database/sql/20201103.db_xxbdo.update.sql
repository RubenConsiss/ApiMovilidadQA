
-- -----------------------------------------------------
-- Name: SP_XXBDO_CREATE_TBL_RPT_BDO_SEMANAL_POR_PLAZA
-- Description: Crear tabla temporal para obtener reporte de captura semanal de BDO por plaza.
-- Input: cr_plaza, numero_de_semana, año, fecha_inicio, fecha_fin
-- Output: Single row with: STATUS, MESSAGE
-- 
-- Example: 
-- CALL SP_XXBDO_CREATE_TBL_RPT_BDO_SEMANAL_POR_PLAZA("10MON", "43", "2020", "2020-10-19 00:00:00", "2020-10-25 23:59:59");
-- -----------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS `SP_XXBDO_CREATE_TBL_RPT_BDO_SEMANAL_POR_PLAZA`//
CREATE PROCEDURE `SP_XXBDO_CREATE_TBL_RPT_BDO_SEMANAL_POR_PLAZA`(
    IN _cr_plaza VARCHAR(10),
    IN _num_semana VARCHAR(2),
    IN _num_year VARCHAR(4),
    IN _fecha_inicio VARCHAR(20),
    IN _fecha_fin VARCHAR(20)
    )
    COMMENT 'Crear tabla temporal del reporte semanal de uso app Movilidad En Tienda'
BEGIN

    SET @inicio = NOW();
    SET @tbl_name = CONCAT("xxbdo_reporte_bdo_", _cr_plaza, "_semana_", _num_semana, "_", _num_year);

    SET @query = CONCAT("CREATE TABLE IF NOT EXISTS ", @tbl_name,
    " SELECT `xxbdo_checklists`.`titulo_app` AS `version_bdo`, 
    `xxbdo_respuestas`.`cr_plaza`,
    `xxbdo_respuestas`.`cr_tienda`,
    `xxbdo_areas`.`titulo` AS `area_titulo`,       
    `xxbdo_estandares`.`estandar` AS `estandar`,       
    `xxbdo_estandares`.`titulo` AS `estandar_titulo`,       
    IF(`xxbdo_respuestas`.`tipo`='D','DIARIO', (IF(`xxbdo_respuestas`.`tipo`='S', 'SEMANAL', (IF(`xxbdo_respuestas`.`tipo`='M', 'MENSUAL',''))))) AS `tipo_estandar`,           
    IF(`xxbdo_respuestas`.`respuesta`='K','OK',`xxbdo_respuestas`.`respuesta`) AS `respuesta_lider`,      
    `xxbdo_respuestas`.`fecha_respuesta`,  
    `xxbdo_respuestas`.`año` AS `respuesta_año`,  
    `xxbdo_respuestas`.`semana` AS `respuesta_semana`,  
    `xxbdo_respuestas`.`mes` AS `respuesta_mes`,  
    `xxbdo_observaciones`.`descripcion` AS `observacion_descripcion`,
    `xxbdo_observaciones`.`causa`  AS `observacion_causa`,
    `xxbdo_observaciones`.`accion`  AS `observacion_accion`,
    `xxbdo_observaciones`.`accion_responsable`  AS `observacion_accion_responsable`,
    `xxbdo_observaciones`.`accion_fecha`  AS `observacion_accion_fecha`,
    IF(`xxbdo_observaciones`.`requiere_ajuste_ata`='1','SI',(IF(`xxbdo_observaciones`.`requiere_ajuste_ata`='0','NO','')))  AS `observacion_requiere_ajuste_ata`,
    IF(`xxbdo_observaciones`.`realizaron_plan_accion`='1','SI',(IF(`xxbdo_observaciones`.`realizaron_plan_accion`='0','NO','')))  AS `observacion_realizaron_plan_accion`,
    IF(`xxbdo_observaciones`.`resolvio_problema`='1','SI',(IF(`xxbdo_observaciones`.`resolvio_problema`='0','NO','')))  AS `observacion_se_resolvio_problema`,
    `xxbdo_observaciones`.`observacion`  AS `observacion_nota_asesor`,
    `xxbdo_observaciones`.`folio` AS `observacion_folio`,       
    IF(`xxbdo_observaciones`.`turno_mañana`='1','SI','') AS `observacion_turno_mañana`,
    IF(`xxbdo_observaciones`.`turno_tarde`='1','SI','') AS `observacion_turno_tarde`,       
    IF(`xxbdo_observaciones`.`turno_noche`='1','SI','') AS `observacion_turno_noche` ,
    `xxbdo_circulo_de_congruencia`.`fecha` AS `circulo_de_congruencia_fecha`,
    `xxbdo_circulo_de_congruencia`.`comentario` AS `circulo_de_congruencia_comentario`,
    `xxbdo_respuestas`.`fecha_creacion`,
    `xxbdo_respuestas`.`usuario`,
    `xxbdo_respuestas`.`ip_address` 
    FROM (`xxbdo_respuestas`,       
    `xxbdo_areas_estandares`,
    `xxbdo_estandares`,       
    `xxbdo_areas`,       
    `xxbdo_checklists`)  
    LEFT OUTER JOIN `xxbdo_observaciones`       
    ON (`xxbdo_observaciones`.`xxbdo_respuestas_id` = `xxbdo_respuestas`.`id`) 
    LEFT OUTER JOIN `xxbdo_circulo_de_congruencia`       
    ON (`xxbdo_circulo_de_congruencia`.`xxbdo_respuestas_id` = `xxbdo_respuestas`.`id`)       
    WHERE `xxbdo_respuestas`.`cr_plaza`= '", _cr_plaza, "' 
    AND `xxbdo_areas_estandares`.`id`=`xxbdo_respuestas`.`xxbdo_areas_estandares_id`       
    AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id`       
    AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id`       
    AND `xxbdo_checklists`.`id`=`xxbdo_respuestas`.`xxbdo_checklists_id`       
    AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id`       
    AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id`  
    AND DATE(`xxbdo_respuestas`.`fecha_creacion`) BETWEEN DATE('", _fecha_inicio, "') AND DATE('", _fecha_fin, "')");

    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @fin = NOW();

    SELECT @inicio AS inicio, @fin AS fin;

END//




-- -----------------------------------------------------
-- Name: SP_XXBDO_GET_RPT_BDO_SEMANAL_POR_PLAZA
-- Description: Obtener registros para el reporte de captura de checklist por plaza.
-- Input: cr_plaza, num_semana, num_año
-- Output: Select result set
-- 
-- Example: 
-- CALL SP_XXBDO_GET_RPT_BDO_SEMANAL_POR_PLAZA("10MON", "43", "2020");
-- -----------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS `SP_XXBDO_GET_RPT_BDO_SEMANAL_POR_PLAZA`//
CREATE PROCEDURE `SP_XXBDO_GET_RPT_BDO_SEMANAL_POR_PLAZA`(
    IN _cr_plaza VARCHAR(10),
    IN _num_semana VARCHAR(2),
    IN _num_year VARCHAR(4)
    )
    COMMENT 'Reporte Semanal de captura de checklist por plaza.'
BEGIN

    SET @tbl_name = CONCAT("xxbdo_reporte_bdo_", _cr_plaza, "_semana_", _num_semana, "_", _num_year);

    SET @query = CONCAT("SELECT * FROM ", @tbl_name);

    PREPARE stmt FROM @query;

    EXECUTE stmt;

    DEALLOCATE PREPARE stmt;

END//


-- -----------------------------------------------------
-- Name: SP_XXBDO_DELETE_RPT_BDO_SEMANAL_POR_PLAZA
-- Description: Borra tabla del reporte de captura de checklist por plaza.
-- Input: cr_plaza, num_semana, num_año
-- Output: None
-- 
-- Example: 
-- CALL SP_XXBDO_DELETE_RPT_BDO_SEMANAL_POR_PLAZA("10MON", "43", "2020");
-- -----------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS `SP_XXBDO_DELETE_RPT_BDO_SEMANAL_POR_PLAZA`//
CREATE PROCEDURE `SP_XXBDO_DELETE_RPT_BDO_SEMANAL_POR_PLAZA`(
    IN _cr_plaza VARCHAR(10),
    IN _num_semana VARCHAR(2),
    IN _num_year VARCHAR(4)
    )
    COMMENT 'Borrar la tabla del reporte Semanal de captura de checklist por plaza.'
BEGIN

    SET @tbl_name = CONCAT("xxbdo_reporte_bdo_", _cr_plaza, "_semana_", _num_semana, "_", _num_year);

    SET @query = CONCAT("DROP TABLE ", @tbl_name);

    PREPARE stmt FROM @query;

    EXECUTE stmt;

    DEALLOCATE PREPARE stmt;

END//