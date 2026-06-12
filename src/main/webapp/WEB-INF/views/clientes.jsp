<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VetWeb Integrado - Modulo de Clientes</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
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
    <style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #374151; border-radius: 10px; }
    </style>
</head>
<body class="bg-surface text-on-surface flex min-h-screen">
<c:set var="userInitial" value="${fn:toUpperCase(fn:substring(sessionScope.userSession.username, 0, 1))}"/>
<aside class="fixed left-0 top-0 h-screen w-[280px] bg-[#111827] flex flex-col py-lg z-50">
    <div class="px-lg mb-xl">
        <h1 class="text-headline-md font-headline-md text-surface-container-lowest">VetWeb Integrado</h1>
        <p class="text-label-md font-label-md text-surface-variant opacity-70">Veterinary Clinic Management</p>
    </div>
    <nav class="flex-1 overflow-y-auto custom-scrollbar px-md">
        <ul class="space-y-base">
            <li><a class="flex items-center gap-md p-md rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/dashboard"><span class="material-symbols-outlined">dashboard</span><span class="text-body-md font-body-md">Dashboard</span></a></li>
            <li><a class="flex items-center gap-md p-md rounded-lg text-secondary-fixed font-bold border-r-4 border-secondary-fixed bg-on-primary-fixed-variant/10 transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/clientes"><span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">group</span><span class="text-body-md font-body-md">Clientes</span></a></li>
            <li><a class="flex items-center gap-md p-md rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/mascotas"><span class="material-symbols-outlined">pets</span><span class="text-body-md font-body-md">Mascotas</span></a></li>
            <li><a class="flex items-center gap-md p-md rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/productos"><span class="material-symbols-outlined">inventory_2</span><span class="text-body-md font-body-md">Productos</span></a></li>
            <li><a class="flex items-center gap-md p-md rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/catalogos"><span class="material-symbols-outlined">category</span><span class="text-body-md font-body-md">Catalogos</span></a></li>
            <li><a class="flex items-center gap-md p-md rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/citas"><span class="material-symbols-outlined">calendar_today</span><span class="text-body-md font-body-md">Citas</span></a></li>
            <li><a class="flex items-center gap-md p-md rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/atenciones"><span class="material-symbols-outlined">medical_services</span><span class="text-body-md font-body-md">Atenciones</span></a></li>
            <li><a class="flex items-center gap-md p-md rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/comprobantes"><span class="material-symbols-outlined">receipt_long</span><span class="text-body-md font-body-md">Comprobantes</span></a></li>
            <li><a class="flex items-center gap-md p-md rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/reportes"><span class="material-symbols-outlined">bar_chart</span><span class="text-body-md font-body-md">Reportes</span></a></li>
            <li><a class="flex items-center gap-md p-md rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/logout"><span class="material-symbols-outlined">logout</span><span class="text-body-md font-body-md">Cerrar sesion</span></a></li>
        </ul>
    </nav>
    <div class="mt-auto px-lg pt-lg border-t border-surface-variant/10">
        <div class="flex items-center gap-md">
            <div class="w-10 h-10 rounded-full bg-primary-container flex items-center justify-center text-on-primary-container font-bold">${userInitial}</div>
            <div class="flex-1">
                <p class="text-body-md font-bold text-surface-bright">${sessionScope.userSession.nombreCompleto}</p>
                <p class="text-label-md text-surface-variant opacity-60">${sessionScope.userSession.rolNombre}</p>
            </div>
        </div>
    </div>
</aside>

