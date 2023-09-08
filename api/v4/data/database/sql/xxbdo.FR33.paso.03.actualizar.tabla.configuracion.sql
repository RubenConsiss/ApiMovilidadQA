
-- queries para actualizar tabla de configuracion:

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- al correr en BD de pruebas, cambiar a: USE xxbdo_<dbname>;
-- al correr en BD production, USE xxbdo;
USE `xxbdo`;
--
-- Volcado de datos para la tabla `xxbdo_configuracion`
--

INSERT INTO `xxbdo_configuracion` VALUES('517745a6-182f-4687-857f-d33d4d7b3963', 'reportes', 'resumenbdo_ponderacion_etiqueta_estandar', 'Std', 1, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_configuracion` VALUES('abc05e4b-76e7-4121-a122-47266cf0604a', 'reportes', 'resumenbdo_ponderacion_etiqueta_puntos', 'pts', 1, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_configuracion` VALUES('dbd4a72b-13d0-4832-ad8d-61fd98b4aedc', 'pendientes', 'color_hexadecimal_fondo_pendiente_completado', '#CCCCCC', 2, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_configuracion` VALUES('ad8400d9-aa7d-4b25-adb9-ae25921277f4', 'estandares', 'areas_grupos_id_estandares_libres', '86392947-9a57-46c0-a16f-f2f4e5c0745d', 1, 1, 1, NULL, NULL, NOW(), NOW());

--
-- Volcado de datos para la tabla `xxbdo_colores`
--

INSERT INTO `xxbdo_colores` VALUES('06ab5e4b-3bcf-4dc8-80da-ee55c87c3962', '7131ed27-5733-47e9-ad86-83cac29e9288', 'Azul', '#0b0095', 1, 2, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('0d7991a3-a377-4bd4-8af1-a504f0bce24b', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'Verde', '#008000', 1, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('3e6fbb97-fa38-4edb-99a5-1f6f5745e60b', '7131ed27-5733-47e9-ad86-83cac29e9288', 'Rojo', '#FF0000', 1, 4, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('4002b059-26db-414b-a169-013e7ffc66e3', '7131ed27-5733-47e9-ad86-83cac29e9288', 'Verde', '#008000', 1, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('4274355c-2a84-4817-97fb-d4cf72d11f75', 'c98336f8-cf56-4a30-909a-42b592928219', 'Verde', '#008000', 1, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('57114d07-99f8-4196-a99c-38e552a70041', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'Naranja', '#FFA500', 1, 3, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('586a2916-98aa-44cc-8afa-a1d1200d70d7', 'c98336f8-cf56-4a30-909a-42b592928219', 'Rojo', '#FF0000', 1, 4, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('5b7c4ad7-b291-4a7c-8892-6079d64af9aa', 'c98336f8-cf56-4a30-909a-42b592928219', 'Azul', '#0b0095', 1, 2, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('693d6098-7c06-4fc2-bd96-a4acb371a038', '7131ed27-5733-47e9-ad86-83cac29e9288', 'Naranja', '#FFA500', 1, 3, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('8ad15f81-18a9-4aa1-8947-e424774fc4e6', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'Azul', '#0b0095', 1, 2, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('f268e441-5e1f-441d-ac41-f8dfe8adda6f', '3e50f58c-8634-41ce-93b5-c8bebb8bce46', 'Rojo', '#FF0000', 1, 4, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_colores` VALUES('f26993e4-323a-44fe-adcd-bf7a63247cee', 'c98336f8-cf56-4a30-909a-42b592928219', 'Naranja', '#FFA500', 1, 3, 1, NULL, NULL, NOW(), NOW());

--
-- Volcado de datos para la tabla `xxbdo_estandares_alertas`
--

INSERT INTO `xxbdo_estandares_alertas` VALUES('08c832e6-fd71-43d7-9ae9-9d71b1c4eefd', '88622a43-736e-4bdc-87d2-08b0da8ad325', 3, 1, 12, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('13bba40f-6871-4ad3-a8b9-abb800d5838c', 'fc921750-4a86-4c65-a663-b3d9ac0fa155', 3, 1, 11, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('18f2bafa-8884-4d92-a30b-74125324f948', '942567f1-9891-4cf1-bdb9-eafb8339f0e3', 2, 1, 9, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('1d5fcdee-e53c-4733-8225-f111f8678c8f', 'd321a40f-847c-4e8d-b17e-d628999e2449', 3, 1, 5, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('1e5fd680-6ea0-4af3-a734-7b1b967778a9', '82c7ee00-9f85-43ba-8edd-d589df96f130', 3, 1, 4, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('21e5e2df-8654-4d20-86a2-d97848d88ce0', '6f6b7f28-1711-4fb0-8ac6-8fdd4f2fd9cf', 3, 1, 11, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('2733c9d7-9d70-4d5e-b95c-85bdbaa498ad', 'd6ecde14-a46b-431e-93d7-ecbbb2bed989', 2, 1, 6, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('2e353d53-920e-4ade-8095-59063221c5c4', 'c9ee8725-df8f-4efb-b2b5-e8f3729cff2a', 3, 1, 9, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('2f7af981-b06b-4d79-9f7e-7ab022bdfebf', '63dbc878-8105-40d6-8cb9-2acfddce1640', 1, 0, 2, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('3892be78-8355-4366-a072-6fb62f4c45a3', '1611a8be-fca2-4d9b-ba5e-010915372afe', 3, 1, 10, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('48ccfb5a-19b0-4b8e-b041-c894452c1ca3', '6fc69885-e1f7-48e6-b226-aacbd98f35a2', 2, 1, 7, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('4e0ed00b-5881-41d7-9e0b-9289ca6f2abc', '2cd92cf6-08cf-4a42-ba80-5faf3b447fd4', 3, 1, 9, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('4eabd459-c164-4af0-bfee-08d6db5cdc15', '7e0ae661-3de5-40af-9047-72e7f2481db7', 2, 1, 6, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('50777a4d-b972-4bc9-a1a9-6ed13411bbe5', '2419f224-6ac7-440d-b32d-3d172ecbdbca', 3, 1, 5, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('558d8974-9d23-4777-8a18-672cdda7c692', '6bcfaf2f-40a7-44bf-b554-d07c644196b9', 3, 1, 10, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('5857b26a-f064-4b80-ad61-8d25925709f7', '339372b7-2b08-445f-aac5-cc07a175317f', 3, 1, 3, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('5a2fa358-dcae-43ca-a557-3703e863343a', 'f52971ec-e16e-46f7-a1fe-ced9410059b3', 3, 1, 14, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('736f8e3d-7841-4eef-becf-454581d66b79', '10f81bf8-ff1b-415e-8fda-c420f1dbf914', 2, 1, 1, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('767a4d47-da1a-49f8-a395-0e5e3fb5c973', 'b1b19ac7-b4b5-4d82-bd95-9d674f24de3d', 3, 1, 13, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('78c24f2e-5893-42ca-99a4-41930d437156', 'a7d6420e-eba0-4261-a3e4-8db1ae1b5912', 3, 1, 14, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('7e769e8f-1dc9-4b23-b192-ce97c6e8daaf', '5ae71d28-c4f9-4968-a3ce-c60908fc8bdf', 2, 1, 7, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('83262f32-ec69-4797-9aaf-e5aace944701', '8bc82813-3ed0-459d-a1bb-f0dcaf524300', 2, 1, 8, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('880587d4-61aa-4a5f-9083-9b9212ab25c0', 'f13898da-1eb4-47c4-89e2-8f38d009bc3c', 2, 1, 8, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('8da95228-d202-49b5-80b6-a5a239f5a2e6', '21469197-833c-4e11-a1e2-346e6b4123a6', 3, 1, 13, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('8e52209d-ba39-43ff-9282-6d9160e992f2', 'ab9e5aff-2dfe-4062-9fb1-3f1f5980ee5c', 3, 1, 14, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('973891ea-5cc4-4524-b490-fab818b0887e', 'ab241e59-1bbc-444d-b59d-49eb768b4981', 1, 0, 2, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('975bc393-15f0-447d-a503-47ee662ab329', 'fe3b1621-c860-4f4f-994c-04fca06a4919', 2, 1, 7, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('9febbad8-39df-455c-882c-60828c7508de', '52dd7a42-4499-41ea-a673-61bfecafbb58', 1, 0, 2, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('a49b3b66-d88d-448a-a0a4-5aa4f6c82fa5', '8fb4955e-688a-4e01-bbe4-872218262a1d', 3, 1, 5, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('a9177c5d-a8ec-44e4-9e62-52faa76beb5e', '139e7f1b-ca27-4000-96c2-3e5b4dda3c3e', 3, 1, 3, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('aa228eef-ea60-4a9e-a25b-7d0abbf8f6e2', 'b90f7b11-a722-47a5-a04a-9e27cdf10348', 3, 1, 11, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('b7f3605c-8737-4754-a93d-c7a5adc94149', '152ce08f-b465-44f8-9560-32e09a67865f', 2, 1, 8, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('bcf89d88-1a61-452d-9fb4-4f882e0e713b', '88e1079d-1f9f-4ad6-a7f2-6bd43d18e377', 3, 1, 12, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('d7a0f444-f339-44d6-9e45-6c8820f927c7', 'c1e11e5d-ac2d-4a80-8cb0-9177a8d8249c', 3, 1, 10, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('d808ae7b-892f-4750-853f-c8c712bf8087', 'da73ab7e-cbbe-4ce5-9d4b-555298d0024a', 2, 1, 6, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('d8e34b63-9aaf-4838-99b5-5bf7bb715145', '5d315324-9c16-4040-9a39-f61e41e9e459', 3, 1, 4, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('eac34de1-b22c-4ff8-acd5-0e3f687e29c6', 'abc97793-4669-4ce7-a770-71a7fe8d764b', 3, 1, 13, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('f0acc860-af12-45a7-aa74-2cd29c4e0734', '6ae06442-1544-4a5a-9f3a-bcc5a87711e6', 3, 1, 12, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('f534cb81-2513-428b-b018-c9dde9d783cb', '390d1816-4beb-4884-b156-10374f142e1b', 3, 1, 4, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('f7b595f2-b5ba-4a00-b373-b3f26b3691f7', '3e91bb3f-3d2e-4ca7-a51d-8c7a4d244d54', 2, 1, 1, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('f87fe2cb-a312-43a8-8d5e-0ba19527d74b', '30a796b4-bbd4-4d8e-9b86-8940a7b1bea9', 3, 1, 3, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('f8b40a5c-5523-4698-9855-b84a37fab0e6', 'd1fd38a0-6086-42aa-bc47-56ec3ba98197', 2, 1, 1, 1, 1, NULL, NULL, NOW(), NOW());
INSERT INTO `xxbdo_estandares_alertas` VALUES('fec24c66-2e65-4d33-b1ea-efb58aae4766', 'ff0647e5-6b8a-4e64-83f6-90e986c90fee', 3, 1, 15, 1, 1, NULL, NULL, NOW(), NOW());


COMMIT;
