package com.veterinaria.dao;

import com.veterinaria.model.Usuario;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserDao {
    public Optional<Usuario> findByUsername(String username) throws SQLException {
        String sql = """
                SELECT u.*, r.nombre AS rol_nombre
                FROM usuario u
                INNER JOIN rol r ON r.id_rol = u.id_rol
                WHERE u.username = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(map(resultSet));
                }
                return Optional.empty();
            }
        }
    }

    public List<Usuario> listVeterinarios() throws SQLException {
        String sql = """
                SELECT u.*, r.nombre AS rol_nombre
                FROM usuario u
                INNER JOIN rol r ON r.id_rol = u.id_rol
                WHERE r.nombre = 'VETERINARIO' AND u.estado = 'ACTIVO'
                ORDER BY u.nombres, u.apellidos
                """;
        List<Usuario> items = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                items.add(map(resultSet));
            }
        }
        return items;
    }

    public Optional<Usuario> findById(int idUsuario) throws SQLException {
        String sql = """
                SELECT u.*, r.nombre AS rol_nombre
                FROM usuario u
                INNER JOIN rol r ON r.id_rol = u.id_rol
                WHERE u.id_usuario = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idUsuario);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public void updatePasswordHash(int idUsuario, String passwordHash) throws SQLException {
        String sql = "UPDATE usuario SET password_hash = ? WHERE id_usuario = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, passwordHash);
            statement.setInt(2, idUsuario);
            statement.executeUpdate();
        }
    }

    private Usuario map(ResultSet resultSet) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setIdUsuario(resultSet.getInt("id_usuario"));
        usuario.setIdRol(resultSet.getInt("id_rol"));
        usuario.setRolNombre(resultSet.getString("rol_nombre"));
        usuario.setNombres(resultSet.getString("nombres"));
        usuario.setApellidos(resultSet.getString("apellidos"));
        usuario.setDni(resultSet.getString("dni"));
        usuario.setTelefono(resultSet.getString("telefono"));
        usuario.setCorreo(resultSet.getString("correo"));
        usuario.setUsername(resultSet.getString("username"));
        usuario.setPasswordHash(resultSet.getString("password_hash"));
        usuario.setEstado(resultSet.getString("estado"));
        if (resultSet.getTimestamp("fecha_registro") != null) {
            usuario.setFechaRegistro(resultSet.getTimestamp("fecha_registro").toLocalDateTime());
        }
        return usuario;
    }
}
