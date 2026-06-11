package com.veterinaria.controller;

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

@WebServlet("/app/productos")
public class ProductoServlet extends BaseServlet {
    private final ProductoService productoService = new ProductoService();
    private final CatalogoService catalogoService = new CatalogoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            if ("edit".equalsIgnoreCase(request.getParameter("action"))) {
                request.setAttribute("producto", productoService.get(WebUtil.getInt(request, "id", 0)));
            }
            request.setAttribute("productos", productoService.list(request.getParameter("search")));
            request.setAttribute("bajoStock", productoService.lowStock());
            request.setAttribute("porVencer", productoService.nearExpiry(30));
            request.setAttribute("tiposProducto", catalogoService.listTiposProductoActivos());
            WebUtil.forward(request, response, "productos.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            request.setAttribute("producto", buildProducto(request));
            request.setAttribute("productos", productoService.list(request.getParameter("search")));
            request.setAttribute("bajoStock", productoService.lowStock());
            request.setAttribute("porVencer", productoService.nearExpiry(30));
            request.setAttribute("tiposProducto", catalogoService.listTiposProductoActivos());
            WebUtil.forward(request, response, "productos.jsp");
        }
    }

    private Producto buildProducto(HttpServletRequest request) {
        Producto producto = new Producto();
        producto.setIdProducto(WebUtil.getInt(request, "idProducto", 0));
        producto.setIdTipoProducto(WebUtil.getInt(request, "idTipoProducto", 0));
        producto.setCodigo(request.getParameter("codigo"));
        producto.setNombre(request.getParameter("nombre"));
        producto.setDescripcion(request.getParameter("descripcion"));
        producto.setStock(WebUtil.getInt(request, "stock", 0));
        producto.setStockMinimo(WebUtil.getInt(request, "stockMinimo", 0));
        producto.setPrecioCompra(new BigDecimal(request.getParameter("precioCompra")));
        producto.setPrecioVenta(new BigDecimal(request.getParameter("precioVenta")));
        if (request.getParameter("fechaVencimiento") != null && !request.getParameter("fechaVencimiento").isBlank()) {
            producto.setFechaVencimiento(LocalDate.parse(request.getParameter("fechaVencimiento")));
        }
        producto.setRequiereReceta("on".equalsIgnoreCase(request.getParameter("requiereReceta")));
        producto.setEstado(request.getParameter("estado"));
        return producto;
    }
}
