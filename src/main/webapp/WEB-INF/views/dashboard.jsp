<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Dashboard"/>
<c:set var="headerSearchPlaceholder" value="Buscar clientes, mascotas o productos..."/>
<%@ include file="includes/app-shell.jspf" %>

        <div class="flex flex-col lg:flex-row justify-between lg:items-end gap-md">
            <div>
                <h2 class="text-display-lg font-display-lg text-primary">Panel de Control</h2>
                <p class="text-body-lg text-on-surface-variant">Bienvenido de nuevo, ${sessionScope.userSession.nombreCompleto}. Aqui esta el resumen de hoy.</p>
            </div>
            <div class="flex gap-sm flex-wrap">
                <a class="flex items-center gap-xs px-md py-sm bg-secondary-container text-on-secondary-container rounded-lg font-label-md hover:shadow-md transition-all" href="${pageContext.request.contextPath}/app/clientes">
                    <span class="material-symbols-outlined text-[20px]">person_add</span>
                    Nuevo Cliente
                </a>
                <a class="flex items-center gap-xs px-md py-sm bg-primary text-on-primary rounded-lg font-label-md hover:shadow-md transition-all" href="${pageContext.request.contextPath}/app/citas">
                    <span class="material-symbols-outlined text-[20px]">add_circle</span>
                    Nueva Cita
                </a>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-md">
            <div class="bg-surface-container-lowest border border-outline-variant p-md rounded-xl hover:shadow-sm transition-all">
                <div class="flex justify-between items-start mb-sm">
                    <div class="p-xs bg-primary-fixed rounded-lg">
                        <span class="material-symbols-outlined text-primary">group</span>
                    </div>
                    <span class="text-label-md text-secondary font-bold flex items-center gap-base">
                        <span class="material-symbols-outlined text-[14px]">trending_up</span>
                        Activos
                    </span>
                </div>
                <p class="text-label-md text-on-surface-variant">Clientes</p>
                <h3 class="text-headline-lg font-headline-lg">${stats.clientes}</h3>
            </div>
            <div class="bg-surface-container-lowest border border-outline-variant p-md rounded-xl hover:shadow-sm transition-all">
                <div class="flex justify-between items-start mb-sm">
                    <div class="p-xs bg-secondary-container rounded-lg">
                        <span class="material-symbols-outlined text-on-secondary-container">pets</span>
                    </div>
                    <span class="text-label-md text-secondary font-bold flex items-center gap-base">
                        <span class="material-symbols-outlined text-[14px]">trending_up</span>
                        Registradas
                    </span>
                </div>
                <p class="text-label-md text-on-surface-variant">Mascotas</p>
                <h3 class="text-headline-lg font-headline-lg">${stats.mascotas}</h3>
            </div>
            <div class="bg-surface-container-lowest border border-outline-variant p-md rounded-xl hover:shadow-sm transition-all">
                <div class="flex justify-between items-start mb-sm">
                    <div class="p-xs bg-primary-fixed-dim rounded-lg">
                        <span class="material-symbols-outlined text-primary">calendar_month</span>
                    </div>
                    <span class="text-label-md text-secondary font-bold flex items-center gap-base">
                        <span class="material-symbols-outlined text-[14px]">schedule</span>
                        Hoy
                    </span>
                </div>
                <p class="text-label-md text-on-surface-variant">Citas</p>
                <h3 class="text-headline-lg font-headline-lg">${stats.citasHoy}</h3>
            </div>
            <div class="bg-surface-container-lowest border border-outline-variant p-md rounded-xl hover:shadow-sm transition-all">
                <div class="flex justify-between items-start mb-sm">
                    <div class="p-xs bg-tertiary-fixed rounded-lg">
                        <span class="material-symbols-outlined text-tertiary">inventory_2</span>
                    </div>
                    <span class="text-label-md text-error font-bold flex items-center gap-base">
                        <span class="material-symbols-outlined text-[14px]">warning</span>
                        Alerta
                    </span>
                </div>
                <p class="text-label-md text-on-surface-variant">Productos bajo stock</p>
                <h3 class="text-headline-lg font-headline-lg">${stats.bajoStock}</h3>
            </div>
        </div>

        <div class="grid grid-cols-12 gap-lg">
            <div class="col-span-12 lg:col-span-8 bg-surface-container-lowest border border-outline-variant rounded-xl overflow-hidden">
                <div class="p-lg border-b border-outline-variant flex justify-between items-center">
                    <h3 class="text-headline-md font-headline-md text-primary">Movimientos recientes de inventario</h3>
                    <a class="text-label-md text-primary hover:underline" href="${pageContext.request.contextPath}/app/productos">Ver productos</a>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead class="bg-surface-container text-label-md text-on-surface-variant">
                            <tr>
                                <th class="px-lg py-md font-semibold">Fecha</th>
                                <th class="px-lg py-md font-semibold">Producto</th>
                                <th class="px-lg py-md font-semibold">Tipo</th>
                                <th class="px-lg py-md font-semibold">Cantidad</th>
                                <th class="px-lg py-md font-semibold">Usuario</th>
                                <th class="px-lg py-md font-semibold text-right">Referencia</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-outline-variant text-body-md">
                            <c:forEach var="mov" items="${movimientos}">
                                <tr class="hover:bg-surface-container-low transition-colors">
                                    <td class="px-lg py-md">${mov.fechaMovimiento}</td>
                                    <td class="px-lg py-md font-semibold">${mov.productoNombre}</td>
                                    <td class="px-lg py-md">${mov.tipoMovimiento}</td>
                                    <td class="px-lg py-md">${mov.cantidad}</td>
                                    <td class="px-lg py-md">${mov.usuarioNombre}</td>
                                    <td class="px-lg py-md text-right">${mov.referencia}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty movimientos}">
                                <tr>
                                    <td class="px-lg py-md text-center text-on-surface-variant" colspan="6">No hay movimientos recientes para mostrar.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="col-span-12 lg:col-span-4 space-y-lg">
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg">
                    <div class="flex items-center gap-sm mb-lg">
                        <span class="material-symbols-outlined text-error">warning</span>
                        <h3 class="text-headline-md font-headline-md">Stock Bajo</h3>
                    </div>
                    <div class="space-y-md">
                        <c:forEach var="producto" items="${bajoStockItems}" end="2">
                            <div>
                                <div class="flex justify-between text-label-md mb-xs gap-sm">
                                    <span>${producto.nombre}</span>
                                    <span class="text-error font-bold">${producto.stock} u. restantes</span>
                                </div>
                                <div class="w-full bg-surface-container rounded-full h-2">
                                    <div class="bg-error h-2 rounded-full" style="width: ${producto.stockMinimo > 0 ? (producto.stock * 100 / producto.stockMinimo) : 0}%"></div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty bajoStockItems}">
                            <p class="text-body-md text-on-surface-variant">No hay productos en alerta de stock.</p>
                        </c:if>
                    </div>
                    <a class="block w-full mt-lg py-sm border border-primary text-primary rounded-lg text-label-md font-bold hover:bg-primary/5 transition-colors text-center" href="${pageContext.request.contextPath}/app/productos">
                        Gestionar Inventario
                    </a>
                </div>

                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg">
                    <h3 class="text-headline-md font-headline-md mb-lg">Actividad Semanal</h3>
                    <div class="flex items-end justify-between h-32 gap-xs px-xs">
                        <div class="w-full bg-primary/20 rounded-t-sm relative"><div class="absolute bottom-0 left-0 w-full bg-primary rounded-t-sm h-[40%]"></div><span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-[10px] text-outline">Lun</span></div>
                        <div class="w-full bg-primary/20 rounded-t-sm relative"><div class="absolute bottom-0 left-0 w-full bg-primary rounded-t-sm h-[65%]"></div><span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-[10px] text-outline">Mar</span></div>
                        <div class="w-full bg-primary/20 rounded-t-sm relative"><div class="absolute bottom-0 left-0 w-full bg-primary rounded-t-sm h-[85%]"></div><span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-[10px] text-outline">Mie</span></div>
                        <div class="w-full bg-primary/20 rounded-t-sm relative"><div class="absolute bottom-0 left-0 w-full bg-primary rounded-t-sm h-[55%]"></div><span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-[10px] text-outline">Jue</span></div>
                        <div class="w-full bg-primary/20 rounded-t-sm relative"><div class="absolute bottom-0 left-0 w-full bg-primary rounded-t-sm h-[95%]"></div><span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-[10px] text-outline">Vie</span></div>
                        <div class="w-full bg-primary/20 rounded-t-sm relative"><div class="absolute bottom-0 left-0 w-full bg-primary rounded-t-sm h-[30%]"></div><span class="absolute -bottom-6 left-1/2 -translate-x-1/2 text-[10px] text-outline">Sab</span></div>
                    </div>
                    <div class="mt-xl pt-md border-t border-outline-variant flex justify-around">
                        <div class="text-center">
                            <p class="text-label-md text-outline">Clientes</p>
                            <p class="text-body-md font-bold">${stats.clientes}</p>
                        </div>
                        <div class="text-center">
                            <p class="text-label-md text-outline">Mascotas</p>
                            <p class="text-body-md font-bold">${stats.mascotas}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="pt-lg">
            <h3 class="text-headline-md font-headline-md mb-md">Acciones Rapidas</h3>
            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-md">
                <a class="flex flex-col items-center gap-xs p-md bg-surface-container-lowest border border-outline-variant rounded-xl hover:border-primary hover:text-primary transition-all group" href="${pageContext.request.contextPath}/app/comprobantes">
                    <span class="material-symbols-outlined text-[32px] group-hover:scale-110 transition-transform">receipt_long</span>
                    <span class="text-label-md">Nueva Venta</span>
                </a>
                <a class="flex flex-col items-center gap-xs p-md bg-surface-container-lowest border border-outline-variant rounded-xl hover:border-primary hover:text-primary transition-all group" href="${pageContext.request.contextPath}/app/citas">
                    <span class="material-symbols-outlined text-[32px] group-hover:scale-110 transition-transform">vaccines</span>
                    <span class="text-label-md">Vacunacion</span>
                </a>
                <a class="flex flex-col items-center gap-xs p-md bg-surface-container-lowest border border-outline-variant rounded-xl hover:border-primary hover:text-primary transition-all group" href="${pageContext.request.contextPath}/app/atenciones">
                    <span class="material-symbols-outlined text-[32px] group-hover:scale-110 transition-transform">medical_services</span>
                    <span class="text-label-md">Atenciones</span>
                </a>
                <a class="flex flex-col items-center gap-xs p-md bg-surface-container-lowest border border-outline-variant rounded-xl hover:border-primary hover:text-primary transition-all group" href="${pageContext.request.contextPath}/app/productos">
                    <span class="material-symbols-outlined text-[32px] group-hover:scale-110 transition-transform">shopping_cart_checkout</span>
                    <span class="text-label-md">Pedido Stock</span>
                </a>
                <a class="flex flex-col items-center gap-xs p-md bg-surface-container-lowest border border-outline-variant rounded-xl hover:border-primary hover:text-primary transition-all group" href="${pageContext.request.contextPath}/app/clientes">
                    <span class="material-symbols-outlined text-[32px] group-hover:scale-110 transition-transform">history</span>
                    <span class="text-label-md">Historial</span>
                </a>
                <a class="flex flex-col items-center gap-xs p-md bg-surface-container-lowest border border-outline-variant rounded-xl hover:border-primary hover:text-primary transition-all group" href="${pageContext.request.contextPath}/app/reportes">
                    <span class="material-symbols-outlined text-[32px] group-hover:scale-110 transition-transform">bar_chart</span>
                    <span class="text-label-md">Reportes</span>
                </a>
            </div>
        </div>
    </div>
<div class="fixed inset-0 pointer-events-none z-0 overflow-hidden">
    <div class="absolute -top-[10%] -right-[10%] w-[40%] h-[40%] bg-primary/5 blur-[120px] rounded-full"></div>
    <div class="absolute -bottom-[10%] -left-[10%] w-[30%] h-[30%] bg-secondary/5 blur-[100px] rounded-full"></div>
</div>

<script>
    document.querySelectorAll('button, a').forEach((el) => {
        el.addEventListener('mousedown', () => {
            el.style.transform = 'scale(0.98)';
        });
        el.addEventListener('mouseup', () => {
            el.style.transform = 'scale(1)';
        });
        el.addEventListener('mouseleave', () => {
            el.style.transform = 'scale(1)';
        });
    });
</script>
<%@ include file="includes/app-shell-end.jspf" %>
