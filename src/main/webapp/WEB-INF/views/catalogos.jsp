<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html class="light" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogos - VetWeb Integrado</title>
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
        .active-tab {
            border-bottom: 2px solid #00236f;
            color: #00236f;
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
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-surface-variant hover:bg-surface-variant/10 hover:text-surface-bright transition-all" href="${pageContext.request.contextPath}/app/productos"><span class="material-symbols-outlined">inventory_2</span><span class="text-body-md font-body-md">Productos</span></a>
        <a class="flex items-center gap-md px-md py-sm rounded-lg text-secondary-fixed font-bold border-r-4 border-secondary-fixed bg-on-primary-fixed-variant/10 transition-all" href="${pageContext.request.contextPath}/app/catalogos"><span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">category</span><span class="text-body-md font-body-md">Catalogos</span></a>
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
        <div class="flex items-center gap-md w-full max-w-xl">
            <span class="material-symbols-outlined text-primary">category</span>
            <div class="relative flex-1">
                <span class="material-symbols-outlined absolute left-md top-1/2 -translate-y-1/2 text-outline">search</span>
                <input class="w-full pl-xl pr-md py-sm bg-surface-container rounded-lg border-none focus:ring-2 focus:ring-primary text-body-md" id="catalogSearch" placeholder="Buscar catalogo por nombre o descripcion..." type="text">
            </div>
        </div>
        <div class="flex items-center gap-md">
            <button class="w-10 h-10 flex items-center justify-center rounded-full text-on-surface-variant hover:bg-surface-container transition-colors" type="button"><span class="material-symbols-outlined">notifications</span></button>
            <button class="w-10 h-10 flex items-center justify-center rounded-full text-on-surface-variant hover:bg-surface-container transition-colors" type="button"><span class="material-symbols-outlined">settings</span></button>
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

        <div class="flex justify-between items-end gap-lg">
            <div>
                <h2 class="text-display-lg font-display-lg text-primary">Catalogos de Datos Maestros</h2>
                <p class="text-body-lg text-on-surface-variant">Administra especies y tipos de producto usados en todo el sistema.</p>
            </div>
            <div class="flex gap-md">
                <div class="px-lg py-md bg-white border border-outline-variant rounded-xl shadow-sm flex flex-col items-center min-w-[140px]">
                    <span class="text-label-md text-outline uppercase">Especies</span>
                    <span class="text-headline-lg text-primary">${fn:length(especies)}</span>
                </div>
                <div class="px-lg py-md bg-white border border-outline-variant rounded-xl shadow-sm flex flex-col items-center min-w-[140px]">
                    <span class="text-label-md text-outline uppercase">Tipos</span>
                    <span class="text-headline-lg text-primary">${fn:length(tiposProducto)}</span>
                </div>
                <div class="px-lg py-md bg-white border border-outline-variant rounded-xl shadow-sm flex flex-col items-center min-w-[140px]">
                    <span class="text-label-md text-secondary uppercase">Activos</span>
                    <span class="text-headline-lg text-secondary" id="activeCount">0</span>
                </div>
            </div>
        </div>

        <div class="mb-lg border-b border-outline-variant flex gap-xl">
            <button class="pb-3 text-label-md font-label-md active-tab flex items-center gap-sm" id="tab-especies" type="button" onclick="switchTab('especies')">
                <span class="material-symbols-outlined text-[18px]">pets</span>
                Especies
            </button>
            <button class="pb-3 text-label-md font-label-md text-on-surface-variant hover:text-primary transition-all flex items-center gap-sm" id="tab-tipos" type="button" onclick="switchTab('tipos')">
                <span class="material-symbols-outlined text-[18px]">inventory_2</span>
                Tipos de Producto
            </button>
        </div>

        <div class="grid grid-cols-12 gap-gutter items-start">
            <div class="col-span-8 space-y-lg">
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl overflow-hidden shadow-sm">
                    <div class="px-lg py-md border-b border-outline-variant bg-surface-container-low">
                        <h3 class="text-headline-md font-headline-md text-on-surface" id="tableTitle">Listado de Especies</h3>
                        <p class="text-body-md text-outline" id="tableSubtitle">Consulta y edita las especies disponibles para registrar mascotas.</p>
                    </div>

                    <div class="block" id="content-especies">
                        <table class="w-full text-left">
                            <thead class="bg-surface-container border-b border-outline-variant">
                                <tr>
                                    <th class="px-md py-3 text-label-md font-label-md text-on-surface-variant uppercase tracking-wider">Nombre</th>
                                    <th class="px-md py-3 text-label-md font-label-md text-on-surface-variant uppercase tracking-wider">Descripcion</th>
                                    <th class="px-md py-3 text-label-md font-label-md text-on-surface-variant uppercase tracking-wider">Estado</th>
                                    <th class="px-md py-3 text-label-md font-label-md text-on-surface-variant uppercase tracking-wider text-right">Acciones</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant" id="speciesRows">
                                <c:forEach var="item" items="${especies}">
                                    <tr class="catalog-row hover:bg-surface-container-low transition-colors"
                                        data-tab="especies"
                                        data-name="${item.nombre}"
                                        data-description="${item.descripcion}"
                                        data-status="${item.estado}">
                                        <td class="px-md py-4 text-body-md font-semibold text-primary">${item.nombre}</td>
                                        <td class="px-md py-4 text-body-md text-on-surface-variant">${empty item.descripcion ? 'Sin descripcion registrada.' : item.descripcion}</td>
                                        <td class="px-md py-4">
                                            <span class="inline-flex items-center rounded-full px-sm py-xs text-label-md font-label-md ${item.estado eq 'ACTIVO' ? 'bg-secondary-container text-on-secondary-container' : 'bg-surface-container text-on-surface-variant'}">${item.estado}</span>
                                        </td>
                                        <td class="px-md py-4 text-right">
                                            <button class="p-1 text-outline hover:text-primary transition-colors" type="button"
                                                    onclick="openSpeciesEdit(this)"
                                                    data-id="${item.idEspecie}"
                                                    data-name="${item.nombre}"
                                                    data-description="${item.descripcion}"
                                                    data-status="${item.estado}">
                                                <span class="material-symbols-outlined">edit</span>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="hidden" id="content-tipos">
                        <table class="w-full text-left">
                            <thead class="bg-surface-container border-b border-outline-variant">
                                <tr>
                                    <th class="px-md py-3 text-label-md font-label-md text-on-surface-variant uppercase tracking-wider">Categoria</th>
                                    <th class="px-md py-3 text-label-md font-label-md text-on-surface-variant uppercase tracking-wider">Descripcion</th>
                                    <th class="px-md py-3 text-label-md font-label-md text-on-surface-variant uppercase tracking-wider">Estado</th>
                                    <th class="px-md py-3 text-label-md font-label-md text-on-surface-variant uppercase tracking-wider text-right">Acciones</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant" id="typeRows">
                                <c:forEach var="item" items="${tiposProducto}">
                                    <tr class="catalog-row hover:bg-surface-container-low transition-colors"
                                        data-tab="tipos"
                                        data-name="${item.nombre}"
                                        data-description="${item.descripcion}"
                                        data-status="${item.estado}">
                                        <td class="px-md py-4 text-body-md font-semibold text-secondary">${item.nombre}</td>
                                        <td class="px-md py-4 text-body-md text-on-surface-variant">${empty item.descripcion ? 'Sin descripcion registrada.' : item.descripcion}</td>
                                        <td class="px-md py-4">
                                            <span class="inline-flex items-center rounded-full px-sm py-xs text-label-md font-label-md ${item.estado eq 'ACTIVO' ? 'bg-secondary-container text-on-secondary-container' : 'bg-surface-container text-on-surface-variant'}">${item.estado}</span>
                                        </td>
                                        <td class="px-md py-4 text-right">
                                            <button class="p-1 text-outline hover:text-secondary transition-colors" type="button"
                                                    onclick="openTypeEdit(this)"
                                                    data-id="${item.idTipoProducto}"
                                                    data-name="${item.nombre}"
                                                    data-description="${item.descripcion}"
                                                    data-status="${item.estado}">
                                                <span class="material-symbols-outlined">edit</span>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="px-lg py-md border-t border-outline-variant text-body-md text-outline">
                        <span id="tableCount">Mostrando ${fn:length(especies)} registro(s).</span>
                    </div>
                </div>
            </div>

            <div class="col-span-4 space-y-lg">
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-sm">
                    <div class="mb-md">
                        <h3 class="text-headline-md font-headline-md text-on-surface" id="formTitle">Agregar Especie</h3>
                        <p class="text-body-md text-outline" id="formSubtitle">Complete los campos para registrar una nueva especie.</p>
                    </div>

                    <form class="space-y-lg" id="speciesForm" method="post">
                        <input type="hidden" name="formType" value="especie">
                        <input type="hidden" id="speciesId" name="idEspecie" value="${especie.idEspecie}">
                        <div class="space-y-sm">
                            <label class="block text-label-md font-label-md text-on-surface" for="speciesName">Nombre</label>
                            <input class="w-full px-md py-2.5 border border-outline-variant rounded-lg text-body-md focus:ring-2 focus:ring-primary focus:border-transparent transition-all outline-none" id="speciesName" name="nombreEspecie" placeholder="Ej. Canino" type="text" value="${especie.nombre}" required>
                        </div>
                        <div class="space-y-sm">
                            <label class="block text-label-md font-label-md text-on-surface" for="speciesDescription">Descripcion</label>
                            <textarea class="w-full px-md py-2.5 border border-outline-variant rounded-lg text-body-md focus:ring-2 focus:ring-primary focus:border-transparent transition-all outline-none resize-none" id="speciesDescription" name="descripcionEspecie" placeholder="Breve descripcion..." rows="4">${especie.descripcion}</textarea>
                        </div>
                        <div class="space-y-sm">
                            <label class="block text-label-md font-label-md text-on-surface" for="speciesStatus">Estado</label>
                            <select class="w-full px-md py-2.5 border border-outline-variant rounded-lg text-body-md focus:ring-2 focus:ring-primary focus:border-transparent transition-all outline-none" id="speciesStatus" name="estadoEspecie">
                                <option value="ACTIVO" ${empty especie.estado || especie.estado eq 'ACTIVO' ? 'selected' : ''}>ACTIVO</option>
                                <option value="INACTIVO" ${especie.estado eq 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
                            </select>
                        </div>
                        <div class="pt-md space-y-sm">
                            <button class="w-full bg-primary text-white py-3 rounded-lg text-label-md font-label-md hover:opacity-90 transition-opacity flex items-center justify-center gap-sm" type="submit">
                                <span class="material-symbols-outlined text-[20px]">save</span>
                                Guardar especie
                            </button>
                            <button class="w-full text-on-surface-variant py-2.5 rounded-lg text-label-md font-label-md hover:bg-surface-container transition-colors" type="button" onclick="resetSpeciesForm()">
                                Cancelar
                            </button>
                        </div>
                    </form>

                    <form class="space-y-lg hidden" id="typeForm" method="post">
                        <input type="hidden" name="formType" value="tipoProducto">
                        <input type="hidden" id="typeId" name="idTipoProducto" value="${tipoProducto.idTipoProducto}">
                        <div class="space-y-sm">
                            <label class="block text-label-md font-label-md text-on-surface" for="typeName">Nombre</label>
                            <input class="w-full px-md py-2.5 border border-outline-variant rounded-lg text-body-md focus:ring-2 focus:ring-primary focus:border-transparent transition-all outline-none" id="typeName" name="nombreTipoProducto" placeholder="Ej. Medicamento" type="text" value="${tipoProducto.nombre}" required>
                        </div>
                        <div class="space-y-sm">
                            <label class="block text-label-md font-label-md text-on-surface" for="typeDescription">Descripcion</label>
                            <textarea class="w-full px-md py-2.5 border border-outline-variant rounded-lg text-body-md focus:ring-2 focus:ring-primary focus:border-transparent transition-all outline-none resize-none" id="typeDescription" name="descripcionTipoProducto" placeholder="Breve descripcion..." rows="4">${tipoProducto.descripcion}</textarea>
                        </div>
                        <div class="space-y-sm">
                            <label class="block text-label-md font-label-md text-on-surface" for="typeStatus">Estado</label>
                            <select class="w-full px-md py-2.5 border border-outline-variant rounded-lg text-body-md focus:ring-2 focus:ring-primary focus:border-transparent transition-all outline-none" id="typeStatus" name="estadoTipoProducto">
                                <option value="ACTIVO" ${empty tipoProducto.estado || tipoProducto.estado eq 'ACTIVO' ? 'selected' : ''}>ACTIVO</option>
                                <option value="INACTIVO" ${tipoProducto.estado eq 'INACTIVO' ? 'selected' : ''}>INACTIVO</option>
                            </select>
                        </div>
                        <div class="pt-md space-y-sm">
                            <button class="w-full bg-primary text-white py-3 rounded-lg text-label-md font-label-md hover:opacity-90 transition-opacity flex items-center justify-center gap-sm" type="submit">
                                <span class="material-symbols-outlined text-[20px]">save</span>
                                Guardar tipo
                            </button>
                            <button class="w-full text-on-surface-variant py-2.5 rounded-lg text-label-md font-label-md hover:bg-surface-container transition-colors" type="button" onclick="resetTypeForm()">
                                Cancelar
                            </button>
                        </div>
                    </form>
                </div>

                <div class="p-lg bg-secondary-container/20 border border-secondary-fixed/30 rounded-xl">
                    <div class="flex items-start gap-md">
                        <span class="material-symbols-outlined text-on-secondary-container">lightbulb</span>
                        <div>
                            <h4 class="text-label-md font-bold text-on-secondary-container">Consejo Maestro</h4>
                            <p class="text-body-md text-on-secondary-container mt-xs leading-relaxed">
                                Mantener estos catalogos limpios ayuda a filtrar mejor mascotas y productos en los modulos operativos.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    let activeTab = '${not empty tipoProducto ? "tipos" : "especies"}';

    function switchTab(tab) {
        activeTab = tab;
        const isSpecies = tab === 'especies';

        document.getElementById('tab-especies').classList.toggle('active-tab', isSpecies);
        document.getElementById('tab-especies').classList.toggle('text-on-surface-variant', !isSpecies);
        document.getElementById('tab-tipos').classList.toggle('active-tab', !isSpecies);
        document.getElementById('tab-tipos').classList.toggle('text-on-surface-variant', isSpecies);

        document.getElementById('content-especies').classList.toggle('hidden', !isSpecies);
        document.getElementById('content-tipos').classList.toggle('hidden', isSpecies);
        document.getElementById('speciesForm').classList.toggle('hidden', !isSpecies);
        document.getElementById('typeForm').classList.toggle('hidden', isSpecies);

        document.getElementById('tableTitle').textContent = isSpecies ? 'Listado de Especies' : 'Listado de Tipos de Producto';
        document.getElementById('tableSubtitle').textContent = isSpecies
            ? 'Consulta y edita las especies disponibles para registrar mascotas.'
            : 'Administra las categorias que se usan al registrar productos.';

        if (isSpecies) {
            if (!document.getElementById('speciesId').value) {
                resetSpeciesForm();
            }
        } else {
            if (!document.getElementById('typeId').value) {
                resetTypeForm();
            }
        }

        filterCatalogRows();
        updateActiveCount();
    }

    function resetSpeciesForm() {
        document.getElementById('speciesForm').reset();
        document.getElementById('speciesId').value = '';
        document.getElementById('formTitle').textContent = 'Agregar Especie';
        document.getElementById('formSubtitle').textContent = 'Complete los campos para registrar una nueva especie.';
        document.getElementById('speciesStatus').value = 'ACTIVO';
    }

    function resetTypeForm() {
        document.getElementById('typeForm').reset();
        document.getElementById('typeId').value = '';
        document.getElementById('formTitle').textContent = 'Agregar Tipo de Producto';
        document.getElementById('formSubtitle').textContent = 'Complete los campos para registrar un nuevo tipo de producto.';
        document.getElementById('typeStatus').value = 'ACTIVO';
    }

    function openSpeciesEdit(button) {
        switchTab('especies');
        document.getElementById('speciesId').value = button.dataset.id || '';
        document.getElementById('speciesName').value = button.dataset.name || '';
        document.getElementById('speciesDescription').value = button.dataset.description || '';
        document.getElementById('speciesStatus').value = button.dataset.status || 'ACTIVO';
        document.getElementById('formTitle').textContent = 'Editar Especie';
        document.getElementById('formSubtitle').textContent = 'Actualiza la informacion de la especie seleccionada.';
    }

    function openTypeEdit(button) {
        switchTab('tipos');
        document.getElementById('typeId').value = button.dataset.id || '';
        document.getElementById('typeName').value = button.dataset.name || '';
        document.getElementById('typeDescription').value = button.dataset.description || '';
        document.getElementById('typeStatus').value = button.dataset.status || 'ACTIVO';
        document.getElementById('formTitle').textContent = 'Editar Tipo de Producto';
        document.getElementById('formSubtitle').textContent = 'Actualiza la informacion del tipo de producto seleccionado.';
    }

    function filterCatalogRows() {
        const query = (document.getElementById('catalogSearch').value || '').trim().toLowerCase();
        const rows = document.querySelectorAll('.catalog-row');
        let visibleCount = 0;

        rows.forEach((row) => {
            const sameTab = row.dataset.tab === activeTab;
            const haystack = ((row.dataset.name || '') + ' ' + (row.dataset.description || '') + ' ' + (row.dataset.status || '')).toLowerCase();
            const visible = sameTab && (!query || haystack.includes(query));
            row.style.display = visible ? '' : 'none';
            if (visible) {
                visibleCount += 1;
            }
        });

        document.getElementById('tableCount').textContent = 'Mostrando ' + visibleCount + ' registro(s).';
    }

    function updateActiveCount() {
        const rows = document.querySelectorAll('.catalog-row');
        let active = 0;
        rows.forEach((row) => {
            if (row.dataset.status === 'ACTIVO') {
                active += 1;
            }
        });
        document.getElementById('activeCount').textContent = String(active);
    }

    document.getElementById('catalogSearch').addEventListener('input', filterCatalogRows);
    switchTab(activeTab);
</script>
</body>
</html>
