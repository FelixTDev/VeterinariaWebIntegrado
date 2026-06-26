<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Comprobantes"/>
<c:set var="headerSearchPlaceholder" value="Buscar ventas, clientes o numeros de comprobante..."/>
<c:set var="emitidos" value="0"/>
<c:set var="anulados" value="0"/>
<c:set var="pagados" value="0"/>
<c:set var="totalFacturado" value="0"/>
<c:forEach var="item" items="${comprobantes}">
    <c:set var="totalFacturado" value="${totalFacturado + item.total}"/>
    <c:if test="${item.estado eq 'EMITIDO'}"><c:set var="emitidos" value="${emitidos + 1}"/></c:if>
    <c:if test="${item.estado eq 'ANULADO'}"><c:set var="anulados" value="${anulados + 1}"/></c:if>
    <c:if test="${item.estado eq 'PAGADO'}"><c:set var="pagados" value="${pagados + 1}"/></c:if>
</c:forEach>
<%@ include file="includes/app-shell.jspf" %>

<section class="flex flex-col xl:flex-row xl:items-end justify-between gap-md">
    <div>
        <p class="text-label-md uppercase tracking-[0.18em] text-outline mb-xs">Facturacion</p>
        <h2 class="text-display-lg font-display-lg text-primary">Comprobantes y Cobros</h2>
        <p class="text-body-lg text-on-surface-variant">Emision, consulta y seguimiento de comprobantes desde una sola vista.</p>
    </div>
    <form method="get" class="glass-card rounded-2xl p-sm flex flex-col md:flex-row md:items-end gap-sm border border-outline-variant">
        <div class="px-sm">
            <label class="block text-[11px] font-bold text-outline uppercase tracking-wider mb-1" for="fechaFiltro">Fecha</label>
            <input class="bg-transparent border-outline-variant rounded-lg text-body-md focus:ring-primary" id="fechaFiltro" name="fecha" type="date" value="${param.fecha}">
        </div>
        <div class="px-sm">
            <label class="block text-[11px] font-bold text-outline uppercase tracking-wider mb-1" for="estadoFiltro">Estado</label>
            <select class="bg-transparent border-outline-variant rounded-lg text-body-md focus:ring-primary" id="estadoFiltro" name="estado">
                <option value="">Todos</option>
                <option value="EMITIDO" ${param.estado eq 'EMITIDO' ? 'selected' : ''}>Emitido</option>
                <option value="PAGADO" ${param.estado eq 'PAGADO' ? 'selected' : ''}>Pagado</option>
                <option value="ANULADO" ${param.estado eq 'ANULADO' ? 'selected' : ''}>Anulado</option>
            </select>
        </div>
        <div class="px-sm">
            <label class="block text-[11px] font-bold text-outline uppercase tracking-wider mb-1" for="searchFiltro">Buscar</label>
            <input class="bg-transparent border-outline-variant rounded-lg text-body-md focus:ring-primary" id="searchFiltro" name="search" placeholder="Numero o cliente" type="text" value="${param.search}">
        </div>
        <button class="flex items-center justify-center gap-xs px-lg py-sm bg-primary text-on-primary rounded-lg font-bold hover:opacity-90 transition-opacity w-auto" type="submit">
            <span class="material-symbols-outlined text-[18px]">filter_list</span>
            Filtrar
        </button>
    </form>
</section>