<main class="flex-1 ml-[280px] min-h-screen flex flex-col">
    <header class="sticky top-0 z-40 bg-surface border-b border-outline-variant flex justify-between items-center h-16 px-lg w-full">
        <form method="get" class="flex items-center flex-1 max-w-md">
            <div class="relative w-full">
                <span class="material-symbols-outlined absolute left-md top-1/2 -translate-y-1/2 text-outline">search</span>
                <input class="w-full pl-xl pr-md py-sm bg-surface-container-low border-none rounded-lg focus:ring-2 focus:ring-primary text-body-md placeholder:text-outline/60" name="search" value="${param.search}" placeholder="Buscar clientes, DNI o telefono..." type="text">
            </div>
        </form>
        <div class="flex items-center gap-lg">
            <button class="relative p-xs text-on-surface-variant hover:text-primary transition-opacity duration-200 w-auto" type="button">
                <span class="material-symbols-outlined">notifications</span>
                <span class="absolute top-0 right-0 w-2 h-2 bg-error rounded-full border-2 border-surface"></span>
            </button>
            <button class="p-xs text-on-surface-variant hover:text-primary transition-opacity duration-200 w-auto" type="button">
                <span class="material-symbols-outlined">settings</span>
            </button>
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

        <div class="flex justify-between items-end gap-md flex-wrap">
            <div>
                <h2 class="text-headline-lg font-headline-lg text-primary">Modulo de Clientes</h2>
                <p class="text-body-md text-on-surface-variant">Gestion centralizada de propietarios y contactos.</p>
            </div>
            <button class="flex items-center gap-sm px-lg py-md bg-primary text-on-primary rounded-lg font-semibold hover:bg-primary-container hover:text-on-primary-container transition-all shadow-sm w-auto" type="button" onclick="openModalForCreate()">
                <span class="material-symbols-outlined">person_add</span>
                Nuevo Cliente
            </button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-4 gap-gutter">
            <div class="bg-surface-container-lowest border border-outline-variant p-lg rounded-xl flex flex-col gap-sm">
                <span class="text-label-md font-label-md text-outline uppercase tracking-wider">Total Clientes</span>
                <div class="flex items-baseline gap-sm">
                    <span class="text-display-lg font-display-lg text-primary" id="statsTotalClientes">${statsTotalClientes}</span>
                </div>
            </div>
            <div class="bg-surface-container-lowest border border-outline-variant p-lg rounded-xl flex flex-col gap-sm">
                <span class="text-label-md font-label-md text-outline uppercase tracking-wider">Activos</span>
                <div class="flex items-baseline gap-sm">
                    <span class="text-display-lg font-display-lg text-secondary" id="statsClientesActivos">${statsClientesActivos}</span>
                </div>
            </div>
            <div class="bg-surface-container-lowest border border-outline-variant p-lg rounded-xl flex flex-col gap-sm">
                <span class="text-label-md font-label-md text-outline uppercase tracking-wider">Nuevos (Mes)</span>
                <div class="flex items-baseline gap-sm">
                    <span class="text-display-lg font-display-lg text-on-tertiary-fixed-variant" id="statsClientesNuevosMes">${statsClientesNuevosMes}</span>
                </div>
            </div>
            <div class="bg-surface-container-lowest border border-outline-variant p-lg rounded-xl flex flex-col gap-sm">
                <span class="text-label-md font-label-md text-outline uppercase tracking-wider">Inactivos</span>
                <div class="flex items-baseline gap-sm">
                    <span class="text-display-lg font-display-lg text-primary" id="statsClientesInactivos">${statsClientesInactivos}</span>
                </div>
            </div>
        </div>

        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl overflow-hidden shadow-sm">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead class="bg-surface-container text-on-surface-variant">
                        <tr>
                            <th class="px-lg py-md text-label-md font-label-md border-b border-outline-variant">Nombres</th>
                            <th class="px-lg py-md text-label-md font-label-md border-b border-outline-variant">Apellidos</th>
                            <th class="px-lg py-md text-label-md font-label-md border-b border-outline-variant">DNI / ID</th>
                            <th class="px-lg py-md text-label-md font-label-md border-b border-outline-variant">Telefono</th>
                            <th class="px-lg py-md text-label-md font-label-md border-b border-outline-variant">Correo</th>
                            <th class="px-lg py-md text-label-md font-label-md border-b border-outline-variant">Estado</th>
                            <th class="px-lg py-md text-label-md font-label-md border-b border-outline-variant">Registro</th>
                            <th class="px-lg py-md text-label-md font-label-md border-b border-outline-variant text-right">Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-outline-variant">
                        <c:forEach var="item" items="${clientes}">
                            <tr class="hover:bg-surface-container-low transition-colors client-row" data-estado="${item.estado}" data-registro="${empty item.fechaRegistro ? '' : fn:substring(item.fechaRegistro, 0, 7)}">
                                <td class="px-lg py-md text-body-md font-semibold text-primary">${item.nombres}</td>
                                <td class="px-lg py-md text-body-md">${item.apellidos}</td>
                                <td class="px-lg py-md text-body-md font-mono">${item.dni}</td>
                                <td class="px-lg py-md text-body-md">${item.telefono}</td>
                                <td class="px-lg py-md text-body-md text-outline">${empty item.correo ? '-' : item.correo}</td>
                                <td class="px-lg py-md">
                                    <span class="inline-flex items-center px-sm py-xs rounded-full ${item.estado eq 'ACTIVO' ? 'bg-secondary-container text-on-secondary-container' : 'bg-error-container text-on-error-container'} text-[10px] font-bold uppercase">${item.estado}</span>
                                </td>
                                <td class="px-lg py-md text-body-md text-outline">${empty item.fechaRegistro ? '-' : fn:substring(item.fechaRegistro, 0, 10)}</td>
                                <td class="px-lg py-md text-right">
                                    <div class="flex justify-end gap-sm">
                                        <button class="p-xs text-outline hover:text-primary transition-colors w-auto" type="button" title="Editar"
                                            onclick="openEditModal(this)"
                                            data-id-cliente="${item.idCliente}"
                                            data-nombres="${fn:escapeXml(item.nombres)}"
                                            data-apellidos="${fn:escapeXml(item.apellidos)}"
                                            data-dni="${fn:escapeXml(item.dni)}"
                                            data-telefono="${fn:escapeXml(item.telefono)}"
                                            data-correo="${fn:escapeXml(item.correo)}"
                                            data-direccion="${fn:escapeXml(item.direccion)}"
                                            data-estado="${fn:escapeXml(item.estado)}"><span class="material-symbols-outlined text-[20px]">edit</span></button>
                                        <button class="p-xs text-outline hover:text-primary transition-colors w-auto" type="button" onclick="showClientDetails(this)"
                                            data-nombres="${fn:escapeXml(item.nombres)}"
                                            data-apellidos="${fn:escapeXml(item.apellidos)}"
                                            data-dni="${fn:escapeXml(item.dni)}"
                                            data-telefono="${fn:escapeXml(item.telefono)}"
                                            data-correo="${fn:escapeXml(item.correo)}"
                                            data-direccion="${fn:escapeXml(item.direccion)}"
                                            data-estado="${fn:escapeXml(item.estado)}"><span class="material-symbols-outlined text-[20px]">visibility</span></button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty clientes}">
                            <tr>
                                <td class="px-lg py-lg text-center text-on-surface-variant" colspan="8">No se encontraron clientes con los filtros actuales.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <div class="px-lg py-md border-t border-outline-variant flex justify-between items-center bg-surface-container-lowest">
                <span class="text-label-md text-outline">Mostrando ${fn:length(clientes)} cliente(s).</span>
                <div class="flex gap-sm">
                    <a class="p-xs border border-outline-variant rounded hover:bg-surface-container transition-colors" href="${pageContext.request.contextPath}/app/clientes"><span class="material-symbols-outlined">restart_alt</span></a>
                </div>
            </div>
        </div>
    </div>
