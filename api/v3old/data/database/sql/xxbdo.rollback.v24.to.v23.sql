-- Script to rollback v24 to v23

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- Indicadores
DELETE FROM `xxbdo_checklists_has_areas_estandares_indicadores` WHERE `xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877' ;

DELETE FROM `xxbdo_tiendas_has_areas_estandares_indicadores` WHERE `xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877' ;

DELETE FROM `xxbdo_respuestas_indicadores` WHERE `xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877' ;

DELETE FROM `xxbdo_areas_estandares_indicadores` WHERE `xxbdo_indicadores_id` IN (SELECT id FROM `xxbdo_indicadores` WHERE xxbdo_version_estandares_id='c817b538-1b4d-4901-9181-f89aaeb15171');

DELETE FROM `xxbdo_indicadores` WHERE `xxbdo_version_estandares_id` = 'c817b538-1b4d-4901-9181-f89aaeb15171';

-- Areas Estandares
DELETE FROM `xxbdo_tiendas_has_areas_estandares` WHERE `xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877' ;

DELETE FROM `xxbdo_checklists_tiendas` WHERE `xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877';

DELETE FROM `xxbdo_checklists_has_areas_estandares` WHERE `xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877';

DELETE FROM `xxbdo_observaciones` WHERE xxbdo_respuestas_id IN (SELECT id FROM `xxbdo_respuestas` WHERE `xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877' );

DELETE FROM `xxbdo_circulo_de_congruencia` WHERE `xxbdo_respuestas_id`IN(SELECT id FROM `xxbdo_respuestas` WHERE `xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877' );

DELETE FROM `xxbdo_respuestas` WHERE `xxbdo_checklists_id`='f767aea8-988c-4e36-9037-59660573b877';

DELETE FROM `xxbdo_areas_estandares` WHERE `xxbdo_estandares_id` IN (SELECT id FROM `xxbdo_estandares` WHERE `xxbdo_version_estandares_id` = 'c817b538-1b4d-4901-9181-f89aaeb15171');

DELETE FROM `xxbdo_estandares_fotos` WHERE `xxbdo_estandares_id` IN (SELECT id FROM `xxbdo_estandares` WHERE `xxbdo_version_estandares_id` = 'c817b538-1b4d-4901-9181-f89aaeb15171');

DELETE FROM `xxbdo_estandares` WHERE `xxbdo_version_estandares_id` = 'c817b538-1b4d-4901-9181-f89aaeb15171' ;

DELETE FROM `xxbdo_areas` WHERE `xxbdo_version_estandares_id` = 'c817b538-1b4d-4901-9181-f89aaeb15171';

DELETE FROM `xxbdo_checklists` WHERE id='f767aea8-988c-4e36-9037-59660573b877' ;

DELETE FROM `xxbdo_version_estandares` WHERE id='c817b538-1b4d-4901-9181-f89aaeb15171';

UPDATE `xxbdo_version_estandares` SET es_default=1, fecha_fin=NULL WHERE id='13d772fa-826b-424f-802e-63da4777e33c';

UPDATE `xxbdo_checklists` SET `fecha_fin` = NULL, `es_default` = '1' WHERE `xxbdo_checklists`.`id` = '3e50f58c-8634-41ce-93b5-c8bebb8bce46';

UPDATE `xxbdo_checklists_tiendas` SET es_default=1 WHERE xxbdo_checklists_id='3e50f58c-8634-41ce-93b5-c8bebb8bce46';

SET FOREIGN_KEY_CHECKS=1;
COMMIT;