<section class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-md">
    <div class="bg-surface-container-lowest p-lg rounded-xl border border-outline-variant">
        <div class="flex justify-between items-start mb-sm">
            <div class="p-sm bg-primary/10 rounded-lg text-primary"><span class="material-symbols-outlined">payments</span></div>
            <span class="px-2 py-0.5 rounded-full text-label-md font-bold bg-primary-fixed text-primary">${fn:length(comprobantes)} total</span>
        </div>
        <p class="text-label-md text-on-surface-variant">Facturacion visible</p>
        <p class="text-headline-lg font-headline-lg text-primary mt-1">S/${totalFacturado}</p>
        <p class="text-xs text-outline mt-2">Suma de comprobantes listados</p>
    </div>
    <div class="bg-surface-container-lowest p-lg rounded-xl border border-outline-variant">
        <div class="flex justify-between items-start mb-sm">
            <div class="p-sm bg-secondary/10 rounded-lg text-secondary"><span class="material-symbols-outlined">receipt_long</span></div>
            <span class="px-2 py-0.5 rounded-full text-label-md font-bold bg-secondary-container/50 text-secondary">${emitidos}</span>
        </div>
        <p class="text-label-md text-on-surface-variant">Comprobantes emitidos</p>
        <p class="text-headline-lg font-headline-lg text-primary mt-1">${emitidos}</p>
        <p class="text-xs text-outline mt-2">Pendientes o emitidos sin anulacion</p>
    </div>
    <div class="bg-surface-container-lowest p-lg rounded-xl border border-outline-variant">
        <div class="flex justify-between items-start mb-sm">
            <div class="p-sm bg-tertiary/10 rounded-lg text-tertiary"><span class="material-symbols-outlined">task_alt</span></div>
            <span class="px-2 py-0.5 rounded-full text-label-md font-bold bg-tertiary-container/40 text-tertiary">${pagados}</span>
        </div>
        <p class="text-label-md text-on-surface-variant">Comprobantes pagados</p>
        <p class="text-headline-lg font-headline-lg text-primary mt-1">${pagados}</p>
        <p class="text-xs text-outline mt-2">Marcados como pagados</p>
    </div>
    <div class="bg-surface-container-lowest p-lg rounded-xl border border-outline-variant">
        <div class="flex justify-between items-start mb-sm">
            <div class="p-sm bg-error-container rounded-lg text-error"><span class="material-symbols-outlined">cancel</span></div>
            <span class="px-2 py-0.5 rounded-full text-label-md font-bold bg-error-container/70 text-error">${anulados}</span>
        </div>
        <p class="text-label-md text-on-surface-variant">Comprobantes anulados</p>
        <p class="text-headline-lg font-headline-lg text-error mt-1">${anulados}</p>
        <p class="text-xs text-outline mt-2">Documentos retirados de facturacion</p>
    </div>
</section>

