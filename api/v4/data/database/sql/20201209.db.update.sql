-- -----------------------------------------------------
-- Name: SP_XXBDO_ROLLBACK_CLONED_VERSION_BDO
-- Description: Rollback proceso de clonar versión de BDO.
-- Input: id_version_bdo_to_rollback
-- Output: None
-- 
-- Example: 
-- CALL SP_XXBDO_ROLLBACK_CLONED_VERSION_BDO("589e2b55-4651-4f76-a35a-0abe2397c971");
-- 
-- version de prueba:
-- INSERT INTO `xxbdo_version_estandares` (`id`, `titulo`, `titulo_app`, `descripcion`, `es_default`, `fecha_inicio`, `fecha_fin`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES ('589e2b55-4651-4f76-a35a-0abe2397c971', 'Estándares Operativos Versión 27', 'Versión 27', 'Estándares Operativos BDO Versión 27', '1', '2021-01-01', NULL, '1', NULL, NULL, '2021-01-01 17:36:12', '2021-11-01 17:36:12'); 
--
-- checklist de prueba:
-- INSERT INTO `xxbdo_checklists` (`id`, `xxbdo_version_estandares_id`, `titulo`, `descripcion`, `titulo_app`, `titulo_indicadores_app`, `fecha_inicio`, `fecha_fin`, `es_default`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES ('9c7f64e7-ea4d-49ee-82b4-df38e3ddfa21', '589e2b55-4651-4f76-a35a-0abe2397c971', 'Estándares Operativos Versión 27', 'Estándares Operativos BDO Versión 27', 'Versión 27', 'Indicadores v27', '2021-01-01', NULL, '1', '1', NULL, NULL, '2021-01-01 17:36:12', '2021-01-01 17:36:12'); 
-- -----------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS `SP_XXBDO_ROLLBACK_CLONED_VERSION_BDO`//
CREATE PROCEDURE `SP_XXBDO_ROLLBACK_CLONED_VERSION_BDO`(
    IN _id_version_bdo_to_rollback VARCHAR(36)
    )
    COMMENT 'Rollback BDO Cloning Process.'
BEGIN
    DECLARE _id_checklist_to_rollback VARCHAR(36) DEFAULT NULL;
    DECLARE _id_version_previa VARCHAR(36) DEFAULT NULL;
    DECLARE _id_checklist_previo VARCHAR(36) DEFAULT NULL;

    START TRANSACTION;

    IF LENGTH(_id_version_bdo_to_rollback)<36 THEN 
        SELECT "ERROR" AS `status`, 
        NOW() AS `inicio`, 
        NOW() AS `fin`, 
        "ID de versión es incorrecto, intente nuevamente." AS `mensaje`;
    ELSE
        BEGIN
            -- Obtener checklist_id de version a rollback
            SELECT `id` INTO _id_checklist_to_rollback 
            FROM `xxbdo_checklists` 
            WHERE `xxbdo_version_estandares_id` = _id_version_bdo_to_rollback 
            LIMIT 1;

            IF LENGTH(_id_checklist_to_rollback)<36 THEN 
                SELECT "ERROR" AS `status`, 
                NOW() AS `inicio`, 
                NOW() AS `fin`, 
                "ID de versión de estándar no existente, intente nuevamente." AS `mensaje`;
            ELSE
                BEGIN
                    -- timestamp inicio proceso
                    SET @inicio_proceso = NOW();

                    -- query para borrar registros de circulo_de_congruencia:
                    -- DELETE FROM `xxbdo_circulo_de_congruencia` 
                    -- WHERE `xxbdo_respuestas_id` IN (
                    --     SELECT `id` 
                    --    FROM `xxbdo_respuestas` 
                    --     WHERE `xxbdo_checklists_id`= _id_checklist_to_rollback
                    -- );

                    -- query para borrar registros de observaciones:
                    -- DELETE FROM `xxbdo_observaciones` 
                    -- WHERE `xxbdo_respuestas_id` IN (
                    --     SELECT `id` 
                    --     FROM `xxbdo_respuestas` 
                    --     WHERE `xxbdo_checklists_id`= _id_checklist_to_rollback
                    -- );

                    -- query para borrar registros de:
                    -- DELETE FROM `xxbdo_respuestas` 
                    -- WHERE `xxbdo_checklists_id`= _id_checklist_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_respuestas_indicadores` 
                    WHERE `xxbdo_checklists_id`= _id_checklist_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_checklists_has_areas_estandares_indicadores` 
                    WHERE `xxbdo_checklists_id`= _id_checklist_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_checklists_has_areas_estandares` 
                    WHERE `xxbdo_checklists_id`= _id_checklist_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_tiendas_has_areas_estandares_indicadores` 
                    WHERE `xxbdo_checklists_id`= _id_checklist_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_tiendas_has_areas_estandares` 
                    WHERE `xxbdo_checklists_id`= _id_checklist_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_estandares_fotos` 
                    WHERE `xxbdo_estandares_id` IN ( 
                        SELECT `id` 
                        FROM `xxbdo_estandares` 
                        WHERE `xxbdo_version_estandares_id`= _id_version_bdo_to_rollback
                    );

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_checklists_tiendas` 
                    WHERE `xxbdo_checklists_id`= _id_checklist_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_areas_estandares_indicadores` 
                    WHERE `xxbdo_indicadores_id` IN (
                        SELECT `id` 
                        FROM `xxbdo_indicadores` 
                        WHERE `xxbdo_version_estandares_id`= _id_version_bdo_to_rollback
                    );

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_areas_estandares` 
                    WHERE `xxbdo_areas_id` IN (
                        SELECT `id` 
                        FROM `xxbdo_areas` 
                        WHERE `xxbdo_version_estandares_id`= _id_version_bdo_to_rollback 
                    );

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_indicadores` 
                    WHERE `xxbdo_version_estandares_id`= _id_version_bdo_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_estandares_alertas` 
                    WHERE `xxbdo_estandares_id` IN (
                        SELECT `id` FROM `xxbdo_estandares` 
                        WHERE `xxbdo_version_estandares_id`= _id_version_bdo_to_rollback
                    );

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_areas` 
                    WHERE `xxbdo_version_estandares_id`= _id_version_bdo_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_evop_configuracion` 
                    WHERE `xxbdo_checklists_id` = _id_checklist_to_rollback;

                    -- query para borrar registros de: 
                    DELETE FROM `xxbdo_evop_ponderacion_estandares` 
                    WHERE `xxbdo_checklists_id` = _id_checklist_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_evop_promedios_drivers` 
                    WHERE `xxbdo_checklists_id` = _id_checklist_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_evop_drivers` 
                    WHERE `xxbdo_checklists_id` = _id_checklist_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_estandares` 
                    WHERE `xxbdo_version_estandares_id`= _id_version_bdo_to_rollback;

                    -- query para borrar registros de:
                    DELETE FROM `xxbdo_checklists` 
                    WHERE `xxbdo_version_estandares_id`= _id_version_bdo_to_rollback;

                    -- query para obtener checklist previo:
                    SELECT `id` INTO _id_checklist_previo
                    FROM `xxbdo_checklists` 
                    ORDER BY `xxbdo_checklists`.`fecha_creacion` DESC 
                    LIMIT 1;

                    -- query para asignar checklist default:
                    UPDATE `xxbdo_checklists` 
                    SET `es_default`=1, 
                    `fecha_fin` = NULL 
                    WHERE `xxbdo_checklists`.`id` = _id_checklist_previo;

                    -- query para asignar checklist_tiendas default:
                    UPDATE `xxbdo_checklists_tiendas` 
                    SET `es_default`=1, 
                    `fecha_fin`=NULL 
                    WHERE `xxbdo_checklists_id` = _id_checklist_previo;

                    -- query para borrar version a rollback:
                    DELETE FROM `xxbdo_version_estandares` 
                    WHERE `id`= _id_version_bdo_to_rollback;

                    -- query para obtener id de version previa:
                    SELECT `id` 
                    INTO _id_version_previa 
                    FROM `xxbdo_version_estandares` 
                    ORDER BY `xxbdo_version_estandares`.`fecha_creacion` DESC 
                    LIMIT 1;

                    -- query para asignar version default:
                    UPDATE `xxbdo_version_estandares` 
                    SET `es_default`=1, 
                    `fecha_fin`=NULL 
                    WHERE `id`= _id_version_previa;

                    -- fin del proceso
                    SELECT "OK" AS `status`, 
                    @inicio_proceso AS `inicio`, 
                    NOW() AS `fin`, 
                    "Proceso terminado exitósamente." AS `mensaje`;
                END;
            END IF;
        END;
    END IF;

    COMMIT;

END//