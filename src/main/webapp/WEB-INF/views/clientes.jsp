<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Clientes"/>
<%@ include file="includes/app-shell.jspf" %>
<div class="grid grid-2">
    <div class="card">
        <h3>${empty cliente ? 'Nuevo cliente' : 'Editar cliente'}</h3>
        <form method="post" class="grid">
            <input type="hidden" name="idCliente" value="${cliente.idCliente}">
            <input type="text" name="nombres" placeholder="Nombres" value="${cliente.nombres}" required>
            <input type="text" name="apellidos" placeholder="Apellidos" value="${cliente.apellidos}" required>
            <input type="text" name="dni" placeholder="DNI" value="${cliente.dni}" required>
            <input type="text" name="telefono" placeholder="Teléfono" value="${cliente.telefono}" required>
            <input type="email" name="correo" placeholder="Correo" value="${cliente.correo}">
            <input type="text" name="direccion" placeholder="Dirección" value="${cliente.direccion}" required>
            <select name="estado">
                <option value="ACTIVO" ${cliente.estado eq 'ACTIVO' ? 'selected' : ''}>ACTIVO</option>
                <option value="INACTIVO" ${cliente.estado eq 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
            </select>
            <button type="submit">Guardar</button>
        </form>
    </div>
    <div class="card">
        <form method="get" class="inline-form">
            <input type="text" name="search" placeholder="Buscar por DNI, nombre o teléfono" value="${param.search}">
            <button type="submit">Buscar</button>
        </form>
        <table>
            <thead>
            <tr><th>Cliente</th><th>DNI</th><th>Teléfono</th><th>Estado</th><th></th></tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${clientes}">
                <tr>
                    <td>${item.nombreCompleto}</td>
                    <td>${item.dni}</td>
                    <td>${item.telefono}</td>
                    <td>${item.estado}</td>
                    <td><a href="${pageContext.request.contextPath}/app/clientes?action=edit&id=${item.idCliente}">Editar</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="includes/app-shell-end.jspf" %>
