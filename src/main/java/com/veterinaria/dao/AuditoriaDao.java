package com.veterinaria.dao;

import com.veterinaria.model.Auditoria;
import com.veterinaria.util.Database;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AuditoriaDao {
    public void save(Auditoria auditoria) throws SQLException {
        try (Connection connection = Database.getConnection()) {
            save(connection, auditoria);
        }
    }

    public void save(Connection connection, Auditoria auditoria) throws SQLException {
        String sql = "INSERT INTO auditoria (id_usuario, modulo, accion, descripcion) VALUES (?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setObject(1, auditoria.getIdUsuario());
            statement.setString(2, auditoria.getModulo());
            statement.setString(3, auditoria.getAccion());
            statement.setString(4, auditoria.getDescripcion());
            statement.executeUpdate();
        }
    }
}
