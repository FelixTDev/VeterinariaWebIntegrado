<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Reportes"/>
<%@ include file="includes/app-shell.jspf" %>
<div class="card">
    <form method="get" class="inline-form">
        <input type="date" name="desde" value="${desde}">
        <input type="date" name="hasta" value="${hasta}">
        <button type="submit">Generar</button>
    </form>
</div>
<div class="grid grid-2" style="margin-top:18px;">
    <div class="card">
        <h3>Citas por rango</h3>
        <table>
            <thead><tr><th>Fecha</th><th>Total</th></tr></thead>
            <tbody>
            <c:forEach var="row" items="${citasRango}">
                <tr><td>${row.etiqueta}</td><td>${row.total}</td></tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <div class="card">
        <h3>Ingresos por rango</h3>
        <table>
            <thead><tr><th>Fecha</th><th>Total</th></tr></thead>
            <tbody>
            <c:forEach var="row" items="${ingresosRango}">
                <tr><td>${row.etiqueta}</td><td>${row.total}</td></tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<div class="grid grid-2" style="margin-top:18px;">
    <div class="card">
        <h3>Productos con bajo stock</h3>
        <table>
            <thead><tr><th>Producto</th><th>Stock</th><th>Mínimo</th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${bajoStock}">
                <tr><td>${item.nombre}</td><td>${item.stock}</td><td>${item.stockMinimo}</td></tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <div class="card">
        <h3>Productos próximos a vencer</h3>
        <table>
            <thead><tr><th>Producto</th><th>Vencimiento</th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${porVencer}">
                <tr><td>${item.nombre}</td><td>${item.fechaVencimiento}</td></tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<div class="card" style="margin-top:18px;">
    <h3>Movimientos recientes</h3>
    <table>
        <thead><tr><th>Fecha</th><th>Producto</th><th>Tipo</th><th>Cantidad</th><th>Usuario</th></tr></thead>
        <tbody>
        <c:forEach var="item" items="${movimientos}">
            <tr>
                <td>${item.fechaMovimiento}</td>
                <td>${item.productoNombre}</td>
                <td>${item.tipoMovimiento}</td>
                <td>${item.cantidad}</td>
                <td>${item.usuarioNombre}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<%@ include file="includes/app-shell-end.jspf" %>
