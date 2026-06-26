<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Atenciones"/>
<c:set var="headerSearchPlaceholder" value="Buscar historial por paciente..."/>
<%@ include file="includes/app-shell.jspf" %>

    <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-md -mt-sm">
        <form class="flex items-center gap-md" method="get" id="historyFilterForm">
            <input name="search" type="hidden" value="" id="historySearchMirror">
            <select class="w-full max-w-[360px] rounded-lg border-outline-variant focus:border-primary focus:ring-primary" name="idMascota" id="historyPetFilter" onchange="this.form.submit()">
                <option value="">Selecciona mascota</option>
                <c:forEach var="mascotaItem" items="${mascotas}">
                    <option value="${mascotaItem.idMascota}" ${param.idMascota eq mascotaItem.idMascota.toString() ? 'selected' : ''}>${mascotaItem.nombre} - ${mascotaItem.clienteNombre}</option>
                </c:forEach>
            </select>
        </form>
        <button class="flex items-center gap-sm bg-primary text-on-primary px-md py-2 rounded-lg font-label-md hover:opacity-90 transition-opacity w-auto" type="button" onclick="openAtencionModal()">
            <span class="material-symbols-outlined">add</span>
            Nueva Atencion
        </button>
    </div>

    <section class="flex-1 overflow-hidden flex bg-surface-container-lowest">
        <div class="w-[34%] border-r border-outline-variant flex flex-col bg-surface-container-low">
            <div class="p-lg border-b border-outline-variant flex justify-between items-center bg-surface-bright">
                <div>
                    <h2 class="text-headline-md font-headline-md text-primary">Historial Reciente</h2>
                    <p class="text-label-md text-outline">Atenciones registradas por mascota</p>
                </div>
                <span class="text-label-md text-outline">${empty historial ? 0 : fn:length(historial)} Atenciones</span>
            </div>
            <div class="flex-1 overflow-y-auto custom-scrollbar p-md space-y-md" id="historyCards">
                <c:choose>
                    <c:when test="${not empty historial}">
                        <c:forEach var="item" items="${historial}">
                            <a class="history-card block p-md rounded-xl bg-surface-container-lowest border border-outline-variant hover:shadow-md transition-shadow cursor-pointer ${not empty atencion and atencion.idAtencion eq item.idAtencion ? 'border-l-4 border-l-primary' : ''}"
                               href="${pageContext.request.contextPath}/app/atenciones?action=view&id=${item.idAtencion}&idMascota=${param.idMascota}"
                               data-search="${fn:toLowerCase(item.mascotaNombre)} ${fn:toLowerCase(item.veterinarioNombre)} ${fn:toLowerCase(item.diagnostico)}">
                                <div class="flex justify-between items-start mb-sm">
                                    <span class="px-2 py-0.5 rounded text-[10px] font-bold uppercase ${item.estado eq 'REGISTRADA' ? 'bg-secondary-container text-on-secondary-container' : 'bg-surface-variant text-on-surface-variant'}">${item.estado}</span>
                                    <span class="text-label-md text-outline">${fn:substring(item.fechaAtencion, 0, 16)}</span>
                                </div>
                                <div class="flex gap-md items-center">
                                    <div class="w-12 h-12 rounded-lg bg-primary-fixed text-primary flex items-center justify-center font-bold">
                                        ${fn:toUpperCase(fn:substring(item.mascotaNombre, 0, 1))}
                                    </div>
                                    <div class="min-w-0">
                                        <p class="text-body-lg font-bold text-on-surface truncate">${item.mascotaNombre}</p>
                                        <p class="text-label-md text-outline line-clamp-1">${item.diagnostico}</p>
                                    </div>
                                </div>
                                <div class="mt-md pt-sm border-t border-outline-variant flex items-center justify-between">
                                    <span class="text-label-md font-label-md text-on-surface-variant flex items-center gap-1">
                                        <span class="material-symbols-outlined text-[16px]">medical_services</span>${item.veterinarioNombre}
                                    </span>
                                    <span class="material-symbols-outlined text-primary">chevron_right</span>
                                </div>
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="p-lg rounded-xl border border-dashed border-outline-variant bg-surface-container-lowest text-center text-outline">
                            Selecciona una mascota para ver su historial clínico.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="flex-1 overflow-y-auto custom-scrollbar bg-surface-bright">
            <c:choose>
                <c:when test="${not empty atencion}">
                    <div class="p-lg border-b border-outline-variant flex justify-between items-center sticky top-0 bg-surface-bright/95 backdrop-blur z-10">
                        <div>
                            <h3 class="text-headline-lg font-headline-lg text-primary">Detalle de Atencion #AT-${atencion.idAtencion}</h3>
                            <div class="flex items-center gap-md mt-sm">
                                <span class="flex items-center gap-1 text-label-md font-bold text-secondary">
                                    <span class="material-symbols-outlined text-[18px]">check_circle</span>${atencion.estado}
                                </span>
                                <span class="text-label-md text-outline">|</span>
                                <span class="text-label-md text-outline">Atendido por: ${atencion.veterinarioNombre}</span>
                            </div>
                        </div>
                        <div class="flex gap-sm">
                            <button class="px-md py-2 border border-outline rounded-lg text-on-surface font-label-md flex items-center gap-2 hover:bg-surface-container w-auto" type="button">
                                <span class="material-symbols-outlined text-[20px]">print</span> Imprimir
                            </button>
                        </div>
                    </div>

                    <div class="p-lg grid grid-cols-12 gap-lg">
                        <div class="col-span-12 grid grid-cols-4 gap-md">
                            <div class="p-md rounded-xl glass-panel flex flex-col items-center justify-center text-center">
                                <span class="material-symbols-outlined text-primary mb-2">weight</span>
                                <p class="text-label-md text-outline">Peso</p>
                                <p class="text-headline-md font-bold text-on-surface">${empty atencion.peso ? '-' : atencion.peso} <span class="text-body-md font-normal text-outline">kg</span></p>
                            </div>
                            <div class="p-md rounded-xl glass-panel flex flex-col items-center justify-center text-center">
                                <span class="material-symbols-outlined text-error mb-2">thermostat</span>
                                <p class="text-label-md text-outline">Temp</p>
                                <p class="text-headline-md font-bold text-on-surface">${empty atencion.temperatura ? '-' : atencion.temperatura} <span class="text-body-md font-normal text-outline">C</span></p>
                            </div>
                            <div class="p-md rounded-xl glass-panel flex flex-col items-center justify-center text-center">
                                <span class="material-symbols-outlined text-secondary mb-2">event</span>
                                <p class="text-label-md text-outline">Fecha</p>
                                <p class="text-headline-md font-bold text-on-surface text-sm">${fn:substring(atencion.fechaAtencion, 0, 10)}</p>
                            </div>
                            <div class="p-md rounded-xl glass-panel flex flex-col items-center justify-center text-center">
                                <span class="material-symbols-outlined text-tertiary mb-2">pets</span>
                                <p class="text-label-md text-outline">Paciente</p>
                                <p class="text-headline-md font-bold text-on-surface text-sm">${atencion.mascotaNombre}</p>
                            </div>
                        </div>

                        <div class="col-span-12 lg:col-span-8 space-y-lg">
                            <div class="p-lg rounded-xl bg-surface-container-lowest border border-outline-variant">
                                <div class="flex items-center gap-2 mb-md text-primary">
                                    <span class="material-symbols-outlined">psychology</span>
                                    <h4 class="font-bold text-body-lg">Sintomas y Motivo de Consulta</h4>
                                </div>
                                <div class="w-full bg-surface rounded-lg p-md text-body-md min-h-24">${empty atencion.sintomas ? 'Sin sintomas registrados.' : atencion.sintomas}</div>
                            </div>

                            <div class="p-lg rounded-xl bg-surface-container-lowest border border-outline-variant">
                                <div class="flex items-center gap-2 mb-md text-primary">
                                    <span class="material-symbols-outlined">medical_information</span>
                                    <h4 class="font-bold text-body-lg">Diagnostico</h4>
                                </div>
                                <div class="w-full bg-surface rounded-lg p-md text-body-md font-bold mb-md">${atencion.diagnostico}</div>
                                <div class="w-full bg-surface rounded-lg p-md text-body-md min-h-20">${empty atencion.observaciones ? 'Sin observaciones adicionales.' : atencion.observaciones}</div>
                            </div>

                            <div class="p-lg rounded-xl bg-surface-container-lowest border border-outline-variant">
                                <div class="flex items-center gap-2 mb-md text-primary">
                                    <span class="material-symbols-outlined">prescriptions</span>
                                    <h4 class="font-bold text-body-lg">Tratamiento Planificado</h4>
                                </div>
                                <div class="w-full bg-surface rounded-lg p-md text-body-md min-h-32 whitespace-pre-line">${empty atencion.tratamiento ? 'Sin tratamiento registrado.' : atencion.tratamiento}</div>
                            </div>
                        </div>

                        <div class="col-span-12 lg:col-span-4 space-y-lg">
                            <div class="p-lg rounded-xl bg-surface-container-lowest border border-outline-variant h-full">
                                <div class="flex items-center justify-between mb-md text-primary">
                                    <div class="flex items-center gap-2">
                                        <span class="material-symbols-outlined">inventory_2</span>
                                        <h4 class="font-bold text-body-lg">Insumos Usados</h4>
                                    </div>
                                    <span class="text-label-md text-outline">${fn:length(atencion.detalles)} item(s)</span>
                                </div>
                                <div class="overflow-hidden">
                                    <table class="w-full text-left text-body-md">
                                        <thead class="bg-surface-container-low text-on-surface-variant">
                                            <tr>
                                                <th class="py-2 px-3 font-label-md rounded-l-lg">Producto</th>
                                                <th class="py-2 px-3 font-label-md">Cant.</th>
                                                <th class="py-2 px-3 font-label-md rounded-r-lg">Dosis</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-outline-variant">
                                            <c:choose>
                                                <c:when test="${not empty atencion.detalles}">
                                                    <c:forEach var="detalle" items="${atencion.detalles}">
                                                        <tr>
                                                            <td class="py-3 px-3">
                                                                <p class="font-bold">${detalle.productoNombre}</p>
                                                                <p class="text-[10px] text-outline">${empty detalle.indicaciones ? 'Sin indicaciones' : detalle.indicaciones}</p>
                                                            </td>
                                                            <td class="py-3 px-3">${detalle.cantidad}</td>
                                                            <td class="py-3 px-3 text-outline">${empty detalle.dosis ? '-' : detalle.dosis}</td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td class="py-4 px-3 text-outline" colspan="3">No se registraron productos usados.</td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="h-full flex items-center justify-center p-lg">
                        <div class="max-w-lg text-center bg-surface-container-lowest border border-outline-variant rounded-2xl p-xl shadow-sm">
                            <div class="w-16 h-16 rounded-full bg-primary-fixed text-primary mx-auto mb-md flex items-center justify-center">
                                <span class="material-symbols-outlined text-[32px]">history_edu</span>
                            </div>
                            <h3 class="text-headline-md font-headline-md text-primary mb-sm">Historial Clinico</h3>
                            <p class="text-body-md text-outline">Selecciona una mascota con historial o registra una nueva atención clínica para comenzar.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
