package com.veterinaria.model;

import java.io.Serializable;

public class UserSession implements Serializable {
    private final int idUsuario;
    private final int idRol;
    private final String username;
    private final String nombreCompleto;
    private final String rolNombre;

    public UserSession(int idUsuario, int idRol, String username, String nombreCompleto, String rolNombre) {
        this.idUsuario = idUsuario;
        this.idRol = idRol;
        this.username = username;
        this.nombreCompleto = nombreCompleto;
        this.rolNombre = rolNombre;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public int getIdRol() {
        return idRol;
    }

    public String getUsername() {
        return username;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public String getRolNombre() {
        return rolNombre;
    }
}
