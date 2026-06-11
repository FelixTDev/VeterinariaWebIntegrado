<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login | Veterinaria</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<div class="login-shell">
    <div class="card login-card">
        <h1>Acceso al Sistema</h1>
        <p>Usuarios demo del SQL actual: <strong>admin</strong>, <strong>lquispe</strong>, <strong>atorres</strong>.</p>
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>
        <form method="post" action="${pageContext.request.contextPath}/login" class="grid">
            <div>
                <label>Usuario</label>
                <input type="text" name="username" required>
            </div>
            <div>
                <label>Contraseña</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit">Ingresar</button>
        </form>
    </div>
</div>
</body>
</html>
