-- 
-- Queries utilizados para instalar en BD de producción
-- XXBDO el soporte para configuración de acceso a
-- módulos
-- 

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Base de datos: `xxbdo`
--

-- Views definition:
CREATE OR REPLACE VIEW vista_xxbdo_modulos  
AS SELECT `xxbdo_modulos`.`id`, 
`xxbdo_modulos`.`nombre`, 
`xxbdo_modulos`.`codigo`, 
`xxbdo_modulos`.`descripcion`, 
IF(`xxbdo_modulos`.`es_activo`,'SI','NO') AS `modulo_activo`, 
IF(`xxbdo_modulos`.`es_visible`,'SI','NO') AS `modulo_visible`,
`xxbdo_modulos`.`es_activo`, 
`xxbdo_modulos`.`es_visible`,
`xxbdo_modulos`.`orden`,
`xxbdo_modulos`.`activo` 
FROM `xxbdo_modulos`;

CREATE OR REPLACE VIEW `vista_xxbdo_modulos_por_plaza` 
AS SELECT `xxbdo_modulos_por_plaza`.`id`, 
`xxbdo_modulos_por_plaza`.`cr_plaza`, 
`xxbdo_modulos`.`nombre` AS `nombre_modulo`, 
`xxbdo_modulos`.`codigo`, 
IF(`xxbdo_modulos_por_plaza`.`es_activo`,'SI','NO') AS `modulo_activo`,
IF(`xxbdo_modulos_por_plaza`.`es_visible`, 'SI', 'NO') AS `modulo_visible`, 
`xxbdo_modulos_por_plaza`.`es_activo`,
`xxbdo_modulos_por_plaza`.`es_visible`,
`xxbdo_modulos_por_plaza`.`orden`,
`xxbdo_modulos_por_plaza`.`activo` 
FROM `xxbdo_modulos_por_plaza`, `xxbdo_modulos` 
WHERE `xxbdo_modulos_por_plaza`.`xxbdo_modulos_id` = `xxbdo_modulos`.`id`;

CREATE OR REPLACE VIEW `vista_xxbdo_modulos_por_tienda` 
AS SELECT `xxbdo_modulos_por_tienda`.`id`, 
`xxbdo_modulos_por_tienda`.`cr_plaza`, 
`xxbdo_modulos_por_tienda`.`cr_tienda`, 
`xxbdo_modulos`.`nombre` AS `nombre_modulo`, 
`xxbdo_modulos`.`codigo`, 
IF(`xxbdo_modulos_por_tienda`.`es_activo`,'SI','NO') AS `modulo_activo`,
IF(`xxbdo_modulos_por_tienda`.`es_visible`, 'SI', 'NO') AS `modulo_visible`, 
`xxbdo_modulos_por_tienda`.`es_activo`,
`xxbdo_modulos_por_tienda`.`es_visible`, 
`xxbdo_modulos_por_tienda`.`orden`, 
`xxbdo_modulos_por_tienda`.`activo` 
FROM `xxbdo_modulos_por_tienda`, `xxbdo_modulos` 
WHERE `xxbdo_modulos_por_tienda`.`xxbdo_modulos_id` = `xxbdo_modulos`.`id`;



