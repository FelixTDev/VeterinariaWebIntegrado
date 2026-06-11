<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Comprobantes"/>
<%@ include file="includes/app-shell.jspf" %>
<div class="grid grid-2">
    <div class="card">
        <h3>Emitir comprobante</h3>
        <form method="post" class="grid">
            <select name="idCliente" required>
                <option value="">Cliente</option>
                <c:forEach var="clienteItem" items="${clientes}">
                    <option value="${clienteItem.idCliente}" ${comprobante.idCliente eq clienteItem.idCliente ? 'selected' : ''}>${clienteItem.nombreCompleto}</option>
                </c:forEach>
            </select>
            <select name="idMascota">
                <option value="">Mascota</option>
                <c:forEach var="mascotaItem" items="${mascotas}">
                    <option value="${mascotaItem.idMascota}" ${comprobante.idMascota eq mascotaItem.idMascota ? 'selected' : ''}>${mascotaItem.nombre}</option>
                </c:forEach>
            </select>
            <select name="tipoComprobante" required>
                <option value="BOLETA">BOLETA</option>
                <option value="FACTURA">FACTURA</option>
                <option value="RECIBO">RECIBO</option>
            </select>
            <select name="metodoPago" required>
                <option value="EFECTIVO">EFECTIVO</option>
                <option value="TARJETA">TARJETA</option>
                <option value="YAPE">YAPE</option>
                <option value="PLIN">PLIN</option>
                <option value="TRANSFERENCIA">TRANSFERENCIA</option>
            </select>
            <textarea name="observaciones" placeholder="Observaciones">${comprobante.observaciones}</textarea>
            <h4>Detalle</h4>
            <select name="detalleTipo">
                <option value="SERVICIO">SERVICIO</option>
                <option value="PRODUCTO">PRODUCTO</option>
            </select>
            <select name="detalleProductoId">
                <option value="">Producto opcional</option>
                <c:forEach var="productoItem" items="${productos}">
                    <option value="${productoItem.idProducto}">${productoItem.nombre}</option>
                </c:forEach>
            </select>
            <input type="text" name="detalleDescripcion" placeholder="Descripción del servicio o producto">
            <input type="number" name="detalleCantidad" value="1" min="1">
            <input type="number" step="0.01" name="detallePrecio" placeholder="Precio (si es servicio)">
            <button type="submit">Emitir comprobante</button>
        </form>
    </div>
    <div class="card">
        <form method="get" class="inline-form">
            <input type="date" name="fecha" value="${param.fecha}">
            <select name="estado">
                <option value="">Todos</option>
                <option value="EMITIDO">EMITIDO</option>
                <option value="PAGADO">PAGADO</option>
                <option value="ANULADO">ANULADO</option>
            </select>
            <input type="text" name="search" placeholder="Número o cliente" value="${param.search}">
            <button type="submit">Filtrar</button>
        </form>
        <table>
            <thead><tr><th>Número</th><th>Cliente</th><th>Total</th><th>Estado</th><th>Acciones</th></tr></thead>
            <tbody>
            <c:forEach var="item" items="${comprobantes}">
                <tr>
                    <td>${item.numeroComprobante}</td>
                    <td>${item.clienteNombre}</td>
                    <td>${item.total}</td>
                    <td>${item.estado}</td>
                    <td class="actions">
                        <a href="${pageContext.request.contextPath}/app/comprobantes?action=view&id=${item.idComprobante}">Ver</a>
                        <c:if test="${item.estado ne 'ANULADO'}">
                            <form method="post" action="${pageContext.request.contextPath}/app/comprobantes" style="display:inline;">
                                <input type="hidden" name="formAction" value="anular">
                                <input type="hidden" name="idComprobante" value="${item.idComprobante}">
                                <button type="submit">Anular</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <c:if test="${not empty comprobante and not empty comprobante.detalles}">
            <h4>Detalle del comprobante</h4>
            <table>
                <thead><tr><th>Tipo</th><th>Descripción</th><th>Cantidad</th><th>Subtotal</th></tr></thead>
                <tbody>
                <c:forEach var="detalle" items="${comprobante.detalles}">
                    <tr>
                        <td>${detalle.tipoItem}</td>
                        <td>${detalle.descripcion}</td>
                        <td>${detalle.cantidad}</td>
                        <td>${detalle.subtotal}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>
<%@ include file="includes/app-shell-end.jspf" %>
