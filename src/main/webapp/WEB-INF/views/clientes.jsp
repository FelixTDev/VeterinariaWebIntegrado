<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Clientes"/>
<c:set var="headerSearchPlaceholder" value="Buscar clientes, DNI o telefono..."/>
<%@ include file="includes/app-shell.jspf" %>

        <form method="get" class="hidden" id="clientHeaderSearchForm">
            <input name="search" type="hidden" value="${param.search}" id="clientHeaderSearchMirror">
        </form>

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
    const headerGlobalSearch = document.getElementById("headerGlobalSearch");

    if (headerGlobalSearch) {
        headerGlobalSearch.value = '${fn:escapeXml(param.search)}';
        headerGlobalSearch.addEventListener("change", function() {
            document.getElementById("clientHeaderSearchMirror").value = this.value;
            document.getElementById("clientHeaderSearchForm").submit();
        });
    }

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
<%@ include file="includes/app-shell-end.jspf" %>
