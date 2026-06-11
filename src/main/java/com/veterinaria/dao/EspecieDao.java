package com.veterinaria.dao;

import com.veterinaria.model.Especie;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class EspecieDao {
    public List<Especie> list() throws SQLException {
        return query("SELECT * FROM especie ORDER BY nombre");
    }

    public List<Especie> listActive() throws SQLException {
        return query("SELECT * FROM especie WHERE estado = 'ACTIVO' ORDER BY nombre");
    }

    public Optional<Especie> findById(int id) throws SQLException {
        String sql = "SELECT * FROM especie WHERE id_especie = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public void save(Especie especie) throws SQLException {
        String sql = "INSERT INTO especie (nombre, descripcion, estado) VALUES (?, ?, ?)";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, especie.getNombre());
            statement.setString(2, especie.getDescripcion());
            statement.setString(3, especie.getEstado());
            statement.executeUpdate();
        }
    }

    public void update(Especie especie) throws SQLException {
        String sql = "UPDATE especie SET nombre = ?, descripcion = ?, estado = ? WHERE id_especie = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, especie.getNombre());
            statement.setString(2, especie.getDescripcion());
            statement.setString(3, especie.getEstado());
            statement.setInt(4, especie.getIdEspecie());
            statement.executeUpdate();
        }
    }

    private List<Especie> query(String sql) throws SQLException {
        List<Especie> items = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                items.add(map(resultSet));
            }
        }
        return items;
    }

    private Especie map(ResultSet resultSet) throws SQLException {
        Especie especie = new Especie();
        especie.setIdEspecie(resultSet.getInt("id_especie"));
        especie.setNombre(resultSet.getString("nombre"));
        especie.setDescripcion(resultSet.getString("descripcion"));
        especie.setEstado(resultSet.getString("estado"));
        return especie;
    }
}
