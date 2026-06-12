<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VetWeb Integrado - Dashboard Principal</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
        }
        .custom-scrollbar::-webkit-scrollbar {
            width: 4px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
            background: transparent;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: #e5e7eb;
            border-radius: 10px;
        }
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
                        "headline-lg-mobile": ["Inter"],
                        "headline-md": ["Inter"],
                        "display-lg": ["Inter"],
                        "body-lg": ["Inter"]
                    },
                    fontSize: {
                        "label-md": ["12px", { lineHeight: "16px", fontWeight: "600" }],
                        "body-md": ["14px", { lineHeight: "20px", fontWeight: "400" }],
                        "headline-lg": ["28px", { lineHeight: "36px", letterSpacing: "-0.01em", fontWeight: "600" }],
                        "headline-lg-mobile": ["24px", { lineHeight: "32px", fontWeight: "600" }],
                        "headline-md": ["20px", { lineHeight: "28px", fontWeight: "600" }],
                        "display-lg": ["36px", { lineHeight: "44px", letterSpacing: "-0.02em", fontWeight: "700" }],
                        "body-lg": ["16px", { lineHeight: "24px", fontWeight: "400" }]
                    }
                }
            }
        };
    </script>
</head>
<body class="bg-surface text-on-surface">
<c:set var="userInitial" value="${fn:toUpperCase(fn:substring(sessionScope.userSession.username, 0, 1))}"/>
<aside class="fixed left-0 top-0 h-screen w-[280px] bg-[#111827] flex flex-col py-lg z-50">
    <div class="px-lg mb-xl">
        <h1 class="text-headline-md font-headline-md text-surface-container-lowest">VetWeb Integrado</h1>
        <p class="text-label-md font-label-md text-surface-variant opacity-70">Veterinary Clinic Management</p>
    </div>
    <nav class="flex-1 px-sm space-y-base overflow-y-auto custom-scrollbar">
        <a class="flex items-center gap-md px-md py-sm text-secondary-fixed font-bold border-r-4 border-secondary-fixed bg-on-primary-fixed-variant/10 transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/dashboard">
            <span class="material-symbols-outlined">dashboard</span>
            <span class="text-body-md font-body-md">Dashboard</span>
        </a>
        <a class="flex items-center gap-md px-md py-sm text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/clientes">
            <span class="material-symbols-outlined">group</span>
            <span class="text-body-md font-body-md">Clientes</span>
        </a>
        <a class="flex items-center gap-md px-md py-sm text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/mascotas">
            <span class="material-symbols-outlined">pets</span>
            <span class="text-body-md font-body-md">Mascotas</span>
        </a>
        <a class="flex items-center gap-md px-md py-sm text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/productos">
            <span class="material-symbols-outlined">inventory_2</span>
            <span class="text-body-md font-body-md">Productos</span>
        </a>
        <a class="flex items-center gap-md px-md py-sm text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/catalogos">
            <span class="material-symbols-outlined">category</span>
            <span class="text-body-md font-body-md">Catalogos</span>
        </a>
        <a class="flex items-center gap-md px-md py-sm text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/citas">
            <span class="material-symbols-outlined">calendar_today</span>
            <span class="text-body-md font-body-md">Citas</span>
        </a>
        <a class="flex items-center gap-md px-md py-sm text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/atenciones">
            <span class="material-symbols-outlined">medical_services</span>
            <span class="text-body-md font-body-md">Atenciones</span>
        </a>
        <a class="flex items-center gap-md px-md py-sm text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/comprobantes">
            <span class="material-symbols-outlined">receipt_long</span>
            <span class="text-body-md font-body-md">Comprobantes</span>
        </a>
        <a class="flex items-center gap-md px-md py-sm text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/reportes">
            <span class="material-symbols-outlined">bar_chart</span>
            <span class="text-body-md font-body-md">Reportes</span>
        </a>
        <a class="flex items-center gap-md px-md py-sm text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/logout">
            <span class="material-symbols-outlined">logout</span>
            <span class="text-body-md font-body-md">Cerrar sesion</span>
        </a>
    </nav>
    <div class="px-lg pt-md border-t border-surface-variant/10">
        <div class="flex items-center gap-sm">
            <div class="w-10 h-10 rounded-full bg-primary-container flex items-center justify-center text-on-primary-container font-bold">
                ${userInitial}
            </div>
            <div>
                <p class="text-body-md font-bold text-surface-bright">${sessionScope.userSession.nombreCompleto}</p>
                <p class="text-label-md text-surface-variant/60">${sessionScope.userSession.rolNombre}</p>
            </div>
        </div>
    </div>
</aside>

<main class="ml-[280px] w-[calc(100%-280px)] min-h-screen">
    <header class="sticky top-0 z-40 bg-surface border-b border-outline-variant flex justify-between items-center h-16 px-lg">
        <div class="flex items-center gap-md bg-surface-container-low px-md py-xs rounded-full w-96 max-w-full">
            <span class="material-symbols-outlined text-outline">search</span>
            <input class="bg-transparent border-none focus:ring-0 text-body-md w-full placeholder:text-outline" placeholder="Buscar clientes, mascotas o productos..." type="text">
        </div>
        <div class="flex items-center gap-lg">
            <button class="relative p-xs hover:bg-surface-container-high rounded-full transition-colors w-auto">
                <span class="material-symbols-outlined text-on-surface-variant">notifications</span>
                <span class="absolute top-1 right-1 w-2 h-2 bg-error rounded-full"></span>
            </button>
            <button class="p-xs hover:bg-surface-container-high rounded-full transition-colors w-auto">
                <span class="material-symbols-outlined text-on-surface-variant">settings</span>
            </button>
            <div class="w-8 h-8 rounded-full bg-primary-container flex items-center justify-center text-on-primary-container text-xs font-bold border border-outline-variant">
                ${userInitial}
            </div>
        </div>
    </header>

    <div class="p-lg space-y-lg">
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
</main>

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
</body>
</html>
