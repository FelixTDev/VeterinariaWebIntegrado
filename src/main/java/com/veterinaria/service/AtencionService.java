package com.veterinaria.service;

import com.veterinaria.dao.AtencionDao;
import com.veterinaria.dao.CitaDao;
import com.veterinaria.dao.MovimientoInventarioDao;
import com.veterinaria.dao.ProductoDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.AtencionClinica;
import com.veterinaria.model.Cita;
import com.veterinaria.model.DetalleAtencionProducto;
import com.veterinaria.model.MovimientoInventario;
import com.veterinaria.model.Producto;
import com.veterinaria.util.Database;
import com.veterinaria.util.ValidationUtil;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class AtencionService {
    private final AtencionDao atencionDao;
    private final CitaDao citaDao;
    private final ProductoDao productoDao;
    private final MovimientoInventarioDao movimientoDao;
    private final AuditService auditService;

    public AtencionService() {
        this(new AtencionDao(), new CitaDao(), new ProductoDao(), new MovimientoInventarioDao(), new AuditService());
    }

    AtencionService(AtencionDao atencionDao, CitaDao citaDao, ProductoDao productoDao,
            MovimientoInventarioDao movimientoDao, AuditService auditService) {
        this.atencionDao = atencionDao;
        this.citaDao = citaDao;
        this.productoDao = productoDao;
        this.movimientoDao = movimientoDao;
        this.auditService = auditService;
    }

    public List<AtencionClinica> listByMascota(int idMascota) {
        try {
            return atencionDao.listByMascota(idMascota);
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar el historial clínico.", ex);
        }
    }

    public AtencionClinica get(int idAtencion) {
        try {
            return atencionDao.findById(idAtencion).orElseThrow(() -> new AppException("Atención no encontrada."));
        } catch (SQLException ex) {
            throw new AppException("No fue posible obtener la atención clínica.", ex);
        }
    }

    public void registrar(AtencionClinica atencion, int actorId) {
        ValidationUtil.require(atencion.getIdCita() > 0, "La atención debe estar asociada a una cita.");
        ValidationUtil.require(atencion.getIdMascota() > 0, "La atención debe estar asociada a una mascota.");
        ValidationUtil.require(atencion.getIdVeterinario() > 0, "La atención debe tener veterinario.");
        ValidationUtil.notBlank(atencion.getDiagnostico(), "El diagnóstico es obligatorio.");

        Connection connection = null;
        try {
            Cita cita = citaDao.findById(atencion.getIdCita()).orElseThrow(() -> new AppException("La cita no existe."));
            ValidationUtil.require(
                    "PENDIENTE".equalsIgnoreCase(cita.getEstado()) || "CONFIRMADA".equalsIgnoreCase(cita.getEstado()),
                    "Solo se pueden registrar atenciones para citas pendientes o confirmadas."
            );
            ValidationUtil.require(
                    cita.getIdMascota() == atencion.getIdMascota(),
                    "La mascota seleccionada no corresponde a la cita elegida."
            );
            if (cita.getIdVeterinario() != null) {
                ValidationUtil.require(
                        cita.getIdVeterinario() == atencion.getIdVeterinario(),
                        "La atención debe registrarse con el veterinario asignado a la cita."
                );
            }
            ValidationUtil.require(
                    !atencionDao.existsByCita(atencion.getIdCita()),
                    "La cita seleccionada ya tiene una atención clínica registrada."
            );

            connection = Database.getConnection();
            connection.setAutoCommit(false);
            int idAtencion = atencionDao.save(connection, atencion);
            for (DetalleAtencionProducto detalle : atencion.getDetalles()) {
                validarDetalle(detalle);
                Producto producto = productoDao.findById(connection, detalle.getIdProducto())
                        .orElseThrow(() -> new AppException("Producto no encontrado para la atención."));
                if (producto.getStock() < detalle.getCantidad()) {
                    throw new AppException("Stock insuficiente para el producto: " + producto.getNombre());
                }
                detalle.setPrecioUnitario(producto.getPrecioVenta());
                detalle.setSubtotal(producto.getPrecioVenta().multiply(BigDecimal.valueOf(detalle.getCantidad())));
                atencionDao.saveDetalle(connection, detalle, idAtencion);

                int stockNuevo = producto.getStock() - detalle.getCantidad();
                productoDao.updateStock(connection, producto.getIdProducto(), stockNuevo);

                MovimientoInventario movimiento = new MovimientoInventario();
                movimiento.setIdProducto(producto.getIdProducto());
                movimiento.setIdUsuario(actorId);
                movimiento.setTipoMovimiento("SALIDA");
                movimiento.setMotivo("Uso en atención clínica");
                movimiento.setCantidad(detalle.getCantidad());
                movimiento.setStockAnterior(producto.getStock());
                movimiento.setStockNuevo(stockNuevo);
                movimiento.setReferencia("ATENCION-" + idAtencion);
                movimientoDao.save(connection, movimiento);
            }
            citaDao.updateEstado(connection, atencion.getIdCita(), "ATENDIDA");
            auditService.log(connection, actorId, "ATENCION", "CREAR", "Atención clínica registrada #" + idAtencion);
            connection.commit();
        } catch (Exception ex) {
            rollbackQuietly(connection);
            if (ex instanceof AppException appException) {
                throw appException;
            }
            throw new AppException("No fue posible registrar la atención clínica.", ex);
        } finally {
            closeQuietly(connection);
        }
    }

    private void validarDetalle(DetalleAtencionProducto detalle) {
        ValidationUtil.require(detalle.getIdProducto() > 0, "Producto inválido en atención clínica.");
        ValidationUtil.require(detalle.getCantidad() > 0, "La cantidad del producto debe ser mayor a cero.");
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
