<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citas - VetWeb Integrado</title>
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
<c:set var="pendingCount" value="0"/>
<c:set var="confirmedCount" value="0"/>
<c:set var="attendedCount" value="0"/>
<c:forEach var="item" items="${citas}">
    <c:if test="${item.estado eq 'PENDIENTE'}"><c:set var="pendingCount" value="${pendingCount + 1}"/></c:if>
    <c:if test="${item.estado eq 'CONFIRMADA'}"><c:set var="confirmedCount" value="${confirmedCount + 1}"/></c:if>
    <c:if test="${item.estado eq 'ATENDIDA'}"><c:set var="attendedCount" value="${attendedCount + 1}"/></c:if>
</c:forEach>
<aside class="fixed left-0 top-0 h-screen w-[280px] bg-[#111827] flex flex-col py-lg z-50">
    <div class="px-lg mb-xl">
        <h1 class="text-headline-md font-headline-md text-surface-container-lowest tracking-tight">VetWeb Integrado</h1>
        <p class="text-label-md font-label-md text-outline-variant opacity-60">Veterinary Clinic Management</p>
    </div>
    <nav class="flex-1 px-sm space-y-1 custom-scrollbar overflow-y-auto">
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/dashboard"><span class="material-symbols-outlined">dashboard</span><span class="text-body-md font-body-md">Dashboard</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/clientes"><span class="material-symbols-outlined">group</span><span class="text-body-md font-body-md">Clientes</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/mascotas"><span class="material-symbols-outlined">pets</span><span class="text-body-md font-body-md">Mascotas</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-secondary-fixed font-bold border-r-4 border-secondary-fixed bg-on-primary-fixed-variant/10 transition-all" href="${pageContext.request.contextPath}/app/citas"><span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">calendar_today</span><span class="text-body-md font-body-md">Citas</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/atenciones"><span class="material-symbols-outlined">medical_services</span><span class="text-body-md font-body-md">Atenciones</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/productos"><span class="material-symbols-outlined">inventory_2</span><span class="text-body-md font-body-md">Productos</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/catalogos"><span class="material-symbols-outlined">category</span><span class="text-body-md font-body-md">Catalogos</span></a>
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
        <form class="flex items-center gap-md w-full max-w-xl" method="get">
            <div class="relative w-full">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">search</span>
                <input class="w-full bg-surface-container-low border-none rounded-lg pl-10 pr-md py-2 text-body-md focus:ring-2 focus:ring-primary/20" name="search" placeholder="Buscar citas, mascotas o clientes..." type="text" value="${param.search}">
            </div>
            <button class="hidden" type="submit">Buscar</button>
        </form>
        <div class="flex items-center gap-lg">
            <div class="flex items-center gap-md">
                <button class="p-2 text-on-surface-variant hover:text-primary transition-opacity relative" type="button">
                    <span class="material-symbols-outlined">notifications</span>
                    <span class="absolute top-1 right-1 w-2 h-2 bg-error rounded-full"></span>
                </button>
                <button class="p-2 text-on-surface-variant hover:text-primary transition-opacity" type="button">
                    <span class="material-symbols-outlined">settings</span>
                </button>
            </div>
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

        <div class="flex justify-between items-end mb-xl">
            <div>
                <h2 class="text-display-lg font-display-lg text-primary mb-xs">Agenda de Citas</h2>
                <p class="text-body-lg text-on-surface-variant flex items-center gap-xs">
                    <span class="material-symbols-outlined text-primary">calendar_month</span>
                    <span id="todayLabel"></span>
                </p>
            </div>
            <button class="bg-primary text-on-primary px-lg py-sm rounded-lg flex items-center gap-sm hover:opacity-90 transition-all shadow-md w-auto" type="button" onclick="openNewAppointment()">
                <span class="material-symbols-outlined">add</span>
                <span class="text-body-md font-bold">Nueva Cita</span>
            </button>
        </div>

        <form class="grid grid-cols-12 gap-lg mb-xl" method="get" id="appointmentsFilterForm">
            <div class="col-span-8 bg-surface-container-lowest border border-outline-variant rounded-xl p-lg flex items-center gap-xl">
                <div class="flex-grow">
                    <label class="text-label-md text-on-surface-variant mb-xs block">Filtrar por fecha</label>
                    <div class="flex gap-sm items-center">
                        <input class="w-full max-w-[240px] bg-surface-container-low border border-outline-variant rounded-lg text-body-md px-md py-2 outline-none focus:ring-1 focus:ring-primary" name="fecha" type="date" value="${param.fecha}">
                        <button class="px-md py-2 rounded-full border border-primary bg-primary-fixed text-primary text-body-md font-bold w-auto" type="submit">Aplicar</button>
                    </div>
                </div>
                <div class="w-[1px] h-12 bg-outline-variant"></div>
                <div class="min-w-[220px]">
                    <label class="text-label-md text-on-surface-variant mb-xs block">Estado</label>
                    <select class="w-full bg-surface-container-low border border-outline-variant rounded-lg text-body-md px-md py-2 outline-none focus:ring-1 focus:ring-primary" name="estado" id="estadoFiltro">
                        <option value="">Todos los estados</option>
                        <option value="PENDIENTE" ${param.estado eq 'PENDIENTE' ? 'selected' : ''}>Pendiente</option>
                        <option value="CONFIRMADA" ${param.estado eq 'CONFIRMADA' ? 'selected' : ''}>Confirmada</option>
                        <option value="ATENDIDA" ${param.estado eq 'ATENDIDA' ? 'selected' : ''}>Atendida</option>
                        <option value="CANCELADA" ${param.estado eq 'CANCELADA' ? 'selected' : ''}>Cancelada</option>
                        <option value="NO_ASISTIO" ${param.estado eq 'NO_ASISTIO' ? 'selected' : ''}>No asistio</option>
                    </select>
                </div>
                <input type="hidden" name="search" value="${param.search}">
            </div>
            <div class="col-span-4 bg-primary text-on-primary rounded-xl p-lg relative overflow-hidden flex flex-col justify-between">
                <div class="relative z-10">
                    <p class="text-label-md opacity-80 mb-base">Total visible</p>
                    <h3 class="text-display-lg font-bold">${fn:length(citas)} Citas</h3>
                </div>
                <div class="flex gap-md relative z-10 flex-wrap">
                    <div class="flex items-center gap-xs">
                        <span class="w-2 h-2 rounded-full bg-error-container"></span>
                        <span class="text-[12px]">${pendingCount} Pendientes</span>
                    </div>
                    <div class="flex items-center gap-xs">
                        <span class="w-2 h-2 rounded-full bg-secondary-fixed"></span>
                        <span class="text-[12px]">${confirmedCount} Confirmadas</span>
                    </div>
                    <div class="flex items-center gap-xs">
                        <span class="w-2 h-2 rounded-full bg-white/40"></span>
                        <span class="text-[12px]">${attendedCount} Atendidas</span>
                    </div>
                </div>
                <div class="absolute -right-4 -bottom-4 opacity-10">
                    <span class="material-symbols-outlined text-[120px]">medical_information</span>
                </div>
            </div>
        </form>

        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead class="bg-surface-container-low">
                    <tr>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase tracking-wider">Hora</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase tracking-wider">Mascota / Dueño</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase tracking-wider">Motivo</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase tracking-wider">Veterinario</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase tracking-wider text-center">Estado</th>
                        <th class="px-lg py-md text-label-md text-on-surface-variant uppercase tracking-wider text-right">Acciones</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-outline-variant">
                    <c:forEach var="item" items="${citas}">
                        <tr class="hover:bg-surface-container-low transition-colors group appointment-row"
                            data-id="${item.idCita}"
                            data-cliente-id="${item.idCliente}"
                            data-mascota-id="${item.idMascota}"
                            data-veterinario-id="${item.idVeterinario}"
                            data-fecha="${item.fechaCita}"
                            data-hora="${item.horaCita}"
                            data-motivo="${item.motivo}"
                            data-observaciones="${item.observaciones}"
                            data-estado="${item.estado}">
                            <td class="px-lg py-lg">
                                <span class="text-headline-md text-primary font-bold">${fn:substring(item.horaCita, 0, 5)}</span>
                                <p class="text-[10px] text-on-surface-variant">${fn:substring(item.horaCita, 0, 2) lt '12' ? 'AM' : 'PM'}</p>
                            </td>
                            <td class="px-lg py-lg">
                                <div class="flex items-center gap-md">
                                    <div class="w-12 h-12 rounded-lg bg-primary-fixed text-primary flex items-center justify-center font-bold">
                                        ${fn:toUpperCase(fn:substring(item.mascotaNombre, 0, 1))}
                                    </div>
                                    <div>
                                        <p class="text-body-lg font-bold text-on-surface">${item.mascotaNombre}</p>
                                        <p class="text-body-md text-on-surface-variant">${item.clienteNombre}</p>
                                    </div>
                                </div>
                            </td>
                            <td class="px-lg py-lg text-body-md max-w-xs">${item.motivo}</td>
                            <td class="px-lg py-lg">
                                <div class="flex items-center gap-sm">
                                    <span class="w-6 h-6 rounded-full bg-tertiary-fixed text-[10px] flex items-center justify-center font-bold">
                                        ${empty item.veterinarioNombre ? 'SV' : fn:toUpperCase(fn:substring(item.veterinarioNombre, 0, 1))}
                                    </span>
                                    <span class="text-body-md">${empty item.veterinarioNombre ? 'Sin asignar' : item.veterinarioNombre}</span>
                                </div>
                            </td>
                            <td class="px-lg py-lg text-center">
                                <span class="inline-flex px-3 py-1 rounded-full text-label-md font-bold
                                    ${item.estado eq 'CONFIRMADA' ? 'bg-secondary-container text-on-secondary-container' : ''}
                                    ${item.estado eq 'PENDIENTE' ? 'bg-error-container text-on-error-container' : ''}
                                    ${item.estado eq 'ATENDIDA' ? 'bg-surface-container-highest text-on-surface-variant' : ''}
                                    ${item.estado eq 'CANCELADA' ? 'bg-surface-container text-on-surface-variant' : ''}
                                    ${item.estado eq 'NO_ASISTIO' ? 'bg-tertiary-container text-on-tertiary-container' : ''}">
                                    ${item.estado}
                                </span>
                            </td>
                            <td class="px-lg py-lg text-right">
                                <button class="text-outline hover:text-primary transition-colors p-2" type="button" onclick="openAppointmentEdit(this)"
                                        data-id="${item.idCita}"
                                        data-cliente-id="${item.idCliente}"
                                        data-mascota-id="${item.idMascota}"
                                        data-veterinario-id="${item.idVeterinario}"
                                        data-fecha="${item.fechaCita}"
                                        data-hora="${item.horaCita}"
                                        data-motivo="${item.motivo}"
                                        data-observaciones="${item.observaciones}"
                                        data-estado="${item.estado}">
                                    <span class="material-symbols-outlined">edit</span>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="px-lg py-md bg-surface-container-low flex justify-between items-center">
                <p class="text-body-md text-on-surface-variant">Mostrando ${fn:length(citas)} cita(s).</p>
                <div class="flex gap-base">
                    <button class="p-2 border border-outline-variant rounded opacity-40 cursor-default" type="button">
                        <span class="material-symbols-outlined">chevron_left</span>
                    </button>
                    <button class="p-2 border border-outline-variant rounded opacity-40 cursor-default" type="button">
                        <span class="material-symbols-outlined">chevron_right</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</main>

