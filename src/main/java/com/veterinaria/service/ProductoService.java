package com.veterinaria.service;

import com.veterinaria.dao.ProductoDao;
import com.veterinaria.dao.TipoProductoDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.Producto;
import com.veterinaria.util.ValidationUtil;
import java.sql.SQLException;
import java.util.List;

public class ProductoService {
    private final ProductoDao productoDao = new ProductoDao();
    private final TipoProductoDao tipoProductoDao = new TipoProductoDao();
    private final AuditService auditService = new AuditService();

    public List<Producto> list(String search) {
        try {
            return productoDao.list(search);
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar productos.", ex);
        }
    }

    public Producto get(int id) {
        try {
            return productoDao.findById(id).orElseThrow(() -> new AppException("Producto no encontrado."));
        } catch (SQLException ex) {
            throw new AppException("No fue posible obtener el producto.", ex);
        }
    }

    public List<Producto> lowStock() {
        try {
            return productoDao.listLowStock();
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar productos con bajo stock.", ex);
        }
    }

    public List<Producto> nearExpiry(int days) {
        try {
            return productoDao.listNearExpiry(days);
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar productos próximos a vencer.", ex);
        }
    }

    public void save(Producto producto, int actorId) {
        validate(producto);
        try {
            productoDao.save(producto);
            auditService.log(actorId, "PRODUCTO", "CREAR", "Producto registrado: " + producto.getCodigo());
        } catch (SQLException ex) {
            throw new AppException("No fue posible registrar el producto.", ex);
        }
    }

    public void update(Producto producto, int actorId) {
        validate(producto);
        try {
            productoDao.update(producto);
            auditService.log(actorId, "PRODUCTO", "ACTUALIZAR", "Producto actualizado: " + producto.getCodigo());
        } catch (SQLException ex) {
            throw new AppException("No fue posible actualizar el producto.", ex);
        }
    }

    private void validate(Producto producto) {
        ValidationUtil.notBlank(producto.getCodigo(), "El código del producto es obligatorio.");
        ValidationUtil.notBlank(producto.getNombre(), "El nombre del producto es obligatorio.");
        ValidationUtil.require(producto.getIdTipoProducto() > 0, "Selecciona un tipo de producto válido.");
        ValidationUtil.require(producto.getStock() >= 0, "El stock no puede ser negativo.");
        ValidationUtil.require(producto.getStockMinimo() >= 0, "El stock mínimo no puede ser negativo.");
        ValidationUtil.nonNegative(producto.getPrecioCompra(), "El precio de compra no puede ser negativo.");
        ValidationUtil.nonNegative(producto.getPrecioVenta(), "El precio de venta no puede ser negativo.");
        try {
            tipoProductoDao.findById(producto.getIdTipoProducto())
                    .filter(tipo -> "ACTIVO".equalsIgnoreCase(tipo.getEstado()))
                    .orElseThrow(() -> new AppException("El tipo de producto seleccionado no está activo."));
        } catch (SQLException ex) {
            throw new AppException("No fue posible validar el tipo de producto.", ex);
        }
        if (producto.getEstado() == null || producto.getEstado().isBlank()) {
            producto.setEstado("ACTIVO");
        }
    }
}