-- --------------------------------------------------------
--
-- 507GK Cordoba Ixtaltepec VER Maira Garcia
--
INSERT INTO `xxbdo_modulos_por_tienda` (`id`, `cr_plaza`, `cr_tienda`, `xxbdo_modulos_id`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
--  'Compra'
('a6d52aa8-647a-4e42-9d44-12b14ee91097', '10VCZ', '507GK', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', '1', '1', '10', '1', NULL, NULL, NOW(), NOW()),
--  'Generación'
('c007b279-8329-4a45-a4d4-e9af967b06c6', '10VCZ', '507GK', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', '1', '1', '11', '1', NULL, NULL, NOW(), NOW()),
--  'Recepción'
('4cc2a2fd-5b49-4505-9dd9-5d68d447604a', '10VCZ', '507GK', '26580c8b-a7ff-4bf5-a34c-8028068bceac', '1', '1', '12', '1', NULL, NULL, NOW(), NOW()),
--  'BDO'
('c4b3b76e-8adc-4376-83a0-9d5d83e718a9', '10VCZ', '507GK', '95909efd-2f72-4389-888c-c3e2dda067dc', '1', '1', '13', '1', NULL, NULL, NOW(), NOW()),
--  'Preinventarios'
('e15b56e1-c9bd-4692-ac6e-72af7230d3ec', '10VCZ', '507GK', 'fb2368e7-242c-490e-84dd-a47a95002473', '1', '1', '14', '1', NULL, NULL, NOW(), NOW()),
--  'Etiqueteo'
('78e735a5-3e63-4f11-bd9a-da6925e83241', '10VCZ', '507GK', '68e44875-fd0e-4cd1-b048-dacfc20c355f', '1', '1', '15', '1', NULL, NULL, NOW(), NOW()),
--  'Portales'
('bed84dca-1e4d-47a7-ac2c-04dec095c270', '10VCZ', '507GK', '255a55a3-ae5a-4240-889e-d1c93b8460b7', '1', '1', '16', '1', NULL, NULL, NOW(), NOW()),
--  'Calendario'
('567ea3e8-f6e8-4649-836b-39fd6a78bb31', '10VCZ', '507GK', '8031e15a-7096-4430-90ec-6209fbffbcbc', '1', '1', '17', '1', NULL, NULL, NOW(), NOW()),
--  'Indicadores'
('9add37ec-b227-4be5-baec-4777e205d468', '10VCZ', '507GK', '417b4991-1a5e-4ae7-ab5d-e58117902607', '1', '1', '18', '1', NULL, NULL, NOW(), NOW()),
--  'Pendientes'
('563704a8-5f58-4f7e-965a-30f6a8f6fa1b', '10VCZ', '507GK', '018161c8-922a-477d-8a0d-21e318cd26c4', '1', '1', '19', '1', NULL, NULL, NOW(), NOW()),
--  'Corte Z'
('080009fc-2861-4877-9168-37508429dd55', '10VCZ', '507GK', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', '1', '1', '20', '1', NULL, NULL, NOW(), NOW()),
--  'Utensilios'
('001a22a1-9d9e-4521-aeb9-97f9cb06ccc3', '10VCZ', '507GK', '7223d9dc-e0a4-466b-a023-89a8c56bb327', '1', '1', '21', '1', NULL, NULL, NOW(), NOW()),
--  'Rol de Preinventarios'
('92ef7b27-f4c7-4e43-be68-dca2ab2fd356', '10VCZ', '507GK', 'd3060505-308e-4341-9966-8fcda411b68e', '1', '1', '22', '1', NULL, NULL, NOW(), NOW()),
--  'Reclutamiento'
('87593396-9284-473d-854f-72d46583f2eb', '10VCZ', '507GK', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', '1', '1', '23', '1', NULL, NULL, NOW(), NOW()),
--  'Merma de café'
('256d8c54-83c5-489b-9449-bc02b41ff53a', '10VCZ', '507GK', '3a8910a1-10f7-452f-a870-9a108ee741de', '0', '0', '24', '1', NULL, NULL, NOW(), NOW());


-- --------------------------------------------------------
--
-- 50SSO Cordoba Libertad VER Maira Garcia
--
INSERT INTO `xxbdo_modulos_por_tienda` (`id`, `cr_plaza`, `cr_tienda`, `xxbdo_modulos_id`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
--  'Compra'
('2dbb3a47-6c7f-42e1-8c46-ab6255287abb', '10VCZ', '50SSO', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', '1', '1', '10', '1', NULL, NULL, NOW(), NOW()),
--  'Generación'
('685bb10f-3cc6-44d8-8d8f-1b2f9457fe8e', '10VCZ', '50SSO', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', '1', '1', '11', '1', NULL, NULL, NOW(), NOW()),
--  'Recepción'
('d3305d37-c97d-47d9-9d20-a985d23be4b2', '10VCZ', '50SSO', '26580c8b-a7ff-4bf5-a34c-8028068bceac', '1', '1', '12', '1', NULL, NULL, NOW(), NOW()),
--  'BDO'
('24fdd92c-5dc0-4982-880b-55222af296bd', '10VCZ', '50SSO', '95909efd-2f72-4389-888c-c3e2dda067dc', '1', '1', '13', '1', NULL, NULL, NOW(), NOW()),
--  'Preinventarios'
('9748fb6d-8162-4e93-97e3-f6d6c364ce99', '10VCZ', '50SSO', 'fb2368e7-242c-490e-84dd-a47a95002473', '1', '1', '14', '1', NULL, NULL, NOW(), NOW()),
--  'Etiqueteo'
('e2343bae-2f73-4438-bce5-4cc217e13854', '10VCZ', '50SSO', '68e44875-fd0e-4cd1-b048-dacfc20c355f', '1', '1', '15', '1', NULL, NULL, NOW(), NOW()),
--  'Portales'
('3a1b15c2-e543-43e6-98fa-90ea0e9567da', '10VCZ', '50SSO', '255a55a3-ae5a-4240-889e-d1c93b8460b7', '1', '1', '16', '1', NULL, NULL, NOW(), NOW()),
--  'Calendario'
('c7376dcd-67e1-46d6-8043-b696e359c215', '10VCZ', '50SSO', '8031e15a-7096-4430-90ec-6209fbffbcbc', '1', '1', '17', '1', NULL, NULL, NOW(), NOW()),
--  'Indicadores'
('f80c8d42-d366-42a2-934f-1b14be71e74c', '10VCZ', '50SSO', '417b4991-1a5e-4ae7-ab5d-e58117902607', '1', '1', '18', '1', NULL, NULL, NOW(), NOW()),
--  'Pendientes'
('2b5ca273-4e3a-4fe5-b06e-4d40e24a0630', '10VCZ', '50SSO', '018161c8-922a-477d-8a0d-21e318cd26c4', '1', '1', '19', '1', NULL, NULL, NOW(), NOW()),
--  'Corte Z'
('b98d1f3b-4ce1-4cb4-92fb-24fa2ac7551f', '10VCZ', '50SSO', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', '1', '1', '20', '1', NULL, NULL, NOW(), NOW()),
--  'Utensilios'
('9fd2ce9b-e6cc-44a7-a580-3325b95c5d09', '10VCZ', '50SSO', '7223d9dc-e0a4-466b-a023-89a8c56bb327', '1', '1', '21', '1', NULL, NULL, NOW(), NOW()),
--  'Rol de Preinventarios'
('2b860777-2dbd-4519-a084-b17e534d10c8', '10VCZ', '50SSO', 'd3060505-308e-4341-9966-8fcda411b68e', '1', '1', '22', '1', NULL, NULL, NOW(), NOW()),
--  'Reclutamiento'
('e1d884a6-a22b-4e43-a660-714e1361ccdc', '10VCZ', '50SSO', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', '1', '1', '23', '1', NULL, NULL, NOW(), NOW()),
--  'Merma de café'
('a6d02c21-0346-461a-a485-89f29a625a83', '10VCZ', '50SSO', '3a8910a1-10f7-452f-a870-9a108ee741de', '0', '0', '24', '1', NULL, NULL, NOW(), NOW());


-- --------------------------------------------------------
--
-- 50LIB Cordoba Piragua VER Maira Garcia
--
INSERT INTO `xxbdo_modulos_por_tienda` (`id`, `cr_plaza`, `cr_tienda`, `xxbdo_modulos_id`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
--  'Compra'
('1ad4b12a-b2f9-446b-a126-675acedd698b', '10VCZ', '50LIB', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', '1', '1', '10', '1', NULL, NULL, NOW(), NOW()),
--  'Generación'
('49082108-352e-4a45-830c-197f92603123', '10VCZ', '50LIB', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', '1', '1', '11', '1', NULL, NULL, NOW(), NOW()),
--  'Recepción'
('9b3f210d-68b5-44a7-bdae-f49b9c7e6915', '10VCZ', '50LIB', '26580c8b-a7ff-4bf5-a34c-8028068bceac', '1', '1', '12', '1', NULL, NULL, NOW(), NOW()),
--  'BDO'
('e5e349af-91d1-452d-ada5-ecbe7a275d90', '10VCZ', '50LIB', '95909efd-2f72-4389-888c-c3e2dda067dc', '1', '1', '13', '1', NULL, NULL, NOW(), NOW()),
--  'Preinventarios'
('1bef585b-2031-4cfb-8f52-0ae8dd14c99b', '10VCZ', '50LIB', 'fb2368e7-242c-490e-84dd-a47a95002473', '1', '1', '14', '1', NULL, NULL, NOW(), NOW()),
--  'Etiqueteo'
('2db6b177-8b2b-4034-8aeb-3864eb028d5e', '10VCZ', '50LIB', '68e44875-fd0e-4cd1-b048-dacfc20c355f', '1', '1', '15', '1', NULL, NULL, NOW(), NOW()),
--  'Portales'
('18e83078-edb9-4aad-84e3-6513baaad24a', '10VCZ', '50LIB', '255a55a3-ae5a-4240-889e-d1c93b8460b7', '1', '1', '16', '1', NULL, NULL, NOW(), NOW()),
--  'Calendario'
('bc43463c-5014-4e8f-9fe7-f93a137ae04a', '10VCZ', '50LIB', '8031e15a-7096-4430-90ec-6209fbffbcbc', '1', '1', '17', '1', NULL, NULL, NOW(), NOW()),
--  'Indicadores'
('9eebf257-1d67-4305-8254-12d1540ed6fa', '10VCZ', '50LIB', '417b4991-1a5e-4ae7-ab5d-e58117902607', '1', '1', '18', '1', NULL, NULL, NOW(), NOW()),
--  'Pendientes'
('dc5794d8-8edc-409a-a7ad-93b7f7bc8316', '10VCZ', '50LIB', '018161c8-922a-477d-8a0d-21e318cd26c4', '1', '1', '19', '1', NULL, NULL, NOW(), NOW()),
--  'Corte Z'
('76d2e31d-6da4-4b88-8ad2-47bafca57e04', '10VCZ', '50LIB', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', '1', '1', '20', '1', NULL, NULL, NOW(), NOW()),
--  'Utensilios'
('e71d2169-d01e-4e1a-9312-6ec987201371', '10VCZ', '50LIB', '7223d9dc-e0a4-466b-a023-89a8c56bb327', '1', '1', '21', '1', NULL, NULL, NOW(), NOW()),
--  'Rol de Preinventarios'
('df98bd44-527d-45f7-970f-f1730f4c2ccc', '10VCZ', '50LIB', 'd3060505-308e-4341-9966-8fcda411b68e', '1', '1', '22', '1', NULL, NULL, NOW(), NOW()),
--  'Reclutamiento'
('e154be8c-9438-4bb6-9f27-efffcf810cdd', '10VCZ', '50LIB', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', '1', '1', '23', '1', NULL, NULL, NOW(), NOW()),
--  'Merma de café'
('0f73d135-721b-473a-a8a9-578492002ecd', '10VCZ', '50LIB', '3a8910a1-10f7-452f-a870-9a108ee741de', '0', '0', '24', '1', NULL, NULL, NOW(), NOW());


-- --------------------------------------------------------
--
-- 50F5T Xalapa Comonfort VER Gloria Anzures
--
INSERT INTO `xxbdo_modulos_por_tienda` (`id`, `cr_plaza`, `cr_tienda`, `xxbdo_modulos_id`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
--  'Compra'
('43ecb016-9e91-4042-9131-254a5d056836', '10VCZ', '50F5T', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', '1', '1', '10', '1', NULL, NULL, NOW(), NOW()),
--  'Generación'
('3c888b4c-3482-44bc-bdc4-8abc06ba19e8', '10VCZ', '50F5T', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', '1', '1', '11', '1', NULL, NULL, NOW(), NOW()),
--  'Recepción'
('480ad10d-4095-49de-a7e1-52643aa9da99', '10VCZ', '50F5T', '26580c8b-a7ff-4bf5-a34c-8028068bceac', '1', '1', '12', '1', NULL, NULL, NOW(), NOW()),
--  'BDO'
('d79d4781-f8ba-4b7e-ab22-df15b83a700d', '10VCZ', '50F5T', '95909efd-2f72-4389-888c-c3e2dda067dc', '1', '1', '13', '1', NULL, NULL, NOW(), NOW()),
--  'Preinventarios'
('6762e3ce-1014-4b50-bd00-d2d6c2b1afdf', '10VCZ', '50F5T', 'fb2368e7-242c-490e-84dd-a47a95002473', '1', '1', '14', '1', NULL, NULL, NOW(), NOW()),
--  'Etiqueteo'
('3db09e56-6182-4af3-8604-68d3dfd17483', '10VCZ', '50F5T', '68e44875-fd0e-4cd1-b048-dacfc20c355f', '1', '1', '15', '1', NULL, NULL, NOW(), NOW()),
--  'Portales'
('56a89e9e-db15-48be-8afc-5a6c270c2067', '10VCZ', '50F5T', '255a55a3-ae5a-4240-889e-d1c93b8460b7', '1', '1', '16', '1', NULL, NULL, NOW(), NOW()),
--  'Calendario'
('89398f0f-492a-4e0c-bdcd-88404d7594ad', '10VCZ', '50F5T', '8031e15a-7096-4430-90ec-6209fbffbcbc', '1', '1', '17', '1', NULL, NULL, NOW(), NOW()),
--  'Indicadores'
('ec9abc1c-d2ff-4e38-ac1f-da0cbf16759f', '10VCZ', '50F5T', '417b4991-1a5e-4ae7-ab5d-e58117902607', '1', '1', '18', '1', NULL, NULL, NOW(), NOW()),
--  'Pendientes'
('f7e763e5-c4f7-4905-978d-703518867f2a', '10VCZ', '50F5T', '018161c8-922a-477d-8a0d-21e318cd26c4', '1', '1', '19', '1', NULL, NULL, NOW(), NOW()),
--  'Corte Z'
('ba46dff1-791b-418c-b22e-6f1e2a74e502', '10VCZ', '50F5T', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', '1', '1', '20', '1', NULL, NULL, NOW(), NOW()),
--  'Utensilios'
('d558893f-8f7a-40c1-be4a-9e00c7a5e8f9', '10VCZ', '50F5T', '7223d9dc-e0a4-466b-a023-89a8c56bb327', '1', '1', '21', '1', NULL, NULL, NOW(), NOW()),
--  'Rol de Preinventarios'
('474c63fb-e7c5-43c9-86c1-8975ce6db28d', '10VCZ', '50F5T', 'd3060505-308e-4341-9966-8fcda411b68e', '1', '1', '22', '1', NULL, NULL, NOW(), NOW()),
--  'Reclutamiento'
('3d63800a-a656-4335-8684-61f823c4a9df', '10VCZ', '50F5T', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', '1', '1', '23', '1', NULL, NULL, NOW(), NOW()),
--  'Merma de café'
('ca7aa9bd-4e45-40c6-8fe6-e08b17c1b4d4', '10VCZ', '50F5T', '3a8910a1-10f7-452f-a870-9a108ee741de', '0', '0', '24', '1', NULL, NULL, NOW(), NOW());


-- --------------------------------------------------------
--
-- 50B67 Xalapa Hidalgo VER Gloria Anzures
--
INSERT INTO `xxbdo_modulos_por_tienda` (`id`, `cr_plaza`, `cr_tienda`, `xxbdo_modulos_id`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
--  'Compra'
('535c97b8-a559-4de3-80ae-b9609dbe2ada', '10VCZ', '50B67', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', '1', '1', '10', '1', NULL, NULL, NOW(), NOW()),
--  'Generación'
('42bb219d-27c0-465f-9756-ea496a372b1e', '10VCZ', '50B67', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', '1', '1', '11', '1', NULL, NULL, NOW(), NOW()),
--  'Recepción'
('24585a10-8926-4cf3-b634-8efeaf1df121', '10VCZ', '50B67', '26580c8b-a7ff-4bf5-a34c-8028068bceac', '1', '1', '12', '1', NULL, NULL, NOW(), NOW()),
--  'BDO'
('005b7974-ca75-40e4-b9d4-7c387cff6606', '10VCZ', '50B67', '95909efd-2f72-4389-888c-c3e2dda067dc', '1', '1', '13', '1', NULL, NULL, NOW(), NOW()),
--  'Preinventarios'
('eaaa48af-692f-453e-8791-78042cafd552', '10VCZ', '50B67', 'fb2368e7-242c-490e-84dd-a47a95002473', '1', '1', '14', '1', NULL, NULL, NOW(), NOW()),
--  'Etiqueteo'
('d688f680-766e-455c-9efd-f872bd0cdaf6', '10VCZ', '50B67', '68e44875-fd0e-4cd1-b048-dacfc20c355f', '1', '1', '15', '1', NULL, NULL, NOW(), NOW()),
--  'Portales'
('351e17db-4e9f-4167-a21c-52ab5a48640a', '10VCZ', '50B67', '255a55a3-ae5a-4240-889e-d1c93b8460b7', '1', '1', '16', '1', NULL, NULL, NOW(), NOW()),
--  'Calendario'
('f0a63bd3-4c9e-4565-84d2-e3d1d2a2f718', '10VCZ', '50B67', '8031e15a-7096-4430-90ec-6209fbffbcbc', '1', '1', '17', '1', NULL, NULL, NOW(), NOW()),
--  'Indicadores'
('1acad3cb-ff27-4b6e-8a03-5a204263d0cc', '10VCZ', '50B67', '417b4991-1a5e-4ae7-ab5d-e58117902607', '1', '1', '18', '1', NULL, NULL, NOW(), NOW()),
--  'Pendientes'
('13fdc3f4-1f9e-4914-9abd-c1fe65fd765e', '10VCZ', '50B67', '018161c8-922a-477d-8a0d-21e318cd26c4', '1', '1', '19', '1', NULL, NULL, NOW(), NOW()),
--  'Corte Z'
('dd43dcea-ef28-4915-a7c4-2d4be697b5f2', '10VCZ', '50B67', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', '1', '1', '20', '1', NULL, NULL, NOW(), NOW()),
--  'Utensilios'
('eb21986d-72f5-49fc-94ae-8acb282199bf', '10VCZ', '50B67', '7223d9dc-e0a4-466b-a023-89a8c56bb327', '1', '1', '21', '1', NULL, NULL, NOW(), NOW()),
--  'Rol de Preinventarios'
('afdc292c-0ee8-4d2c-a698-54b31071e43f', '10VCZ', '50B67', 'd3060505-308e-4341-9966-8fcda411b68e', '1', '1', '22', '1', NULL, NULL, NOW(), NOW()),
--  'Reclutamiento'
('1dd96014-f066-4986-b968-04c1b44851ce', '10VCZ', '50B67', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', '1', '1', '23', '1', NULL, NULL, NOW(), NOW()),
--  'Merma de café'
('86168181-79dd-46e1-832d-985325de387d', '10VCZ', '50B67', '3a8910a1-10f7-452f-a870-9a108ee741de', '0', '0', '24', '1', NULL, NULL, NOW(), NOW());


-- --------------------------------------------------------
--
-- 50SZV Coatzacoalcos Aurelia Solis MTT Keila Hernandez
--
INSERT INTO `xxbdo_modulos_por_tienda` (`id`, `cr_plaza`, `cr_tienda`, `xxbdo_modulos_id`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
--  'Compra'
('23ac560a-4948-4cfc-8317-919f28833aa4', '10VCZ', '50SZV', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', '1', '1', '10', '1', NULL, NULL, NOW(), NOW()),
--  'Generación'
('8fcd5271-68e5-4fc3-bfad-5028bec85939', '10VCZ', '50SZV', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', '1', '1', '11', '1', NULL, NULL, NOW(), NOW()),
--  'Recepción'
('72bd920d-6a19-483d-b4b3-d868a2d314b8', '10VCZ', '50SZV', '26580c8b-a7ff-4bf5-a34c-8028068bceac', '1', '1', '12', '1', NULL, NULL, NOW(), NOW()),
--  'BDO'
('52459f66-ec8b-49f2-bf53-22f2605ab2b3', '10VCZ', '50SZV', '95909efd-2f72-4389-888c-c3e2dda067dc', '1', '1', '13', '1', NULL, NULL, NOW(), NOW()),
--  'Preinventarios'
('fdf5aa57-62dc-4927-bd8c-36d1c8ebce04', '10VCZ', '50SZV', 'fb2368e7-242c-490e-84dd-a47a95002473', '1', '1', '14', '1', NULL, NULL, NOW(), NOW()),
--  'Etiqueteo'
('03b50446-b718-453b-abf9-620e6a26721a', '10VCZ', '50SZV', '68e44875-fd0e-4cd1-b048-dacfc20c355f', '1', '1', '15', '1', NULL, NULL, NOW(), NOW()),
--  'Portales'
('3807d04d-b7b0-4ce4-879f-82aed8065afa', '10VCZ', '50SZV', '255a55a3-ae5a-4240-889e-d1c93b8460b7', '1', '1', '16', '1', NULL, NULL, NOW(), NOW()),
--  'Calendario'
('f8f3fea1-bdd5-4eda-a18a-cdd5e0da6528', '10VCZ', '50SZV', '8031e15a-7096-4430-90ec-6209fbffbcbc', '1', '1', '17', '1', NULL, NULL, NOW(), NOW()),
--  'Indicadores'
('b7cf13ba-f818-4a38-85a8-bac728ae9f1b', '10VCZ', '50SZV', '417b4991-1a5e-4ae7-ab5d-e58117902607', '1', '1', '18', '1', NULL, NULL, NOW(), NOW()),
--  'Pendientes'
('e1946e83-13b8-42c5-9c24-7fc1cdec695e', '10VCZ', '50SZV', '018161c8-922a-477d-8a0d-21e318cd26c4', '1', '1', '19', '1', NULL, NULL, NOW(), NOW()),
--  'Corte Z'
('ba7832e0-1042-419b-b8fc-198a0c9ed819', '10VCZ', '50SZV', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', '1', '1', '20', '1', NULL, NULL, NOW(), NOW()),
--  'Utensilios'
('b197f9e4-7cee-4de4-9708-92a36441ebd1', '10VCZ', '50SZV', '7223d9dc-e0a4-466b-a023-89a8c56bb327', '1', '1', '21', '1', NULL, NULL, NOW(), NOW()),
--  'Rol de Preinventarios'
('2e3cb1f1-3727-435e-8cc4-2db8f68566a5', '10VCZ', '50SZV', 'd3060505-308e-4341-9966-8fcda411b68e', '1', '1', '22', '1', NULL, NULL, NOW(), NOW()),
--  'Reclutamiento'
('2cc35387-7d28-48d8-97e5-27864a0a948a', '10VCZ', '50SZV', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', '1', '1', '23', '1', NULL, NULL, NOW(), NOW()),
--  'Merma de café'
('5e2e8ab4-370e-4e49-9aa6-3633e64f363a', '10VCZ', '50SZV', '3a8910a1-10f7-452f-a870-9a108ee741de', '0', '0', '24', '1', NULL, NULL, NOW(), NOW());


-- --------------------------------------------------------
--
-- 50YHU Coatzacoalcos 7 Leguas MTT Keila Hernandez
--
INSERT INTO `xxbdo_modulos_por_tienda` (`id`, `cr_plaza`, `cr_tienda`, `xxbdo_modulos_id`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
--  'Compra'
('efbc0f01-7aba-49de-a2f5-85424a439208', '10VCZ', '50YHU', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', '1', '1', '10', '1', NULL, NULL, NOW(), NOW()),
--  'Generación'
('3bd2cd4a-4ef7-4931-860a-356ae36a95fa', '10VCZ', '50YHU', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', '1', '1', '11', '1', NULL, NULL, NOW(), NOW()),
--  'Recepción'
('53065d12-15b7-428e-96af-8de5ec5364be', '10VCZ', '50YHU', '26580c8b-a7ff-4bf5-a34c-8028068bceac', '1', '1', '12', '1', NULL, NULL, NOW(), NOW()),
--  'BDO'
('d04e704f-52f9-4256-a395-9c845fa438bd', '10VCZ', '50YHU', '95909efd-2f72-4389-888c-c3e2dda067dc', '1', '1', '13', '1', NULL, NULL, NOW(), NOW()),
--  'Preinventarios'
('96aa4cd7-853e-4463-b0f4-c775e6b94d47', '10VCZ', '50YHU', 'fb2368e7-242c-490e-84dd-a47a95002473', '1', '1', '14', '1', NULL, NULL, NOW(), NOW()),
--  'Etiqueteo'
('6e2ced8a-9305-410c-9a2a-9d70326f2c90', '10VCZ', '50YHU', '68e44875-fd0e-4cd1-b048-dacfc20c355f', '1', '1', '15', '1', NULL, NULL, NOW(), NOW()),
--  'Portales'
('7c7cf4e9-8dd2-40d0-879c-0ea2acae2f50', '10VCZ', '50YHU', '255a55a3-ae5a-4240-889e-d1c93b8460b7', '1', '1', '16', '1', NULL, NULL, NOW(), NOW()),
--  'Calendario'
('2178a9f9-4e35-44a5-a701-79dfedf464df', '10VCZ', '50YHU', '8031e15a-7096-4430-90ec-6209fbffbcbc', '1', '1', '17', '1', NULL, NULL, NOW(), NOW()),
--  'Indicadores'
('d6f68c7d-3e0f-4738-aa90-cf404964df78', '10VCZ', '50YHU', '417b4991-1a5e-4ae7-ab5d-e58117902607', '1', '1', '18', '1', NULL, NULL, NOW(), NOW()),
--  'Pendientes'
('d571d7c3-e63c-4f15-bb91-571cb6334441', '10VCZ', '50YHU', '018161c8-922a-477d-8a0d-21e318cd26c4', '1', '1', '19', '1', NULL, NULL, NOW(), NOW()),
--  'Corte Z'
('d3069408-9e41-4227-9c04-7508f53f7b5b', '10VCZ', '50YHU', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', '1', '1', '20', '1', NULL, NULL, NOW(), NOW()),
--  'Utensilios'
('a52bbc24-be62-4535-9019-bf3612cef2da', '10VCZ', '50YHU', '7223d9dc-e0a4-466b-a023-89a8c56bb327', '1', '1', '21', '1', NULL, NULL, NOW(), NOW()),
--  'Rol de Preinventarios'
('007d2001-4279-44a8-b015-7cb826068566', '10VCZ', '50YHU', 'd3060505-308e-4341-9966-8fcda411b68e', '1', '1', '22', '1', NULL, NULL, NOW(), NOW()),
--  'Reclutamiento'
('a70cd5cb-6436-44ea-8edc-430f86e85f4c', '10VCZ', '50YHU', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', '1', '1', '23', '1', NULL, NULL, NOW(), NOW()),
--  'Merma de café'
('6614db84-846b-40dc-a034-5da29cf1038e', '10VCZ', '50YHU', '3a8910a1-10f7-452f-a870-9a108ee741de', '0', '0', '24', '1', NULL, NULL, NOW(), NOW());


-- --------------------------------------------------------
--
-- 50KPB Boca del Rio Paseo Boca del Rio VER Bernardo Salgado
--
INSERT INTO `xxbdo_modulos_por_tienda` (`id`, `cr_plaza`, `cr_tienda`, `xxbdo_modulos_id`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
--  'Compra'
('c742dc70-47f9-4291-bc8c-be4ec69896c9', '10VCZ', '50KPB', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', '1', '1', '10', '1', NULL, NULL, NOW(), NOW()),
--  'Generación'
('71433d8a-1bbc-4317-b7e6-46608bf10d88', '10VCZ', '50KPB', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', '1', '1', '11', '1', NULL, NULL, NOW(), NOW()),
--  'Recepción'
('6ddaf853-7cb0-4e38-9125-a20c15c7d934', '10VCZ', '50KPB', '26580c8b-a7ff-4bf5-a34c-8028068bceac', '1', '1', '12', '1', NULL, NULL, NOW(), NOW()),
--  'BDO'
('c11ae321-0cdf-424b-8799-e2af9f0955b5', '10VCZ', '50KPB', '95909efd-2f72-4389-888c-c3e2dda067dc', '1', '1', '13', '1', NULL, NULL, NOW(), NOW()),
--  'Preinventarios'
('5445a463-cce1-49a5-8a24-c221607f8f0e', '10VCZ', '50KPB', 'fb2368e7-242c-490e-84dd-a47a95002473', '1', '1', '14', '1', NULL, NULL, NOW(), NOW()),
--  'Etiqueteo'
('a395ec5b-9eea-476b-8d7e-75638ba2479a', '10VCZ', '50KPB', '68e44875-fd0e-4cd1-b048-dacfc20c355f', '1', '1', '15', '1', NULL, NULL, NOW(), NOW()),
--  'Portales'
('3d080241-083b-42b1-9fce-cdd2d161649c', '10VCZ', '50KPB', '255a55a3-ae5a-4240-889e-d1c93b8460b7', '1', '1', '16', '1', NULL, NULL, NOW(), NOW()),
--  'Calendario'
('f660525d-0a3f-4222-a1dd-c48d81dd6f96', '10VCZ', '50KPB', '8031e15a-7096-4430-90ec-6209fbffbcbc', '1', '1', '17', '1', NULL, NULL, NOW(), NOW()),
--  'Indicadores'
('ba069657-41cb-44cc-a2c0-cb9e1a8af908', '10VCZ', '50KPB', '417b4991-1a5e-4ae7-ab5d-e58117902607', '1', '1', '18', '1', NULL, NULL, NOW(), NOW()),
--  'Pendientes'
('98f5b92c-0b03-41de-930e-b8413faf951c', '10VCZ', '50KPB', '018161c8-922a-477d-8a0d-21e318cd26c4', '1', '1', '19', '1', NULL, NULL, NOW(), NOW()),
--  'Corte Z'
('bcdf7e17-5f7f-40e8-9035-a60b64fac8ba', '10VCZ', '50KPB', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', '1', '1', '20', '1', NULL, NULL, NOW(), NOW()),
--  'Utensilios'
('3c105c79-4c96-4489-92bd-c85b59128632', '10VCZ', '50KPB', '7223d9dc-e0a4-466b-a023-89a8c56bb327', '1', '1', '21', '1', NULL, NULL, NOW(), NOW()),
--  'Rol de Preinventarios'
('11a21f4c-72ec-4808-9a2e-1a12d1ee64ee', '10VCZ', '50KPB', 'd3060505-308e-4341-9966-8fcda411b68e', '1', '1', '22', '1', NULL, NULL, NOW(), NOW()),
--  'Reclutamiento'
('02ebf835-98aa-444a-ad2d-a949c0bd1771', '10VCZ', '50KPB', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', '1', '1', '23', '1', NULL, NULL, NOW(), NOW()),
--  'Merma de café'
('a9513a0e-0690-4086-ba7d-884ddd92c03d', '10VCZ', '50KPB', '3a8910a1-10f7-452f-a870-9a108ee741de', '0', '0', '24', '1', NULL, NULL, NOW(), NOW());


-- --------------------------------------------------------
--
-- 508U9 Boca del Rio Sol VER Bernardo Salgado
--
INSERT INTO `xxbdo_modulos_por_tienda` (`id`, `cr_plaza`, `cr_tienda`, `xxbdo_modulos_id`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
--  'Compra'
('82831ac4-8b69-46c7-9e6a-23cf4af605f1', '10VCZ', '508U9', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', '1', '1', '10', '1', NULL, NULL, NOW(), NOW()),
--  'Generación'
('adede8e8-07f2-4e29-b3da-e5146bb6ba15', '10VCZ', '508U9', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', '1', '1', '11', '1', NULL, NULL, NOW(), NOW()),
--  'Recepción'
('3553226f-e01b-4d1c-a349-1fa250f9be01', '10VCZ', '508U9', '26580c8b-a7ff-4bf5-a34c-8028068bceac', '1', '1', '12', '1', NULL, NULL, NOW(), NOW()),
--  'BDO'
('55fa7f8b-a1f9-4a51-905b-04af9f08d9fe', '10VCZ', '508U9', '95909efd-2f72-4389-888c-c3e2dda067dc', '1', '1', '13', '1', NULL, NULL, NOW(), NOW()),
--  'Preinventarios'
('eaebade3-22a7-4189-b523-743fca971dbc', '10VCZ', '508U9', 'fb2368e7-242c-490e-84dd-a47a95002473', '1', '1', '14', '1', NULL, NULL, NOW(), NOW()),
--  'Etiqueteo'
('ad2b037b-6a25-4c0e-90b1-fba5fe51921c', '10VCZ', '508U9', '68e44875-fd0e-4cd1-b048-dacfc20c355f', '1', '1', '15', '1', NULL, NULL, NOW(), NOW()),
--  'Portales'
('6b2e0100-1473-4096-9838-5daf3bdc53ad', '10VCZ', '508U9', '255a55a3-ae5a-4240-889e-d1c93b8460b7', '1', '1', '16', '1', NULL, NULL, NOW(), NOW()),
--  'Calendario'
('0f70a1ae-0761-4142-8687-01d1f6a28d8c', '10VCZ', '508U9', '8031e15a-7096-4430-90ec-6209fbffbcbc', '1', '1', '17', '1', NULL, NULL, NOW(), NOW()),
--  'Indicadores'
('14a57461-b14e-4ee7-a23c-1fce7237420a', '10VCZ', '508U9', '417b4991-1a5e-4ae7-ab5d-e58117902607', '1', '1', '18', '1', NULL, NULL, NOW(), NOW()),
--  'Pendientes'
('adbbe668-9f6b-4a79-a74a-c15605883137', '10VCZ', '508U9', '018161c8-922a-477d-8a0d-21e318cd26c4', '1', '1', '19', '1', NULL, NULL, NOW(), NOW()),
--  'Corte Z'
('f3274e3b-6599-40bd-a94d-aad81f807a8b', '10VCZ', '508U9', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', '1', '1', '20', '1', NULL, NULL, NOW(), NOW()),
--  'Utensilios'
('0e867b73-ade7-4e85-a61e-6ce074ee9492', '10VCZ', '508U9', '7223d9dc-e0a4-466b-a023-89a8c56bb327', '1', '1', '21', '1', NULL, NULL, NOW(), NOW()),
--  'Rol de Preinventarios'
('de345ac0-4b94-4fe6-8847-af0f3d09ba2c', '10VCZ', '508U9', 'd3060505-308e-4341-9966-8fcda411b68e', '1', '1', '22', '1', NULL, NULL, NOW(), NOW()),
--  'Reclutamiento'
('c27b3284-f0b2-4aab-b3b2-ef324982691b', '10VCZ', '508U9', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', '1', '1', '23', '1', NULL, NULL, NOW(), NOW()),
--  'Merma de café'
('27ca5c53-eb60-4294-957d-3b550ee53287', '10VCZ', '508U9', '3a8910a1-10f7-452f-a870-9a108ee741de', '0', '0', '24', '1', NULL, NULL, NOW(), NOW());


-- --------------------------------------------------------
--
-- 50LMH Boca del Rio Los Mangos VER Bernardo Salgado
--
INSERT INTO `xxbdo_modulos_por_tienda` (`id`, `cr_plaza`, `cr_tienda`, `xxbdo_modulos_id`, `es_activo`, `es_visible`, `orden`, `activo`, `usuario`, `ip_address`, `fecha_creacion`, `fecha_modificacion`) VALUES 
--  'Compra'
('34aff0a6-9a96-482c-aca7-93cb88e7e231', '10VCZ', '50LMH', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', '1', '1', '10', '1', NULL, NULL, NOW(), NOW()),
--  'Generación'
('6737da33-42d5-4f8a-8a17-15af95119a44', '10VCZ', '50LMH', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', '1', '1', '11', '1', NULL, NULL, NOW(), NOW()),
--  'Recepción'
('f6468c56-317e-45c4-8b21-97a1c2b59882', '10VCZ', '50LMH', '26580c8b-a7ff-4bf5-a34c-8028068bceac', '1', '1', '12', '1', NULL, NULL, NOW(), NOW()),
--  'BDO'
('ff17704b-96e0-4733-966d-7f11f54c8401', '10VCZ', '50LMH', '95909efd-2f72-4389-888c-c3e2dda067dc', '1', '1', '13', '1', NULL, NULL, NOW(), NOW()),
--  'Preinventarios'
('58e49bc6-2fd0-4976-9da8-948133abf38e', '10VCZ', '50LMH', 'fb2368e7-242c-490e-84dd-a47a95002473', '1', '1', '14', '1', NULL, NULL, NOW(), NOW()),
--  'Etiqueteo'
('095ea579-179c-4d37-b564-932a9458f0c9', '10VCZ', '50LMH', '68e44875-fd0e-4cd1-b048-dacfc20c355f', '1', '1', '15', '1', NULL, NULL, NOW(), NOW()),
--  'Portales'
('a262a148-a397-48d2-825c-8c33e9019bf4', '10VCZ', '50LMH', '255a55a3-ae5a-4240-889e-d1c93b8460b7', '1', '1', '16', '1', NULL, NULL, NOW(), NOW()),
--  'Calendario'
('cbfc957a-29b1-4e0b-9892-447ff297c838', '10VCZ', '50LMH', '8031e15a-7096-4430-90ec-6209fbffbcbc', '1', '1', '17', '1', NULL, NULL, NOW(), NOW()),
--  'Indicadores'
('c6873373-99d1-4c55-9992-ffb0401c2dc1', '10VCZ', '50LMH', '417b4991-1a5e-4ae7-ab5d-e58117902607', '1', '1', '18', '1', NULL, NULL, NOW(), NOW()),
--  'Pendientes'
('622ea3f8-ba41-4cd1-aae2-6ae140f6ed0b', '10VCZ', '50LMH', '018161c8-922a-477d-8a0d-21e318cd26c4', '1', '1', '19', '1', NULL, NULL, NOW(), NOW()),
--  'Corte Z'
('b3a9e04c-1256-4b59-b41e-adeab544eb42', '10VCZ', '50LMH', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', '1', '1', '20', '1', NULL, NULL, NOW(), NOW()),
--  'Utensilios'
('51c8f94e-1c56-4452-a96a-d935bf89d86d', '10VCZ', '50LMH', '7223d9dc-e0a4-466b-a023-89a8c56bb327', '1', '1', '21', '1', NULL, NULL, NOW(), NOW()),
--  'Rol de Preinventarios'
('0f67e935-727b-405c-8c4d-68b177e1d00b', '10VCZ', '50LMH', 'd3060505-308e-4341-9966-8fcda411b68e', '1', '1', '22', '1', NULL, NULL, NOW(), NOW()),
--  'Reclutamiento'
('df9b809b-7c9e-4fcf-af6f-8c2a9c2be2b6', '10VCZ', '50LMH', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', '1', '1', '23', '1', NULL, NULL, NOW(), NOW()),
--  'Merma de café'
('103e4e36-d773-4c3b-9567-d939629696db', '10VCZ', '50LMH', '3a8910a1-10f7-452f-a870-9a108ee741de', '0', '0', '24', '1', NULL, NULL, NOW(), NOW());

SET FOREIGN_KEY_CHECKS=1;
COMMIT;