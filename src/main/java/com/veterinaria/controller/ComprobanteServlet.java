package com.veterinaria.controller;

import com.veterinaria.model.Comprobante;
import com.veterinaria.model.DetalleComprobante;
import com.veterinaria.service.ClienteService;
import com.veterinaria.service.ComprobanteService;
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

@WebServlet("/app/comprobantes")
public class ComprobanteServlet extends BaseServlet {
    private final ComprobanteService comprobanteService = new ComprobanteService();
    private final ClienteService clienteService = new ClienteService();
    private final MascotaService mascotaService = new MascotaService();
    private final ProductoService productoService = new ProductoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            if ("view".equalsIgnoreCase(request.getParameter("action"))) {
                request.setAttribute("comprobante", comprobanteService.get(WebUtil.getInt(request, "id", 0)));
            }
            request.setAttribute("comprobantes", comprobanteService.list(request.getParameter("fecha"), request.getParameter("estado"), request.getParameter("search")));
            loadCatalogs(request);
            WebUtil.forward(request, response, "comprobantes.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            requireRoles(request, "ADMINISTRADOR", "RECEPCIONISTA");
            String action = request.getParameter("formAction");
            if ("anular".equalsIgnoreCase(action)) {
                comprobanteService.anular(WebUtil.getInt(request, "idComprobante", 0), getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Comprobante anulado correctamente.");
            } else {
                Comprobante comprobante = buildComprobante(request);
                comprobanteService.emitir(comprobante, getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Comprobante emitido correctamente.");
            }
            WebUtil.redirect(request, response, "/app/comprobantes");
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("comprobante", buildComprobante(request));
            request.setAttribute("comprobantes", comprobanteService.list(request.getParameter("fecha"), request.getParameter("estado"), request.getParameter("search")));
            loadCatalogs(request);
            WebUtil.forward(request, response, "comprobantes.jsp");
        }
    }

    private void loadCatalogs(HttpServletRequest request) {
        request.setAttribute("clientes", clienteService.listActive());
        request.setAttribute("mascotas", mascotaService.list(null));
        request.setAttribute("productos", productoService.list(null));
    }

    private Comprobante buildComprobante(HttpServletRequest request) {
        Comprobante comprobante = new Comprobante();
        comprobante.setIdComprobante(WebUtil.getInt(request, "idComprobante", 0));
        comprobante.setIdCliente(WebUtil.getInt(request, "idCliente", 0));
        int idMascota = WebUtil.getInt(request, "idMascota", 0);
        comprobante.setIdMascota(idMascota > 0 ? idMascota : null);
        comprobante.setTipoComprobante(request.getParameter("tipoComprobante"));
        comprobante.setMetodoPago(request.getParameter("metodoPago"));
        comprobante.setObservaciones(request.getParameter("observaciones"));
        comprobante.setEstado("EMITIDO");
        comprobante.setDetalles(buildDetalles(request));
        return comprobante;
    }

    private List<DetalleComprobante> buildDetalles(HttpServletRequest request) {
        String[] tipos = request.getParameterValues("detalleTipo");
        String[] productos = request.getParameterValues("detalleProductoId");
        String[] descripciones = request.getParameterValues("detalleDescripcion");
        String[] cantidades = request.getParameterValues("detalleCantidad");
        String[] precios = request.getParameterValues("detallePrecio");
        List<DetalleComprobante> detalles = new ArrayList<>();
        if (tipos == null) {
            return detalles;
        }
        for (int i = 0; i < tipos.length; i++) {
            if (tipos[i] == null || tipos[i].isBlank()) {
                continue;
            }
            DetalleComprobante detalle = new DetalleComprobante();
            detalle.setTipoItem(tipos[i]);
            if (productos != null && productos.length > i && productos[i] != null && !productos[i].isBlank()) {
                detalle.setIdProducto(Integer.parseInt(productos[i]));
            }
            detalle.setDescripcion(descripciones != null && descripciones.length > i ? descripciones[i] : null);
            detalle.setCantidad(Integer.parseInt(cantidades[i]));
            if (precios != null && precios.length > i && precios[i] != null && !precios[i].isBlank()) {
                detalle.setPrecioUnitario(new BigDecimal(precios[i]));
            }
            detalles.add(detalle);
        }
        return detalles;
    }
}
