package com.veterinaria.service;

import com.veterinaria.dao.ComprobanteDao;
import com.veterinaria.dao.MovimientoInventarioDao;
import com.veterinaria.dao.ProductoDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.Comprobante;
import com.veterinaria.model.DetalleComprobante;
import com.veterinaria.model.MovimientoInventario;
import com.veterinaria.model.Producto;
import com.veterinaria.util.Database;
import com.veterinaria.util.ValidationUtil;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class ComprobanteService {
    private final ComprobanteDao comprobanteDao = new ComprobanteDao();
    private final ProductoDao productoDao = new ProductoDao();
    private final MovimientoInventarioDao movimientoDao = new MovimientoInventarioDao();
    private final AuditService auditService = new AuditService();

    public List<Comprobante> list(String fecha, String estado, String search) {
        try {
            return comprobanteDao.list(fecha, estado, search);
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar comprobantes.", ex);
        }
    }

    public Comprobante get(int idComprobante) {
        try {
            return comprobanteDao.findById(idComprobante).orElseThrow(() -> new AppException("Comprobante no encontrado."));
        } catch (SQLException ex) {
            throw new AppException("No fue posible obtener el comprobante.", ex);
        }
    }

    public void emitir(Comprobante comprobante, int actorId) {
        ValidationUtil.require(comprobante.getIdCliente() > 0, "El comprobante debe tener cliente.");
        ValidationUtil.notEmpty(comprobante.getDetalles(), "El comprobante debe tener al menos un detalle.");
        recalcular(comprobante);
        comprobante.setIdUsuario(actorId);
        if (comprobante.getNumeroComprobante() == null || comprobante.getNumeroComprobante().isBlank()) {
            comprobante.setNumeroComprobante("CMP-" + DateTimeFormatter.ofPattern("yyyyMMddHHmmss").format(LocalDateTime.now()));
        }
        if (comprobante.getEstado() == null || comprobante.getEstado().isBlank()) {
            comprobante.setEstado("EMITIDO");
        }
        try (Connection connection = Database.getConnection()) {
            connection.setAutoCommit(false);
            int idComprobante = comprobanteDao.save(connection, comprobante);
            for (DetalleComprobante detalle : comprobante.getDetalles()) {
                validarDetalle(detalle);
                if ("PRODUCTO".equalsIgnoreCase(detalle.getTipoItem())) {
                    Producto producto = productoDao.findById(connection, detalle.getIdProducto())
                            .orElseThrow(() -> new AppException("Producto no encontrado para comprobante."));
                    if (producto.getStock() < detalle.getCantidad()) {
                        throw new AppException("Stock insuficiente para el producto: " + producto.getNombre());
                    }
                    detalle.setDescripcion(producto.getNombre());
                    detalle.setPrecioUnitario(producto.getPrecioVenta());
                    detalle.setSubtotal(producto.getPrecioVenta().multiply(BigDecimal.valueOf(detalle.getCantidad())));
                    int stockNuevo = producto.getStock() - detalle.getCantidad();
                    productoDao.updateStock(connection, producto.getIdProducto(), stockNuevo);

                    MovimientoInventario movimiento = new MovimientoInventario();
                    movimiento.setIdProducto(producto.getIdProducto());
                    movimiento.setIdUsuario(actorId);
                    movimiento.setTipoMovimiento("SALIDA");
                    movimiento.setMotivo("Venta en comprobante");
                    movimiento.setCantidad(detalle.getCantidad());
                    movimiento.setStockAnterior(producto.getStock());
                    movimiento.setStockNuevo(stockNuevo);
                    movimiento.setReferencia("CMP-" + idComprobante);
                    movimientoDao.save(connection, movimiento);
                } else {
                    ValidationUtil.notBlank(detalle.getDescripcion(), "La descripción del servicio es obligatoria.");
                    ValidationUtil.nonNegative(detalle.getPrecioUnitario(), "El precio del servicio no puede ser negativo.");
                    detalle.setSubtotal(detalle.getPrecioUnitario().multiply(BigDecimal.valueOf(detalle.getCantidad())));
                }
                comprobanteDao.saveDetalle(connection, idComprobante, detalle);
            }
            auditService.log(connection, actorId, "COMPROBANTE", "EMITIR", "Comprobante emitido #" + idComprobante);
            connection.commit();
        } catch (SQLException ex) {
            throw new AppException("No fue posible emitir el comprobante.", ex);
        }
    }

    public void anular(int idComprobante, int actorId) {
        try (Connection connection = Database.getConnection()) {
            connection.setAutoCommit(false);
            Comprobante comprobante = comprobanteDao.findById(idComprobante)
                    .orElseThrow(() -> new AppException("Comprobante no encontrado."));
            if ("ANULADO".equalsIgnoreCase(comprobante.getEstado())) {
                throw new AppException("El comprobante ya está anulado.");
            }
            for (DetalleComprobante detalle : comprobante.getDetalles()) {
                if (!"PRODUCTO".equalsIgnoreCase(detalle.getTipoItem()) || detalle.getIdProducto() == null) {
                    continue;
                }
                Producto producto = productoDao.findById(connection, detalle.getIdProducto())
                        .orElseThrow(() -> new AppException("Producto no encontrado durante la anulación."));
                int stockNuevo = producto.getStock() + detalle.getCantidad();
                productoDao.updateStock(connection, producto.getIdProducto(), stockNuevo);
                MovimientoInventario movimiento = new MovimientoInventario();
                movimiento.setIdProducto(producto.getIdProducto());
                movimiento.setIdUsuario(actorId);
                movimiento.setTipoMovimiento("ANULACION");
                movimiento.setMotivo("Anulación de comprobante");
                movimiento.setCantidad(detalle.getCantidad());
                movimiento.setStockAnterior(producto.getStock());
                movimiento.setStockNuevo(stockNuevo);
                movimiento.setReferencia("CMP-" + idComprobante);
                movimientoDao.save(connection, movimiento);
            }
            comprobanteDao.updateEstado(connection, idComprobante, "ANULADO");
            auditService.log(connection, actorId, "COMPROBANTE", "ANULAR", "Comprobante anulado #" + idComprobante);
            connection.commit();
        } catch (SQLException ex) {
            throw new AppException("No fue posible anular el comprobante.", ex);
        }
    }

    private void recalcular(Comprobante comprobante) {
        BigDecimal subtotal = BigDecimal.ZERO;
        for (DetalleComprobante detalle : comprobante.getDetalles()) {
            ValidationUtil.require(detalle.getCantidad() > 0, "La cantidad de cada detalle debe ser mayor a cero.");
            if (detalle.getPrecioUnitario() != null) {
                detalle.setSubtotal(detalle.getPrecioUnitario().multiply(BigDecimal.valueOf(detalle.getCantidad())));
            }
            if (detalle.getSubtotal() != null) {
                subtotal = subtotal.add(detalle.getSubtotal());
            }
        }
        BigDecimal impuesto = subtotal.multiply(BigDecimal.valueOf(0.18)).setScale(2, RoundingMode.HALF_UP);
        comprobante.setSubtotal(subtotal.setScale(2, RoundingMode.HALF_UP));
        comprobante.setImpuesto(impuesto);
        comprobante.setTotal(comprobante.getSubtotal().add(impuesto).setScale(2, RoundingMode.HALF_UP));
    }

    private void validarDetalle(DetalleComprobante detalle) {
        ValidationUtil.notBlank(detalle.getTipoItem(), "El tipo de detalle es obligatorio.");
        ValidationUtil.require(detalle.getCantidad() > 0, "La cantidad del detalle debe ser mayor a cero.");
        if ("PRODUCTO".equalsIgnoreCase(detalle.getTipoItem())) {
            ValidationUtil.notNull(detalle.getIdProducto(), "El detalle de producto requiere un producto.");
        }
    }
}