<div class="fixed inset-0 z-[60] hidden" id="appointmentModal">
    <div class="absolute inset-0 bg-inverse-surface/40 backdrop-blur-sm" onclick="closeAppointmentModal()"></div>
    <div class="absolute right-0 top-0 h-full w-full max-w-2xl bg-surface shadow-2xl flex flex-col transform transition-transform duration-300 translate-x-full" id="appointmentPanel">
        <div class="p-lg border-b border-outline-variant flex justify-between items-center bg-surface-container-low">
            <div class="flex items-center gap-md">
                <span class="material-symbols-outlined text-primary text-headline-md">event_note</span>
                <h3 class="text-headline-md font-bold text-primary" id="appointmentModalTitle">Nueva Cita Veterinaria</h3>
            </div>
            <button class="p-2 hover:bg-error-container hover:text-error rounded-full transition-colors" type="button" onclick="closeAppointmentModal()">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <form class="flex-grow overflow-y-auto custom-scrollbar p-xl space-y-lg" method="post" id="appointmentForm">
            <input type="hidden" name="idCita" id="appointmentId" value="${cita.idCita}">
            <div class="grid grid-cols-2 gap-lg">
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="idCliente">Cliente</label>
                    <select class="w-full p-md border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" id="idCliente" name="idCliente" required>
                        <option value="">Seleccione cliente</option>
                        <c:forEach var="clienteItem" items="${clientes}">
                            <option value="${clienteItem.idCliente}" ${cita.idCliente eq clienteItem.idCliente ? 'selected' : ''}>${clienteItem.nombreCompleto}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="idMascota">Mascota</label>
                    <select class="w-full p-md border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" id="idMascota" name="idMascota" required>
                        <option value="">Seleccione mascota</option>
                        <c:forEach var="mascotaItem" items="${mascotas}">
                            <option value="${mascotaItem.idMascota}" data-cliente-id="${mascotaItem.idCliente}" ${cita.idMascota eq mascotaItem.idMascota ? 'selected' : ''}>${mascotaItem.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="space-y-xs">
                <label class="text-label-md text-on-surface-variant font-bold" for="idVeterinario">Veterinario Asignado</label>
                <select class="w-full p-md border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" id="idVeterinario" name="idVeterinario">
                    <option value="">Sin asignar</option>
                    <c:forEach var="vet" items="${veterinarios}">
                        <option value="${vet.idUsuario}" ${cita.idVeterinario eq vet.idUsuario ? 'selected' : ''}>${vet.nombreCompleto}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="grid grid-cols-2 gap-lg">
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="fechaCita">Fecha</label>
                    <input class="w-full p-md border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" id="fechaCita" name="fechaCita" type="date" value="${cita.fechaCita}" required>
                </div>
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="horaCita">Hora</label>
                    <input class="w-full p-md border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" id="horaCita" name="horaCita" type="time" value="${cita.horaCita}" required>
                </div>
            </div>

            <div class="space-y-xs">
                <label class="text-label-md text-on-surface-variant font-bold" for="motivo">Motivo de la Cita</label>
                <input class="w-full p-md border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" id="motivo" name="motivo" placeholder="Describa el sintoma o procedimiento..." type="text" value="${cita.motivo}" required>
            </div>

            <div class="space-y-xs">
                <label class="text-label-md text-on-surface-variant font-bold" for="observaciones">Observaciones</label>
                <textarea class="w-full p-md border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all resize-none" id="observaciones" name="observaciones" placeholder="Notas internas o comentarios..." rows="4">${cita.observaciones}</textarea>
            </div>

            <div class="space-y-xs">
                <label class="text-label-md text-on-surface-variant font-bold" for="estadoCita">Estado</label>
                <select class="w-full p-md border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all" id="estadoCita" name="estado">
                    <option value="PENDIENTE" ${empty cita.estado || cita.estado eq 'PENDIENTE' ? 'selected' : ''}>PENDIENTE</option>
                    <option value="CONFIRMADA" ${cita.estado eq 'CONFIRMADA' ? 'selected' : ''}>CONFIRMADA</option>
                    <option value="ATENDIDA" ${cita.estado eq 'ATENDIDA' ? 'selected' : ''}>ATENDIDA</option>
                    <option value="CANCELADA" ${cita.estado eq 'CANCELADA' ? 'selected' : ''}>CANCELADA</option>
                    <option value="NO_ASISTIO" ${cita.estado eq 'NO_ASISTIO' ? 'selected' : ''}>NO_ASISTIO</option>
                </select>
            </div>

            <div class="p-md bg-secondary-container/20 rounded-lg flex gap-md items-start">
                <span class="material-symbols-outlined text-secondary">info</span>
                <p class="text-body-md text-on-secondary-container">Valida cliente, mascota y horario antes de confirmar la cita para evitar cruces en la agenda.</p>
            </div>
        </form>
        <div class="p-lg border-t border-outline-variant flex gap-md bg-surface-container-low">
            <button class="flex-grow py-sm border border-outline-variant text-on-surface-variant font-bold rounded-lg hover:bg-white transition-colors" type="button" onclick="closeAppointmentModal()">Cancelar</button>
            <button class="flex-grow-[2] py-sm bg-primary text-on-primary font-bold rounded-lg hover:opacity-90 transition-all shadow-md" form="appointmentForm" type="submit">Guardar cita</button>
        </div>
    </div>
</div>

<script>
    function openAppointmentModal() {
        const modal = document.getElementById('appointmentModal');
        const panel = document.getElementById('appointmentPanel');
        modal.classList.remove('hidden');
        setTimeout(() => panel.classList.remove('translate-x-full'), 10);
    }

    function closeAppointmentModal() {
        const modal = document.getElementById('appointmentModal');
        const panel = document.getElementById('appointmentPanel');
        panel.classList.add('translate-x-full');
        setTimeout(() => modal.classList.add('hidden'), 300);
    }

    function filterMascotasByCliente(selectedClienteId, selectedMascotaId) {
        const mascotaSelect = document.getElementById('idMascota');
        const options = Array.from(mascotaSelect.options);
        let hasVisibleSelectedPet = false;

        options.forEach((option, index) => {
            if (index === 0) {
                option.hidden = false;
                return;
            }

            const belongsToClient = !selectedClienteId || option.dataset.clienteId === selectedClienteId;
            option.hidden = !belongsToClient;

            if (!belongsToClient && option.selected) {
                option.selected = false;
            }

            if (belongsToClient && selectedMascotaId && option.value === selectedMascotaId) {
                option.selected = true;
                hasVisibleSelectedPet = true;
            }
        });

        if (selectedMascotaId && !hasVisibleSelectedPet) {
            mascotaSelect.value = '';
        }
    }

    function resetAppointmentForm() {
        document.getElementById('appointmentForm').reset();
        document.getElementById('appointmentId').value = '';
        document.getElementById('appointmentModalTitle').textContent = 'Nueva Cita Veterinaria';
        document.getElementById('estadoCita').value = 'PENDIENTE';
        filterMascotasByCliente(document.getElementById('idCliente').value, '');
    }

    function openNewAppointment() {
        resetAppointmentForm();
        openAppointmentModal();
    }

    function openAppointmentEdit(button) {
        document.getElementById('appointmentId').value = button.dataset.id || '';
        document.getElementById('idCliente').value = button.dataset.clienteId || '';
        filterMascotasByCliente(button.dataset.clienteId || '', button.dataset.mascotaId || '');
        document.getElementById('idVeterinario').value = button.dataset.veterinarioId || '';
        document.getElementById('fechaCita').value = button.dataset.fecha || '';
        document.getElementById('horaCita').value = (button.dataset.hora || '').substring(0, 5);
        document.getElementById('motivo').value = button.dataset.motivo || '';
        document.getElementById('observaciones').value = button.dataset.observaciones || '';
        document.getElementById('estadoCita').value = button.dataset.estado || 'PENDIENTE';
        document.getElementById('appointmentModalTitle').textContent = 'Editar Cita Veterinaria';
        openAppointmentModal();
    }

    const today = new Date();
    document.getElementById('todayLabel').textContent = today.toLocaleDateString('es-PE', {
        weekday: 'long',
        day: 'numeric',
        month: 'long',
        year: 'numeric'
    });

    document.getElementById('estadoFiltro').addEventListener('change', function() {
        document.getElementById('appointmentsFilterForm').submit();
    });

    document.getElementById('idCliente').addEventListener('change', function() {
        filterMascotasByCliente(this.value, '');
    });

    filterMascotasByCliente(document.getElementById('idCliente').value, document.getElementById('idMascota').value);

    <c:if test="${not empty cita || not empty error}">
        openAppointmentModal();
    </c:if>
</script>
</body>
</html>
