package com.veterinaria.controller;

import com.veterinaria.exception.AppException;
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
        prepareRequest(request, response);
        try {
            if ("view".equalsIgnoreCase(request.getParameter("action"))) {
                request.setAttribute("comprobante", comprobanteService.get(parseRequiredInt(request, "id", "El comprobante solicitado no es válido.")));
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
        prepareRequest(request, response);
        try {
            requireRoles(request, "ADMINISTRADOR", "RECEPCIONISTA");
            String action = request.getParameter("formAction");
            if ("anular".equalsIgnoreCase(action)) {
                comprobanteService.anular(parseRequiredInt(request, "idComprobante", "El comprobante a anular no es válido."), getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Comprobante anulado correctamente.");
            } else {
                Comprobante comprobante = buildComprobante(request);
                comprobanteService.emitir(comprobante, getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Comprobante emitido correctamente.");
            }
            WebUtil.redirect(request, response, "/app/comprobantes");
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("comprobante", safeBuildComprobante(request));
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
        comprobante.setIdComprobante(parseOptionalInt(request, "idComprobante", 0, "El identificador del comprobante no es válido."));
        comprobante.setIdCliente(parseRequiredInt(request, "idCliente", "Selecciona un cliente válido."));
        int idMascota = parseOptionalInt(request, "idMascota", 0, "Selecciona una mascota válida.");
        comprobante.setIdMascota(idMascota > 0 ? idMascota : null);
        int idAtencion = parseOptionalInt(request, "idAtencion", 0, "La atención asociada no es válida.");
        comprobante.setIdAtencion(idAtencion > 0 ? idAtencion : null);
        comprobante.setTipoComprobante(request.getParameter("tipoComprobante"));
        comprobante.setMetodoPago(request.getParameter("metodoPago"));
        comprobante.setObservaciones(request.getParameter("observaciones"));
        comprobante.setEstado("EMITIDO");
        comprobante.setDetalles(buildDetalles(request));
        return comprobante;
    }

    private Comprobante safeBuildComprobante(HttpServletRequest request) {
        try {
            return buildComprobante(request);
        } catch (AppException ex) {
            return new Comprobante();
        }
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
        if (!sameLength(tipos.length, cantidades) || productos == null || descripciones == null || precios == null
                || productos.length != tipos.length || descripciones.length != tipos.length || precios.length != tipos.length) {
            throw new AppException("Los detalles del comprobante llegaron incompletos. Vuelve a intentarlo.");
        }
        for (int i = 0; i < tipos.length; i++) {
            boolean emptyRow = isBlank(tipos[i]) && isBlank(productos[i]) && isBlank(descripciones[i]) && isBlank(cantidades[i]) && isBlank(precios[i]);
            if (emptyRow) {
                continue;
            }
            if (isBlank(tipos[i]) || isBlank(cantidades[i])) {
                throw new AppException("Cada detalle del comprobante debe indicar tipo y cantidad.");
            }
            DetalleComprobante detalle = new DetalleComprobante();
            detalle.setTipoItem(tipos[i]);
            if (!isBlank(productos[i])) {
                detalle.setIdProducto(parseInt(productos[i], "Uno de los productos seleccionados no es válido."));
            }
            detalle.setDescripcion(descripciones[i]);
            detalle.setCantidad(parseInt(cantidades[i], "La cantidad de uno de los detalles no es válida."));
            if (!isBlank(precios[i])) {
                detalle.setPrecioUnitario(parseDecimal(precios[i], "El precio de uno de los detalles no es válido."));
            }
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

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private int parseRequiredInt(HttpServletRequest request, String parameter, String message) {
        return parseInt(request.getParameter(parameter), message);
    }

    private int parseOptionalInt(HttpServletRequest request, String parameter, int defaultValue, String message) {
        String value = request.getParameter(parameter);
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        return parseInt(value, message);
    }

    private int parseInt(String value, String message) {
        try {
            return Integer.parseInt(value);
        } catch (Exception ex) {
            throw new AppException(message);
        }
    }

    private BigDecimal parseDecimal(String value, String message) {
        try {
            return new BigDecimal(value);
        } catch (Exception ex) {
            throw new AppException(message);
        }
    }
}
