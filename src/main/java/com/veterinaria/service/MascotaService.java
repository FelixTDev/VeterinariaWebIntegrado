package com.veterinaria.service;

import com.veterinaria.dao.ClienteDao;
import com.veterinaria.dao.EspecieDao;
import com.veterinaria.dao.MascotaDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.Mascota;
import com.veterinaria.util.ValidationUtil;
import java.sql.SQLException;
import java.util.List;

public class MascotaService {
    private final MascotaDao mascotaDao = new MascotaDao();
    private final ClienteDao clienteDao = new ClienteDao();
    private final EspecieDao especieDao = new EspecieDao();
    private final AuditService auditService = new AuditService();

    public List<Mascota> list(String search) {
        try {
            return mascotaDao.list(search);
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar mascotas.", ex);
        }
    }

    public Mascota get(int id) {
        try {
            return mascotaDao.findById(id).orElseThrow(() -> new AppException("Mascota no encontrada."));
        } catch (SQLException ex) {
            throw new AppException("No fue posible obtener la mascota.", ex);
        }
    }

    public List<Mascota> listByCliente(int idCliente) {
        try {
            return mascotaDao.listByCliente(idCliente);
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar mascotas por cliente.", ex);
        }
    }

    public void save(Mascota mascota, int actorId) {
        validate(mascota);
        try {
            mascotaDao.save(mascota);
            auditService.log(actorId, "MASCOTA", "CREAR", "Mascota registrada: " + mascota.getNombre());
        } catch (SQLException ex) {
            throw new AppException("No fue posible registrar la mascota.", ex);
        }
    }

    public void update(Mascota mascota, int actorId) {
        validate(mascota);
        try {
            mascotaDao.update(mascota);
            auditService.log(actorId, "MASCOTA", "ACTUALIZAR", "Mascota actualizada: " + mascota.getNombre());
        } catch (SQLException ex) {
            throw new AppException("No fue posible actualizar la mascota.", ex);
        }
    }

    private void validate(Mascota mascota) {
        ValidationUtil.notBlank(mascota.getNombre(), "El nombre de la mascota es obligatorio.");
        ValidationUtil.require(mascota.getIdCliente() > 0, "La mascota debe tener un cliente responsable.");
        ValidationUtil.require(mascota.getIdEspecie() > 0, "La mascota debe tener una especie válida.");
        try {
            clienteDao.findById(mascota.getIdCliente()).orElseThrow(() -> new AppException("Cliente no encontrado."));
            especieDao.findById(mascota.getIdEspecie())
                    .filter(especie -> "ACTIVO".equalsIgnoreCase(especie.getEstado()))
                    .orElseThrow(() -> new AppException("La especie seleccionada no está disponible."));
        } catch (SQLException ex) {
            throw new AppException("No fue posible validar la mascota.", ex);
        }
        if (mascota.getEstado() == null || mascota.getEstado().isBlank()) {
            mascota.setEstado("ACTIVO");
        }
        if (mascota.getSexo() == null || mascota.getSexo().isBlank()) {
            mascota.setSexo("NO_DEFINIDO");
        }
    }
}
