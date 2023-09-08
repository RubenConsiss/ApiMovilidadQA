ALTER TABLE `xxbdo_v4`.`xxbdo_observaciones` 

ADD COLUMN `accion_responsable` TEXT NULL DEFAULT NULL AFTER `accion`,

ADD COLUMN `accion_fecha` DATE NULL DEFAULT NULL AFTER `accion_responsable`,

ADD COLUMN `accion_comentario` TEXT NULL DEFAULT NULL AFTER `accion_fecha`,

ADD COLUMN `turno_mañana` TINYINT(4) NULL DEFAULT NULL AFTER `turno`,

ADD COLUMN `turno_tarde` TINYINT(4) NULL DEFAULT NULL AFTER `turno_mañana`,

ADD COLUMN `turno_noche` TINYINT(4) NULL DEFAULT NULL AFTER `turno_tarde`,

CHANGE COLUMN `accion_responsable_fecha` `accion` TEXT NULL DEFAULT NULL;

UPDATE `xxbdo_observaciones` SET `turno_mañana`=1 WHERE turno='M';
UPDATE `xxbdo_observaciones` SET `turno_tarde`=1 WHERE turno='T';
UPDATE `xxbdo_observaciones` SET `turno_noche`=1 WHERE turno='N';

ALTER TABLE `xxbdo_v4`.`xxbdo_observaciones` 
DROP COLUMN `turno`;