</main>

<div class="fixed inset-0 z-[60] ${openClienteModal ? '' : 'invisible'} transition-all duration-300" id="customerModal">
    <div class="absolute inset-0 bg-on-surface/40 backdrop-blur-sm" onclick="closeModal()"></div>
    <div class="absolute right-0 top-0 h-full w-full max-w-lg bg-surface shadow-2xl transform ${openClienteModal ? 'translate-x-0' : 'translate-x-full'} transition-transform duration-300 ease-in-out flex flex-col" id="modalPanel">
        <header class="p-lg border-b border-outline-variant flex justify-between items-center">
            <div>
                <h3 class="text-headline-md font-headline-md text-primary" id="customerModalTitle">${empty cliente.idCliente ? 'Registrar Nuevo Cliente' : 'Editar Cliente'}</h3>
                <p class="text-label-md text-outline">Complete la informacion para el historial clinico.</p>
            </div>
            <button class="p-sm rounded-full hover:bg-surface-container-high transition-colors w-auto" type="button" onclick="closeModal()">
                <span class="material-symbols-outlined">close</span>
            </button>
        </header>
        <form method="post" class="flex-1 overflow-y-auto p-lg space-y-xl custom-scrollbar" id="customerForm">
            <input type="hidden" name="idCliente" value="${cliente.idCliente}">
            <section>
                <div class="flex items-center gap-sm mb-md text-primary border-b border-primary/10 pb-xs">
                    <span class="material-symbols-outlined">badge</span>
                    <h4 class="text-label-md font-bold uppercase tracking-widest">Datos Personales</h4>
                </div>
                <div class="grid grid-cols-2 gap-md">
                    <div class="col-span-1">
                        <label class="block text-label-md font-semibold text-on-surface-variant mb-xs">Nombres *</label>
                        <input class="w-full px-md py-sm rounded-lg border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary text-body-md" name="nombres" placeholder="Ej. Juan Manuel" type="text" value="${cliente.nombres}" required>
                    </div>
                    <div class="col-span-1">
                        <label class="block text-label-md font-semibold text-on-surface-variant mb-xs">Apellidos *</label>
                        <input class="w-full px-md py-sm rounded-lg border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary text-body-md" name="apellidos" placeholder="Ej. Perez Quispe" type="text" value="${cliente.apellidos}" required>
                    </div>
                    <div class="col-span-2">
                        <label class="block text-label-md font-semibold text-on-surface-variant mb-xs">Nro. Documento *</label>
                        <input class="w-full px-md py-sm rounded-lg border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary text-body-md" name="dni" placeholder="00000000" type="text" value="${cliente.dni}" required>
                    </div>
                </div>
            </section>

            <section>
                <div class="flex items-center gap-sm mb-md text-primary border-b border-primary/10 pb-xs">
                    <span class="material-symbols-outlined">call</span>
                    <h4 class="text-label-md font-bold uppercase tracking-widest">Contacto</h4>
                </div>
                <div class="grid grid-cols-2 gap-md">
                    <div class="col-span-1">
                        <label class="block text-label-md font-semibold text-on-surface-variant mb-xs">Telefono Movil *</label>
                        <input class="w-full px-md py-sm rounded-lg border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary text-body-md" name="telefono" placeholder="+51 900 000 000" type="tel" value="${cliente.telefono}" required>
                    </div>
                    <div class="col-span-1">
                        <label class="block text-label-md font-semibold text-on-surface-variant mb-xs">Estado</label>
                        <select class="w-full px-md py-sm rounded-lg border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary text-body-md" name="estado">
                            <option value="ACTIVO" ${cliente.estado eq 'ACTIVO' || empty cliente.estado ? 'selected' : ''}>ACTIVO</option>
                            <option value="INACTIVO" ${cliente.estado eq 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
                        </select>
                    </div>
                    <div class="col-span-2">
                        <label class="block text-label-md font-semibold text-on-surface-variant mb-xs">Correo Electronico</label>
                        <input class="w-full px-md py-sm rounded-lg border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary text-body-md" name="correo" placeholder="cliente@ejemplo.com" type="email" value="${cliente.correo}">
                    </div>
                </div>
            </section>

            <section>
                <div class="flex items-center gap-sm mb-md text-primary border-b border-primary/10 pb-xs">
                    <span class="material-symbols-outlined">location_on</span>
                    <h4 class="text-label-md font-bold uppercase tracking-widest">Direccion</h4>
                </div>
                <div class="space-y-md">
                    <div>
                        <label class="block text-label-md font-semibold text-on-surface-variant mb-xs">Direccion de Residencia *</label>
                        <input class="w-full px-md py-sm rounded-lg border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary text-body-md" name="direccion" placeholder="Av. Los Pinos 123, Int 4" type="text" value="${cliente.direccion}" required>
                    </div>
                </div>
            </section>

            <footer class="pt-lg border-t border-outline-variant bg-surface-container-low flex justify-end gap-md sticky bottom-0">
                <button class="px-lg py-md text-primary font-bold hover:bg-surface-container transition-colors rounded-lg w-auto" type="button" onclick="closeModal()">Cancelar</button>
                <button class="px-lg py-md bg-primary text-on-primary font-bold rounded-lg shadow-md hover:bg-primary/90 active:scale-95 transition-all w-auto" type="submit">Guardar Cliente</button>
            </footer>
        </form>
    </div>
</div>

<div class="fixed inset-0 z-[70] invisible transition-all duration-200" id="detailsModal">
    <div class="absolute inset-0 bg-on-surface/40 backdrop-blur-sm" onclick="closeDetailsModal()"></div>
    <div class="absolute inset-x-0 top-20 mx-auto w-[92%] max-w-xl rounded-2xl bg-surface-container-lowest border border-outline-variant shadow-2xl p-lg">
        <div class="flex justify-between items-start gap-md">
            <div>
                <h3 class="text-headline-md font-headline-md text-primary">Detalle del Cliente</h3>
                <p class="text-label-md text-outline">Resumen rapido del propietario seleccionado.</p>
            </div>
            <button class="p-sm rounded-full hover:bg-surface-container-high transition-colors w-auto" type="button" onclick="closeDetailsModal()">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <div class="grid grid-cols-2 gap-md mt-lg text-body-md">
            <div><span class="text-outline block text-label-md">Nombres</span><strong id="detailNombres"></strong></div>
            <div><span class="text-outline block text-label-md">Apellidos</span><strong id="detailApellidos"></strong></div>
            <div><span class="text-outline block text-label-md">DNI</span><strong id="detailDni"></strong></div>
            <div><span class="text-outline block text-label-md">Telefono</span><strong id="detailTelefono"></strong></div>
            <div class="col-span-2"><span class="text-outline block text-label-md">Correo</span><strong id="detailCorreo"></strong></div>
            <div class="col-span-2"><span class="text-outline block text-label-md">Direccion</span><strong id="detailDireccion"></strong></div>
            <div><span class="text-outline block text-label-md">Estado</span><strong id="detailEstado"></strong></div>
        </div>
    </div>
</div>

<script>
    const customerModal = document.getElementById("customerModal");
    const modalPanel = document.getElementById("modalPanel");
    const detailsModal = document.getElementById("detailsModal");
    const customerForm = document.getElementById("customerForm");
    const customerModalTitle = document.getElementById("customerModalTitle");

    function openModalForCreate() {
        customerForm.reset();
        customerForm.querySelector("input[name='idCliente']").value = "";
        customerForm.querySelector("select[name='estado']").value = "ACTIVO";
        customerModalTitle.textContent = "Registrar Nuevo Cliente";
        openModal();
    }

    function openEditModal(button) {
        customerForm.querySelector("input[name='idCliente']").value = button.dataset.idCliente || "";
        customerForm.querySelector("input[name='nombres']").value = button.dataset.nombres || "";
        customerForm.querySelector("input[name='apellidos']").value = button.dataset.apellidos || "";
        customerForm.querySelector("input[name='dni']").value = button.dataset.dni || "";
        customerForm.querySelector("input[name='telefono']").value = button.dataset.telefono || "";
        customerForm.querySelector("input[name='correo']").value = button.dataset.correo || "";
        customerForm.querySelector("input[name='direccion']").value = button.dataset.direccion || "";
        customerForm.querySelector("select[name='estado']").value = button.dataset.estado || "ACTIVO";
        customerModalTitle.textContent = "Editar Cliente";
        openModal();
    }

    function openModal() {
        customerModal.classList.remove("invisible");
        modalPanel.classList.remove("translate-x-full");
        modalPanel.classList.add("translate-x-0");
    }

    function closeModal() {
        modalPanel.classList.remove("translate-x-0");
        modalPanel.classList.add("translate-x-full");
        setTimeout(() => {
            customerModal.classList.add("invisible");
            if (window.location.search.includes("action=edit")) {
                window.location.href = "${pageContext.request.contextPath}/app/clientes";
            }
        }, 300);
    }

    function showClientDetails(button) {
        document.getElementById("detailNombres").textContent = button.dataset.nombres || "-";
        document.getElementById("detailApellidos").textContent = button.dataset.apellidos || "-";
        document.getElementById("detailDni").textContent = button.dataset.dni || "-";
        document.getElementById("detailTelefono").textContent = button.dataset.telefono || "-";
        document.getElementById("detailCorreo").textContent = button.dataset.correo || "-";
        document.getElementById("detailDireccion").textContent = button.dataset.direccion || "-";
        document.getElementById("detailEstado").textContent = button.dataset.estado || "-";
        detailsModal.classList.remove("invisible");
    }

    function closeDetailsModal() {
        detailsModal.classList.add("invisible");
    }

    if (${openClienteModal ? 'true' : 'false'}) {
        customerModal.classList.remove("invisible");
    }

    (function populateClientStats() {
        const rows = Array.from(document.querySelectorAll(".client-row"));
        const total = rows.length;
        const active = rows.filter((row) => (row.dataset.estado || "").toUpperCase() === "ACTIVO").length;
        const inactive = total - active;
        const currentMonth = new Date().toISOString().slice(0, 7);
        const nuevosMes = rows.filter((row) => row.dataset.registro === currentMonth).length;

        const totalEl = document.getElementById("statsTotalClientes");
        const activeEl = document.getElementById("statsClientesActivos");
        const inactiveEl = document.getElementById("statsClientesInactivos");
        const nuevosMesEl = document.getElementById("statsClientesNuevosMes");

        if (totalEl && (!totalEl.textContent || !totalEl.textContent.trim())) totalEl.textContent = String(total);
        if (activeEl && (!activeEl.textContent || !activeEl.textContent.trim())) activeEl.textContent = String(active);
        if (inactiveEl && (!inactiveEl.textContent || !inactiveEl.textContent.trim())) inactiveEl.textContent = String(inactive);
        if (nuevosMesEl && (!nuevosMesEl.textContent || !nuevosMesEl.textContent.trim())) nuevosMesEl.textContent = String(nuevosMes);
    }());
</script>
</body>
</html>
