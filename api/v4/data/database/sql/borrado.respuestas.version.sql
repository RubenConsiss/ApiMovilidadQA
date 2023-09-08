
use xxbdo_production_202011250917;

--Borrado de observaciones --

DELETE FROM xxbdo_observaciones where xxbdo_respuestas_id IN(SELECT id FROM xxbdo_respuestas where xxbdo_checklists_id = (Select id from xxbdo_checklists where xxbdo_checklists.es_default = 1));


--Borrado de circulo de congruencia

DELETE FROM xxbdo_circulo_de_congruencia where xxbdo_respuestas_id IN(SELECT id FROM xxbdo_respuestas where xxbdo_checklists_id = (Select id from xxbdo_checklists where xxbdo_checklists.es_default = 1));


--Por ultimo es el borrado de respuestas

DELETE FROM xxbdo_respuestas where xxbdo_checklists_id = (Select id from xxbdo_checklists where xxbdo_checklists.es_default = 1)