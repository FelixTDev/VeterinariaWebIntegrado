package com.veterinaria.controller;

import com.veterinaria.exception.AppException;
import com.veterinaria.model.Producto;
import com.veterinaria.service.CatalogoService;
import com.veterinaria.service.ProductoService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/app/productos")
public class ProductoServlet extends BaseServlet {
    private final ProductoService productoService = new ProductoService();
    private final CatalogoService catalogoService = new CatalogoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        prepareRequest(request, response);
        try {
            if ("edit".equalsIgnoreCase(request.getParameter("action"))) {
                request.setAttribute("producto", productoService.get(parseRequiredInt(request, "id", "El producto a editar no es válido.")));
            }
            loadPageData(request);
            WebUtil.forward(request, response, "productos.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        prepareRequest(request, response);
        try {
            requireRoles(request, "ADMINISTRADOR", "RECEPCIONISTA");
            Producto producto = buildProducto(request);
            if (producto.getIdProducto() > 0) {
                productoService.update(producto, getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Producto actualizado correctamente.");
            } else {
                productoService.save(producto, getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Producto registrado correctamente.");
            }
            WebUtil.redirect(request, response, "/app/productos");
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("producto", safeBuildProducto(request));
            loadPageData(request);
            WebUtil.forward(request, response, "productos.jsp");
        }
    }

    private void loadPageData(HttpServletRequest request) {
        request.setAttribute("productos", productoService.list(request.getParameter("search")));
        request.setAttribute("bajoStock", productoService.lowStock());
        request.setAttribute("porVencer", productoService.nearExpiry(30));
        request.setAttribute("tiposProducto", catalogoService.listTiposProductoActivos());
    }

    private Producto buildProducto(HttpServletRequest request) {
        Producto producto = new Producto();
        producto.setIdProducto(parseOptionalInt(request, "idProducto", 0, "El identificador del producto no es válido."));
        producto.setIdTipoProducto(parseRequiredInt(request, "idTipoProducto", "Selecciona un tipo de producto válido."));
        producto.setCodigo(request.getParameter("codigo"));
        producto.setNombre(request.getParameter("nombre"));
        producto.setDescripcion(request.getParameter("descripcion"));
        producto.setStock(parseOptionalInt(request, "stock", 0, "El stock debe ser numérico."));
        producto.setStockMinimo(parseOptionalInt(request, "stockMinimo", 0, "El stock mínimo debe ser numérico."));
        producto.setPrecioCompra(parseRequiredDecimal(request, "precioCompra", "Ingresa un precio de compra válido."));
        producto.setPrecioVenta(parseRequiredDecimal(request, "precioVenta", "Ingresa un precio de venta válido."));
        producto.setFechaVencimiento(parseOptionalDate(request, "fechaVencimiento", "La fecha de vencimiento no es válida."));
        producto.setRequiereReceta("on".equalsIgnoreCase(request.getParameter("requiereReceta")));
        producto.setEstado(request.getParameter("estado"));
        return producto;
    }

    private Producto safeBuildProducto(HttpServletRequest request) {
        try {
            return buildProducto(request);
        } catch (AppException ex) {
            return new Producto();
        }
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

    private BigDecimal parseRequiredDecimal(HttpServletRequest request, String parameter, String message) {
        try {
            return new BigDecimal(request.getParameter(parameter));
        } catch (Exception ex) {
            throw new AppException(message);
        }
    }

    private LocalDate parseOptionalDate(HttpServletRequest request, String parameter, String message) {
        String value = request.getParameter(parameter);
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return LocalDate.parse(value);
        } catch (DateTimeParseException ex) {
            throw new AppException(message);
        }
    }
}
