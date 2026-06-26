package com.veterinaria.controller;

import com.veterinaria.exception.AppException;
import com.veterinaria.model.AtencionClinica;
import com.veterinaria.model.DetalleAtencionProducto;
import com.veterinaria.service.AtencionService;
import com.veterinaria.service.AuthService;
import com.veterinaria.service.CitaService;
import com.veterinaria.service.MascotaService;
import com.veterinaria.service.ProductoService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/app/atenciones")
public class AtencionServlet extends BaseServlet {
    private final AtencionService atencionService = new AtencionService();
    private final CitaService citaService = new CitaService();
    private final MascotaService mascotaService = new MascotaService();
    private final AuthService authService = new AuthService();
    private final ProductoService productoService = new ProductoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        prepareRequest(request, response);
        try {
            String action = request.getParameter("action");
            if ("view".equalsIgnoreCase(action)) {
                request.setAttribute("atencion", atencionService.get(parseRequiredInt(request, "id", "La atención solicitada no es válida.")));
            }
            if (request.getParameter("idMascota") != null && !request.getParameter("idMascota").isBlank()) {
                int idMascota = parseRequiredInt(request, "idMascota", "La mascota consultada no es válida.");
                var historial = atencionService.listByMascota(idMascota);
                request.setAttribute("historial", historial);
                if (request.getAttribute("atencion") == null && !historial.isEmpty()) {
                    request.setAttribute("atencion", atencionService.get(historial.get(0).getIdAtencion()));
                }
            }
            loadCatalogs(request);
            WebUtil.forward(request, response, "atenciones.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        prepareRequest(request, response);
        try {
            requireRoles(request, "ADMINISTRADOR", "VETERINARIO");
            AtencionClinica atencion = buildAtencion(request);
            atencionService.registrar(atencion, getUserSession(request).getIdUsuario());
            request.getSession().setAttribute("flash", "Atención clínica registrada correctamente.");
            WebUtil.redirect(request, response, "/app/atenciones?idMascota=" + atencion.getIdMascota());
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("atencion", safeBuildAtencion(request));
            loadCatalogs(request);
            WebUtil.forward(request, response, "atenciones.jsp");
        }
    }

    private void loadCatalogs(HttpServletRequest request) {
        request.setAttribute("citas", citaService.listDisponiblesParaAtencion());
        request.setAttribute("mascotas", mascotaService.list(null));
        request.setAttribute("veterinarios", authService.listVeterinarios());
        request.setAttribute("productos", productoService.list(null));
    }

    private AtencionClinica buildAtencion(HttpServletRequest request) {
        AtencionClinica atencion = new AtencionClinica();
        atencion.setIdCita(parseRequiredInt(request, "idCita", "Selecciona una cita válida."));
        atencion.setIdMascota(parseRequiredInt(request, "idMascota", "Selecciona una mascota válida."));
        atencion.setIdVeterinario(parseRequiredInt(request, "idVeterinario", "Selecciona un veterinario válido."));
        atencion.setPeso(parseOptionalDecimal(request, "peso", "El peso ingresado no es válido."));
        atencion.setTemperatura(parseOptionalDecimal(request, "temperatura", "La temperatura ingresada no es válida."));
        atencion.setSintomas(request.getParameter("sintomas"));
        atencion.setDiagnostico(request.getParameter("diagnostico"));
        atencion.setTratamiento(request.getParameter("tratamiento"));
        atencion.setObservaciones(request.getParameter("observaciones"));
        atencion.setEstado("REGISTRADA");
        atencion.setDetalles(buildDetalles(request));
        return atencion;
    }

    private AtencionClinica safeBuildAtencion(HttpServletRequest request) {
        try {
            return buildAtencion(request);
        } catch (AppException ex) {
            return new AtencionClinica();
        }
    }

    private List<DetalleAtencionProducto> buildDetalles(HttpServletRequest request) {
        String[] productos = request.getParameterValues("detalleProductoId");
        String[] cantidades = request.getParameterValues("detalleCantidad");
        String[] dosis = request.getParameterValues("detalleDosis");
        String[] indicaciones = request.getParameterValues("detalleIndicaciones");
        List<DetalleAtencionProducto> detalles = new ArrayList<>();
        if (productos == null) {
            return detalles;
        }
        int total = productos.length;
        if (!sameLength(total, cantidades, dosis, indicaciones)) {
            throw new AppException("Los productos de la atención llegaron incompletos. Vuelve a intentarlo.");
        }
        for (int i = 0; i < total; i++) {
            boolean emptyRow = isBlank(productos[i]) && isBlank(valueAt(dosis, i)) && isBlank(valueAt(indicaciones, i)) && isBlank(valueAt(cantidades, i));
            if (emptyRow) {
                continue;
            }
            if (isBlank(productos[i]) || isBlank(cantidades[i])) {
                throw new AppException("Cada detalle de atención debe tener producto y cantidad.");
            }
            DetalleAtencionProducto detalle = new DetalleAtencionProducto();
            detalle.setIdProducto(parseInt(productos[i], "Uno de los productos seleccionados no es válido."));
            detalle.setCantidad(parseInt(cantidades[i], "La cantidad de uno de los productos no es válida."));
            detalle.setDosis(valueAt(dosis, i));
            detalle.setIndicaciones(valueAt(indicaciones, i));
            detalles.add(detalle);
        }
        return detalles;
    }

    private boolean sameLength(int expected, String[]... arrays) {
        for (String[] array : arrays) {
            if (array == null || array.length != expected) {
                return false;
            }
        }
        return true;
    }

    private String valueAt(String[] values, int index) {
        return values != null && values.length > index ? values[index] : null;
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private int parseRequiredInt(HttpServletRequest request, String parameter, String message) {
        return parseInt(request.getParameter(parameter), message);
    }

    private int parseInt(String value, String message) {
        try {
            return Integer.parseInt(value);
        } catch (Exception ex) {
            throw new AppException(message);
        }
    }

    private BigDecimal parseOptionalDecimal(HttpServletRequest request, String parameter, String message) {
        String value = request.getParameter(parameter);
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return new BigDecimal(value);
        } catch (NumberFormatException ex) {
            throw new AppException(message);
        }
    }
}
