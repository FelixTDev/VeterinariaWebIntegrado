<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Historial Clínico"/>
<%@ include file="includes/app-shell.jspf" %>
<div class="grid grid-2">
    <div class="card">
        <h3>Nueva atención clínica</h3>
        <form method="post" class="grid">
            <select name="idCita" required>
                <option value="">Cita atendida</option>
                <c:forEach var="citaItem" items="${citas}">
                    <option value="${citaItem.idCita}" ${atencion.idCita eq citaItem.idCita ? 'selected' : ''}>#${citaItem.idCita} - ${citaItem.mascotaNombre}</option>
                </c:forEach>
            </select>
            <select name="idMascota" required>
                <option value="">Mascota</option>
                <c:forEach var="mascotaItem" items="${mascotas}">
                    <option value="${mascotaItem.idMascota}" ${atencion.idMascota eq mascotaItem.idMascota ? 'selected' : ''}>${mascotaItem.nombre}</option>
                </c:forEach>
            </select>
            <select name="idVeterinario" required>
                <option value="">Veterinario</option>
                <c:forEach var="vet" items="${veterinarios}">
                    <option value="${vet.idUsuario}" ${atencion.idVeterinario eq vet.idUsuario ? 'selected' : ''}>${vet.nombreCompleto}</option>
                </c:forEach>
            </select>
            <input type="number" step="0.01" name="peso" placeholder="Peso" value="${atencion.peso}">
            <input type="number" step="0.1" name="temperatura" placeholder="Temperatura" value="${atencion.temperatura}">
            <textarea name="sintomas" placeholder="Síntomas">${atencion.sintomas}</textarea>
            <textarea name="diagnostico" placeholder="Diagnóstico" required>${atencion.diagnostico}</textarea>
            <textarea name="tratamiento" placeholder="Tratamiento">${atencion.tratamiento}</textarea>
            <textarea name="observaciones" placeholder="Observaciones">${atencion.observaciones}</textarea>
            <h4>Productos aplicados</h4>
            <select name="detalleProductoId">
                <option value="">Producto</option>
                <c:forEach var="productoItem" items="${productos}">
                    <option value="${productoItem.idProducto}">${productoItem.nombre}</option>
                </c:forEach>
            </select>
            <input type="number" name="detalleCantidad" value="1" min="1">
            <input type="text" name="detalleDosis" placeholder="Dosis">
            <input type="text" name="detalleIndicaciones" placeholder="Indicaciones">
            <button type="submit">Registrar atención</button>
        </form>
    </div>
    <div class="card">
        <form method="get" class="inline-form">
            <select name="idMascota">
                <option value="">Selecciona mascota</option>
                <c:forEach var="mascotaItem" items="${mascotas}">
                    <option value="${mascotaItem.idMascota}" ${param.idMascota eq mascotaItem.idMascota.toString() ? 'selected' : ''}>${mascotaItem.nombre}</option>
                </c:forEach>
            </select>
            <button type="submit">Ver historial</button>
        </form>
        <table>
            <thead><tr><th>Fecha</th><th>Diagnóstico</th><th>Veterinario</th><th></th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${historial}">
                <tr>
                    <td>${item.fechaAtencion}</td>
                    <td>${item.diagnostico}</td>
                    <td>${item.veterinarioNombre}</td>
                    <td><a href="${pageContext.request.contextPath}/app/atenciones?action=view&id=${item.idAtencion}">Ver</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <c:if test="${not empty atencion and not empty atencion.detalles}">
            <h4>Detalle de atención</h4>
            <div class="details-grid">
                <div>Mascota: ${atencion.mascotaNombre}</div>
                <div>Diagnóstico: ${atencion.diagnostico}</div>
                <div>Tratamiento: ${atencion.tratamiento}</div>
            </div>
        </c:if>
    </div>
</div>
<%@ include file="includes/app-shell-end.jspf" %>
