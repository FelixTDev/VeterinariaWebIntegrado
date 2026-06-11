package com.veterinaria.service;

import com.veterinaria.dao.MovimientoInventarioDao;
import com.veterinaria.dao.ProductoDao;
import com.veterinaria.dao.ReporteDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.MovimientoInventario;
import com.veterinaria.model.Producto;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class ReporteService {
    private final ReporteDao reporteDao = new ReporteDao();
    private final ProductoDao productoDao = new ProductoDao();
    private final MovimientoInventarioDao movimientoDao = new MovimientoInventarioDao();

    public Map<String, Object> dashboard() {
        try {
            return reporteDao.dashboard();
        } catch (SQLException ex) {
            throw new AppException("No fue posible cargar el dashboard.", ex);
        }
    }

    public List<Map<String, Object>> citasPorRango(String desde, String hasta) {
        try {
            return reporteDao.citasPorRango(desde, hasta);
        } catch (SQLException ex) {
            throw new AppException("No fue posible generar el reporte de citas.", ex);
        }
    }

    public List<Map<String, Object>> ingresosPorRango(String desde, String hasta) {
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
}