<section class="grid grid-cols-1 xl:grid-cols-5 gap-lg">
    <div class="xl:col-span-2 bg-surface-container-lowest rounded-2xl border border-outline-variant overflow-hidden">
        <div class="p-lg border-b border-outline-variant">
            <h3 class="text-headline-md font-headline-md text-primary">Emitir comprobante</h3>
            <p class="text-body-md text-on-surface-variant mt-xs">Mantuvimos el flujo funcional actual y mejoramos la experiencia visual.</p>
        </div>
        <form method="post" class="p-lg space-y-lg">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-md">
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="idCliente">Cliente</label>
                    <select class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="idCliente" name="idCliente" required>
                        <option value="">Seleccione cliente</option>
                        <c:forEach var="clienteItem" items="${clientes}">
                            <option value="${clienteItem.idCliente}" ${comprobante.idCliente eq clienteItem.idCliente ? 'selected' : ''}>${clienteItem.nombreCompleto}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="idMascota">Mascota</label>
                    <select class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="idMascota" name="idMascota">
                        <option value="">Mascota opcional</option>
                        <c:forEach var="mascotaItem" items="${mascotas}">
                            <option value="${mascotaItem.idMascota}" ${comprobante.idMascota eq mascotaItem.idMascota ? 'selected' : ''}>${mascotaItem.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-md">
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="tipoComprobante">Tipo</label>
                    <select class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="tipoComprobante" name="tipoComprobante" required>
                        <option value="BOLETA" ${comprobante.tipoComprobante eq 'BOLETA' || empty comprobante.tipoComprobante ? 'selected' : ''}>BOLETA</option>
                        <option value="FACTURA" ${comprobante.tipoComprobante eq 'FACTURA' ? 'selected' : ''}>FACTURA</option>
                        <option value="RECIBO" ${comprobante.tipoComprobante eq 'RECIBO' ? 'selected' : ''}>RECIBO</option>
                    </select>
                </div>
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="metodoPago">Metodo de pago</label>
                    <select class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="metodoPago" name="metodoPago" required>
                        <option value="EFECTIVO" ${comprobante.metodoPago eq 'EFECTIVO' || empty comprobante.metodoPago ? 'selected' : ''}>EFECTIVO</option>
                        <option value="TARJETA" ${comprobante.metodoPago eq 'TARJETA' ? 'selected' : ''}>TARJETA</option>
                        <option value="YAPE" ${comprobante.metodoPago eq 'YAPE' ? 'selected' : ''}>YAPE</option>
                        <option value="PLIN" ${comprobante.metodoPago eq 'PLIN' ? 'selected' : ''}>PLIN</option>
                        <option value="TRANSFERENCIA" ${comprobante.metodoPago eq 'TRANSFERENCIA' ? 'selected' : ''}>TRANSFERENCIA</option>
                    </select>
                </div>
            </div>

            <div class="space-y-xs">
                <label class="text-label-md text-on-surface-variant font-bold" for="observaciones">Observaciones</label>
                <textarea class="w-full rounded-xl border-outline-variant focus:border-primary focus:ring-primary resize-none" id="observaciones" name="observaciones" placeholder="Notas internas, referencia de servicio o condiciones de pago..." rows="3">${comprobante.observaciones}</textarea>
            </div>

            <div class="rounded-xl border border-outline-variant bg-surface-container-low p-lg space-y-md">
                <div>
                    <h4 class="text-body-lg font-bold text-primary">Detalle del comprobante</h4>
                    <p class="text-label-md text-outline">Se conserva el modelo actual de un solo detalle por emision.</p>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-md">
                    <div class="space-y-xs">
                        <label class="text-label-md text-on-surface-variant font-bold" for="detalleTipo">Tipo de item</label>
                        <select class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="detalleTipo" name="detalleTipo">
                            <option value="SERVICIO">SERVICIO</option>
                            <option value="PRODUCTO">PRODUCTO</option>
                        </select>
                    </div>
                    <div class="space-y-xs">
                        <label class="text-label-md text-on-surface-variant font-bold" for="detalleProductoId">Producto</label>
                        <select class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="detalleProductoId" name="detalleProductoId">
                            <option value="">Producto opcional</option>
                            <c:forEach var="productoItem" items="${productos}">
                                <option value="${productoItem.idProducto}">${productoItem.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="detalleDescripcion">Descripcion</label>
                    <input class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="detalleDescripcion" name="detalleDescripcion" placeholder="Descripcion del servicio o producto" type="text">
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-md">
                    <div class="space-y-xs">
                        <label class="text-label-md text-on-surface-variant font-bold" for="detalleCantidad">Cantidad</label>
                        <input class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="detalleCantidad" min="1" name="detalleCantidad" type="number" value="1">
                    </div>
                    <div class="space-y-xs">
                        <label class="text-label-md text-on-surface-variant font-bold" for="detallePrecio">Precio</label>
                        <input class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="detallePrecio" name="detallePrecio" placeholder="Precio si es servicio" step="0.01" type="number">
                    </div>
                </div>
            </div>

            <div class="flex flex-col md:flex-row gap-sm">
                <button class="flex items-center justify-center gap-xs px-lg py-sm bg-primary text-on-primary rounded-lg font-bold hover:opacity-90 transition-opacity w-auto" type="submit">
                    <span class="material-symbols-outlined text-[18px]">receipt_long</span>
                    Emitir comprobante
                </button>
                <div class="text-body-md text-on-surface-variant flex items-center">El backend mantiene validaciones y calculos actuales.</div>
            </div>
        </form>
    </div>

    <div class="xl:col-span-3 space-y-lg">
        <div class="bg-surface-container-lowest rounded-2xl border border-outline-variant overflow-hidden">
            <div class="p-lg border-b border-outline-variant flex justify-between items-center">
                <div>
                    <h3 class="text-headline-md font-headline-md text-primary">Listado de comprobantes</h3>
                    <p class="text-body-md text-on-surface-variant">Consulta rapida de documentos emitidos, pagados o anulados.</p>
                </div>
                <span class="px-3 py-1 bg-primary-fixed text-primary text-xs font-bold rounded-full">${fn:length(comprobantes)} registro(s)</span>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead class="bg-surface-container-high/60">
                        <tr>
                            <th class="px-lg py-sm text-label-md text-outline font-bold uppercase tracking-wider">Numero</th>
                            <th class="px-lg py-sm text-label-md text-outline font-bold uppercase tracking-wider">Cliente</th>
                            <th class="px-lg py-sm text-label-md text-outline font-bold uppercase tracking-wider">Total</th>
                            <th class="px-lg py-sm text-label-md text-outline font-bold uppercase tracking-wider">Estado</th>
                            <th class="px-lg py-sm text-label-md text-outline font-bold uppercase tracking-wider text-right">Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-outline-variant">
                        <c:forEach var="item" items="${comprobantes}">
                            <tr class="hover:bg-surface-container/40 transition-colors">
                                <td class="px-lg py-md">
                                    <p class="font-bold text-primary">${item.numeroComprobante}</p>
                                    <p class="text-xs text-outline">${item.tipoComprobante}</p>
                                </td>
                                <td class="px-lg py-md">
                                    <p class="font-bold text-on-surface">${item.clienteNombre}</p>
                                    <p class="text-xs text-outline">${empty item.mascotaNombre ? 'Sin mascota asociada' : item.mascotaNombre}</p>
                                </td>
                                <td class="px-lg py-md font-bold">S/${item.total}</td>
                                <td class="px-lg py-md">
                                    <span class="px-2 py-1 rounded-full text-[11px] font-bold
                                        ${item.estado eq 'EMITIDO' ? 'bg-primary-fixed text-primary' : ''}
                                        ${item.estado eq 'PAGADO' ? 'bg-secondary-container text-secondary' : ''}
                                        ${item.estado eq 'ANULADO' ? 'bg-error-container text-error' : ''}">
                                        ${item.estado}
                                    </span>
                                </td>
                                <td class="px-lg py-md">
                                    <div class="flex justify-end items-center gap-sm">
                                        <a class="inline-flex items-center gap-xs px-sm py-2 border border-outline-variant rounded-lg text-on-surface hover:bg-surface-container transition-colors w-auto" href="${pageContext.request.contextPath}/app/comprobantes?action=view&id=${item.idComprobante}">
                                            <span class="material-symbols-outlined text-[18px]">visibility</span>
                                            Ver
                                        </a>
                                        <c:if test="${item.estado ne 'ANULADO'}">
                                            <form method="post" action="${pageContext.request.contextPath}/app/comprobantes">
                                                <input type="hidden" name="formAction" value="anular">
                                                <input type="hidden" name="idComprobante" value="${item.idComprobante}">
                                                <button class="inline-flex items-center gap-xs px-sm py-2 border border-error/30 text-error rounded-lg hover:bg-error-container transition-colors w-auto" type="submit">
                                                    <span class="material-symbols-outlined text-[18px]">block</span>
                                                    Anular
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty comprobantes}">
                            <tr>
                                <td class="px-lg py-lg text-center text-on-surface-variant" colspan="5">No se encontraron comprobantes con los filtros actuales.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-lg">
            <div class="bg-surface-container-lowest rounded-2xl border border-outline-variant overflow-hidden">
                <div class="p-lg border-b border-outline-variant">
                    <h3 class="text-headline-md font-headline-md text-primary">Detalle seleccionado</h3>
                    <p class="text-body-md text-on-surface-variant">Se muestra cuando entras con la accion de ver.</p>
                </div>
                <div class="p-lg space-y-md">
                    <c:choose>
                        <c:when test="${not empty comprobante and not empty comprobante.detalles}">
                            <div class="grid grid-cols-2 gap-md">
                                <div class="rounded-xl bg-surface-container-low p-md">
                                    <p class="text-label-md text-outline">Numero</p>
                                    <p class="font-bold text-primary">${comprobante.numeroComprobante}</p>
                                </div>
                                <div class="rounded-xl bg-surface-container-low p-md">
                                    <p class="text-label-md text-outline">Total</p>
                                    <p class="font-bold text-primary">S/${comprobante.total}</p>
                                </div>
                            </div>
                            <div class="space-y-sm">
                                <c:forEach var="detalle" items="${comprobante.detalles}">
                                    <div class="rounded-xl border border-outline-variant bg-surface-container-lowest p-md">
                                        <div class="flex justify-between gap-md">
                                            <div>
                                                <p class="font-bold text-on-surface">${detalle.descripcion}</p>
                                                <p class="text-xs text-outline">${detalle.tipoItem}</p>
                                            </div>
                                            <div class="text-right">
                                                <p class="font-bold">x${detalle.cantidad}</p>
                                                <p class="text-xs text-outline">S/${detalle.subtotal}</p>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="rounded-xl border border-dashed border-outline-variant bg-surface-container-low p-lg text-center text-on-surface-variant">
                                Selecciona un comprobante del listado para revisar su detalle.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="bg-surface-container-lowest rounded-2xl border border-outline-variant overflow-hidden">
                <div class="p-lg border-b border-outline-variant">
                    <h3 class="text-headline-md font-headline-md text-primary">Estado de la facturacion</h3>
                    <p class="text-body-md text-on-surface-variant">Resumen visual rapido del estado de documentos.</p>
                </div>
                <div class="p-lg space-y-md">
                    <div class="space-y-xs">
                        <div class="flex justify-between text-body-md"><span>Emitidos</span><span class="font-bold">${emitidos}</span></div>
                        <div class="w-full h-3 bg-surface-variant rounded-full overflow-hidden"><div class="h-full bg-primary rounded-full" style="width: ${fn:length(comprobantes) gt 0 ? (emitidos * 100 / fn:length(comprobantes)) : 0}%"></div></div>
                    </div>
                    <div class="space-y-xs">
                        <div class="flex justify-between text-body-md"><span>Pagados</span><span class="font-bold">${pagados}</span></div>
                        <div class="w-full h-3 bg-surface-variant rounded-full overflow-hidden"><div class="h-full bg-secondary rounded-full" style="width: ${fn:length(comprobantes) gt 0 ? (pagados * 100 / fn:length(comprobantes)) : 0}%"></div></div>
                    </div>
                    <div class="space-y-xs">
                        <div class="flex justify-between text-body-md"><span>Anulados</span><span class="font-bold">${anulados}</span></div>
                        <div class="w-full h-3 bg-surface-variant rounded-full overflow-hidden"><div class="h-full bg-error rounded-full" style="width: ${fn:length(comprobantes) gt 0 ? (anulados * 100 / fn:length(comprobantes)) : 0}%"></div></div>
                    </div>
                    <div class="rounded-xl bg-on-primary-fixed-variant text-on-primary p-md">
                        <div class="flex items-center gap-sm mb-xs">
                            <span class="material-symbols-outlined text-secondary-fixed">info</span>
                            <p class="font-bold">Nota operativa</p>
                        </div>
                        <p class="text-body-md">El diseno fue modernizado sin cambiar rutas, nombres de campos ni acciones de anulacion.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="includes/app-shell-end.jspf" %>
