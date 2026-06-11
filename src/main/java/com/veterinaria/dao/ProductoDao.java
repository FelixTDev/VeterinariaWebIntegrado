package com.veterinaria.dao;

import com.veterinaria.model.Producto;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ProductoDao {
    public List<Producto> list(String search) throws SQLException {
        String sql = """
                SELECT p.*, tp.nombre AS tipo_producto_nombre
                FROM producto p
                INNER JOIN tipo_producto tp ON tp.id_tipo_producto = p.id_tipo_producto
                WHERE (? IS NULL OR p.codigo LIKE ? OR p.nombre LIKE ? OR tp.nombre LIKE ?)
                ORDER BY p.id_producto DESC
                """;
        List<Producto> items = new ArrayList<>();
        String like = search == null || search.isBlank() ? null : "%" + search.trim() + "%";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, like);
            statement.setString(2, like);
            statement.setString(3, like);
            statement.setString(4, like);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    items.add(map(resultSet));
                }
            }
        }
        return items;
    }

    public List<Producto> listLowStock() throws SQLException {
        return query("""
                SELECT p.*, tp.nombre AS tipo_producto_nombre
                FROM producto p
                INNER JOIN tipo_producto tp ON tp.id_tipo_producto = p.id_tipo_producto
                WHERE p.estado = 'ACTIVO' AND p.stock <= p.stock_minimo
                ORDER BY p.stock, p.nombre
                """);
    }

    public List<Producto> listNearExpiry(int days) throws SQLException {
        String sql = """
                SELECT p.*, tp.nombre AS tipo_producto_nombre
                FROM producto p
                INNER JOIN tipo_producto tp ON tp.id_tipo_producto = p.id_tipo_producto
                WHERE p.estado = 'ACTIVO'
                  AND p.fecha_vencimiento IS NOT NULL
                  AND p.fecha_vencimiento BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL ? DAY)
                ORDER BY p.fecha_vencimiento
                """;
        List<Producto> items = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, days);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    items.add(map(resultSet));
                }
            }
        }
        return items;
    }

    public Optional<Producto> findById(int id) throws SQLException {
        String sql = """
                SELECT p.*, tp.nombre AS tipo_producto_nombre
                FROM producto p
                INNER JOIN tipo_producto tp ON tp.id_tipo_producto = p.id_tipo_producto
                WHERE p.id_producto = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public Optional<Producto> findById(Connection connection, int id) throws SQLException {
        String sql = """
                SELECT p.*, tp.nombre AS tipo_producto_nombre
                FROM producto p
                INNER JOIN tipo_producto tp ON tp.id_tipo_producto = p.id_tipo_producto
                WHERE p.id_producto = ?
                FOR UPDATE
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public void save(Producto producto) throws SQLException {
        String sql = """
                INSERT INTO producto (id_tipo_producto, codigo, nombre, descripcion, stock, stock_minimo, precio_compra, precio_venta, fecha_vencimiento, requiere_receta, estado)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            fill(statement, producto);
            statement.executeUpdate();
        }
    }

    public void update(Producto producto) throws SQLException {
        String sql = """
                UPDATE producto
                SET id_tipo_producto = ?, codigo = ?, nombre = ?, descripcion = ?, stock = ?, stock_minimo = ?, precio_compra = ?, precio_venta = ?, fecha_vencimiento = ?, requiere_receta = ?, estado = ?
                WHERE id_producto = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            fill(statement, producto);
            statement.setInt(12, producto.getIdProducto());
            statement.executeUpdate();
        }
    }

    public void updateStock(Connection connection, int idProducto, int stockNuevo) throws SQLException {
        String sql = "UPDATE producto SET stock = ? WHERE id_producto = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, stockNuevo);
            statement.setInt(2, idProducto);
            statement.executeUpdate();
        }
    }

    private void fill(PreparedStatement statement, Producto producto) throws SQLException {
        statement.setInt(1, producto.getIdTipoProducto());
        statement.setString(2, producto.getCodigo());
        statement.setString(3, producto.getNombre());
        statement.setString(4, producto.getDescripcion());
        statement.setInt(5, producto.getStock());
        statement.setInt(6, producto.getStockMinimo());
        statement.setBigDecimal(7, producto.getPrecioCompra());
        statement.setBigDecimal(8, producto.getPrecioVenta());
        statement.setObject(9, producto.getFechaVencimiento());
        statement.setBoolean(10, producto.isRequiereReceta());
        statement.setString(11, producto.getEstado());
    }

    private List<Producto> query(String sql) throws SQLException {
        List<Producto> items = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                items.add(map(resultSet));
            }
        }
        return items;
    }

    private Producto map(ResultSet resultSet) throws SQLException {
        Producto producto = new Producto();
        producto.setIdProducto(resultSet.getInt("id_producto"));
        producto.setIdTipoProducto(resultSet.getInt("id_tipo_producto"));
        producto.setTipoProductoNombre(resultSet.getString("tipo_producto_nombre"));
        producto.setCodigo(resultSet.getString("codigo"));
        producto.setNombre(resultSet.getString("nombre"));
        producto.setDescripcion(resultSet.getString("descripcion"));
        producto.setStock(resultSet.getInt("stock"));
        producto.setStockMinimo(resultSet.getInt("stock_minimo"));
        producto.setPrecioCompra(resultSet.getBigDecimal("precio_compra"));
        producto.setPrecioVenta(resultSet.getBigDecimal("precio_venta"));
        if (resultSet.getDate("fecha_vencimiento") != null) {
            producto.setFechaVencimiento(resultSet.getDate("fecha_vencimiento").toLocalDate());
        }
        producto.setRequiereReceta(resultSet.getBoolean("requiere_receta"));
        producto.setEstado(resultSet.getString("estado"));
        if (resultSet.getTimestamp("fecha_registro") != null) {
            producto.setFechaRegistro(resultSet.getTimestamp("fecha_registro").toLocalDateTime());
        }
        return producto;
    }
}
