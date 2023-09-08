
-- -----------------------------------------------------
-- Name: SP_XXBDO_ADD_TARJETA
-- Description: 
-- Input: cr_plaza, cr_tienda, tarjeta_tipo_id, agregada_por, numeracion, fecha_registro, usuario, ip_address
-- Output: tarjeta_id
-- 
-- Example: 
-- CALL SP_XXBDO_ADD_TARJETA("10MON", "50VAZ", "4682d43d-8db8-4453-8d97-26afa488cee0", "6975ca63-6138-47d0-9456-677bc94b02d7", "4766840583619374", "2020-11-18 08:30:15", "usuario", "127.0.0.1");
-- -----------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS `SP_XXBDO_ADD_TARJETA`//
CREATE PROCEDURE `SP_XXBDO_ADD_TARJETA`(
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

END//
