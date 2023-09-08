# BDO - API Movilidad en Tienda
------------------------------

## Uso:

1. Descargar e instalar Node 8.11.3
https://nodejs.org/en/download/

2. Instalar MySQL 5.7.21, puede instalar el software Bitnami Wamp stack 7.1.21 que incluye MySQL:
https://bitnami.com/stack/wamp/installer

2.1 Al seleccionar las aplicaciones a instalar, seleccione unicamente PHPMyAdmin
2.2 Al instalar MySQL, guarde el password de root

5. Clone el proyecto API-MovilidadEntienda :
- `git clone https://coemov.visualstudio.com/API-MovilidadEnTienda/_git/API-MovilidadEnTienda`
- `cd ApiMovilidadEnTienda`
- `npm install`

6. Dentro de la carpeta:
API-MovilidadEntienda/
Crear el archivo:
 "API-MovilidadEntienda/nodemon.json"
con el siguiente contenido:
```
{
    "env":{
        "TZ":"UTC"
    }
}
```

7. Copie el archivo:
API-MovilidadEntienda/config/default.json
a
API-MovilidadEntienda/config/development.json

8. Ejecute las siguientes instrucciones dentro de la carpeta del proyecto para crear su base de datos local:
- `cd api/v1/data/database/sql/`
- `mysql -u root < db.sql`

9. Escriba los parametros correctos de conexión a su base de datos local en
   el archivo:
   API-MovilidadEntienda/config/development.json

10. Finalmente, para iniciar el servidor node local, ejecute la siguiente instrucción dentro de la carpeta del proyecto:
- `npm start`
