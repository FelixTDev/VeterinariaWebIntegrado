package com.veterinaria.controller;

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
        try {
            String action = request.getParameter("action");
            if ("view".equalsIgnoreCase(action)) {
                request.setAttribute("atencion", atencionService.get(WebUtil.getInt(request, "id", 0)));
            }
            if (request.getParameter("idMascota") != null && !request.getParameter("idMascota").isBlank()) {
                request.setAttribute("historial", atencionService.listByMascota(WebUtil.getInt(request, "idMascota", 0)));
            }
            request.setAttribute("citas", citaService.list(null, "ATENDIDA", null));
            request.setAttribute("mascotas", mascotaService.list(null));
            request.setAttribute("veterinarios", authService.listVeterinarios());
            request.setAttribute("productos", productoService.list(null));
            WebUtil.forward(request, response, "atenciones.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            requireRoles(request, "ADMINISTRADOR", "VETERINARIO");
            AtencionClinica atencion = buildAtencion(request);
            atencionService.registrar(atencion, getUserSession(request).getIdUsuario());
            request.getSession().setAttribute("flash", "Atención clínica registrada correctamente.");
            WebUtil.redirect(request, response, "/app/atenciones?idMascota=" + atencion.getIdMascota());
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("atencion", buildAtencion(request));
            request.setAttribute("citas", citaService.list(null, "ATENDIDA", null));
            request.setAttribute("mascotas", mascotaService.list(null));
            request.setAttribute("veterinarios", authService.listVeterinarios());
            request.setAttribute("productos", productoService.list(null));
            WebUtil.forward(request, response, "atenciones.jsp");
        }
    }

    private AtencionClinica buildAtencion(HttpServletRequest request) {
        AtencionClinica atencion = new AtencionClinica();
        atencion.setIdCita(WebUtil.getInt(request, "idCita", 0));
        atencion.setIdMascota(WebUtil.getInt(request, "idMascota", 0));
        atencion.setIdVeterinario(WebUtil.getInt(request, "idVeterinario", 0));
        if (request.getParameter("peso") != null && !request.getParameter("peso").isBlank()) {
            atencion.setPeso(new BigDecimal(request.getParameter("peso")));
        }
        if (request.getParameter("temperatura") != null && !request.getParameter("temperatura").isBlank()) {
            atencion.setTemperatura(new BigDecimal(request.getParameter("temperatura")));
        }
        atencion.setSintomas(request.getParameter("sintomas"));
        atencion.setDiagnostico(request.getParameter("diagnostico"));
        atencion.setTratamiento(request.getParameter("tratamiento"));
        atencion.setObservaciones(request.getParameter("observaciones"));
        atencion.setEstado("REGISTRADA");
        atencion.setDetalles(buildDetalles(request));
        return atencion;
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
        for (int i = 0; i < productos.length; i++) {
            if (productos[i] == null || productos[i].isBlank()) {
                continue;
            }
            DetalleAtencionProducto detalle = new DetalleAtencionProducto();
            detalle.setIdProducto(Integer.parseInt(productos[i]));
            detalle.setCantidad(Integer.parseInt(cantidades[i]));
            detalle.setDosis(dosis[i]);
            detalle.setIndicaciones(indicaciones[i]);
            detalles.add(detalle);
        }
        return detalles;
    }
}