<div class="fixed inset-0 z-[60] hidden" id="atencionModal">
    <div class="absolute inset-0 bg-inverse-surface/40 backdrop-blur-sm" onclick="closeAtencionModal()"></div>
    <div class="absolute right-0 top-0 h-full w-full max-w-3xl bg-surface shadow-2xl flex flex-col transform transition-transform duration-300 translate-x-full" id="atencionPanel">
        <div class="p-lg border-b border-outline-variant flex justify-between items-center bg-surface-container-low">
            <div class="flex items-center gap-md">
                <span class="material-symbols-outlined text-primary text-headline-md">medical_services</span>
                <h3 class="text-headline-md font-bold text-primary">Nueva Atencion Clinica</h3>
            </div>
            <button class="p-2 hover:bg-error-container hover:text-error rounded-full transition-colors" type="button" onclick="closeAtencionModal()">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <form class="flex-grow overflow-y-auto custom-scrollbar p-xl space-y-lg" id="atencionForm" method="post">
            <div class="grid grid-cols-3 gap-lg">
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="idCita">Cita por atender</label>
                    <select class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="idCita" name="idCita" onchange="syncPetFromCita()" required>
                        <option value="">Seleccione cita</option>
                        <c:forEach var="citaItem" items="${citas}">
                            <option value="${citaItem.idCita}" data-mascota-id="${citaItem.idMascota}" ${atencion.idCita eq citaItem.idCita ? 'selected' : ''}>#${citaItem.idCita} - ${citaItem.mascotaNombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="idMascotaForm">Mascota</label>
                    <select class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="idMascotaForm" name="idMascota" required>
                        <option value="">Mascota</option>
                        <c:forEach var="mascotaItem" items="${mascotas}">
                            <option value="${mascotaItem.idMascota}" ${atencion.idMascota eq mascotaItem.idMascota ? 'selected' : ''}>${mascotaItem.nombre} - ${mascotaItem.clienteNombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="idVeterinario">Veterinario</label>
                    <select class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="idVeterinario" name="idVeterinario" required>
                        <option value="">Veterinario</option>
                        <c:forEach var="vet" items="${veterinarios}">
                            <option value="${vet.idUsuario}" ${atencion.idVeterinario eq vet.idUsuario ? 'selected' : ''}>${vet.nombreCompleto}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-lg">
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="peso">Peso (kg)</label>
                    <input class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="peso" name="peso" placeholder="Ej. 4.20" step="0.01" type="number" value="${atencion.peso}">
                </div>
                <div class="space-y-xs">
                    <label class="text-label-md text-on-surface-variant font-bold" for="temperatura">Temperatura (C)</label>
                    <input class="w-full rounded-lg border-outline-variant focus:border-primary focus:ring-primary" id="temperatura" name="temperatura" placeholder="Ej. 38.5" step="0.1" type="number" value="${atencion.temperatura}">
                </div>
            </div>

            <div class="space-y-xs">
                <label class="text-label-md text-on-surface-variant font-bold" for="sintomas">Sintomas</label>
                <textarea class="w-full rounded-xl border-outline-variant focus:border-primary focus:ring-primary resize-none" id="sintomas" name="sintomas" placeholder="Describe los sintomas observados..." rows="4">${atencion.sintomas}</textarea>
            </div>
            <div class="space-y-xs">
                <label class="text-label-md text-on-surface-variant font-bold" for="diagnostico">Diagnostico</label>
                <textarea class="w-full rounded-xl border-outline-variant focus:border-primary focus:ring-primary resize-none" id="diagnostico" name="diagnostico" placeholder="Diagnostico principal..." rows="3" required>${atencion.diagnostico}</textarea>
            </div>
            <div class="space-y-xs">
                <label class="text-label-md text-on-surface-variant font-bold" for="tratamiento">Tratamiento</label>
                <textarea class="w-full rounded-xl border-outline-variant focus:border-primary focus:ring-primary resize-none" id="tratamiento" name="tratamiento" placeholder="Tratamiento y recomendaciones..." rows="4">${atencion.tratamiento}</textarea>
            </div>
            <div class="space-y-xs">
                <label class="text-label-md text-on-surface-variant font-bold" for="observacionesForm">Observaciones</label>
                <textarea class="w-full rounded-xl border-outline-variant focus:border-primary focus:ring-primary resize-none" id="observacionesForm" name="observaciones" placeholder="Notas adicionales..." rows="3">${atencion.observaciones}</textarea>
            </div>

            <div class="rounded-xl border border-outline-variant bg-surface-container-lowest p-lg space-y-md">
                <div class="flex items-center justify-between">
                    <div>
                        <h4 class="text-body-lg font-bold text-primary">Productos Aplicados</h4>
                        <p class="text-label-md text-outline">Puedes agregar uno o varios insumos usados durante la atención.</p>
                    </div>
                    <button class="flex items-center gap-xs text-secondary font-label-md hover:underline w-auto" type="button" onclick="addProductRow()">
                        <span class="material-symbols-outlined text-[18px]">add</span> Agregar producto
                    </button>
                </div>
                <div class="space-y-md" id="productRows">
                    <div class="grid grid-cols-12 gap-md product-row">
                        <div class="col-span-5">
                            <select class="rounded-lg border-outline-variant focus:border-primary focus:ring-primary" name="detalleProductoId">
                                <option value="">Producto</option>
                                <c:forEach var="productoItem" items="${productos}">
                                    <option value="${productoItem.idProducto}">${productoItem.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-span-2">
                            <input class="rounded-lg border-outline-variant focus:border-primary focus:ring-primary" min="1" name="detalleCantidad" type="number" value="1">
                        </div>
                        <div class="col-span-2">
                            <input class="rounded-lg border-outline-variant focus:border-primary focus:ring-primary" name="detalleDosis" placeholder="Dosis" type="text">
                        </div>
                        <div class="col-span-3 flex gap-sm">
                            <input class="rounded-lg border-outline-variant focus:border-primary focus:ring-primary" name="detalleIndicaciones" placeholder="Indicaciones" type="text">
                            <button class="w-10 h-10 shrink-0 rounded-lg border border-outline-variant text-outline hover:text-error hover:border-error transition-colors" type="button" onclick="removeProductRow(this)">
                                <span class="material-symbols-outlined text-[18px]">delete</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <div class="p-lg border-t border-outline-variant flex gap-md bg-surface-container-low">
            <button class="flex-grow py-sm border border-outline-variant text-on-surface-variant font-bold rounded-lg hover:bg-white transition-colors" type="button" onclick="closeAtencionModal()">Cancelar</button>
            <button class="flex-grow-[2] py-sm bg-primary text-on-primary font-bold rounded-lg hover:opacity-90 transition-all shadow-md" form="atencionForm" type="submit">Registrar atencion</button>
        </div>
    </div>
</div>

<script>
    function openAtencionModal() {
        document.getElementById('atencionModal').classList.remove('hidden');
        setTimeout(() => document.getElementById('atencionPanel').classList.remove('translate-x-full'), 10);
    }

    function closeAtencionModal() {
        document.getElementById('atencionPanel').classList.add('translate-x-full');
        setTimeout(() => document.getElementById('atencionModal').classList.add('hidden'), 300);
    }

    function filterHistoryCards() {
        const query = (document.getElementById('headerGlobalSearch').value || '').trim().toLowerCase();
        document.querySelectorAll('.history-card').forEach((card) => {
            const visible = !query || (card.dataset.search || '').includes(query);
            card.style.display = visible ? '' : 'none';
        });
    }

    function syncPetFromCita() {
        const citaSelect = document.getElementById('idCita');
        const selected = citaSelect.options[citaSelect.selectedIndex];
        const mascotaId = selected ? selected.dataset.mascotaId : '';
        if (mascotaId) {
            document.getElementById('idMascotaForm').value = mascotaId;
        }
    }

    function addProductRow() {
        const container = document.getElementById('productRows');
        const firstRow = container.querySelector('.product-row');
        const clone = firstRow.cloneNode(true);
        clone.querySelectorAll('select, input').forEach((field) => {
            if (field.tagName === 'SELECT') {
                field.selectedIndex = 0;
            } else if (field.name === 'detalleCantidad') {
                field.value = '1';
            } else {
                field.value = '';
            }
        });
        container.appendChild(clone);
    }

    function removeProductRow(button) {
        const rows = document.querySelectorAll('.product-row');
        if (rows.length === 1) {
            rows[0].querySelectorAll('select, input').forEach((field) => {
                if (field.tagName === 'SELECT') {
                    field.selectedIndex = 0;
                } else if (field.name === 'detalleCantidad') {
                    field.value = '1';
                } else {
                    field.value = '';
                }
            });
            return;
        }
        button.closest('.product-row').remove();
    }

    const headerGlobalSearch = document.getElementById('headerGlobalSearch');
    if (headerGlobalSearch) {
        headerGlobalSearch.addEventListener('input', filterHistoryCards);
    }
    document.getElementById('idCita').addEventListener('change', syncPetFromCita);
    document.getElementById('atencionForm').addEventListener('submit', syncPetFromCita);
    syncPetFromCita();

    <c:if test="${not empty error}">
        openAtencionModal();
    </c:if>
</script>
<%@ include file="includes/app-shell-end.jspf" %>
