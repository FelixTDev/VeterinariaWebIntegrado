<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Reportes"/>
<c:set var="headerSearchPlaceholder" value="Buscar insights, fechas o movimientos..."/>
<c:set var="totalCitas" value="0"/>
<c:forEach var="row" items="${citasRango}">
    <c:set var="totalCitas" value="${totalCitas + row.total}"/>
</c:forEach>
<c:set var="totalIngresos" value="0"/>
<c:forEach var="row" items="${ingresosRango}">
    <c:set var="totalIngresos" value="${totalIngresos + row.total}"/>
</c:forEach>
<%@ include file="includes/app-shell.jspf" %>

<section class="flex flex-col xl:flex-row xl:items-end justify-between gap-md">
    <div>
        <p class="text-label-md uppercase tracking-[0.18em] text-outline mb-xs">Centro Analitico</p>
        <h2 class="text-display-lg font-display-lg text-primary">Reportes Analiticos</h2>
        <p class="text-body-lg text-on-surface-variant">Seguimiento operativo, inventario y comportamiento de ingresos del periodo seleccionado.</p>
    </div>
    <form method="get" class="glass-card rounded-2xl p-sm flex flex-col md:flex-row md:items-end gap-sm border border-outline-variant">
        <div class="px-sm">
            <label class="block text-[11px] font-bold text-outline uppercase tracking-wider mb-1" for="desde">Desde</label>
            <input class="bg-transparent border-outline-variant rounded-lg text-body-md focus:ring-primary" id="desde" name="desde" type="date" value="${desde}">
        </div>
        <div class="px-sm">
            <label class="block text-[11px] font-bold text-outline uppercase tracking-wider mb-1" for="hasta">Hasta</label>
            <input class="bg-transparent border-outline-variant rounded-lg text-body-md focus:ring-primary" id="hasta" name="hasta" type="date" value="${hasta}">
        </div>
        <div class="flex gap-sm">
            <button class="flex items-center justify-center gap-xs px-lg py-sm bg-primary text-on-primary rounded-lg font-bold hover:opacity-90 transition-opacity w-auto" type="submit">
                <span class="material-symbols-outlined text-[18px]">filter_list</span>
                Generar
            </button>
            <button class="flex items-center justify-center gap-xs px-lg py-sm border border-outline-variant text-on-surface rounded-lg font-bold hover:bg-surface-container-high transition-colors w-auto" type="button">
                <span class="material-symbols-outlined text-[18px]">download</span>
                Exportar
            </button>
        </div>
    </form>
</section>

<section class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-md">
    <div class="bg-surface-container-lowest p-lg rounded-xl border border-outline-variant hover:shadow-md transition-shadow">
        <div class="flex justify-between items-start mb-sm">
            <div class="p-sm bg-primary/10 rounded-lg text-primary">
                <span class="material-symbols-outlined">payments</span>
            </div>
            <span class="text-label-md font-bold px-2 py-0.5 rounded-full ${totalIngresos gt 0 ? 'bg-secondary-container/50 text-secondary' : 'bg-surface-container text-on-surface-variant'}">
                ${empty ingresosRango ? 'Sin datos' : 'Activo'}
            </span>
        </div>
        <p class="text-label-md text-on-surface-variant">Ingresos del rango</p>
        <p class="text-headline-lg font-headline-lg text-primary mt-1">S/${totalIngresos}</p>
        <p class="text-xs text-outline mt-2">${fn:length(ingresosRango)} fecha(s) con facturacion</p>
    </div>
    <div class="bg-surface-container-lowest p-lg rounded-xl border border-outline-variant hover:shadow-md transition-shadow">
        <div class="flex justify-between items-start mb-sm">
            <div class="p-sm bg-secondary/10 rounded-lg text-secondary">
                <span class="material-symbols-outlined">event_available</span>
            </div>
            <span class="text-label-md font-bold px-2 py-0.5 rounded-full ${totalCitas gt 0 ? 'bg-secondary-container/50 text-secondary' : 'bg-surface-container text-on-surface-variant'}">
                ${empty citasRango ? 'Sin datos' : 'Operativo'}
            </span>
        </div>
        <p class="text-label-md text-on-surface-variant">Citas registradas</p>
        <p class="text-headline-lg font-headline-lg text-primary mt-1">${totalCitas}</p>
        <p class="text-xs text-outline mt-2">${fn:length(citasRango)} fecha(s) evaluadas</p>
    </div>
    <div class="bg-surface-container-lowest p-lg rounded-xl border border-outline-variant hover:shadow-md transition-shadow">
        <div class="flex justify-between items-start mb-sm">
            <div class="p-sm bg-tertiary/10 rounded-lg text-tertiary">
                <span class="material-symbols-outlined">inventory</span>
            </div>
            <span class="text-label-md font-bold px-2 py-0.5 rounded-full ${fn:length(bajoStock) gt 0 ? 'bg-error-container/70 text-error' : 'bg-secondary-container/40 text-secondary'}">
                ${fn:length(bajoStock)} alerta(s)
            </span>
        </div>
        <p class="text-label-md text-on-surface-variant">Productos con bajo stock</p>
        <p class="text-headline-lg font-headline-lg ${fn:length(bajoStock) gt 0 ? 'text-error' : 'text-primary'} mt-1">${fn:length(bajoStock)}</p>
        <p class="text-xs text-outline mt-2">Items por debajo del minimo</p>
    </div>
    <div class="bg-surface-container-lowest p-lg rounded-xl border border-outline-variant hover:shadow-md transition-shadow">
        <div class="flex justify-between items-start mb-sm">
            <div class="p-sm bg-primary-fixed rounded-lg text-primary">
                <span class="material-symbols-outlined">schedule</span>
            </div>
            <span class="text-label-md font-bold px-2 py-0.5 rounded-full ${fn:length(movimientos) gt 0 ? 'bg-primary-fixed text-primary' : 'bg-surface-container text-on-surface-variant'}">
                ${fn:length(movimientos)} registro(s)
            </span>
        </div>
        <p class="text-label-md text-on-surface-variant">Movimientos recientes</p>
        <p class="text-headline-lg font-headline-lg text-primary mt-1">${fn:length(movimientos)}</p>
        <p class="text-xs text-outline mt-2">Actividad reciente de inventario</p>
    </div>
