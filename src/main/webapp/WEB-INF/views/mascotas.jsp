<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Mascotas"/>
<%@ include file="includes/app-shell.jspf" %>
<div class="grid grid-2">
    <div class="card">
        <h3>${empty mascota ? 'Nueva mascota' : 'Editar mascota'}</h3>
        <form method="post" class="grid">
            <input type="hidden" name="idMascota" value="${mascota.idMascota}">
            <select name="idCliente" required>
                <option value="">Cliente</option>
                <c:forEach var="clienteItem" items="${clientes}">
                    <option value="${clienteItem.idCliente}" ${mascota.idCliente eq clienteItem.idCliente ? 'selected' : ''}>${clienteItem.nombreCompleto}</option>
                </c:forEach>
            </select>
            <select name="idEspecie" required>
                <option value="">Especie</option>
                <c:forEach var="especieItem" items="${especies}">
                    <option value="${especieItem.idEspecie}" ${mascota.idEspecie eq especieItem.idEspecie ? 'selected' : ''}>${especieItem.nombre}</option>
                </c:forEach>
            </select>
            <input type="text" name="nombre" placeholder="Nombre" value="${mascota.nombre}" required>
            <input type="text" name="raza" placeholder="Raza" value="${mascota.raza}">
            <select name="sexo">
                <option value="NO_DEFINIDO">NO_DEFINIDO</option>
                <option value="MACHO" ${mascota.sexo eq 'MACHO' ? 'selected' : ''}>MACHO</option>
                <option value="HEMBRA" ${mascota.sexo eq 'HEMBRA' ? 'selected' : ''}>HEMBRA</option>
            </select>
            <input type="text" name="color" placeholder="Color" value="${mascota.color}">
            <input type="date" name="fechaNacimiento" value="${mascota.fechaNacimiento}">
            <input type="number" step="0.01" name="peso" placeholder="Peso" value="${mascota.peso}">
            <textarea name="observaciones" placeholder="Observaciones">${mascota.observaciones}</textarea>
            <select name="estado">
                <option value="ACTIVO">ACTIVO</option>
                <option value="INACTIVO" ${mascota.estado eq 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
                <option value="FALLECIDO" ${mascota.estado eq 'FALLECIDO' ? 'selected' : ''}>FALLECIDO</option>
            </select>
            <button type="submit">Guardar</button>
        </form>
    </div>
    <div class="card">
        <form method="get" class="inline-form">
            <input type="text" name="search" placeholder="Buscar por mascota, especie o propietario" value="${param.search}">
            <button type="submit">Buscar</button>
        </form>
        <table>
            <thead><tr><th>Mascota</th><th>Especie</th><th>Cliente</th><th>Estado</th><th></th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${mascotas}">
                <tr>
                    <td>${item.nombre}</td>
                    <td>${item.especieNombre}</td>
                    <td>${item.clienteNombre}</td>
                    <td>${item.estado}</td>
                    <td><a href="${pageContext.request.contextPath}/app/mascotas?action=edit&id=${item.idMascota}">Editar</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="includes/app-shell-end.jspf" %>
