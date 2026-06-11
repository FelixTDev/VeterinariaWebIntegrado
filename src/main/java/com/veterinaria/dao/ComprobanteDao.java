package com.veterinaria.dao;

import com.veterinaria.model.Comprobante;
import com.veterinaria.model.DetalleComprobante;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ComprobanteDao {
    public int save(Connection connection, Comprobante comprobante) throws SQLException {
        String sql = """
                INSERT INTO comprobante
                (id_cliente, id_mascota, id_usuario, id_atencion, numero_comprobante, tipo_comprobante, subtotal, impuesto, total, metodo_pago, estado, observaciones)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, comprobante.getIdCliente());
            statement.setObject(2, comprobante.getIdMascota());
            statement.setInt(3, comprobante.getIdUsuario());
            statement.setObject(4, comprobante.getIdAtencion());
            statement.setString(5, comprobante.getNumeroComprobante());
            statement.setString(6, comprobante.getTipoComprobante());
            statement.setBigDecimal(7, comprobante.getSubtotal());
            statement.setBigDecimal(8, comprobante.getImpuesto());
            statement.setBigDecimal(9, comprobante.getTotal());
            statement.setString(10, comprobante.getMetodoPago());
            statement.setString(11, comprobante.getEstado());
            statement.setString(12, comprobante.getObservaciones());
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                keys.next();
                return keys.getInt(1);
            }
        }
    }

    public void saveDetalle(Connection connection, int idComprobante, DetalleComprobante detalle) throws SQLException {
        String sql = """
                INSERT INTO detalle_comprobante
                (id_comprobante, tipo_item, id_producto, descripcion, cantidad, precio_unitario, subtotal)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idComprobante);
            statement.setString(2, detalle.getTipoItem());
            statement.setObject(3, detalle.getIdProducto());
            statement.setString(4, detalle.getDescripcion());
            statement.setInt(5, detalle.getCantidad());
            statement.setBigDecimal(6, detalle.getPrecioUnitario());
            statement.setBigDecimal(7, detalle.getSubtotal());
            statement.executeUpdate();
        }
    }

    public List<Comprobante> list(String fecha, String estado, String search) throws SQLException {
        String sql = """
                SELECT c.*, CONCAT(cl.nombres, ' ', cl.apellidos) AS cliente_nombre,
                       m.nombre AS mascota_nombre,
                       CONCAT(u.nombres, ' ', u.apellidos) AS usuario_nombre
                FROM comprobante c
                INNER JOIN cliente cl ON cl.id_cliente = c.id_cliente
                LEFT JOIN mascota m ON m.id_mascota = c.id_mascota
                INNER JOIN usuario u ON u.id_usuario = c.id_usuario
                WHERE (? IS NULL OR DATE(c.fecha_emision) = ?)
                  AND (? IS NULL OR c.estado = ?)
                  AND (? IS NULL OR c.numero_comprobante LIKE ? OR CONCAT(cl.nombres, ' ', cl.apellidos) LIKE ?)
                ORDER BY c.fecha_emision DESC
                """;
        List<Comprobante> items = new ArrayList<>();
        String like = search == null || search.isBlank() ? null : "%" + search.trim() + "%";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, fecha);
            statement.setString(2, fecha);
            statement.setString(3, estado == null || estado.isBlank() ? null : estado);
            statement.setString(4, estado == null || estado.isBlank() ? null : estado);
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

    public Optional<Comprobante> findById(int idComprobante) throws SQLException {
        String sql = """
                SELECT c.*, CONCAT(cl.nombres, ' ', cl.apellidos) AS cliente_nombre,
                       m.nombre AS mascota_nombre,
                       CONCAT(u.nombres, ' ', u.apellidos) AS usuario_nombre
                FROM comprobante c
                INNER JOIN cliente cl ON cl.id_cliente = c.id_cliente
                LEFT JOIN mascota m ON m.id_mascota = c.id_mascota
                INNER JOIN usuario u ON u.id_usuario = c.id_usuario
                WHERE c.id_comprobante = ?
                """;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idComprobante);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return Optional.empty();
                }
                Comprobante comprobante = map(resultSet);
                comprobante.setDetalles(listDetalles(connection, idComprobante));
                return Optional.of(comprobante);
            }
        }
    }

    public void updateEstado(Connection connection, int idComprobante, String estado) throws SQLException {
        String sql = "UPDATE comprobante SET estado = ? WHERE id_comprobante = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, estado);
            statement.setInt(2, idComprobante);
            statement.executeUpdate();
        }
    }

    public List<DetalleComprobante> listDetalles(Connection connection, int idComprobante) throws SQLException {
        String sql = "SELECT * FROM detalle_comprobante WHERE id_comprobante = ? ORDER BY id_detalle_comprobante";
        List<DetalleComprobante> items = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, idComprobante);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    DetalleComprobante detalle = new DetalleComprobante();
                    detalle.setIdDetalleComprobante(resultSet.getInt("id_detalle_comprobante"));
                    detalle.setIdComprobante(resultSet.getInt("id_comprobante"));
                    detalle.setTipoItem(resultSet.getString("tipo_item"));
                    int idProducto = resultSet.getInt("id_producto");
                    detalle.setIdProducto(resultSet.wasNull() ? null : idProducto);
                    detalle.setDescripcion(resultSet.getString("descripcion"));
                    detalle.setCantidad(resultSet.getInt("cantidad"));
                    detalle.setPrecioUnitario(resultSet.getBigDecimal("precio_unitario"));
                    detalle.setSubtotal(resultSet.getBigDecimal("subtotal"));
                    items.add(detalle);
                }
            }
        }
        return items;
    }

    private Comprobante map(ResultSet resultSet) throws SQLException {
        Comprobante comprobante = new Comprobante();
        comprobante.setIdComprobante(resultSet.getInt("id_comprobante"));
        comprobante.setIdCliente(resultSet.getInt("id_cliente"));
        int idMascota = resultSet.getInt("id_mascota");
        comprobante.setIdMascota(resultSet.wasNull() ? null : idMascota);
        comprobante.setIdUsuario(resultSet.getInt("id_usuario"));
        int idAtencion = resultSet.getInt("id_atencion");
        comprobante.setIdAtencion(resultSet.wasNull() ? null : idAtencion);
        comprobante.setClienteNombre(resultSet.getString("cliente_nombre"));
        comprobante.setMascotaNombre(resultSet.getString("mascota_nombre"));
        comprobante.setUsuarioNombre(resultSet.getString("usuario_nombre"));
        comprobante.setNumeroComprobante(resultSet.getString("numero_comprobante"));
        comprobante.setTipoComprobante(resultSet.getString("tipo_comprobante"));
        comprobante.setFechaEmision(resultSet.getTimestamp("fecha_emision").toLocalDateTime());
        comprobante.setSubtotal(resultSet.getBigDecimal("subtotal"));
        comprobante.setImpuesto(resultSet.getBigDecimal("impuesto"));
        comprobante.setTotal(resultSet.getBigDecimal("total"));
        comprobante.setMetodoPago(resultSet.getString("metodo_pago"));
        comprobante.setEstado(resultSet.getString("estado"));
        comprobante.setObservaciones(resultSet.getString("observaciones"));
        return comprobante;
    }
}
