package com.veterinaria.dao;

import com.veterinaria.model.Cita;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CitaDao {
    public List<Cita> list(String fecha, String estado, String search) throws SQLException {
        String fechaFiltro = fecha == null || fecha.isBlank() ? null : fecha.trim();
        String estadoFiltro = estado == null || estado.isBlank() ? null : estado.trim().toUpperCase();
        String sql = """
                SELECT c.*, CONCAT(cl.nombres, ' ', cl.apellidos) AS cliente_nombre,
                       m.nombre AS mascota_nombre,
                       CONCAT(u.nombres, ' ', u.apellidos) AS veterinario_nombre
                FROM cita c
                INNER JOIN cliente cl ON cl.id_cliente = c.id_cliente
                INNER JOIN mascota m ON m.id_mascota = c.id_mascota
                LEFT JOIN usuario u ON u.id_usuario = c.id_veterinario
                WHERE (? IS NULL OR c.fecha_cita = ?)
                  AND (? IS NULL OR UPPER(TRIM(c.estado)) = ?)
                  AND (? IS NULL OR CONCAT(cl.nombres, ' ', cl.apellidos) LIKE ? OR m.nombre LIKE ?)
                ORDER BY c.fecha_cita DESC, c.hora_cita DESC
                """;
        List<Cita> items = new ArrayList<>();
        String like = search == null || search.isBlank() ? null : "%" + search.trim() + "%";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, fechaFiltro);
            statement.setString(2, fechaFiltro);
            statement.setString(3, estadoFiltro);
            statement.setString(4, estadoFiltro);
            statement.setString(5, like);
            statement.setString(6, like);
            statement.setString(7, like);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    items.add(map(resultSet));
                }
            }
        }
        return items;
    }

    public Optional<Cita> findById(int id) throws SQLException {
        String sql = """
                SELECT c.*, CONCAT(cl.nombres, ' ', cl.apellidos) AS cliente_nombre,
                       m.nombre AS mascota_nombre,
                       CONCAT(u.nombres, ' ', u.apellidos) AS veterinario_nombre
                FROM cita c
                INNER JOIN cliente cl ON cl.id_cliente = c.id_cliente
                INNER JOIN mascota m ON m.id_mascota = c.id_mascota
                LEFT JOIN usuario u ON u.id_usuario = c.id_veterinario
                WHERE c.id_cita = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    public boolean existsScheduleConflict(Cita cita) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM cita
                WHERE id_veterinario = ?
                  AND fecha_cita = ?
                  AND hora_cita = ?
                  AND estado IN ('PENDIENTE', 'CONFIRMADA')
                  AND id_cita <> ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setObject(1, cita.getIdVeterinario());
            statement.setObject(2, cita.getFechaCita());
            statement.setObject(3, cita.getHoraCita());
            statement.setInt(4, cita.getIdCita());
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt(1) > 0;
            }
        }
    }

    public List<Cita> listDisponiblesParaAtencion() throws SQLException {
        String sql = """
                SELECT c.*, CONCAT(cl.nombres, ' ', cl.apellidos) AS cliente_nombre,
                       m.nombre AS mascota_nombre,
                       CONCAT(u.nombres, ' ', u.apellidos) AS veterinario_nombre
                FROM cita c
                INNER JOIN cliente cl ON cl.id_cliente = c.id_cliente
                INNER JOIN mascota m ON m.id_mascota = c.id_mascota
                LEFT JOIN usuario u ON u.id_usuario = c.id_veterinario
                LEFT JOIN atencion_clinica a ON a.id_cita = c.id_cita AND a.estado <> 'ANULADA'
                WHERE c.estado IN ('PENDIENTE', 'CONFIRMADA')
                  AND a.id_atencion IS NULL
                ORDER BY c.fecha_cita ASC, c.hora_cita ASC
                """;
        List<Cita> items = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                items.add(map(resultSet));
            }
        }
        return items;
    }

    public void save(Cita cita) throws SQLException {
        String sql = """
                INSERT INTO cita (id_cliente, id_mascota, id_veterinario, fecha_cita, hora_cita, motivo, observaciones, estado)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            fill(statement, cita);
            statement.executeUpdate();
        }
    }

    public void update(Cita cita) throws SQLException {
        String sql = """
                UPDATE cita
                SET id_cliente = ?, id_mascota = ?, id_veterinario = ?, fecha_cita = ?, hora_cita = ?, motivo = ?, observaciones = ?, estado = ?
                WHERE id_cita = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            fill(statement, cita);
            statement.setInt(9, cita.getIdCita());
            statement.executeUpdate();
        }
    }

    public void updateEstado(Connection connection, int idCita, String estado) throws SQLException {
        String sql = "UPDATE cita SET estado = ? WHERE id_cita = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, estado);
            statement.setInt(2, idCita);
            statement.executeUpdate();
        }
    }

    private void fill(PreparedStatement statement, Cita cita) throws SQLException {
        statement.setInt(1, cita.getIdCliente());
        statement.setInt(2, cita.getIdMascota());
        statement.setObject(3, cita.getIdVeterinario());
        statement.setObject(4, cita.getFechaCita());
        statement.setObject(5, cita.getHoraCita());
        statement.setString(6, cita.getMotivo());
        statement.setString(7, cita.getObservaciones());
        statement.setString(8, cita.getEstado());
    }

    private Cita map(ResultSet resultSet) throws SQLException {
        Cita cita = new Cita();
        cita.setIdCita(resultSet.getInt("id_cita"));
        cita.setIdCliente(resultSet.getInt("id_cliente"));
        cita.setIdMascota(resultSet.getInt("id_mascota"));
        int vet = resultSet.getInt("id_veterinario");
        cita.setIdVeterinario(resultSet.wasNull() ? null : vet);
        cita.setClienteNombre(resultSet.getString("cliente_nombre"));
        cita.setMascotaNombre(resultSet.getString("mascota_nombre"));
        cita.setVeterinarioNombre(resultSet.getString("veterinario_nombre"));
        cita.setFechaCita(resultSet.getDate("fecha_cita").toLocalDate());
        cita.setHoraCita(resultSet.getTime("hora_cita").toLocalTime());
        cita.setMotivo(resultSet.getString("motivo"));
        cita.setObservaciones(resultSet.getString("observaciones"));
        cita.setEstado(resultSet.getString("estado"));
        cita.setFechaRegistro(resultSet.getTimestamp("fecha_registro").toLocalDateTime());
        return cita;
    }
}
