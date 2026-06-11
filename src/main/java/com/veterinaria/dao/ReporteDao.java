package com.veterinaria.dao;

import com.veterinaria.util.Database;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReporteDao {
    public Map<String, Object> dashboard() throws SQLException {
        String sql = """
                SELECT
                    (SELECT COUNT(*) FROM cliente WHERE estado = 'ACTIVO') AS clientes,
                    (SELECT COUNT(*) FROM mascota WHERE estado = 'ACTIVO') AS mascotas,
                    (SELECT COUNT(*) FROM cita WHERE fecha_cita = CURDATE()) AS citas_hoy,
                    (SELECT COUNT(*) FROM producto WHERE estado = 'ACTIVO' AND stock <= stock_minimo) AS bajo_stock
                """;
        Map<String, Object> result = new HashMap<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            result.put("clientes", resultSet.getInt("clientes"));
            result.put("mascotas", resultSet.getInt("mascotas"));
            result.put("citasHoy", resultSet.getInt("citas_hoy"));
            result.put("bajoStock", resultSet.getInt("bajo_stock"));
        }
        return result;
    }

    public List<Map<String, Object>> citasPorRango(String desde, String hasta) throws SQLException {
        return query("""
                SELECT fecha_cita AS etiqueta, COUNT(*) AS total
                FROM cita
                WHERE fecha_cita BETWEEN ? AND ?
                GROUP BY fecha_cita
                ORDER BY fecha_cita
                """, desde, hasta);
    }

    public List<Map<String, Object>> ingresosPorRango(String desde, String hasta) throws SQLException {
        return query("""
                SELECT DATE(fecha_emision) AS etiqueta, COALESCE(SUM(total), 0) AS total
                FROM comprobante
                WHERE estado <> 'ANULADO'
                  AND DATE(fecha_emision) BETWEEN ? AND ?
                GROUP BY DATE(fecha_emision)
                ORDER BY DATE(fecha_emision)
                """, desde, hasta);
    }

    public List<Map<String, Object>> query(String sql, String desde, String hasta) throws SQLException {
        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, desde);
            statement.setString(2, hasta);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("etiqueta", String.valueOf(resultSet.getObject("etiqueta")));
                    Object total = resultSet.getObject("total");
                    row.put("total", total instanceof BigDecimal ? total : resultSet.getInt("total"));
                    rows.add(row);
                }
            }
        }
        return rows;
    }
}
