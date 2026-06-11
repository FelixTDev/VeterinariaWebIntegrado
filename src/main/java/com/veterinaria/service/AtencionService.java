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
    private final AtencionDao atencionDao = new AtencionDao();
    private final CitaDao citaDao = new CitaDao();
    private final ProductoDao productoDao = new ProductoDao();
    private final MovimientoInventarioDao movimientoDao = new MovimientoInventarioDao();
    private final AuditService auditService = new AuditService();

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
        try {
            Cita cita = citaDao.findById(atencion.getIdCita()).orElseThrow(() -> new AppException("La cita no existe."));
            if (!"ATENDIDA".equalsIgnoreCase(cita.getEstado())) {
                throw new AppException("Solo una cita atendida puede generar una atención clínica.");
            }
            try (Connection connection = Database.getConnection()) {
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
                auditService.log(connection, actorId, "ATENCION", "CREAR", "Atención clínica registrada #" + idAtencion);
                connection.commit();
            }
        } catch (SQLException ex) {
            throw new AppException("No fue posible registrar la atención clínica.", ex);
        }
    }

    private void validarDetalle(DetalleAtencionProducto detalle) {
        ValidationUtil.require(detalle.getIdProducto() > 0, "Producto inválido en atención clínica.");
        ValidationUtil.require(detalle.getCantidad() > 0, "La cantidad del producto debe ser mayor a cero.");
    }
}
