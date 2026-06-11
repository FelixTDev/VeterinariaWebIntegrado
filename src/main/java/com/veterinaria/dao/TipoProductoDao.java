package com.veterinaria.dao;

import com.veterinaria.model.TipoProducto;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class TipoProductoDao {
    public List<TipoProducto> list() throws SQLException {
        return query("SELECT * FROM tipo_producto ORDER BY nombre");
    }

    public List<TipoProducto> listActive() throws SQLException {
        return query("SELECT * FROM tipo_producto WHERE estado = 'ACTIVO' ORDER BY nombre");
    }

    public Optional<TipoProducto> findById(int id) throws SQLException {
        String sql = "SELECT * FROM tipo_producto WHERE id_tipo_producto = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public void save(TipoProducto tipoProducto) throws SQLException {
        String sql = "INSERT INTO tipo_producto (nombre, descripcion, estado) VALUES (?, ?, ?)";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, tipoProducto.getNombre());
            statement.setString(2, tipoProducto.getDescripcion());
            statement.setString(3, tipoProducto.getEstado());
            statement.executeUpdate();
        }
    }

    public void update(TipoProducto tipoProducto) throws SQLException {
        String sql = "UPDATE tipo_producto SET nombre = ?, descripcion = ?, estado = ? WHERE id_tipo_producto = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, tipoProducto.getNombre());
            statement.setString(2, tipoProducto.getDescripcion());
            statement.setString(3, tipoProducto.getEstado());
            statement.setInt(4, tipoProducto.getIdTipoProducto());
            statement.executeUpdate();
        }
    }

    private List<TipoProducto> query(String sql) throws SQLException {
        List<TipoProducto> items = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                items.add(map(resultSet));
            }
        }
        return items;
    }

    private TipoProducto map(ResultSet resultSet) throws SQLException {
        TipoProducto tipoProducto = new TipoProducto();
        tipoProducto.setIdTipoProducto(resultSet.getInt("id_tipo_producto"));
        tipoProducto.setNombre(resultSet.getString("nombre"));
        tipoProducto.setDescripcion(resultSet.getString("descripcion"));
        tipoProducto.setEstado(resultSet.getString("estado"));
        return tipoProducto;
    }
}
