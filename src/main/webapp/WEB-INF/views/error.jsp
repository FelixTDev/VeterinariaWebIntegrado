<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Error"/>
<%@ include file="includes/app-shell.jspf" %>
<div class="card">
    <h3>Ocurrió un error</h3>
    <p>${error}</p>
    <p><a href="${pageContext.request.contextPath}/app/dashboard">Volver al dashboard</a></p>
</div>
<%@ include file="includes/app-shell-end.jspf" %>
