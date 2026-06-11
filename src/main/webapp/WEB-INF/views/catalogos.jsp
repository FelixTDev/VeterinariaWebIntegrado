<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Catálogos"/>
<%@ include file="includes/app-shell.jspf" %>
<div class="grid grid-2">
    <div class="card">
        <h3>Especies</h3>
        <form method="post" class="grid">
            <input type="hidden" name="formType" value="especie">
            <input type="hidden" name="idEspecie" value="${especie.idEspecie}">
            <input type="text" name="nombreEspecie" placeholder="Nombre" value="${especie.nombre}" required>
            <textarea name="descripcionEspecie" placeholder="Descripción">${especie.descripcion}</textarea>
            <select name="estadoEspecie">
                <option value="ACTIVO">ACTIVO</option>
                <option value="INACTIVO" ${especie.estado eq 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
            </select>
            <button type="submit">Guardar especie</button>
        </form>
        <table>
            <thead><tr><th>Nombre</th><th>Estado</th><th></th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${especies}">
                <tr>
                    <td>${item.nombre}</td>
                    <td>${item.estado}</td>
                    <td><a href="${pageContext.request.contextPath}/app/catalogos?tipo=especie&id=${item.idEspecie}">Editar</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <div class="card">
        <h3>Tipos de producto</h3>
        <form method="post" class="grid">
            <input type="hidden" name="formType" value="tipoProducto">
            <input type="hidden" name="idTipoProducto" value="${tipoProducto.idTipoProducto}">
            <input type="text" name="nombreTipoProducto" placeholder="Nombre" value="${tipoProducto.nombre}" required>
            <textarea name="descripcionTipoProducto" placeholder="Descripción">${tipoProducto.descripcion}</textarea>
            <select name="estadoTipoProducto">
                <option value="ACTIVO">ACTIVO</option>
                <option value="INACTIVO" ${tipoProducto.estado eq 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
            </select>
            <button type="submit">Guardar tipo</button>
        </form>
        <table>
            <thead><tr><th>Nombre</th><th>Estado</th><th></th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${tiposProducto}">
                <tr>
                    <td>${item.nombre}</td>
                    <td>${item.estado}</td>
                    <td><a href="${pageContext.request.contextPath}/app/catalogos?tipo=tipoProducto&id=${item.idTipoProducto}">Editar</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="includes/app-shell-end.jspf" %>
