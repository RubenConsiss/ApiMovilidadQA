
USE `xxbdo`;

-- Borrar configuracion individual de tiendas de prueba 10VCZ:
--  507GK
--	508U9
--	50B67
--	50F5T
--	50KPB
--	50LIB
--	50LMH
--	50SSO
--	50SZV
--	50YHU
TRUNCATE `xxbdo`.`xxbdo_modulos_por_tienda`;

--
-- Habilitar módulo de reclutamiento unicamente para plaza 10VCZ
--
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('73760b2c-b8c8-4ea4-8fe2-347b17725d0d', '10VCZ', '018161c8-922a-477d-8a0d-21e318cd26c4', 1, 1, 19, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('646a43d7-3048-4c65-82be-1a0bbf1cf4b9', '10VCZ', '255a55a3-ae5a-4240-889e-d1c93b8460b7', 1, 1, 16, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('4a6e4f0c-64db-4079-b37c-c75fc74d16d8', '10VCZ', '26580c8b-a7ff-4bf5-a34c-8028068bceac', 1, 1, 12, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('93032fd8-2cbe-454f-b8ca-3257b3804f60', '10VCZ', '3a8910a1-10f7-452f-a870-9a108ee741de', 0, 0, 24, 1, NULL, NULL, '2020-08-19 22:24:31', '2020-08-19 22:24:31');
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('cee45860-e8ab-44f0-90ad-227ffd6c1df4', '10VCZ', '417b4991-1a5e-4ae7-ab5d-e58117902607', 1, 1, 18, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('dd138341-b0fb-4327-b934-748ac4204cba', '10VCZ', '68e44875-fd0e-4cd1-b048-dacfc20c355f', 1, 1, 15, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('64d69a15-dcaf-4f5a-b4bb-02c59f32afb9', '10VCZ', '7223d9dc-e0a4-466b-a023-89a8c56bb327', 1, 1, 21, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('0de1bd6f-87dc-4dac-b643-9c67211c0df4', '10VCZ', '8031e15a-7096-4430-90ec-6209fbffbcbc', 1, 1, 17, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('08a874bf-4225-4716-82e6-b88539ce7584', '10VCZ', '95909efd-2f72-4389-888c-c3e2dda067dc', 1, 1, 13, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('bda61282-52ab-4d3c-a60b-067653171bfa', '10VCZ', 'b5209c49-75ca-46af-91d0-a0dfda8b1ea0', 1, 1, 20, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('d59595c6-82bf-45a4-b13d-3a1b3cd735ff', '10VCZ', 'c21c7557-c726-4bd2-9a99-fa2bd66e5bc0', 1, 1, 10, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('7d3624da-338e-4d4b-bf54-6ef4ce0206ac', '10VCZ', 'c99d6077-3a3d-4bca-b39a-ef8ca461bf44', 1, 1, 11, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('e531f1b0-4278-427f-8ea0-8faabbd3855a', '10VCZ', 'd3060505-308e-4341-9966-8fcda411b68e', 1, 1, 22, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('f23a28ed-39b3-4b3b-a462-e2c775742589', '10VCZ', 'e8686cc6-a3ed-430d-8e5d-1c4d7284b9fa', 0, 0, 23, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_modulos_por_plaza` VALUES('ba9856eb-20af-46c2-aa00-3019d604452a', '10VCZ', 'fb2368e7-242c-490e-84dd-a47a95002473', 1, 1, 14, 1, NULL, NULL, NOW(), NOW());