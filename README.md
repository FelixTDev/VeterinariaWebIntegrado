# Veterinaria Web

Proyecto MVC clásico con `Jakarta Servlet/JSP`, `Maven`, `Tomcat 10.1+` y `MySQL`.

## Requisitos

- JDK 21 o superior
- Maven 3.9+
- Tomcat 10.1+
- MySQL 9.x

## Base de datos

1. Crea la BD ejecutando `bd_veterinaria_mysql.sql`.
2. Agrega la tabla de auditoría ejecutando el bloque final de [database/veterinaria_schema.sql](/C:/Users/felix/PROYECTO-ROUS/database/veterinaria_schema.sql).
3. Ajusta credenciales en [src/main/resources/db.properties](/C:/Users/felix/PROYECTO-ROUS/src/main/resources/db.properties).

## Compilación

```bash
mvn clean package
```

## Despliegue

1. Genera el WAR con Maven.
2. Despliega `target/veterinaria-web.war` en Tomcat 10.1+.
3. Abre `http://localhost:8080/veterinaria-web/login`.

## Usuarios demo

- `admin / admin123`
- `lquispe / vet123`
- `atorres / recep123`

En el primer login exitoso, si la contraseña en la BD estaba en texto plano, el sistema la migra automáticamente a BCrypt.
