package com.veterinaria.service;

import com.veterinaria.dao.CitaDao;
import com.veterinaria.dao.ClienteDao;
import com.veterinaria.dao.MascotaDao;
import com.veterinaria.dao.UserDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.Cita;
import com.veterinaria.util.ValidationUtil;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;

public class CitaService {
    private static final Set<String> ESTADOS_VALIDOS = Set.of("PENDIENTE", "CONFIRMADA", "ATENDIDA", "CANCELADA", "NO_ASISTIO");

    private final CitaDao citaDao = new CitaDao();
    private final ClienteDao clienteDao = new ClienteDao();
    private final MascotaDao mascotaDao = new MascotaDao();
    private final UserDao userDao = new UserDao();
    private final AuditService auditService = new AuditService();

    public List<Cita> list(String fecha, String estado, String search) {
        try {
            return citaDao.list(fecha, estado, search);
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar citas.", ex);
        }
    }

    public Cita get(int id) {
        try {
            return citaDao.findById(id).orElseThrow(() -> new AppException("Cita no encontrada."));
        } catch (SQLException ex) {
            throw new AppException("No fue posible obtener la cita.", ex);
        }
    }

    public void save(Cita cita, int actorId) {
        validate(cita);
        try {
            if (citaDao.existsScheduleConflict(cita)) {
                throw new AppException("El veterinario ya tiene una cita activa en ese horario.");
            }
            citaDao.save(cita);
            auditService.log(actorId, "CITA", "CREAR", "Cita registrada para mascota " + cita.getIdMascota());
        } catch (SQLException ex) {
            throw new AppException("No fue posible registrar la cita.", ex);
        }
    }

    public void update(Cita cita, int actorId) {
        validate(cita);
        try {
            if (citaDao.existsScheduleConflict(cita)) {
                throw new AppException("El veterinario ya tiene una cita activa en ese horario.");
            }
            citaDao.update(cita);
            auditService.log(actorId, "CITA", "ACTUALIZAR", "Cita actualizada #" + cita.getIdCita());
        } catch (SQLException ex) {
            throw new AppException("No fue posible actualizar la cita.", ex);
        }
    }

    private void validate(Cita cita) {
        ValidationUtil.require(cita.getIdCliente() > 0, "La cita debe tener cliente.");
        ValidationUtil.require(cita.getIdMascota() > 0, "La cita debe tener mascota.");
        ValidationUtil.futureOrToday(cita.getFechaCita(), "No se puede registrar una cita en una fecha pasada.");
        ValidationUtil.notNull(cita.getHoraCita(), "La hora de la cita es obligatoria.");
        ValidationUtil.notBlank(cita.getMotivo(), "El motivo de la cita es obligatorio.");
        if (cita.getEstado() == null || cita.getEstado().isBlank()) {
            cita.setEstado("PENDIENTE");
        }
        ValidationUtil.require(ESTADOS_VALIDOS.contains(cita.getEstado()), "Estado de cita inválido.");
        try {
            clienteDao.findById(cita.getIdCliente()).orElseThrow(() -> new AppException("Cliente no encontrado."));
            mascotaDao.findById(cita.getIdMascota()).orElseThrow(() -> new AppException("Mascota no encontrada."));
            if (cita.getIdVeterinario() != null && cita.getIdVeterinario() > 0) {
                userDao.findById(cita.getIdVeterinario())
                        .filter(usuario -> "VETERINARIO".equalsIgnoreCase(usuario.getRolNombre()))
                        .orElseThrow(() -> new AppException("Veterinario no encontrado."));
            }
        } catch (SQLException ex) {
            throw new AppException("No fue posible validar la cita.", ex);
        }
    }
}