</section>

<section class="grid grid-cols-1 xl:grid-cols-2 gap-lg">
    <div class="bg-surface-container-lowest p-lg rounded-xl border border-outline-variant">
        <div class="flex justify-between items-center mb-lg">
            <h3 class="text-headline-md font-headline-md text-primary">Ingresos por rango</h3>
            <span class="text-[11px] uppercase tracking-[0.16em] text-outline">Soles</span>
        </div>
        <div class="space-y-md">
            <c:forEach var="row" items="${ingresosRango}">
                <div class="space-y-xs">
                    <div class="flex justify-between text-body-md">
                        <span>${row.etiqueta}</span>
                        <span class="font-bold">S/${row.total}</span>
                    </div>
                    <div class="w-full h-3 bg-surface-variant rounded-full overflow-hidden">
                        <div class="h-full bg-primary rounded-full" style="width: ${totalIngresos gt 0 ? (row.total * 100 / totalIngresos) : 0}%"></div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty ingresosRango}">
                <div class="rounded-xl border border-dashed border-outline-variant bg-surface-container-low p-lg text-center text-on-surface-variant">
                    No hay ingresos registrados para el rango seleccionado.
                </div>
            </c:if>
        </div>
    </div>

    <div class="bg-surface-container-lowest p-lg rounded-xl border border-outline-variant">
        <div class="flex justify-between items-center mb-lg">
            <h3 class="text-headline-md font-headline-md text-primary">Citas por fecha</h3>
            <span class="text-[11px] uppercase tracking-[0.16em] text-outline">Agenda</span>
        </div>
        <div class="space-y-md">
            <c:forEach var="row" items="${citasRango}">
                <div class="space-y-xs">
                    <div class="flex justify-between text-body-md">
                        <span>${row.etiqueta}</span>
                        <span class="font-bold">${row.total}</span>
                    </div>
                    <div class="w-full h-3 bg-surface-variant rounded-full overflow-hidden">
                        <div class="h-full bg-secondary rounded-full" style="width: ${totalCitas gt 0 ? (row.total * 100 / totalCitas) : 0}%"></div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty citasRango}">
                <div class="rounded-xl border border-dashed border-outline-variant bg-surface-container-low p-lg text-center text-on-surface-variant">
                    No hay citas dentro del periodo consultado.
                </div>
            </c:if>
        </div>
    </div>
</section>

