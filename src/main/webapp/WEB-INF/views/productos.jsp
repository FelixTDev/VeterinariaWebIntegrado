<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario de Productos - VetWeb Integrado</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            display: inline-block;
            line-height: 1;
        }
        body { font-family: 'Inter', sans-serif; }
        .custom-scrollbar::-webkit-scrollbar { width: 6px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #e5e7eb; border-radius: 10px; }
    </style>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "surface-bright": "#f8f9fa",
                        "on-secondary-fixed-variant": "#005236",
                        "on-tertiary-container": "#453f20",
                        "on-error-container": "#93000a",
                        "inverse-surface": "#2e3132",
                        "secondary-fixed-dim": "#4edea3",
                        "surface-variant": "#e1e3e4",
                        "on-primary-container": "#90a8ff",
                        "secondary-container": "#6cf8bb",
                        "on-primary": "#ffffff",
                        "surface-container-high": "#e7e8e9",
                        "primary-fixed": "#dce1ff",
                        "inverse-on-surface": "#f0f1f2",
                        "on-background": "#191c1d",
                        "on-secondary-fixed": "#002113",
                        "surface-container": "#edeeef",
                        "on-tertiary-fixed-variant": "#4d4727",
                        "tertiary-fixed": "#ede3b8",
                        "surface-container-highest": "#e1e3e4",
                        "primary-fixed-dim": "#b6c4ff",
                        "tertiary": "#665f3d",
                        "on-secondary": "#ffffff",
                        "on-secondary-container": "#00714d",
                        "on-surface-variant": "#444651",
                        "tertiary-container": "#b4ab84",
                        "primary-container": "#1e3a8a",
                        "surface-container-low": "#f3f4f5",
                        "on-error": "#ffffff",
                        "on-primary-fixed-variant": "#264191",
                        "on-primary-fixed": "#00164e",
                        "secondary": "#006c49",
                        "surface": "#f8f9fa",
                        "surface-tint": "#4059aa",
                        "outline-variant": "#c5c5d3",
                        "background": "#f8f9fa",
                        "inverse-primary": "#b6c4ff",
                        "error-container": "#ffdad6",
                        "surface-container-lowest": "#ffffff",
                        "primary": "#00236f",
                        "tertiary-fixed-dim": "#d1c79d",
                        "secondary-fixed": "#6ffbbe",
                        "error": "#ba1a1a",
                        "on-surface": "#191c1d",
                        "outline": "#757682",
                        "surface-dim": "#d9dadb",
                        "on-tertiary-fixed": "#201c02",
                        "on-tertiary": "#ffffff"
                    },
                    borderRadius: {
                        DEFAULT: "0.25rem",
                        lg: "0.5rem",
                        xl: "0.75rem",
                        full: "9999px"
                    },
                    spacing: {
                        xl: "2rem",
                        lg: "1.5rem",
                        md: "1rem",
                        margin_mobile: "16px",
                        sm: "0.5rem",
                        gutter: "24px",
                        xs: "0.25rem",
                        base: "4px",
                        sidebar_width: "280px"
                    },
                    fontFamily: {
                        "label-md": ["Inter"],
                        "body-md": ["Inter"],
                        "headline-lg": ["Inter"],
                        "headline-md": ["Inter"],
                        "display-lg": ["Inter"],
                        "body-lg": ["Inter"]
                    },
                    fontSize: {
                        "label-md": ["12px", {"lineHeight": "16px", "fontWeight": "600"}],
                        "body-md": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "headline-lg": ["28px", {"lineHeight": "36px", "letterSpacing": "-0.01em", "fontWeight": "600"}],
                        "headline-md": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                        "display-lg": ["36px", {"lineHeight": "44px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "body-lg": ["16px", {"lineHeight": "24px", "fontWeight": "400"}]
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-surface text-on-surface flex min-h-screen">
<c:set var="userInitial" value="${fn:toUpperCase(fn:substring(sessionScope.userSession.username, 0, 1))}"/>
<aside class="fixed left-0 top-0 h-screen w-[280px] bg-[#111827] flex flex-col py-lg z-50">
    <div class="px-lg mb-xl">
        <h1 class="text-headline-md font-headline-md text-surface-container-lowest tracking-tight">VetWeb Integrado</h1>
        <p class="text-label-md font-label-md text-outline-variant opacity-60">Veterinary Clinic Management</p>
    </div>
    <nav class="flex-1 px-sm space-y-1 custom-scrollbar overflow-y-auto">
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/dashboard"><span class="material-symbols-outlined">dashboard</span><span class="text-body-md font-body-md">Dashboard</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/clientes"><span class="material-symbols-outlined">group</span><span class="text-body-md font-body-md">Clientes</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/mascotas"><span class="material-symbols-outlined">pets</span><span class="text-body-md font-body-md">Mascotas</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-secondary-fixed font-bold border-r-4 border-secondary-fixed bg-on-primary-fixed-variant/10 transition-all" href="${pageContext.request.contextPath}/app/productos"><span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">inventory_2</span><span class="text-body-md font-body-md">Productos</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/catalogos"><span class="material-symbols-outlined">category</span><span class="text-body-md font-body-md">Catalogos</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/citas"><span class="material-symbols-outlined">calendar_today</span><span class="text-body-md font-body-md">Citas</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/atenciones"><span class="material-symbols-outlined">medical_services</span><span class="text-body-md font-body-md">Atenciones</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/comprobantes"><span class="material-symbols-outlined">receipt_long</span><span class="text-body-md font-body-md">Comprobantes</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/reportes"><span class="material-symbols-outlined">bar_chart</span><span class="text-body-md font-body-md">Reportes</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/logout"><span class="material-symbols-outlined">logout</span><span class="text-body-md font-body-md">Cerrar sesion</span></a>
    </nav>
    <div class="mt-auto px-lg border-t border-surface-variant/10 pt-lg">
        <div class="flex items-center gap-md">
            <div class="w-10 h-10 rounded-full bg-primary-container flex items-center justify-center text-on-primary-container font-bold">${userInitial}</div>
            <div class="overflow-hidden">
                <p class="text-label-md font-label-md text-surface-bright truncate">${sessionScope.userSession.nombreCompleto}</p>
                <p class="text-[10px] text-outline-variant uppercase tracking-wider">${sessionScope.userSession.rolNombre}</p>
            </div>
        </div>
    </div>
</aside>

<main class="ml-[280px] w-[calc(100%-280px)] min-h-screen flex flex-col">
    <header class="sticky top-0 z-40 bg-surface border-b border-outline-variant flex justify-between items-center h-16 px-lg">
        <form method="get" class="flex items-center gap-xl w-full max-w-2xl">
            <div class="relative w-full max-w-md">
                <span class="material-symbols-outlined absolute left-md top-1/2 -translate-y-1/2 text-outline">search</span>
                <input class="w-full pl-xl pr-md py-sm bg-surface-container rounded-lg border-none focus:ring-2 focus:ring-primary text-body-md" name="search" value="${param.search}" placeholder="Buscar productos, lotes o codigos..." type="text">
            </div>
        </form>
        <div class="flex items-center gap-md">
            <button class="w-10 h-10 flex items-center justify-center rounded-full text-on-surface-variant hover:bg-surface-container transition-colors" type="button"><span class="material-symbols-outlined">notifications</span></button>
            <button class="w-10 h-10 flex items-center justify-center rounded-full text-on-surface-variant hover:bg-surface-container transition-colors" type="button"><span class="material-symbols-outlined">settings</span></button>
            <div class="h-8 w-px bg-outline-variant mx-sm"></div>
            <button class="flex items-center gap-sm bg-primary text-on-primary px-md py-sm rounded-lg font-label-md hover:opacity-90 transition-opacity w-auto" id="addProductBtn" type="button"><span class="material-symbols-outlined text-[20px]">add</span>NUEVO PRODUCTO</button>
        </div>
    </header>

    <div class="p-lg space-y-lg bg-surface-bright flex-1">
        <c:if test="${not empty sessionScope.flash}">
            <div class="flex items-start gap-sm p-md bg-secondary-container text-on-secondary-container rounded-lg border border-secondary/20">
                <span class="material-symbols-outlined">check_circle</span>
                <div class="flex-1">
                    <p class="font-label-md text-label-md">Operacion exitosa</p>
                    <p class="text-[12px]">${sessionScope.flash}</p>
                </div>
            </div>
            <% session.removeAttribute("flash"); %>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flex items-start gap-sm p-md bg-error-container text-on-error-container rounded-lg border border-error/20">
                <span class="material-symbols-outlined text-error">error</span>
                <div class="flex-1">
                    <p class="font-label-md text-label-md">Error</p>
                    <p class="text-[12px]">${error}</p>
                </div>
            </div>
        </c:if>

        <div class="flex justify-between items-end">
            <div>
                <h2 class="text-display-lg font-display-lg text-primary">Inventario de Productos</h2>
                <p class="text-body-lg text-on-surface-variant">Control centralizado de farmacos, insumos y equipos clinicos.</p>
            </div>
            <div class="flex gap-md">
                <div class="px-lg py-md bg-white border border-outline-variant rounded-xl shadow-sm flex flex-col items-center min-w-[140px]">
                    <span class="text-label-md text-outline uppercase">Total SKUs</span>
                    <span class="text-headline-lg text-primary">${fn:length(productos)}</span>
                </div>
                <div class="px-lg py-md bg-white border border-outline-variant rounded-xl shadow-sm flex flex-col items-center min-w-[140px]">
                    <span class="text-label-md text-error uppercase">Stock Bajo</span>
                    <span class="text-headline-lg text-error">${fn:length(bajoStock)}</span>
                </div>
                <div class="px-lg py-md bg-white border border-outline-variant rounded-xl shadow-sm flex flex-col items-center min-w-[140px]">
                    <span class="text-label-md text-tertiary uppercase">Por Vencer</span>
                    <span class="text-headline-lg text-tertiary">${fn:length(porVencer)}</span>
                </div>
            </div>
        </div>

        <div class="flex items-center justify-between bg-surface-container-low p-md rounded-xl border border-outline-variant">
            <div class="flex gap-sm">
                <button class="product-filter-btn px-md py-sm rounded-full bg-primary text-on-primary text-label-md font-label-md w-auto" type="button" onclick="filterProducts('ALL', this)">Todos</button>
                <button class="product-filter-btn px-md py-sm rounded-full bg-white border border-outline-variant text-on-surface-variant hover:bg-error-container hover:text-error transition-all text-label-md font-label-md flex items-center gap-xs w-auto" type="button" onclick="filterProducts('LOW', this)"><span class="material-symbols-outlined text-[16px]">warning</span> Stock Bajo</button>
                <button class="product-filter-btn px-md py-sm rounded-full bg-white border border-outline-variant text-on-surface-variant hover:bg-tertiary-container hover:text-tertiary transition-all text-label-md font-label-md flex items-center gap-xs w-auto" type="button" onclick="filterProducts('EXPIRY', this)"><span class="material-symbols-outlined text-[16px]">event_busy</span> Vencimiento Proximo</button>
            </div>
            <div class="flex gap-md">
                <select class="bg-white border-outline-variant rounded-lg text-body-md px-md py-sm focus:ring-primary" id="productTypeFilter">
                    <option value="">Filtrar por Tipo</option>
                    <c:forEach var="tipo" items="${tiposProducto}">
                        <option value="${tipo.nombre}">${tipo.nombre}</option>
                    </c:forEach>
                </select>
                <button class="flex items-center gap-xs text-on-surface-variant hover:text-primary transition-colors text-label-md font-label-md border border-outline-variant px-md py-sm rounded-lg bg-white w-auto" type="button">
                    <span class="material-symbols-outlined text-[18px]">file_download</span> Exportar
                </button>
            </div>
        </div>

        <div class="bg-white rounded-xl border border-outline-variant shadow-sm overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead class="bg-surface-container-high border-b border-outline-variant">
                    <tr>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase font-bold">Codigo</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase font-bold">Nombre / Tipo</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase font-bold">Stock Actual vs Min</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase font-bold text-right">Precios (Compra/Venta en Soles)</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase font-bold">Vencimiento</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase font-bold">Estado</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase font-bold"></th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-outline-variant" id="productTableBody">
                    <c:forEach var="item" items="${productos}">
                        <c:set var="stockPercent" value="${item.stockMinimo > 0 ? (item.stock * 100 / item.stockMinimo) : 100}"/>
                        <tr class="hover:bg-surface-bright transition-colors group product-row"
                            data-tipo="${item.tipoProductoNombre}"
                            data-low-stock="${item.stock <= item.stockMinimo}"
                            data-near-expiry-date="${empty item.fechaVencimiento ? '' : item.fechaVencimiento}">
                            <td class="px-lg py-md font-mono text-body-md text-primary">${item.codigo}</td>
                            <td class="px-lg py-md">
                                <div class="font-bold text-body-md text-on-surface">${item.nombre}</div>
                                <div class="text-label-md text-outline">${item.tipoProductoNombre}${item.requiereReceta ? ' • Con receta' : ''}</div>
                            </td>
                            <td class="px-lg py-md">
                                <div class="flex items-center gap-md">
                                    <div class="w-full bg-surface-variant h-1.5 rounded-full overflow-hidden max-w-[80px]">
                                        <div class="${item.stock <= item.stockMinimo ? 'bg-error' : 'bg-secondary'} h-full" style="width: ${stockPercent > 100 ? 100 : stockPercent}%"></div>
                                    </div>
                                    <span class="text-body-md font-bold ${item.stock <= item.stockMinimo ? 'text-error' : 'text-on-surface'}">${item.stock} / ${item.stockMinimo}</span>
                                </div>
                            </td>
                            <td class="px-lg py-md text-right">
                                <div class="text-body-md">S/${item.precioCompra} / <span class="font-bold">S/${item.precioVenta}</span></div>
                            </td>
                            <td class="px-lg py-md">
                                <div class="text-body-md">${empty item.fechaVencimiento ? '-' : item.fechaVencimiento}</div>
                            </td>
                            <td class="px-lg py-md">
                                <span class="${item.stock <= item.stockMinimo ? 'bg-error-container text-on-error-container' : item.requiereReceta ? 'bg-primary-container text-on-primary-container' : 'bg-secondary-container text-on-secondary-container'} px-sm py-1 rounded-full text-label-md font-label-md inline-flex items-center gap-xs">
                                    <c:choose>
                                        <c:when test="${item.stock <= item.stockMinimo}">
                                            <span class="w-2 h-2 rounded-full bg-error"></span> CRITICO
                                        </c:when>
                                        <c:when test="${item.requiereReceta}">
                                            <span class="material-symbols-outlined text-[14px]">description</span> CON RECETA
                                        </c:when>
                                        <c:otherwise>
                                            ACTIVO
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="px-lg py-md text-right">
                                <button class="text-outline hover:text-primary transition-colors w-auto" type="button" onclick="openEditProduct(this)"
                                    data-id="${item.idProducto}"
                                    data-id-tipo="${item.idTipoProducto}"
                                    data-codigo="${fn:escapeXml(item.codigo)}"
                                    data-nombre="${fn:escapeXml(item.nombre)}"
                                    data-descripcion="${fn:escapeXml(item.descripcion)}"
                                    data-stock="${item.stock}"
                                    data-stock-minimo="${item.stockMinimo}"
                                    data-precio-compra="${item.precioCompra}"
                                    data-precio-venta="${item.precioVenta}"
                                    data-fecha-vencimiento="${item.fechaVencimiento}"
                                    data-requiere-receta="${item.requiereReceta}"
                                    data-estado="${item.estado}">
                                    <span class="material-symbols-outlined">edit</span>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="fixed inset-0 z-[60] hidden flex items-center justify-center p-md" id="productModal">
            <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" id="closeOverlay"></div>
            <div class="relative bg-white w-full max-w-4xl rounded-2xl shadow-2xl overflow-hidden border border-outline-variant">
                <div class="bg-surface-container-high px-lg py-md flex justify-between items-center border-b border-outline-variant">
                    <div class="flex items-center gap-md">
                        <div class="bg-primary p-2 rounded-lg">
                            <span class="material-symbols-outlined text-on-primary">inventory</span>
                        </div>
                        <h3 class="text-headline-md font-headline-md text-primary" id="productModalTitle">${empty producto.idProducto ? 'Registrar Nuevo Producto' : 'Editar Producto'}</h3>
                    </div>
                    <button class="text-on-surface-variant hover:text-error transition-colors w-auto" id="closeModal" type="button">
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>
                <form method="post" id="productForm">
                    <div class="p-lg grid grid-cols-12 gap-lg overflow-y-auto max-h-[768px] custom-scrollbar">
                        <div class="col-span-12 lg:col-span-8 space-y-md">
                            <input type="hidden" name="idProducto" id="form-idProducto" value="${producto.idProducto}">
                            <div class="grid grid-cols-2 gap-md">
                                <div class="space-y-xs">
                                    <label class="text-label-md text-on-surface-variant uppercase">Nombre del Producto</label>
                                    <input class="w-full border-outline-variant rounded-lg focus:ring-primary" id="form-nombre" name="nombre" placeholder="Ej. Bravecto 20-40kg" type="text" value="${producto.nombre}" required>
                                </div>
                                <div class="space-y-xs">
                                    <label class="text-label-md text-on-surface-variant uppercase">Categoria / Tipo</label>
                                    <select class="w-full border-outline-variant rounded-lg focus:ring-primary" id="form-idTipoProducto" name="idTipoProducto" required>
                                        <option value="">Seleccionar tipo...</option>
                                        <c:forEach var="tipo" items="${tiposProducto}">
                                            <option value="${tipo.idTipoProducto}" ${producto.idTipoProducto eq tipo.idTipoProducto ? 'selected' : ''}>${tipo.nombre}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="space-y-xs">
                                <label class="text-label-md text-on-surface-variant uppercase">Descripcion Detallada</label>
                                <textarea class="w-full border-outline-variant rounded-lg focus:ring-primary resize-none" id="form-descripcion" name="descripcion" placeholder="Indicar componentes, dosis base, advertencias de uso..." rows="4">${producto.descripcion}</textarea>
                            </div>
                            <div class="grid grid-cols-3 gap-md">
                                <div class="space-y-xs">
                                    <label class="text-label-md text-on-surface-variant uppercase">Codigo Interno</label>
                                    <input class="w-full border-outline-variant rounded-lg focus:ring-primary font-mono" id="form-codigo" name="codigo" placeholder="SKU-XXXX" type="text" value="${producto.codigo}" required>
                                </div>
                                <div class="space-y-xs">
                                    <label class="text-label-md text-on-surface-variant uppercase">Stock Actual</label>
                                    <input class="w-full border-outline-variant rounded-lg focus:ring-primary" id="form-stock" name="stock" type="number" value="${producto.stock}" required>
                                </div>
                                <div class="space-y-xs">
                                    <label class="text-label-md text-on-surface-variant uppercase">Stock Minimo</label>
                                    <input class="w-full border-outline-variant rounded-lg focus:ring-primary" id="form-stockMinimo" name="stockMinimo" type="number" value="${producto.stockMinimo}" required>
                                </div>
                            </div>
                        </div>
                        <div class="col-span-12 lg:col-span-4 space-y-lg">
                            <div class="p-md bg-surface-container rounded-xl space-y-md border border-outline-variant">
                                <h4 class="text-label-md font-bold text-primary border-b border-outline-variant pb-xs">PRECIOS & COSTOS</h4>
                                <div class="space-y-xs">
                                    <label class="text-label-md text-on-surface-variant">Precio Compra (S/)</label>
                                    <input class="w-full border-outline-variant rounded-lg focus:ring-primary text-right" id="form-precioCompra" name="precioCompra" step="0.01" type="number" value="${producto.precioCompra}" required>
                                </div>
                                <div class="space-y-xs">
                                    <label class="text-label-md text-on-surface-variant">Precio Venta (S/)</label>
                                    <input class="w-full border-outline-variant rounded-lg focus:ring-primary text-right font-bold text-primary" id="form-precioVenta" name="precioVenta" step="0.01" type="number" value="${producto.precioVenta}" required>
                                </div>
                            </div>
                            <div class="p-md bg-surface-container rounded-xl space-y-md border border-outline-variant">
                                <h4 class="text-label-md font-bold text-primary border-b border-outline-variant pb-xs">CONTROL CRITICO</h4>
                                <div class="space-y-xs">
                                    <label class="text-[10px] text-on-surface-variant uppercase">Vencimiento</label>
                                    <input class="w-full border-outline-variant rounded-lg focus:ring-primary text-[12px]" id="form-fechaVencimiento" name="fechaVencimiento" type="date" value="${producto.fechaVencimiento}">
                                </div>
                                <div class="flex items-center gap-md pt-sm">
                                    <input class="rounded text-primary focus:ring-primary" id="form-requiereReceta" name="requiereReceta" type="checkbox" ${producto.requiereReceta ? 'checked' : ''}>
                                    <label class="text-label-md text-on-surface font-bold" for="form-requiereReceta">Requiere Receta Medica</label>
                                </div>
                                <div class="space-y-xs">
                                    <label class="text-label-md text-on-surface-variant">Estado</label>
                                    <select class="w-full border-outline-variant rounded-lg focus:ring-primary" id="form-estado" name="estado">
                                        <option value="ACTIVO" ${producto.estado eq 'ACTIVO' || empty producto.estado ? 'selected' : ''}>ACTIVO</option>
                                        <option value="INACTIVO" ${producto.estado eq 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="bg-surface-container-high px-lg py-md flex justify-end gap-md border-t border-outline-variant">
                        <button class="px-lg py-sm rounded-lg text-on-surface-variant font-label-md hover:bg-surface-variant/30 transition-colors w-auto" id="cancelModal" type="button">DESCARTAR</button>
                        <button class="px-xl py-sm rounded-lg bg-primary text-on-primary font-label-md hover:shadow-lg transition-all w-auto" type="submit">GUARDAR PRODUCTO</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
    const modal = document.getElementById('productModal');
    const openBtn = document.getElementById('addProductBtn');
    const closeBtn = document.getElementById('closeModal');
    const cancelBtn = document.getElementById('cancelModal');
    const overlay = document.getElementById('closeOverlay');
    const typeFilter = document.getElementById('productTypeFilter');

    function toggleModal(forceOpen) {
        const shouldOpen = typeof forceOpen === 'boolean' ? forceOpen : modal.classList.contains('hidden');
        modal.classList.toggle('hidden', !shouldOpen);
        modal.classList.toggle('flex', shouldOpen);
    }

    function openCreateProduct() {
        document.getElementById('productForm').reset();
        document.getElementById('form-idProducto').value = '';
        document.getElementById('productModalTitle').textContent = 'Registrar Nuevo Producto';
        document.getElementById('form-estado').value = 'ACTIVO';
        toggleModal(true);
    }

    function openEditProduct(button) {
        document.getElementById('form-idProducto').value = button.dataset.id || '';
        document.getElementById('form-idTipoProducto').value = button.dataset.idTipo || '';
        document.getElementById('form-codigo').value = button.dataset.codigo || '';
        document.getElementById('form-nombre').value = button.dataset.nombre || '';
        document.getElementById('form-descripcion').value = button.dataset.descripcion || '';
        document.getElementById('form-stock').value = button.dataset.stock || '0';
        document.getElementById('form-stockMinimo').value = button.dataset.stockMinimo || '0';
        document.getElementById('form-precioCompra').value = button.dataset.precioCompra || '';
        document.getElementById('form-precioVenta').value = button.dataset.precioVenta || '';
        document.getElementById('form-fechaVencimiento').value = button.dataset.fechaVencimiento || '';
        document.getElementById('form-requiereReceta').checked = button.dataset.requiereReceta === 'true';
        document.getElementById('form-estado').value = button.dataset.estado || 'ACTIVO';
        document.getElementById('productModalTitle').textContent = 'Editar Producto';
        toggleModal(true);
    }

    function filterProducts(mode, activeButton) {
        document.querySelectorAll('.product-filter-btn').forEach((button) => {
            button.classList.remove('bg-primary', 'text-on-primary');
            button.classList.add('bg-white', 'text-on-surface-variant', 'border', 'border-outline-variant');
        });
        if (activeButton) {
            activeButton.classList.add('bg-primary', 'text-on-primary');
            activeButton.classList.remove('bg-white', 'text-on-surface-variant', 'border', 'border-outline-variant');
        }
        document.querySelectorAll('.product-row').forEach((row) => {
            let show = true;
            if (mode === 'LOW') show = row.dataset.lowStock === 'true';
            if (mode === 'EXPIRY') {
                const expiry = row.dataset.nearExpiryDate;
                if (!expiry) {
                    show = false;
                } else {
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    const expiryDate = new Date(`${expiry}T00:00:00`);
                    const diffMs = expiryDate.getTime() - today.getTime();
                    const diffDays = Math.ceil(diffMs / (1000 * 60 * 60 * 24));
                    show = diffDays >= 0 && diffDays <= 30;
                }
            }
            row.hidden = !show;
        });
        applyTypeFilter();
    }

    function applyTypeFilter() {
        const selectedType = typeFilter.value;
        document.querySelectorAll('.product-row').forEach((row) => {
            const matchesType = !selectedType || row.dataset.tipo === selectedType;
            if (!matchesType) {
                row.hidden = true;
            }
        });
    }

    openBtn.addEventListener('click', openCreateProduct);
    closeBtn.addEventListener('click', () => toggleModal(false));
    cancelBtn.addEventListener('click', () => toggleModal(false));
    overlay.addEventListener('click', () => toggleModal(false));
    typeFilter.addEventListener('change', () => filterProducts('ALL', document.querySelector('.product-filter-btn')));

    <c:if test="${not empty producto.idProducto or not empty error}">
        toggleModal(true);
    </c:if>
</script>
</body>
</html>
