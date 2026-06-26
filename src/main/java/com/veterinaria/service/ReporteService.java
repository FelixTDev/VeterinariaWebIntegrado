package com.veterinaria.service;

import com.veterinaria.dao.MovimientoInventarioDao;
import com.veterinaria.dao.ProductoDao;
import com.veterinaria.dao.ReporteDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.MovimientoInventario;
import com.veterinaria.model.Producto;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class ReporteService {
    private final ReporteDao reporteDao;
    private final ProductoDao productoDao;
    private final MovimientoInventarioDao movimientoDao;

    public ReporteService() {
        this(new ReporteDao(), new ProductoDao(), new MovimientoInventarioDao());
    }

    ReporteService(ReporteDao reporteDao, ProductoDao productoDao, MovimientoInventarioDao movimientoDao) {
        this.reporteDao = reporteDao;
        this.productoDao = productoDao;
        this.movimientoDao = movimientoDao;
    }

    public Map<String, Object> dashboard() {
        try {
            return reporteDao.dashboard();
        } catch (SQLException ex) {
            throw new AppException("No fue posible cargar el dashboard.", ex);
        }
    }

    public List<Map<String, Object>> citasPorRango(String desde, String hasta) {
        validateRange(LocalDate.parse(desde), LocalDate.parse(hasta));
        try {
            return reporteDao.citasPorRango(desde, hasta);
        } catch (SQLException ex) {
            throw new AppException("No fue posible generar el reporte de citas.", ex);
        }
    }

    public List<Map<String, Object>> ingresosPorRango(String desde, String hasta) {
        validateRange(LocalDate.parse(desde), LocalDate.parse(hasta));
        try {
            return reporteDao.ingresosPorRango(desde, hasta);
        } catch (SQLException ex) {
            throw new AppException("No fue posible generar el reporte de ingresos.", ex);
        }
    }

    public List<Producto> bajoStock() {
        try {
            return productoDao.listLowStock();
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar productos con bajo stock.", ex);
        }
    }

    public List<Producto> porVencer(int dias) {
        try {
            return productoDao.listNearExpiry(dias);
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar productos por vencer.", ex);
        }
    }

    public List<MovimientoInventario> movimientosRecientes() {
        try {
            return movimientoDao.listRecent();
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar movimientos recientes.", ex);
        }
    }

    void validateRange(LocalDate desde, LocalDate hasta) {
        if (desde == null || hasta == null) {
            throw new AppException("Debes indicar un rango de fechas válido.");
        }
        if (desde.isAfter(hasta)) {
            throw new AppException("La fecha desde no puede ser mayor que la fecha hasta.");
        }
    }
}
