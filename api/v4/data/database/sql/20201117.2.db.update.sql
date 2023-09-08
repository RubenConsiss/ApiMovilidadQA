
-- -----------------------------------------------------
-- Name: SP_XXBDO_ENTREGAR_TARJETAS
-- Description: 
-- Inputs: 
-- -- cr_plaza : VARCHAR 
-- -- cr_tienda : VARCHAR 
-- -- quien_entrega : VARCHAR 
-- -- quien_recibe : VARCHAR 
-- -- fecha_entrega : VARCHAR
-- -- tarjetas_data: JSON
-- -- usuario : VARCHAR
-- -- ip_address : VARCHAR
-- Output: tarjeta_id
-- 
-- Example: 
-- CALL SP_XXBDO_ENTREGAR_TARJETAS("10MON", "50VAZ", "2020-11-18 08:30:00", '<json_entregas>' , "usuario", "127.0.0.1");

-- use the following format for "<json_entregas>", example:
-- {"entrega":"42af79a1-6646-4a47-a13e-9eff84149ebc","recibe":"72624c71-2115-4ea6-b6e7-a69d7dfcd7e0","tarjetas":[{"id":"086c1f2f-cdc8-4940-89ae-0676a73b179a","status":"4857a6dd-10ed-4a4a-90ea-e8722bb3a9a7"},{"id":"9479512d-1916-4c90-86d2-dababa5d7a5c","status":"4857a6dd-10ed-4a4a-90ea-e8722bb3a9a7"},{"id":"c5b0d5e5-b354-4f62-a0d4-f4ed0701a41c","status":"442b6ea6-838f-48ca-accc-a7eea7372bb6"},{"id":"29bc236f-2ebf-47cf-89d0-9f8980017bbe","status":"4857a6dd-10ed-4a4a-90ea-e8722bb3a9a7"}]}
-- -----------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS `SP_XXBDO_ENTREGAR_TARJETAS`//
CREATE PROCEDURE `SP_XXBDO_ENTREGAR_TARJETAS`(
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

END//