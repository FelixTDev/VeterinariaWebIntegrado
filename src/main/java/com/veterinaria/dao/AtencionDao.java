package com.veterinaria.dao;

import com.veterinaria.model.AtencionClinica;
import com.veterinaria.model.DetalleAtencionProducto;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AtencionDao {
    public int save(Connection connection, AtencionClinica atencion) throws SQLException {
        String sql = """
                INSERT INTO atencion_clinica
                (id_cita, id_mascota, id_veterinario, peso, temperatura, sintomas, diagnostico, tratamiento, observaciones, estado)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, atencion.getIdCita());
            statement.setInt(2, atencion.getIdMascota());
            statement.setInt(3, atencion.getIdVeterinario());
            statement.setBigDecimal(4, atencion.getPeso());
            statement.setBigDecimal(5, atencion.getTemperatura());
            statement.setString(6, atencion.getSintomas());
            statement.setString(7, atencion.getDiagnostico());
            statement.setString(8, atencion.getTratamiento());
            statement.setString(9, atencion.getObservaciones());
            statement.setString(10, atencion.getEstado());
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                keys.next();
                return keys.getInt(1);
            }
        }
    }

    public void saveDetalle(Connection connection, DetalleAtencionProducto detalle, int idAtencion) throws SQLException {
        String sql = """
                INSERT INTO detalle_atencion_producto
                (id_atencion, id_producto, cantidad, dosis, indicaciones, precio_unitario, subtotal)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idAtencion);
            statement.setInt(2, detalle.getIdProducto());
            statement.setInt(3, detalle.getCantidad());
            statement.setString(4, detalle.getDosis());
            statement.setString(5, detalle.getIndicaciones());
            statement.setBigDecimal(6, detalle.getPrecioUnitario());
            statement.setBigDecimal(7, detalle.getSubtotal());
            statement.executeUpdate();
        }
    }

    public List<AtencionClinica> listByMascota(int idMascota) throws SQLException {
        String sql = """
                SELECT a.*, m.nombre AS mascota_nombre, CONCAT(u.nombres, ' ', u.apellidos) AS veterinario_nombre
                FROM atencion_clinica a
                INNER JOIN mascota m ON m.id_mascota = a.id_mascota
                INNER JOIN usuario u ON u.id_usuario = a.id_veterinario
                WHERE a.id_mascota = ?
                ORDER BY a.fecha_atencion DESC
                """;
        List<AtencionClinica> items = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idMascota);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    items.add(map(resultSet));
                }
            }
        }
        return items;
    }

    public Optional<AtencionClinica> findById(int idAtencion) throws SQLException {
        String sql = """
                SELECT a.*, m.nombre AS mascota_nombre, CONCAT(u.nombres, ' ', u.apellidos) AS veterinario_nombre
                FROM atencion_clinica a
                INNER JOIN mascota m ON m.id_mascota = a.id_mascota
                INNER JOIN usuario u ON u.id_usuario = a.id_veterinario
                WHERE a.id_atencion = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idAtencion);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return Optional.empty();
                }
                AtencionClinica atencion = map(resultSet);
                atencion.setDetalles(listDetalles(connection, idAtencion));
                return Optional.of(atencion);
            }
        }
    }

    public boolean existsByCita(int idCita) throws SQLException {
        String sql = "SELECT COUNT(*) FROM atencion_clinica WHERE id_cita = ? AND estado <> 'ANULADA'";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idCita);
            try (ResultSet resultSet = statement.executeQuery()) {
                resultSet.next();
                return resultSet.getInt(1) > 0;
            }
        }
    }

    private List<DetalleAtencionProducto> listDetalles(Connection connection, int idAtencion) throws SQLException {
        String sql = """
                SELECT d.*, p.nombre AS producto_nombre
                FROM detalle_atencion_producto d
                INNER JOIN producto p ON p.id_producto = d.id_producto
                WHERE d.id_atencion = ?
                ORDER BY d.id_detalle_atencion
                """;
        List<DetalleAtencionProducto> items = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idAtencion);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    DetalleAtencionProducto item = new DetalleAtencionProducto();
                    item.setIdDetalleAtencion(resultSet.getInt("id_detalle_atencion"));
                    item.setIdAtencion(resultSet.getInt("id_atencion"));
                    item.setIdProducto(resultSet.getInt("id_producto"));
                    item.setProductoNombre(resultSet.getString("producto_nombre"));
                    item.setCantidad(resultSet.getInt("cantidad"));
                    item.setDosis(resultSet.getString("dosis"));
                    item.setIndicaciones(resultSet.getString("indicaciones"));
                    item.setPrecioUnitario(resultSet.getBigDecimal("precio_unitario"));
                    item.setSubtotal(resultSet.getBigDecimal("subtotal"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    private AtencionClinica map(ResultSet resultSet) throws SQLException {
        AtencionClinica atencion = new AtencionClinica();
        atencion.setIdAtencion(resultSet.getInt("id_atencion"));
        atencion.setIdCita(resultSet.getInt("id_cita"));
        atencion.setIdMascota(resultSet.getInt("id_mascota"));
        atencion.setIdVeterinario(resultSet.getInt("id_veterinario"));
        atencion.setMascotaNombre(resultSet.getString("mascota_nombre"));
        atencion.setVeterinarioNombre(resultSet.getString("veterinario_nombre"));
        atencion.setPeso(resultSet.getBigDecimal("peso"));
        atencion.setTemperatura(resultSet.getBigDecimal("temperatura"));
        atencion.setSintomas(resultSet.getString("sintomas"));
        atencion.setDiagnostico(resultSet.getString("diagnostico"));
        atencion.setTratamiento(resultSet.getString("tratamiento"));
        atencion.setObservaciones(resultSet.getString("observaciones"));
        atencion.setFechaAtencion(resultSet.getTimestamp("fecha_atencion").toLocalDateTime());
        atencion.setEstado(resultSet.getString("estado"));
        return atencion;
    }
}
