-- nuevo query para reporte de captura de checklist por rango de fecha y plaza, sin ORDER BY:
CREATE TABLE xxbdo_reporte_bdo_Semana_40_2020 
SELECT `xxbdo_checklists`.`titulo_app` AS `version_bdo`,       
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
WHERE `xxbdo_respuestas`.`cr_plaza`='10VCZ'
AND `xxbdo_respuestas`.`año`='2020'
AND `xxbdo_areas_estandares`.`id`=`xxbdo_respuestas`.`xxbdo_areas_estandares_id`       
AND `xxbdo_estandares`.`id`=`xxbdo_areas_estandares`.`xxbdo_estandares_id`       
AND `xxbdo_areas`.`id`=`xxbdo_areas_estandares`.`xxbdo_areas_id`       
AND `xxbdo_checklists`.`id`=`xxbdo_respuestas`.`xxbdo_checklists_id`       
AND `xxbdo_areas`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id`       
AND `xxbdo_estandares`.`xxbdo_version_estandares_id`=`xxbdo_checklists`.`xxbdo_version_estandares_id`  
AND `xxbdo_respuestas`.`fecha_creacion` BETWEEN '2020-09-28 00:00:00' AND '2020-10-04 23:59:59';
