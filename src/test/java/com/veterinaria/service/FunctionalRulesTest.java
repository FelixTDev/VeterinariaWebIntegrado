package com.veterinaria.service;

import com.veterinaria.dao.AtencionDao;
import com.veterinaria.dao.CitaDao;
import com.veterinaria.dao.ClienteDao;
import com.veterinaria.dao.MascotaDao;
import com.veterinaria.dao.MovimientoInventarioDao;
import com.veterinaria.dao.ProductoDao;
import com.veterinaria.dao.ReporteDao;
import com.veterinaria.dao.TipoProductoDao;
import com.veterinaria.dao.UserDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.AtencionClinica;
import com.veterinaria.model.Cita;
import com.veterinaria.model.Cliente;
import com.veterinaria.model.Comprobante;
import com.veterinaria.model.DetalleComprobante;
import com.veterinaria.model.Especie;
import com.veterinaria.model.Mascota;
import com.veterinaria.model.Producto;
import com.veterinaria.model.TipoProducto;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class FunctionalRulesTest {

    @Test
    void citaNoPermiteMascotaAjenaAlCliente() {
        CitaService service = new CitaService(
                new FakeCitaDao(),
                new FakeClienteDao(),
                new FakeMascotaDao(false),
                new FakeUserDao(),
                new NoOpAuditService()
        );

        Cita cita = buildCitaBase();

        AppException ex = assertThrows(AppException.class, () -> service.save(cita, 1));
        assertEquals("La mascota seleccionada no pertenece al cliente indicado.", ex.getMessage());
    }

    @Test
    void atencionNoPermiteCitaYMascotaIncoherentes() {
        FakeCitaDao citaDao = new FakeCitaDao();
        citaDao.cita = buildCitaBase();
        citaDao.cita.setEstado("CONFIRMADA");
        citaDao.cita.setIdMascota(99);

        AtencionService service = new AtencionService(
                new FakeAtencionDao(false),
                citaDao,
                new FakeProductoDao(),
                new FakeMovimientoInventarioDao(),
                new NoOpAuditService()
        );

        AtencionClinica atencion = new AtencionClinica();
        atencion.setIdCita(1);
        atencion.setIdMascota(5);
        atencion.setIdVeterinario(7);
        atencion.setDiagnostico("Diagnóstico");

        AppException ex = assertThrows(AppException.class, () -> service.registrar(atencion, 1));
        assertEquals("La mascota seleccionada no corresponde a la cita elegida.", ex.getMessage());
    }

    @Test
    void atencionNoPermiteDuplicarPorCita() {
        FakeCitaDao citaDao = new FakeCitaDao();
        citaDao.cita = buildCitaBase();
        citaDao.cita.setEstado("CONFIRMADA");
        citaDao.cita.setIdMascota(5);
        citaDao.cita.setIdVeterinario(7);

        AtencionService service = new AtencionService(
                new FakeAtencionDao(true),
                citaDao,
                new FakeProductoDao(),
                new FakeMovimientoInventarioDao(),
                new NoOpAuditService()
        );

        AtencionClinica atencion = new AtencionClinica();
        atencion.setIdCita(1);
        atencion.setIdMascota(5);
        atencion.setIdVeterinario(7);
        atencion.setDiagnostico("Diagnóstico");

        AppException ex = assertThrows(AppException.class, () -> service.registrar(atencion, 1));
        assertEquals("La cita seleccionada ya tiene una atención clínica registrada.", ex.getMessage());
    }

    @Test
    void comprobanteTomaPrecioRealDesdeBaseDeDatos() throws SQLException {
        FakeProductoDao productoDao = new FakeProductoDao();
        productoDao.producto = productoConPrecio(new BigDecimal("10.00"));

        ComprobanteService service = new ComprobanteService(
                new FakeComprobanteDao(),
                productoDao,
                new FakeMovimientoInventarioDao(),
                new FakeClienteDao(),
                new FakeMascotaDao(true),
                new FakeAtencionDao(false),
                new NoOpAuditService()
        );

        Comprobante comprobante = new Comprobante();
        comprobante.setIdCliente(1);
        DetalleComprobante detalle = new DetalleComprobante();
        detalle.setTipoItem("PRODUCTO");
        detalle.setIdProducto(10);
        detalle.setCantidad(2);
        detalle.setPrecioUnitario(new BigDecimal("0.00"));
        comprobante.setDetalles(List.of(detalle));

        service.recalcular(comprobante, null);

        assertEquals(new BigDecimal("10.00"), detalle.getPrecioUnitario());
        assertEquals(new BigDecimal("20.00"), comprobante.getSubtotal());
        assertEquals(new BigDecimal("3.60"), comprobante.getImpuesto());
        assertEquals(new BigDecimal("23.60"), comprobante.getTotal());
    }

    @Test
    void reporteRechazaFechaDesdeMayorQueHasta() {
        ReporteService service = new ReporteService(new FakeReporteDao(), new FakeProductoDao(), new FakeMovimientoInventarioDao());

        AppException ex = assertThrows(AppException.class,
                () -> service.validateRange(LocalDate.of(2026, 6, 25), LocalDate.of(2026, 6, 24)));
        assertEquals("La fecha desde no puede ser mayor que la fecha hasta.", ex.getMessage());
    }

    @Test
    void productoRechazaCodigoDuplicado() {
        ProductoService service = new ProductoService(new FakeProductoDao(true), new FakeTipoProductoDao(), new NoOpAuditService());

        Producto producto = productoConPrecio(new BigDecimal("10.00"));
        producto.setCodigo("DUP-001");
        producto.setNombre("Vacuna");
        producto.setIdTipoProducto(1);

        AppException ex = assertThrows(AppException.class, () -> service.save(producto, 1));
        assertEquals("Ya existe un producto con ese código.", ex.getMessage());
    }

    @Test
    void clienteRechazaCorreoDuplicado() {
        ClienteService service = new ClienteService(new FakeClienteDao(false, true), new NoOpAuditService());

        Cliente cliente = new Cliente();
        cliente.setNombres("Ana");
        cliente.setApellidos("Perez");
        cliente.setDni("12345678");
        cliente.setTelefono("999999999");
        cliente.setCorreo("ana@correo.com");
        cliente.setDireccion("Lima");

        AppException ex = assertThrows(AppException.class, () -> service.save(cliente, 1));
        assertEquals("Ya existe un cliente con ese correo.", ex.getMessage());
    }

    private Cita buildCitaBase() {
        Cita cita = new Cita();
        cita.setIdCita(1);
        cita.setIdCliente(1);
        cita.setIdMascota(5);
        cita.setIdVeterinario(null);
        cita.setFechaCita(LocalDate.now());
        cita.setHoraCita(LocalTime.of(10, 0));
        cita.setMotivo("Consulta");
        cita.setEstado("PENDIENTE");
        return cita;
    }

    private Producto productoConPrecio(BigDecimal precio) {
        Producto producto = new Producto();
        producto.setIdProducto(10);
        producto.setIdTipoProducto(1);
        producto.setCodigo("PRD-001");
        producto.setNombre("Medicamento");
        producto.setStock(10);
        producto.setStockMinimo(1);
        producto.setPrecioCompra(new BigDecimal("5.00"));
        producto.setPrecioVenta(precio);
        producto.setEstado("ACTIVO");
        return producto;
    }

    private static class NoOpAuditService extends AuditService {
        @Override
        public void log(Integer idUsuario, String modulo, String accion, String descripcion) {
        }

        @Override
        public void log(Connection connection, Integer idUsuario, String modulo, String accion, String descripcion) {
        }
    }

    private static class FakeCitaDao extends CitaDao {
        private Cita cita;

        @Override
        public Optional<Cita> findById(int id) {
            return Optional.ofNullable(cita);
        }

        @Override
        public boolean existsScheduleConflict(Cita cita) {
            return false;
        }

        @Override
        public void save(Cita cita) {
        }
    }

    private static class FakeClienteDao extends ClienteDao {
        private final boolean dniDuplicado;
        private final boolean correoDuplicado;

        FakeClienteDao() {
            this(false, false);
        }

        FakeClienteDao(boolean dniDuplicado, boolean correoDuplicado) {
            this.dniDuplicado = dniDuplicado;
            this.correoDuplicado = correoDuplicado;
        }

        @Override
        public Optional<Cliente> findById(int id) {
            Cliente cliente = new Cliente();
            cliente.setIdCliente(id);
            return Optional.of(cliente);
        }

        @Override
        public boolean existsByDni(String dni, Integer excludeId) {
            return dniDuplicado;
        }

        @Override
        public boolean existsByCorreo(String correo, Integer excludeId) {
            return correoDuplicado;
        }

        @Override
        public void save(Cliente cliente) {
        }
    }

    private static class FakeMascotaDao extends MascotaDao {
        private final boolean belongs;

        FakeMascotaDao(boolean belongs) {
            this.belongs = belongs;
        }

        @Override
        public Optional<Mascota> findById(int id) {
            Mascota mascota = new Mascota();
            mascota.setIdMascota(id);
            mascota.setIdCliente(1);
            mascota.setIdEspecie(1);
            return Optional.of(mascota);
        }

        @Override
        public boolean belongsToCliente(int idMascota, int idCliente) {
            return belongs;
        }
    }

    private static class FakeUserDao extends UserDao {
    }

    private static class FakeAtencionDao extends AtencionDao {
        private final boolean existsByCita;

        FakeAtencionDao(boolean existsByCita) {
            this.existsByCita = existsByCita;
        }

        @Override
        public boolean existsByCita(int idCita) {
            return existsByCita;
        }
    }

    private static class FakeProductoDao extends ProductoDao {
        private final boolean codigoDuplicado;
        private Producto producto;

        FakeProductoDao() {
            this(false);
        }

        FakeProductoDao(boolean codigoDuplicado) {
            this.codigoDuplicado = codigoDuplicado;
        }

        @Override
        public boolean existsByCodigo(String codigo, Integer excludeId) {
            return codigoDuplicado;
        }

        @Override
        public Optional<Producto> findById(Connection connection, int id) {
            return Optional.ofNullable(producto);
        }
    }

    private static class FakeTipoProductoDao extends TipoProductoDao {
        @Override
        public Optional<TipoProducto> findById(int idTipoProducto) {
            TipoProducto tipo = new TipoProducto();
            tipo.setIdTipoProducto(idTipoProducto);
            tipo.setEstado("ACTIVO");
            return Optional.of(tipo);
        }
    }

    private static class FakeMovimientoInventarioDao extends MovimientoInventarioDao {
    }

    private static class FakeComprobanteDao extends com.veterinaria.dao.ComprobanteDao {
    }

    private static class FakeReporteDao extends ReporteDao {
        @Override
        public List<Map<String, Object>> citasPorRango(String desde, String hasta) {
            return List.of();
        }

        @Override
        public List<Map<String, Object>> ingresosPorRango(String desde, String hasta) {
            return List.of();
        }
    }
}
