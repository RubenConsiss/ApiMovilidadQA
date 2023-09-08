
-- -----------------------------------------------------
-- Name: SP_XXMET_RPT_USO_SEMANAL_APP
-- Description: Obtener registros para el reporte de uso semanal de la App Movilidad en Tienda.
-- Input: Fecha_inicio, Fecha_Fin
-- Output: Select result set
-- 
-- Example: 
-- CALL SP_XXMET_RPT_USO_SEMANAL_APP("2020-11-03 00:00:00", "2020-11-03 23:59:59");
-- -----------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS `SP_XXMET_RPT_USO_SEMANAL_APP`//
CREATE PROCEDURE `SP_XXMET_RPT_USO_SEMANAL_APP`(
    IN _fecha_inicio VARCHAR(20),
    IN _fecha_fin VARCHAR(20)
    )
    COMMENT 'Reporte Semanal de uso App Movilidad En Tienda'
BEGIN
    SELECT `cr_plaza` AS `PLAZA`, 
    `cr_tienda` AS `TIENDA`, 
    `device_name` AS `DISPOSITIVO`, 
    `device_type` AS `TIPO`, 
    `ip_address` AS `IP_ADDRESS`, 
    `module` AS `MODULO`, 
    `activity` AS `PANTALLA`, 
    `action` AS `ACCION`, 
    `method` AS `METODO`, 
    `user` AS `USUARIO`, 
    DATE(`creation`) as `FECHA`, 
    TIME(`creation`) AS `HORA`, 
    `app_version` AS `APP_VERSION` 
    FROM `xxmet_logs` 
    WHERE DATE(`creation`) 
    BETWEEN DATE(_fecha_inicio) 
    AND DATE(_fecha_fin);
END//