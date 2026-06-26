package com.veterinaria.service;

import com.veterinaria.dao.AtencionDao;
import com.veterinaria.dao.ClienteDao;
import com.veterinaria.dao.ComprobanteDao;
import com.veterinaria.dao.MascotaDao;
import com.veterinaria.dao.MovimientoInventarioDao;
import com.veterinaria.dao.ProductoDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.AtencionClinica;
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
    private final ComprobanteDao comprobanteDao;
    private final ProductoDao productoDao;
    private final MovimientoInventarioDao movimientoDao;
    private final ClienteDao clienteDao;
    private final MascotaDao mascotaDao;
    private final AtencionDao atencionDao;
    private final AuditService auditService;

    public ComprobanteService() {
        this(new ComprobanteDao(), new ProductoDao(), new MovimientoInventarioDao(),
                new ClienteDao(), new MascotaDao(), new AtencionDao(), new AuditService());
    }

    ComprobanteService(ComprobanteDao comprobanteDao, ProductoDao productoDao, MovimientoInventarioDao movimientoDao,
            ClienteDao clienteDao, MascotaDao mascotaDao, AtencionDao atencionDao, AuditService auditService) {
        this.comprobanteDao = comprobanteDao;
        this.productoDao = productoDao;
        this.movimientoDao = movimientoDao;
        this.clienteDao = clienteDao;
        this.mascotaDao = mascotaDao;
        this.atencionDao = atencionDao;
        this.auditService = auditService;
    }

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
        comprobante.setIdUsuario(actorId);
        if (comprobante.getNumeroComprobante() == null || comprobante.getNumeroComprobante().isBlank()) {
            comprobante.setNumeroComprobante("CMP-" + DateTimeFormatter.ofPattern("yyyyMMddHHmmss").format(LocalDateTime.now()));
        }
        if (comprobante.getEstado() == null || comprobante.getEstado().isBlank()) {
            comprobante.setEstado("EMITIDO");
        }

        Connection connection = null;
        try {
            validarCabecera(comprobante);
            connection = Database.getConnection();
            connection.setAutoCommit(false);
            recalcular(comprobante, connection);
            ValidationUtil.require(
                    comprobante.getTotal() != null && comprobante.getTotal().compareTo(BigDecimal.ZERO) > 0,
                    "El comprobante debe tener un total mayor a cero."
            );

            int idComprobante = comprobanteDao.save(connection, comprobante);
            for (DetalleComprobante detalle : comprobante.getDetalles()) {
                if ("PRODUCTO".equalsIgnoreCase(detalle.getTipoItem())) {
                    Producto producto = productoDao.findById(connection, detalle.getIdProducto())
                            .orElseThrow(() -> new AppException("Producto no encontrado para comprobante."));
                    if (producto.getStock() < detalle.getCantidad()) {
                        throw new AppException("Stock insuficiente para el producto: " + producto.getNombre());
                    }
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
                }
                comprobanteDao.saveDetalle(connection, idComprobante, detalle);
            }
            auditService.log(connection, actorId, "COMPROBANTE", "EMITIR", "Comprobante emitido #" + idComprobante);
            connection.commit();
        } catch (Exception ex) {
            rollbackQuietly(connection);
            if (ex instanceof AppException appException) {
                throw appException;
            }
            throw new AppException("No fue posible emitir el comprobante.", ex);
        } finally {
            closeQuietly(connection);
        }
    }

    public void anular(int idComprobante, int actorId) {
        Connection connection = null;
        try {
            connection = Database.getConnection();
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
        } catch (Exception ex) {
            rollbackQuietly(connection);
            if (ex instanceof AppException appException) {
                throw appException;
            }
            throw new AppException("No fue posible anular el comprobante.", ex);
        } finally {
            closeQuietly(connection);
        }
    }

    void validarCabecera(Comprobante comprobante) {
        try {
            clienteDao.findById(comprobante.getIdCliente())
                    .orElseThrow(() -> new AppException("Cliente no encontrado para el comprobante."));
            if (comprobante.getIdMascota() != null) {
                mascotaDao.findById(comprobante.getIdMascota())
                        .orElseThrow(() -> new AppException("Mascota no encontrada para el comprobante."));
                ValidationUtil.require(
                        mascotaDao.belongsToCliente(comprobante.getIdMascota(), comprobante.getIdCliente()),
                        "La mascota seleccionada no pertenece al cliente del comprobante."
                );
            }
            if (comprobante.getIdAtencion() != null) {
                AtencionClinica atencion = atencionDao.findById(comprobante.getIdAtencion())
                        .orElseThrow(() -> new AppException("La atención asociada no existe."));
                ValidationUtil.require(
                        comprobante.getIdMascota() != null && atencion.getIdMascota() == comprobante.getIdMascota(),
                        "La mascota del comprobante no coincide con la atención asociada."
                );
            }
        } catch (SQLException ex) {
            throw new AppException("No fue posible validar el comprobante.", ex);
        }
    }

    void recalcular(Comprobante comprobante, Connection connection) throws SQLException {
        BigDecimal subtotal = BigDecimal.ZERO;
        for (DetalleComprobante detalle : comprobante.getDetalles()) {
            validarDetalle(detalle);
            if ("PRODUCTO".equalsIgnoreCase(detalle.getTipoItem())) {
                Producto producto = productoDao.findById(connection, detalle.getIdProducto())
                        .orElseThrow(() -> new AppException("Producto no encontrado para comprobante."));
                detalle.setDescripcion(producto.getNombre());
                detalle.setPrecioUnitario(producto.getPrecioVenta());
            } else {
                ValidationUtil.notBlank(detalle.getDescripcion(), "La descripción del servicio es obligatoria.");
                ValidationUtil.nonNegative(detalle.getPrecioUnitario(), "El precio del servicio no puede ser negativo.");
            }
            detalle.setSubtotal(detalle.getPrecioUnitario().multiply(BigDecimal.valueOf(detalle.getCantidad())));
            subtotal = subtotal.add(detalle.getSubtotal());
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
            return;
        }
        ValidationUtil.require("SERVICIO".equalsIgnoreCase(detalle.getTipoItem()), "El tipo de detalle no es válido.");
    }

    private void rollbackQuietly(Connection connection) {
        if (connection == null) {
            return;
        }
        try {
            connection.rollback();
        } catch (SQLException ignored) {
        }
    }

    private void closeQuietly(Connection connection) {
        if (connection == null) {
            return;
        }
        try {
            connection.close();
        } catch (SQLException ignored) {
        }
    }
}