<section class="grid grid-cols-1 xl:grid-cols-2 gap-lg">
    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant overflow-hidden">
        <div class="p-lg border-b border-outline-variant flex justify-between items-center">
            <div>
                <h3 class="text-headline-md font-headline-md text-primary">Productos criticos</h3>
                <p class="text-body-md text-on-surface-variant">Stock bajo y proximos a vencer.</p>
            </div>
            <span class="px-3 py-1 bg-error-container text-error text-xs font-bold rounded-full">Inventario</span>
        </div>
        <div class="p-lg space-y-md">
            <c:forEach var="item" items="${bajoStock}">
                <div class="flex items-center justify-between p-md bg-error-container/5 border border-error/20 rounded-lg">
                    <div class="flex items-center gap-md min-w-0">
                        <span class="material-symbols-outlined text-error">warning</span>
                        <div class="min-w-0">
                            <p class="text-body-md font-bold text-on-surface truncate">${item.nombre}</p>
                            <p class="text-xs text-outline">Minimo ${item.stockMinimo}</p>
                        </div>
                    </div>
                    <div class="text-right">
                        <p class="text-body-md font-bold text-error">${item.stock}</p>
                        <p class="text-[10px] text-outline uppercase font-bold">Stock actual</p>
                    </div>
                </div>
            </c:forEach>
            <c:forEach var="item" items="${porVencer}">
                <div class="flex items-center justify-between p-md bg-tertiary-container/20 border border-tertiary/20 rounded-lg">
                    <div class="flex items-center gap-md min-w-0">
                        <span class="material-symbols-outlined text-tertiary">event_busy</span>
                        <div class="min-w-0">
                            <p class="text-body-md font-bold text-on-surface truncate">${item.nombre}</p>
                            <p class="text-xs text-outline">Producto por vencer</p>
                        </div>
                    </div>
                    <div class="text-right">
                        <p class="text-body-md font-bold text-tertiary">${item.fechaVencimiento}</p>
                        <p class="text-[10px] text-outline uppercase font-bold">Vencimiento</p>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty bajoStock and empty porVencer}">
                <div class="rounded-xl border border-dashed border-outline-variant bg-surface-container-low p-lg text-center text-on-surface-variant">
                    No hay alertas de inventario para mostrar.
                </div>
            </c:if>
        </div>
    </div>

    <div class="bg-surface-container-lowest rounded-xl border border-outline-variant overflow-hidden">
        <div class="p-lg border-b border-outline-variant flex justify-between items-center">
            <div>
                <h3 class="text-headline-md font-headline-md text-primary">Movimientos recientes</h3>
                <p class="text-body-md text-on-surface-variant">Ultimos eventos registrados en inventario.</p>
            </div>
            <span class="text-[11px] uppercase tracking-[0.16em] text-outline">Auditoria</span>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left">
                <thead class="bg-surface-container-high/60">
                    <tr>
                        <th class="px-lg py-sm text-label-md text-outline font-bold uppercase tracking-wider">Fecha</th>
                        <th class="px-lg py-sm text-label-md text-outline font-bold uppercase tracking-wider">Producto</th>
                        <th class="px-lg py-sm text-label-md text-outline font-bold uppercase tracking-wider">Tipo</th>
                        <th class="px-lg py-sm text-label-md text-outline font-bold uppercase tracking-wider text-right">Cantidad</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-outline-variant">
                    <c:forEach var="item" items="${movimientos}">
                        <tr class="hover:bg-surface-container/40 transition-colors">
                            <td class="px-lg py-md text-body-md">${item.fechaMovimiento}</td>
                            <td class="px-lg py-md">
                                <p class="font-bold text-on-surface">${item.productoNombre}</p>
                                <p class="text-xs text-outline">${item.usuarioNombre}</p>
                            </td>
                            <td class="px-lg py-md">
                                <span class="px-2 py-1 rounded-full text-[11px] font-bold ${item.tipoMovimiento eq 'SALIDA' ? 'bg-error-container text-error' : 'bg-secondary-container text-secondary'}">${item.tipoMovimiento}</span>
                            </td>
                            <td class="px-lg py-md text-right font-bold">${item.cantidad}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty movimientos}">
                        <tr>
                            <td class="px-lg py-lg text-center text-on-surface-variant" colspan="4">No hay movimientos recientes para mostrar.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</section>

<div class="flex flex-col md:flex-row md:items-center md:justify-between gap-sm p-md bg-on-primary-fixed-variant text-on-primary rounded-lg">
    <div class="flex items-center gap-sm">
        <span class="material-symbols-outlined text-secondary-fixed">info</span>
        <span class="text-body-md">Los datos se calculan con el rango entre ${desde} y ${hasta}.</span>
    </div>
    <button class="text-xs font-bold uppercase tracking-widest border border-white/20 px-3 py-1 rounded hover:bg-white/10 w-auto" type="button">Refrescar vista</button>
</div>

<%@ include file="includes/app-shell-end.jspf" %>
