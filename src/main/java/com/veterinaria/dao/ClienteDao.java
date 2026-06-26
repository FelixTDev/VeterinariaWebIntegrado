package com.veterinaria.dao;

import com.veterinaria.model.Cliente;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ClienteDao {
    public List<Cliente> list(String search) throws SQLException {
        String sql = """
                SELECT *
                FROM cliente
                WHERE (? IS NULL OR CONCAT(nombres, ' ', apellidos) LIKE ? OR dni LIKE ? OR telefono LIKE ?)
                ORDER BY id_cliente DESC
                """;
        List<Cliente> items = new ArrayList<>();
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

    public List<Cliente> listActive() throws SQLException {
        String sql = "SELECT * FROM cliente WHERE estado = 'ACTIVO' ORDER BY nombres, apellidos";
        List<Cliente> items = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                items.add(map(resultSet));
            }
        }
        return items;
    }

    public Optional<Cliente> findById(int id) throws SQLException {
        String sql = "SELECT * FROM cliente WHERE id_cliente = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(map(resultSet));
                }
                return Optional.empty();
            }
        }
    }

    public boolean existsByDni(String dni, Integer excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cliente WHERE dni = ? AND (? IS NULL OR id_cliente <> ?)";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, dni);
            if (excludeId == null) {
                statement.setObject(2, null);
                statement.setObject(3, null);
            } else {
                statement.setInt(2, excludeId);
                statement.setInt(3, excludeId);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt(1) > 0;
            }
        }
    }

    public boolean existsByCorreo(String correo, Integer excludeId) throws SQLException {
        if (correo == null || correo.isBlank()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM cliente WHERE correo = ? AND (? IS NULL OR id_cliente <> ?)";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, correo.trim());
            if (excludeId == null) {
                statement.setObject(2, null);
                statement.setObject(3, null);
            } else {
                statement.setInt(2, excludeId);
                statement.setInt(3, excludeId);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt(1) > 0;
            }
        }
    }

    public void save(Cliente cliente) throws SQLException {
        String sql = """
                INSERT INTO cliente (nombres, apellidos, dni, telefono, correo, direccion, estado)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            fill(statement, cliente);
            statement.executeUpdate();
        }
    }

    public void update(Cliente cliente) throws SQLException {
        String sql = """
                UPDATE cliente
                SET nombres = ?, apellidos = ?, dni = ?, telefono = ?, correo = ?, direccion = ?, estado = ?
                WHERE id_cliente = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            fill(statement, cliente);
            statement.setInt(8, cliente.getIdCliente());
            statement.executeUpdate();
        }
    }

    public int countRelatedRecords(int idCliente) throws SQLException {
        String sql = """
                SELECT
                    (SELECT COUNT(*) FROM mascota WHERE id_cliente = ?) +
                    (SELECT COUNT(*) FROM cita WHERE id_cliente = ?) +
                    (SELECT COUNT(*) FROM comprobante WHERE id_cliente = ?) AS total
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idCliente);
            statement.setInt(2, idCliente);
            statement.setInt(3, idCliente);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt("total");
            }
        }
    }

    private void fill(PreparedStatement statement, Cliente cliente) throws SQLException {
        statement.setString(1, cliente.getNombres());
        statement.setString(2, cliente.getApellidos());
        statement.setString(3, cliente.getDni());
        statement.setString(4, cliente.getTelefono());
        statement.setString(5, cliente.getCorreo());
        statement.setString(6, cliente.getDireccion());
        statement.setString(7, cliente.getEstado());
    }

    private Cliente map(ResultSet resultSet) throws SQLException {
        Cliente cliente = new Cliente();
        cliente.setIdCliente(resultSet.getInt("id_cliente"));
        cliente.setNombres(resultSet.getString("nombres"));
        cliente.setApellidos(resultSet.getString("apellidos"));
        cliente.setDni(resultSet.getString("dni"));
        cliente.setTelefono(resultSet.getString("telefono"));
        cliente.setCorreo(resultSet.getString("correo"));
        cliente.setDireccion(resultSet.getString("direccion"));
        cliente.setEstado(resultSet.getString("estado"));
        if (resultSet.getTimestamp("fecha_registro") != null) {
            cliente.setFechaRegistro(resultSet.getTimestamp("fecha_registro").toLocalDateTime());
        }
        return cliente;
    }
}
