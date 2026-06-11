package com.veterinaria.service;

import com.veterinaria.dao.AuditoriaDao;
import com.veterinaria.model.Auditoria;
import java.sql.Connection;
import java.sql.SQLException;

public class AuditService {
    private final AuditoriaDao auditoriaDao = new AuditoriaDao();

    public void log(Integer idUsuario, String modulo, String accion, String descripcion) {
        Auditoria auditoria = new Auditoria();
        auditoria.setIdUsuario(idUsuario);
        auditoria.setModulo(modulo);
        auditoria.setAccion(accion);
        auditoria.setDescripcion(descripcion);
        try {
            auditoriaDao.save(auditoria);
        } catch (SQLException ignored) {
        }
    }

    public void log(Connection connection, Integer idUsuario, String modulo, String accion, String descripcion)
            throws SQLException {
        Auditoria auditoria = new Auditoria();
        auditoria.setIdUsuario(idUsuario);
        auditoria.setModulo(modulo);
        auditoria.setAccion(accion);
        auditoria.setDescripcion(descripcion);
        auditoriaDao.save(connection, auditoria);
    }
}
