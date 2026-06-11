<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Citas"/>
<%@ include file="includes/app-shell.jspf" %>
<div class="grid grid-2">
    <div class="card">
        <h3>${empty cita ? 'Nueva cita' : 'Editar cita'}</h3>
        <form method="post" class="grid">
            <input type="hidden" name="idCita" value="${cita.idCita}">
            <select name="idCliente" required>
                <option value="">Cliente</option>
                <c:forEach var="clienteItem" items="${clientes}">
                    <option value="${clienteItem.idCliente}" ${cita.idCliente eq clienteItem.idCliente ? 'selected' : ''}>${clienteItem.nombreCompleto}</option>
                </c:forEach>
            </select>
            <select name="idMascota" required>
                <option value="">Mascota</option>
                <c:forEach var="mascotaItem" items="${mascotas}">
                    <option value="${mascotaItem.idMascota}" ${cita.idMascota eq mascotaItem.idMascota ? 'selected' : ''}>${mascotaItem.nombre}</option>
                </c:forEach>
            </select>
            <select name="idVeterinario">
                <option value="">Veterinario</option>
                <c:forEach var="vet" items="${veterinarios}">
                    <option value="${vet.idUsuario}" ${cita.idVeterinario eq vet.idUsuario ? 'selected' : ''}>${vet.nombreCompleto}</option>
                </c:forEach>
            </select>
            <input type="date" name="fechaCita" value="${cita.fechaCita}" required>
            <input type="time" name="horaCita" value="${cita.horaCita}" required>
            <input type="text" name="motivo" placeholder="Motivo" value="${cita.motivo}" required>
            <textarea name="observaciones" placeholder="Observaciones">${cita.observaciones}</textarea>
            <select name="estado">
                <option value="PENDIENTE">PENDIENTE</option>
                <option value="CONFIRMADA" ${cita.estado eq 'CONFIRMADA' ? 'selected' : ''}>CONFIRMADA</option>
                <option value="ATENDIDA" ${cita.estado eq 'ATENDIDA' ? 'selected' : ''}>ATENDIDA</option>
                <option value="CANCELADA" ${cita.estado eq 'CANCELADA' ? 'selected' : ''}>CANCELADA</option>
                <option value="NO_ASISTIO" ${cita.estado eq 'NO_ASISTIO' ? 'selected' : ''}>NO_ASISTIO</option>
            </select>
            <button type="submit">Guardar</button>
        </form>
    </div>
    <div class="card">
        <form method="get" class="inline-form">
            <input type="date" name="fecha" value="${param.fecha}">
            <select name="estado">
                <option value="">Todos los estados</option>
                <option value="PENDIENTE">PENDIENTE</option>
                <option value="CONFIRMADA">CONFIRMADA</option>
                <option value="ATENDIDA">ATENDIDA</option>
                <option value="CANCELADA">CANCELADA</option>
                <option value="NO_ASISTIO">NO_ASISTIO</option>
            </select>
            <input type="text" name="search" placeholder="Cliente o mascota" value="${param.search}">
            <button type="submit">Filtrar</button>
        </form>
        <table>
            <thead><tr><th>Fecha</th><th>Mascota</th><th>Cliente</th><th>Veterinario</th><th>Estado</th><th></th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${citas}">
                <tr>
                    <td>${item.fechaCita} ${item.horaCita}</td>
                    <td>${item.mascotaNombre}</td>
                    <td>${item.clienteNombre}</td>
                    <td>${item.veterinarioNombre}</td>
                    <td>${item.estado}</td>
                    <td><a href="${pageContext.request.contextPath}/app/citas?action=edit&id=${item.idCita}">Editar</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="includes/app-shell-end.jspf" %>
