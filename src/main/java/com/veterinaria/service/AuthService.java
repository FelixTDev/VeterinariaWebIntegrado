package com.veterinaria.service;

import com.veterinaria.dao.UserDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.UserSession;
import com.veterinaria.model.Usuario;
import com.veterinaria.util.PasswordUtil;
import com.veterinaria.util.ValidationUtil;
import java.sql.SQLException;
import java.util.List;

public class AuthService {
    private final UserDao userDao = new UserDao();
    private final AuditService auditService = new AuditService();

    public UserSession login(String username, String password) {
        ValidationUtil.notBlank(username, "Ingresa tu usuario.");
        ValidationUtil.notBlank(password, "Ingresa tu contraseña.");
        try {
            Usuario usuario = userDao.findByUsername(username)
                    .orElseThrow(() -> new AppException("Usuario o contraseña inválidos."));
            if (!"ACTIVO".equalsIgnoreCase(usuario.getEstado())) {
                throw new AppException("El usuario no está activo.");
            }
            if (!PasswordUtil.matches(password, usuario.getPasswordHash())) {
                throw new AppException("Usuario o contraseña inválidos.");
            }
            if (PasswordUtil.isLegacyPlainText(usuario.getPasswordHash())) {
                userDao.updatePasswordHash(usuario.getIdUsuario(), PasswordUtil.hash(password));
            }
            auditService.log(usuario.getIdUsuario(), "SEGURIDAD", "LOGIN", "Inicio de sesión de " + usuario.getUsername());
            return new UserSession(
                    usuario.getIdUsuario(),
                    usuario.getIdRol(),
                    usuario.getUsername(),
                    usuario.getNombreCompleto(),
                    usuario.getRolNombre()
            );
        } catch (SQLException ex) {
            throw new AppException("No fue posible validar el usuario.", ex);
        }
    }

    public List<Usuario> listVeterinarios() {
        try {
            return userDao.listVeterinarios();
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar veterinarios.", ex);
        }
    }
}
