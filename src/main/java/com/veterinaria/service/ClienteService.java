package com.veterinaria.service;

import com.veterinaria.dao.ClienteDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.Cliente;
import com.veterinaria.util.ValidationUtil;
import java.sql.SQLException;
import java.util.List;

public class ClienteService {
    private final ClienteDao clienteDao;
    private final AuditService auditService;

    public ClienteService() {
        this(new ClienteDao(), new AuditService());
    }

    ClienteService(ClienteDao clienteDao, AuditService auditService) {
        this.clienteDao = clienteDao;
        this.auditService = auditService;
    }

    public List<Cliente> list(String search) {
        try {
            return clienteDao.list(search);
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar clientes.", ex);
        }
    }

    public List<Cliente> listActive() {
        try {
            return clienteDao.listActive();
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar clientes activos.", ex);
        }
    }

    public Cliente get(int id) {
        try {
            return clienteDao.findById(id).orElseThrow(() -> new AppException("Cliente no encontrado."));
        } catch (SQLException ex) {
            throw new AppException("No fue posible obtener el cliente.", ex);
        }
    }

    public void save(Cliente cliente, int actorId) {
        validate(cliente, null);
        try {
            clienteDao.save(cliente);
            auditService.log(actorId, "CLIENTE", "CREAR", "Cliente registrado: " + cliente.getDni());
        } catch (SQLException ex) {
            throw new AppException("No fue posible registrar el cliente.", ex);
        }
    }

    public void update(Cliente cliente, int actorId) {
        validate(cliente, cliente.getIdCliente());
        try {
            clienteDao.update(cliente);
            auditService.log(actorId, "CLIENTE", "ACTUALIZAR", "Cliente actualizado: " + cliente.getDni());
        } catch (SQLException ex) {
            throw new AppException("No fue posible actualizar el cliente.", ex);
        }
    }

    private void validate(Cliente cliente, Integer excludeId) {
        ValidationUtil.notBlank(cliente.getNombres(), "Los nombres del cliente son obligatorios.");
        ValidationUtil.notBlank(cliente.getApellidos(), "Los apellidos del cliente son obligatorios.");
        ValidationUtil.notBlank(cliente.getDni(), "El DNI del cliente es obligatorio.");
        ValidationUtil.notBlank(cliente.getTelefono(), "El teléfono del cliente es obligatorio.");
        ValidationUtil.notBlank(cliente.getDireccion(), "La dirección del cliente es obligatoria.");
        if (cliente.getEstado() == null || cliente.getEstado().isBlank()) {
            cliente.setEstado("ACTIVO");
        }
        try {
            if (clienteDao.existsByDni(cliente.getDni(), excludeId)) {
                throw new AppException("Ya existe un cliente con ese DNI.");
            }
            if (clienteDao.existsByCorreo(cliente.getCorreo(), excludeId)) {
                throw new AppException("Ya existe un cliente con ese correo.");
            }
        } catch (SQLException ex) {
            throw new AppException("No fue posible validar los datos del cliente.", ex);
        }
    }
}
