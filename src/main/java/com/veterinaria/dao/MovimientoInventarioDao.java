package com.veterinaria.dao;

import com.veterinaria.model.MovimientoInventario;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MovimientoInventarioDao {
    public void save(Connection connection, MovimientoInventario movimiento) throws SQLException {
        String sql = """
                INSERT INTO movimiento_inventario
                (id_producto, id_usuario, tipo_movimiento, motivo, cantidad, stock_anterior, stock_nuevo, referencia)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, movimiento.getIdProducto());
            statement.setInt(2, movimiento.getIdUsuario());
            statement.setString(3, movimiento.getTipoMovimiento());
            statement.setString(4, movimiento.getMotivo());
            statement.setInt(5, movimiento.getCantidad());
            statement.setInt(6, movimiento.getStockAnterior());
            statement.setInt(7, movimiento.getStockNuevo());
            statement.setString(8, movimiento.getReferencia());
            statement.executeUpdate();
        }
    }

    public List<MovimientoInventario> listRecent() throws SQLException {
        String sql = """
                SELECT m.*, p.nombre AS producto_nombre, CONCAT(u.nombres, ' ', u.apellidos) AS usuario_nombre
                FROM movimiento_inventario m
                INNER JOIN producto p ON p.id_producto = m.id_producto
                INNER JOIN usuario u ON u.id_usuario = m.id_usuario
                ORDER BY m.fecha_movimiento DESC
                LIMIT 50
                """;
        List<MovimientoInventario> items = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                MovimientoInventario item = new MovimientoInventario();
                item.setIdMovimiento(resultSet.getInt("id_movimiento"));
                item.setIdProducto(resultSet.getInt("id_producto"));
                item.setIdUsuario(resultSet.getInt("id_usuario"));
                item.setProductoNombre(resultSet.getString("producto_nombre"));
                item.setUsuarioNombre(resultSet.getString("usuario_nombre"));
                item.setTipoMovimiento(resultSet.getString("tipo_movimiento"));
                item.setMotivo(resultSet.getString("motivo"));
                item.setCantidad(resultSet.getInt("cantidad"));
                item.setStockAnterior(resultSet.getInt("stock_anterior"));
                item.setStockNuevo(resultSet.getInt("stock_nuevo"));
                item.setFechaMovimiento(resultSet.getTimestamp("fecha_movimiento").toLocalDateTime());
                item.setReferencia(resultSet.getString("referencia"));
                items.add(item);
            }
        }
        return items;
    }
}
