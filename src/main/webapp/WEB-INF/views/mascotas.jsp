<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VetWeb Integrado - Gestion de Mascotas</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }
        .active-tab {
            font-variation-settings: 'FILL' 1;
        }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #e5e7eb; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #d1d5db; }
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
                        "label-md": ["12px", {"lineHeight": "16px", "fontWeight": "600"}],
                        "body-md": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                        "headline-lg": ["28px", {"lineHeight": "36px", "letterSpacing": "-0.01em", "fontWeight": "600"}],
                        "headline-lg-mobile": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                        "headline-md": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                        "display-lg": ["36px", {"lineHeight": "44px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "body-lg": ["16px", {"lineHeight": "24px", "fontWeight": "400"}]
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-surface text-on-surface font-body-md overflow-hidden">
<c:set var="userInitial" value="${fn:toUpperCase(fn:substring(sessionScope.userSession.username, 0, 1))}"/>
<aside class="fixed left-0 top-0 h-screen w-[280px] bg-[#111827] flex flex-col py-lg z-50">
    <div class="px-lg mb-xl">
        <h1 class="text-headline-md font-headline-md text-surface-container-lowest">VetWeb Integrado</h1>
        <p class="text-label-md font-label-md text-surface-variant/60">Veterinary Clinic Management</p>
    </div>
    <nav class="flex-1 space-y-base px-sm overflow-y-auto">
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/dashboard"><span class="material-symbols-outlined">dashboard</span><span class="font-label-md text-label-md">Dashboard</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/clientes"><span class="material-symbols-outlined">group</span><span class="font-label-md text-label-md">Clientes</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-secondary-fixed font-bold border-r-4 border-secondary-fixed bg-on-primary-fixed-variant/10" href="${pageContext.request.contextPath}/app/mascotas"><span class="material-symbols-outlined active-tab">pets</span><span class="font-label-md text-label-md">Mascotas</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/productos"><span class="material-symbols-outlined">inventory_2</span><span class="font-label-md text-label-md">Productos</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/catalogos"><span class="material-symbols-outlined">category</span><span class="font-label-md text-label-md">Catalogos</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/citas"><span class="material-symbols-outlined">calendar_today</span><span class="font-label-md text-label-md">Citas</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/atenciones"><span class="material-symbols-outlined">medical_services</span><span class="font-label-md text-label-md">Atenciones</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/comprobantes"><span class="material-symbols-outlined">receipt_long</span><span class="font-label-md text-label-md">Comprobantes</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/app/reportes"><span class="material-symbols-outlined">bar_chart</span><span class="font-label-md text-label-md">Reportes</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all duration-150 ease-in-out" href="${pageContext.request.contextPath}/logout"><span class="material-symbols-outlined">logout</span><span class="font-label-md text-label-md">Cerrar sesion</span></a>
    </nav>
    <div class="px-lg mt-auto pt-lg border-t border-surface-variant/10">
        <div class="flex items-center gap-md">
            <div class="w-10 h-10 rounded-full bg-primary-container flex items-center justify-center text-on-primary-container font-bold">${userInitial}</div>
            <div>
                <p class="text-label-md font-bold text-surface-bright">${sessionScope.userSession.nombreCompleto}</p>
                <p class="text-[10px] text-surface-variant/50">${sessionScope.userSession.rolNombre}</p>
            </div>
        </div>
    </div>
</aside>

<main class="ml-[280px] w-[calc(100%-280px)] h-screen flex flex-col overflow-hidden">
    <header class="sticky top-0 z-40 bg-surface border-b border-outline-variant flex justify-between items-center h-16 px-lg">
        <form method="get" class="flex items-center gap-lg">
            <div class="relative w-96">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">search</span>
                <input class="w-full bg-surface-container-low border-none rounded-xl pl-10 text-body-md focus:ring-2 focus:ring-primary/20 transition-all" name="search" value="${param.search}" placeholder="Buscar mascota o cliente..." type="text">
            </div>
        </form>
        <div class="flex items-center gap-md">
            <button class="p-2 rounded-full hover:bg-surface-container text-on-surface-variant transition-opacity duration-200 w-auto" type="button"><span class="material-symbols-outlined">notifications</span></button>
            <button class="p-2 rounded-full hover:bg-surface-container text-on-surface-variant transition-opacity duration-200 w-auto" type="button"><span class="material-symbols-outlined">settings</span></button>
            <div class="h-8 w-[1px] bg-outline-variant mx-2"></div>
            <button class="bg-primary text-on-primary px-lg py-2 rounded-xl flex items-center gap-2 font-label-md hover:opacity-90 transition-all w-auto" type="button" onclick="openCreateModal()"><span class="material-symbols-outlined">add</span>Nueva Mascota</button>
        </div>
    </header>

    <div class="flex-1 p-lg overflow-y-auto bg-surface-container-lowest">
        <c:if test="${not empty sessionScope.flash}">
            <div class="mb-lg flex items-start gap-sm p-md bg-secondary-container text-on-secondary-container rounded-lg border border-secondary/20">
                <span class="material-symbols-outlined">check_circle</span>
                <div class="flex-1">
                    <p class="font-label-md text-label-md">Operacion exitosa</p>
                    <p class="text-[12px]">${sessionScope.flash}</p>
                </div>
            </div>
            <% session.removeAttribute("flash"); %>
        </c:if>
        <c:if test="${not empty error}">
            <div class="mb-lg flex items-start gap-sm p-md bg-error-container text-on-error-container rounded-lg border border-error/20">
                <span class="material-symbols-outlined text-error">error</span>
                <div class="flex-1">
                    <p class="font-label-md text-label-md">Error</p>
                    <p class="text-[12px]">${error}</p>
                </div>
            </div>
        </c:if>

        <div class="grid grid-cols-12 gap-lg h-full">
            <div class="col-span-8 flex flex-col gap-lg">
                <div class="bg-surface rounded-xl p-md border border-outline-variant flex items-center justify-between">
                    <div class="flex gap-sm flex-wrap">
                        <button class="pet-filter-btn px-md py-1.5 rounded-full bg-primary text-on-primary font-label-md flex items-center gap-2 w-auto" data-filter="ALL" type="button" onclick="filterPets('ALL', this)">Todas</button>
                        <button class="pet-filter-btn px-md py-1.5 rounded-full bg-surface-container text-on-surface-variant font-label-md flex items-center gap-2 hover:bg-surface-variant transition-colors w-auto" data-filter="CANINO" type="button" onclick="filterPets('CANINO', this)"><span class="material-symbols-outlined text-[18px]">pets</span> Caninos</button>
                        <button class="pet-filter-btn px-md py-1.5 rounded-full bg-surface-container text-on-surface-variant font-label-md flex items-center gap-2 hover:bg-surface-variant transition-colors w-auto" data-filter="FELINO" type="button" onclick="filterPets('FELINO', this)"><span class="material-symbols-outlined text-[18px]">pets</span> Felinos</button>
                        <button class="pet-filter-btn px-md py-1.5 rounded-full bg-surface-container text-on-surface-variant font-label-md flex items-center gap-2 hover:bg-surface-variant transition-colors w-auto" data-filter="OTHER" type="button" onclick="filterPets('OTHER', this)"><span class="material-symbols-outlined text-[18px]">cruelty_free</span> Otros</button>
                    </div>
                    <div class="flex items-center gap-sm">
                        <span class="text-label-md text-outline">Ordenar por:</span>
                        <select class="bg-transparent border-none text-label-md font-bold text-primary focus:ring-0 cursor-pointer" id="petSort">
                            <option value="recent">Recientes</option>
                            <option value="name">Nombre (A-Z)</option>
                            <option value="owner">Propietario</option>
                        </select>
                    </div>
                </div>

                <div class="bg-surface rounded-xl border border-outline-variant overflow-hidden shadow-sm">
                    <table class="w-full text-left border-collapse">
                        <thead class="bg-surface-container-low">
                            <tr>
                                <th class="px-lg py-md font-label-md text-label-md text-on-surface-variant">Nombre</th>
                                <th class="px-lg py-md font-label-md text-label-md text-on-surface-variant">Cliente (Propietario)</th>
                                <th class="px-lg py-md font-label-md text-label-md text-on-surface-variant">Especie</th>
                                <th class="px-lg py-md font-label-md text-label-md text-on-surface-variant">Raza</th>
                                <th class="px-lg py-md font-label-md text-label-md text-on-surface-variant">Peso</th>
                                <th class="px-lg py-md font-label-md text-label-md text-on-surface-variant">Estado</th>
                                <th class="px-lg py-md font-label-md text-label-md text-on-surface-variant text-right">Acciones</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-outline-variant" id="petTableBody">
                            <c:forEach var="item" items="${mascotas}">
                                <tr class="hover:bg-primary-container/5 transition-colors cursor-pointer pet-row"
                                    data-id="${item.idMascota}"
                                    data-cliente-id="${item.idCliente}"
                                    data-especie-id="${item.idEspecie}"
                                    data-nombre="${fn:escapeXml(item.nombre)}"
                                    data-cliente="${fn:escapeXml(item.clienteNombre)}"
                                    data-especie="${fn:escapeXml(item.especieNombre)}"
                                    data-raza="${empty item.raza ? '-' : item.raza}"
                                    data-peso="${empty item.peso ? '-' : item.peso}"
                                    data-sexo="${empty item.sexo ? '-' : item.sexo}"
                                    data-estado="${fn:escapeXml(item.estado)}"
                                    data-color="${empty item.color ? '' : item.color}"
                                    data-fecha-nacimiento="${empty item.fechaNacimiento ? '' : item.fechaNacimiento}"
                                    data-observaciones="${empty item.observaciones ? '' : item.observaciones}"
                                    onclick="selectPet(this)">
                                    <td class="px-lg py-md">
                                        <div class="flex items-center gap-md">
                                            <div class="w-10 h-10 rounded-full bg-secondary-container flex items-center justify-center text-on-secondary-container font-bold">${fn:substring(item.nombre,0,1)}</div>
                                            <span class="font-bold text-primary">${item.nombre}</span>
                                        </div>
                                    </td>
                                    <td class="px-lg py-md text-body-md text-on-surface-variant">${item.clienteNombre}</td>
                                    <td class="px-lg py-md"><span class="text-body-md text-on-surface-variant">${item.especieNombre}</span></td>
                                    <td class="px-lg py-md text-body-md">${empty item.raza ? '-' : item.raza}</td>
                                    <td class="px-lg py-md text-body-md">${empty item.peso ? '-' : item.peso} kg</td>
                                    <td class="px-lg py-md">
                                        <span class="px-3 py-1 rounded-full ${item.estado eq 'ACTIVO' ? 'bg-secondary-fixed/20 text-on-secondary-fixed-variant' : item.estado eq 'FALLECIDO' ? 'bg-error-container text-on-error-container' : 'bg-surface-variant text-on-surface-variant'} text-[10px] font-bold">${item.estado}</span>
                                    </td>
                                    <td class="px-lg py-md text-right">
                                        <button class="p-1 hover:bg-surface-container rounded-md w-auto" type="button" onclick="event.stopPropagation(); openEditModal(this)"
                                            data-id="${item.idMascota}"
                                            data-id-cliente="${item.idCliente}"
                                            data-id-especie="${item.idEspecie}"
                                            data-nombre="${fn:escapeXml(item.nombre)}"
                                            data-raza="${empty item.raza ? '' : item.raza}"
                                            data-sexo="${empty item.sexo ? 'NO_DEFINIDO' : item.sexo}"
                                            data-color="${empty item.color ? '' : item.color}"
                                            data-fecha-nacimiento="${empty item.fechaNacimiento ? '' : item.fechaNacimiento}"
                                            data-peso="${empty item.peso ? '' : item.peso}"
                                            data-observaciones="${empty item.observaciones ? '' : item.observaciones}"
                                            data-estado="${fn:escapeXml(item.estado)}"><span class="material-symbols-outlined text-outline">edit</span></button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <aside class="col-span-4 bg-surface rounded-xl border border-outline-variant flex flex-col shadow-sm sticky top-0 overflow-hidden" id="pet-profile">
                <div class="relative h-32 bg-primary">
                    <div class="absolute -bottom-12 left-1/2 -translate-x-1/2">
                        <div class="w-24 h-24 rounded-full border-4 border-surface shadow-md bg-secondary-container text-on-secondary-container flex items-center justify-center text-3xl font-bold" id="detail-avatar">M</div>
                    </div>
                </div>
                <div class="pt-16 px-lg pb-lg flex-1 text-center">
                    <h2 class="text-headline-md font-headline-md text-primary" id="detail-name">Seleccione una mascota</h2>
                    <p class="text-label-md text-outline" id="detail-breed">Raza • Sexo</p>
                    <div class="mt-xl grid grid-cols-2 gap-md">
                        <div class="bg-surface-container-low p-md rounded-xl text-left border border-outline-variant/30">
                            <p class="text-[10px] uppercase font-bold text-outline">Peso Actual</p>
                            <p class="text-headline-md font-bold text-on-surface" id="detail-weight">-</p>
                        </div>
                        <div class="bg-surface-container-low p-md rounded-xl text-left border border-outline-variant/30">
                            <p class="text-[10px] uppercase font-bold text-outline">Estado</p>
                            <p class="text-label-md font-bold text-secondary" id="detail-status">-</p>
                        </div>
                    </div>
                    <div class="mt-lg p-md bg-secondary-fixed/10 rounded-xl border border-secondary-fixed/30 flex items-center gap-md text-left">
                        <div class="w-10 h-10 rounded-full bg-white flex items-center justify-center">
                            <span class="material-symbols-outlined text-secondary">person</span>
                        </div>
                        <div>
                            <p class="text-[10px] font-bold text-secondary uppercase">Propietario</p>
                            <p class="text-body-md font-bold text-on-surface" id="detail-owner">-</p>
                            <a class="text-[11px] text-primary font-bold hover:underline" id="detail-owner-link" href="${pageContext.request.contextPath}/app/clientes">Ver ficha cliente</a>
                        </div>
                    </div>
                    <div class="mt-xl space-y-sm">
                        <button class="w-full py-md px-lg bg-surface-container-highest text-primary font-bold rounded-xl flex items-center justify-center gap-md hover:bg-surface-variant transition-all" type="button"><span class="material-symbols-outlined">history</span>Historial Medico</button>
                        <button class="w-full py-md px-lg bg-surface-container-highest text-primary font-bold rounded-xl flex items-center justify-center gap-md hover:bg-surface-variant transition-all" type="button"><span class="material-symbols-outlined">event</span>Proxima Cita</button>
                    </div>
                </div>
            </aside>
        </div>
    </div>
</main>

<div class="fixed inset-0 bg-inverse-surface/60 backdrop-blur-sm z-[100] hidden items-center justify-center p-md" id="register-modal">
    <div class="bg-surface w-full max-w-2xl rounded-2xl shadow-xl overflow-hidden flex flex-col">
        <div class="p-lg border-b border-outline-variant flex justify-between items-center bg-surface-bright">
            <div>
                <h3 class="text-headline-md font-bold text-primary" id="petModalTitle">${empty mascota.idMascota ? 'Registrar Nueva Mascota' : 'Editar Mascota'}</h3>
                <p class="text-label-md text-outline">Complete la informacion para crear el perfil clinico.</p>
            </div>
            <button class="p-2 hover:bg-surface-variant rounded-full transition-colors w-auto" type="button" onclick="toggleModal('register-modal')"><span class="material-symbols-outlined">close</span></button>
        </div>
        <form class="p-lg overflow-y-auto max-h-[716px]" method="post" id="petForm">
            <input type="hidden" name="idMascota" id="form-idMascota" value="${mascota.idMascota}">
            <div class="grid grid-cols-2 gap-lg">
                <div class="space-y-lg">
                    <div class="flex flex-col gap-xs">
                        <label class="text-label-md font-bold text-on-surface-variant">Nombre de la Mascota</label>
                        <input class="rounded-xl border-outline-variant focus:border-primary focus:ring-primary transition-all" id="form-nombre" name="nombre" placeholder="Ej: Toby" type="text" value="${mascota.nombre}" required>
                    </div>
                    <div class="flex flex-col gap-xs">
                        <label class="text-label-md font-bold text-on-surface-variant">Especie</label>
                        <select class="rounded-xl border-outline-variant focus:border-primary focus:ring-primary" id="form-idEspecie" name="idEspecie" required>
                            <option value="">Seleccionar especie...</option>
                            <c:forEach var="especieItem" items="${especies}">
                                <option value="${especieItem.idEspecie}" ${mascota.idEspecie eq especieItem.idEspecie ? 'selected' : ''}>${especieItem.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="flex flex-col gap-xs">
                        <label class="text-label-md font-bold text-on-surface-variant">Raza</label>
                        <input class="rounded-xl border-outline-variant focus:border-primary focus:ring-primary" id="form-raza" name="raza" placeholder="Seleccione raza..." type="text" value="${mascota.raza}">
                    </div>
                    <div class="flex flex-col gap-xs">
                        <label class="text-label-md font-bold text-on-surface-variant">Color</label>
                        <input class="rounded-xl border-outline-variant focus:border-primary focus:ring-primary" id="form-color" name="color" placeholder="Color principal" type="text" value="${mascota.color}">
                    </div>
                </div>
                <div class="space-y-lg">
                    <div class="flex flex-col gap-xs">
                        <label class="text-label-md font-bold text-on-surface-variant">Propietario</label>
                        <select class="rounded-xl border-outline-variant focus:border-primary focus:ring-primary" id="form-idCliente" name="idCliente" required>
                            <option value="">Seleccionar cliente...</option>
                            <c:forEach var="clienteItem" items="${clientes}">
                                <option value="${clienteItem.idCliente}" ${mascota.idCliente eq clienteItem.idCliente ? 'selected' : ''}>${clienteItem.nombreCompleto}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="grid grid-cols-2 gap-md">
                        <div class="flex flex-col gap-xs">
                            <label class="text-label-md font-bold text-on-surface-variant">Sexo</label>
                            <select class="rounded-xl border-outline-variant focus:border-primary focus:ring-primary" id="form-sexo" name="sexo">
                                <option value="NO_DEFINIDO" ${mascota.sexo eq 'NO_DEFINIDO' ? 'selected' : ''}>NO_DEFINIDO</option>
                                <option value="MACHO" ${mascota.sexo eq 'MACHO' ? 'selected' : ''}>MACHO</option>
                                <option value="HEMBRA" ${mascota.sexo eq 'HEMBRA' ? 'selected' : ''}>HEMBRA</option>
                            </select>
                        </div>
                        <div class="flex flex-col gap-xs">
                            <label class="text-label-md font-bold text-on-surface-variant">Peso (kg)</label>
                            <input class="rounded-xl border-outline-variant focus:border-primary focus:ring-primary" id="form-peso" name="peso" step="0.1" type="number" value="${mascota.peso}">
                        </div>
                    </div>
                    <div class="flex flex-col gap-xs">
                        <label class="text-label-md font-bold text-on-surface-variant">Fecha de Nacimiento</label>
                        <input class="rounded-xl border-outline-variant focus:border-primary focus:ring-primary" id="form-fechaNacimiento" name="fechaNacimiento" type="date" value="${mascota.fechaNacimiento}">
                    </div>
                    <div class="flex flex-col gap-xs">
                        <label class="text-label-md font-bold text-on-surface-variant">Estado</label>
                        <select class="rounded-xl border-outline-variant focus:border-primary focus:ring-primary" id="form-estado" name="estado">
                            <option value="ACTIVO" ${mascota.estado eq 'ACTIVO' || empty mascota.estado ? 'selected' : ''}>ACTIVO</option>
                            <option value="INACTIVO" ${mascota.estado eq 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
                            <option value="FALLECIDO" ${mascota.estado eq 'FALLECIDO' ? 'selected' : ''}>FALLECIDO</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="mt-lg flex flex-col gap-xs">
                <label class="text-label-md font-bold text-on-surface-variant">Observaciones Iniciales</label>
                <textarea class="rounded-xl border-outline-variant focus:border-primary focus:ring-primary" id="form-observaciones" name="observaciones" placeholder="Alergias, comportamiento, notas relevantes..." rows="3">${mascota.observaciones}</textarea>
            </div>
        </form>
        <div class="p-lg bg-surface-container-low flex justify-end gap-md">
            <button class="px-lg py-md rounded-xl font-bold text-primary hover:bg-surface-variant transition-all w-auto" type="button" onclick="toggleModal('register-modal')">Cancelar</button>
            <button class="px-xl py-md bg-primary text-on-primary rounded-xl font-bold hover:opacity-90 transition-all shadow-md w-auto" type="submit" form="petForm">Guardar Mascota</button>
        </div>
    </div>
</div>

<script>
    function toggleModal(id) {
        const modal = document.getElementById(id);
        if (modal.classList.contains('hidden')) {
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        } else {
            modal.classList.remove('flex');
            modal.classList.add('hidden');
        }
    }

    function openCreateModal() {
        const form = document.getElementById('petForm');
        form.reset();
        document.getElementById('form-idMascota').value = '';
        document.getElementById('petModalTitle').textContent = 'Registrar Nueva Mascota';
        document.getElementById('form-sexo').value = 'NO_DEFINIDO';
        document.getElementById('form-estado').value = 'ACTIVO';
        toggleModal('register-modal');
    }

    function openEditModal(button) {
        document.getElementById('form-idMascota').value = button.dataset.id || '';
        document.getElementById('form-idCliente').value = button.dataset.idCliente || '';
        document.getElementById('form-idEspecie').value = button.dataset.idEspecie || '';
        document.getElementById('form-nombre').value = button.dataset.nombre || '';
        document.getElementById('form-raza').value = button.dataset.raza || '';
        document.getElementById('form-sexo').value = button.dataset.sexo || 'NO_DEFINIDO';
        document.getElementById('form-color').value = button.dataset.color || '';
        document.getElementById('form-fechaNacimiento').value = button.dataset.fechaNacimiento || '';
        document.getElementById('form-peso').value = button.dataset.peso || '';
        document.getElementById('form-observaciones').value = button.dataset.observaciones || '';
        document.getElementById('form-estado').value = button.dataset.estado || 'ACTIVO';
        document.getElementById('petModalTitle').textContent = 'Editar Mascota';
        toggleModal('register-modal');
    }

    function selectPet(row) {
        const cells = row.querySelectorAll('td');
        const razaText = cells[3] ? cells[3].innerText.trim() : '-';
        const pesoText = cells[4] ? cells[4].innerText.trim() : '-';
        const estadoText = cells[5] ? cells[5].innerText.trim() : '-';
        document.getElementById('detail-avatar').textContent = (row.dataset.nombre || '?').charAt(0).toUpperCase();
        document.getElementById('detail-name').innerText = row.dataset.nombre || '-';
        document.getElementById('detail-breed').innerText = `${razaText || '-'} • ${row.dataset.sexo || '-'}`;
        document.getElementById('detail-owner').innerText = row.dataset.cliente || '-';
        document.getElementById('detail-owner-link').href = `${'${pageContext.request.contextPath}'}/app/clientes`;
        document.getElementById('detail-weight').innerText = pesoText || '-';
        document.getElementById('detail-status').innerText = estadoText || '-';

        const profile = document.getElementById('pet-profile');
        profile.style.opacity = '0';
        profile.style.transform = 'translateX(20px)';
        setTimeout(() => {
            profile.style.transition = 'all 0.3s ease-out';
            profile.style.opacity = '1';
            profile.style.transform = 'translateX(0)';
        }, 50);
    }

    function filterPets(mode, activeButton) {
        const rows = document.querySelectorAll('.pet-row');
        document.querySelectorAll('.pet-filter-btn').forEach((button) => {
            button.classList.remove('bg-primary', 'text-on-primary');
            button.classList.add('bg-surface-container', 'text-on-surface-variant');
        });
        if (activeButton) {
            activeButton.classList.remove('bg-surface-container', 'text-on-surface-variant');
            activeButton.classList.add('bg-primary', 'text-on-primary');
        }
        rows.forEach((row) => {
            const especie = (row.dataset.especie || '').toUpperCase();
            let show = true;
            const isCanino = especie.includes('CAN') || especie.includes('PERRO');
            const isFelino = especie.includes('FEL') || especie.includes('GAT');
            if (mode === 'CANINO') show = isCanino;
            if (mode === 'FELINO') show = isFelino;
            if (mode === 'OTHER') show = !isCanino && !isFelino;
            row.hidden = !show;
        });
    }

    (function initSelectedPet() {
        const firstRow = document.querySelector('.pet-row');
        if (firstRow) {
            selectPet(firstRow);
        }
        <c:if test="${not empty mascota.idMascota or not empty error}">
            document.getElementById('register-modal').classList.remove('hidden');
            document.getElementById('register-modal').classList.add('flex');
        </c:if>
    }());
</script>
</body>
</html>
