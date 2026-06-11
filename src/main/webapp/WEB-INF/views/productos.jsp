<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Productos"/>
<%@ include file="includes/app-shell.jspf" %>
<div class="grid grid-2">
    <div class="card">
        <h3>${empty producto ? 'Nuevo producto' : 'Editar producto'}</h3>
        <form method="post" class="grid">
            <input type="hidden" name="idProducto" value="${producto.idProducto}">
            <select name="idTipoProducto" required>
                <option value="">Tipo de producto</option>
                <c:forEach var="tipo" items="${tiposProducto}">
                    <option value="${tipo.idTipoProducto}" ${producto.idTipoProducto eq tipo.idTipoProducto ? 'selected' : ''}>${tipo.nombre}</option>
                </c:forEach>
            </select>
            <input type="text" name="codigo" placeholder="Código" value="${producto.codigo}" required>
            <input type="text" name="nombre" placeholder="Nombre" value="${producto.nombre}" required>
            <textarea name="descripcion" placeholder="Descripción">${producto.descripcion}</textarea>
            <input type="number" name="stock" placeholder="Stock" value="${producto.stock}" required>
            <input type="number" name="stockMinimo" placeholder="Stock mínimo" value="${producto.stockMinimo}" required>
            <input type="number" step="0.01" name="precioCompra" placeholder="Precio compra" value="${producto.precioCompra}" required>
            <input type="number" step="0.01" name="precioVenta" placeholder="Precio venta" value="${producto.precioVenta}" required>
            <input type="date" name="fechaVencimiento" value="${producto.fechaVencimiento}">
            <label><input type="checkbox" name="requiereReceta" ${producto.requiereReceta ? 'checked' : ''}> Requiere receta</label>
            <select name="estado">
                <option value="ACTIVO">ACTIVO</option>
                <option value="INACTIVO" ${producto.estado eq 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
            </select>
            <button type="submit">Guardar</button>
        </form>
    </div>
    <div class="card">
        <form method="get" class="inline-form">
            <input type="text" name="search" placeholder="Buscar por código, nombre o tipo" value="${param.search}">
            <button type="submit">Buscar</button>
        </form>
        <table>
            <thead><tr><th>Código</th><th>Nombre</th><th>Stock</th><th>Tipo</th><th></th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${productos}">
                <tr>
                    <td>${item.codigo}</td>
                    <td>${item.nombre}</td>
                    <td>${item.stock}</td>
                    <td>${item.tipoProductoNombre}</td>
                    <td><a href="${pageContext.request.contextPath}/app/productos?action=edit&id=${item.idProducto}">Editar</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <h4>Alertas</h4>
        <p>Bajo stock: ${bajoStock.size()} | Próximos a vencer: ${porVencer.size()}</p>
    </div>
</div>
<%@ include file="includes/app-shell-end.jspf" %>
