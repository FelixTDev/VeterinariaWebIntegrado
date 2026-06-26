package com.veterinaria.dao;

import com.veterinaria.model.Mascota;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class MascotaDao {
    public List<Mascota> list(String search) throws SQLException {
        String sql = """
                SELECT m.*, e.nombre AS especie_nombre, CONCAT(c.nombres, ' ', c.apellidos) AS cliente_nombre
                FROM mascota m
                INNER JOIN cliente c ON c.id_cliente = m.id_cliente
                INNER JOIN especie e ON e.id_especie = m.id_especie
                WHERE (? IS NULL OR m.nombre LIKE ? OR e.nombre LIKE ? OR CONCAT(c.nombres, ' ', c.apellidos) LIKE ?)
                ORDER BY m.id_mascota DESC
                """;
        List<Mascota> items = new ArrayList<>();
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

    public Optional<Mascota> findById(int id) throws SQLException {
        String sql = """
                SELECT m.*, e.nombre AS especie_nombre, CONCAT(c.nombres, ' ', c.apellidos) AS cliente_nombre
                FROM mascota m
                INNER JOIN cliente c ON c.id_cliente = m.id_cliente
                INNER JOIN especie e ON e.id_especie = m.id_especie
                WHERE m.id_mascota = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public List<Mascota> listByCliente(int idCliente) throws SQLException {
        String sql = """
                SELECT m.*, e.nombre AS especie_nombre, NULL AS cliente_nombre
                FROM mascota m
                INNER JOIN especie e ON e.id_especie = m.id_especie
                WHERE m.id_cliente = ? AND m.estado <> 'FALLECIDO'
                ORDER BY m.nombre
                """;
        List<Mascota> items = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idCliente);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    items.add(map(resultSet));
                }
            }
        }
        return items;
    }

    public boolean belongsToCliente(int idMascota, int idCliente) throws SQLException {
        String sql = "SELECT COUNT(*) FROM mascota WHERE id_mascota = ? AND id_cliente = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idMascota);
            statement.setInt(2, idCliente);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt(1) > 0;
            }
        }
    }

    public void save(Mascota mascota) throws SQLException {
        String sql = """
                INSERT INTO mascota (id_cliente, id_especie, nombre, raza, sexo, color, fecha_nacimiento, peso, observaciones, estado)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            fill(statement, mascota);
            statement.executeUpdate();
        }
    }

    public void update(Mascota mascota) throws SQLException {
        String sql = """
                UPDATE mascota
                SET id_cliente = ?, id_especie = ?, nombre = ?, raza = ?, sexo = ?, color = ?, fecha_nacimiento = ?, peso = ?, observaciones = ?, estado = ?
                WHERE id_mascota = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            fill(statement, mascota);
            statement.setInt(11, mascota.getIdMascota());
            statement.executeUpdate();
        }
    }

    private void fill(PreparedStatement statement, Mascota mascota) throws SQLException {
        statement.setInt(1, mascota.getIdCliente());
        statement.setInt(2, mascota.getIdEspecie());
        statement.setString(3, mascota.getNombre());
        statement.setString(4, mascota.getRaza());
        statement.setString(5, mascota.getSexo());
        statement.setString(6, mascota.getColor());
        statement.setObject(7, mascota.getFechaNacimiento());
        statement.setBigDecimal(8, mascota.getPeso());
        statement.setString(9, mascota.getObservaciones());
        statement.setString(10, mascota.getEstado());
    }

    private Mascota map(ResultSet resultSet) throws SQLException {
        Mascota mascota = new Mascota();
        mascota.setIdMascota(resultSet.getInt("id_mascota"));
        mascota.setIdCliente(resultSet.getInt("id_cliente"));
        mascota.setIdEspecie(resultSet.getInt("id_especie"));
        mascota.setClienteNombre(resultSet.getString("cliente_nombre"));
        mascota.setEspecieNombre(resultSet.getString("especie_nombre"));
        mascota.setNombre(resultSet.getString("nombre"));
        mascota.setRaza(resultSet.getString("raza"));
        mascota.setSexo(resultSet.getString("sexo"));
        mascota.setColor(resultSet.getString("color"));
        if (resultSet.getDate("fecha_nacimiento") != null) {
            mascota.setFechaNacimiento(resultSet.getDate("fecha_nacimiento").toLocalDate());
        }
        mascota.setPeso(resultSet.getBigDecimal("peso"));
        mascota.setObservaciones(resultSet.getString("observaciones"));
        mascota.setEstado(resultSet.getString("estado"));
        if (resultSet.getTimestamp("fecha_registro") != null) {
            mascota.setFechaRegistro(resultSet.getTimestamp("fecha_registro").toLocalDateTime());
        }
        return mascota;
    }
}
