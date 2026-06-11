<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Dashboard"/>
<%@ include file="includes/app-shell.jspf" %>
<div class="grid grid-4">
    <div class="card"><div>Clientes activos</div><div class="stat">${stats.clientes}</div></div>
    <div class="card"><div>Mascotas activas</div><div class="stat">${stats.mascotas}</div></div>
    <div class="card"><div>Citas de hoy</div><div class="stat">${stats.citasHoy}</div></div>
    <div class="card"><div>Productos bajo stock</div><div class="stat">${stats.bajoStock}</div></div>
</div>
<div class="card" style="margin-top:18px;">
    <h3>Movimientos recientes de inventario</h3>
    <table>
        <thead>
        <tr><th>Fecha</th><th>Producto</th><th>Tipo</th><th>Cantidad</th><th>Usuario</th><th>Referencia</th></tr>
        </thead>
        <tbody>
        <c:forEach var="mov" items="${movimientos}">
            <tr>
                <td>${mov.fechaMovimiento}</td>
                <td>${mov.productoNombre}</td>
                <td>${mov.tipoMovimiento}</td>
                <td>${mov.cantidad}</td>
                <td>${mov.usuarioNombre}</td>
                <td>${mov.referencia}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<%@ include file="includes/app-shell-end.jspf" %>
