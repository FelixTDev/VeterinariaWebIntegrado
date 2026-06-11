# Veterinaria Web

Proyecto MVC clásico con `Jakarta Servlet/JSP`, `Maven`, `Tomcat 10.1+` y `MySQL`.

## Stack

- Java 21 o 22
- Maven 3.9+
- Tomcat 10.1+
- MySQL 9.x

## Clonar el proyecto

```bash
git clone https://github.com/FelixTDev/VeterinariaWebIntegrado.git
cd VeterinariaWebIntegrado
```

## Configurar Java

El proyecto compila por defecto con Java 21 para evitar fallos en máquinas que todavía no tienen JDK 22.

Verifica tu entorno:

```bash
java -version
mvn -version
```

Ambos comandos deben mostrar al menos Java 21.

Si estás en NetBeans:

1. Abre el proyecto Maven.
2. Ve a `Project Properties > Libraries`.
3. Selecciona la plataforma `JDK 21` o `JDK 22`.
4. Verifica que el servidor asignado sea `Tomcat 10.1+`.

## Si quieres usar Java 22

Tienes dos opciones:

1. Cambiar temporalmente el release al compilar:

```bash
mvn clean test -Dmaven.compiler.release=22
mvn clean package -Dmaven.compiler.release=22
```

2. O editar [pom.xml](/C:/Users/felix/PROYECTO-ROUS/pom.xml) y cambiar:

```xml
<maven.compiler.release>21</maven.compiler.release>
```

por:

```xml
<maven.compiler.release>22</maven.compiler.release>
```

Haz esto solo si `java -version` y `mvn -version` ya están corriendo con JDK 22.

## Base de datos

1. Ejecuta [bd_veterinaria_mysql.sql](/C:/Users/felix/PROYECTO-ROUS/bd_veterinaria_mysql.sql).
2. Luego crea la tabla de auditoría usando [database/veterinaria_schema.sql](/C:/Users/felix/PROYECTO-ROUS/database/veterinaria_schema.sql).
3. Ajusta las credenciales en [src/main/resources/db.properties](/C:/Users/felix/PROYECTO-ROUS/src/main/resources/db.properties).

Configuración actual de ejemplo:

```properties
db.url=jdbc:mysql://localhost:3306/veterinaria_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=America/Lima
db.user=root
db.password=123456
db.driver=com.mysql.cj.jdbc.Driver
```

## Compilar y probar

```bash
mvn clean test
mvn clean package
```

Si todo sale bien, se generará:

```bash
target/veterinaria-web.war
```

## Despliegue en Tomcat

1. Inicia `Tomcat 10.1+`.
2. Despliega `target/veterinaria-web.war`.
3. Abre:

```text
http://localhost:8080/veterinaria-web/login
```

## Usuarios demo

- `admin / admin123`
- `lquispe / vet123`
- `atorres / recep123`

En el primer login exitoso, si la contraseña de la BD estaba en texto plano, el sistema la migra automáticamente a BCrypt.

## Estructura general

- `src/main/java/com/veterinaria/controller`: Servlets
- `src/main/java/com/veterinaria/service`: lógica de negocio
- `src/main/java/com/veterinaria/dao`: acceso a datos JDBC
- `src/main/java/com/veterinaria/model`: entidades
- `src/main/webapp/WEB-INF/views`: vistas JSP
- `database/`: scripts auxiliares SQL

## Validaciones importantes implementadas

- login con sesión y roles
- migración automática de contraseñas legacy a hash BCrypt
- DNI único para clientes
- mascota obligatoriamente asociada a cliente y especie válida
- stock no negativo
- alerta de bajo stock y próximos a vencer
- citas sin fecha pasada
- bloqueo de cruce de horario por veterinario
- atención clínica solo desde cita `ATENDIDA`
- emisión de comprobante con al menos un detalle
- anulación de comprobante con restitución de stock
- auditoría de operaciones críticas
