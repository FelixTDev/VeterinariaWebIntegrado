package com.veterinaria.service;

import com.veterinaria.dao.EspecieDao;
import com.veterinaria.dao.TipoProductoDao;
import com.veterinaria.exception.AppException;
import com.veterinaria.model.Especie;
import com.veterinaria.model.TipoProducto;
import com.veterinaria.util.ValidationUtil;
import java.sql.SQLException;
import java.util.List;

public class CatalogoService {
    private final EspecieDao especieDao = new EspecieDao();
    private final TipoProductoDao tipoProductoDao = new TipoProductoDao();
    private final AuditService auditService = new AuditService();

    public List<Especie> listEspecies() {
        try {
            return especieDao.list();
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar especies.", ex);
        }
    }

    public List<Especie> listEspeciesActivas() {
        try {
            return especieDao.listActive();
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar especies activas.", ex);
        }
    }

    public Especie getEspecie(int id) {
        try {
            return especieDao.findById(id).orElseThrow(() -> new AppException("Especie no encontrada."));
        } catch (SQLException ex) {
            throw new AppException("No fue posible obtener la especie.", ex);
        }
    }

    public void saveEspecie(Especie especie, int actorId) {
        ValidationUtil.notBlank(especie.getNombre(), "El nombre de la especie es obligatorio.");
        if (especie.getEstado() == null || especie.getEstado().isBlank()) {
            especie.setEstado("ACTIVO");
        }
        try {
            especieDao.save(especie);
            auditService.log(actorId, "ESPECIE", "CREAR", "Especie registrada: " + especie.getNombre());
        } catch (SQLException ex) {
            throw new AppException("No fue posible registrar la especie.", ex);
        }
    }

    public void updateEspecie(Especie especie, int actorId) {
        ValidationUtil.notBlank(especie.getNombre(), "El nombre de la especie es obligatorio.");
        try {
            especieDao.update(especie);
            auditService.log(actorId, "ESPECIE", "ACTUALIZAR", "Especie actualizada: " + especie.getNombre());
        } catch (SQLException ex) {
            throw new AppException("No fue posible actualizar la especie.", ex);
        }
    }

    public List<TipoProducto> listTiposProducto() {
        try {
            return tipoProductoDao.list();
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar tipos de producto.", ex);
        }
    }

    public List<TipoProducto> listTiposProductoActivos() {
        try {
            return tipoProductoDao.listActive();
        } catch (SQLException ex) {
            throw new AppException("No fue posible listar tipos de producto activos.", ex);
        }
    }

    public TipoProducto getTipoProducto(int id) {
        try {
            return tipoProductoDao.findById(id).orElseThrow(() -> new AppException("Tipo de producto no encontrado."));
        } catch (SQLException ex) {
            throw new AppException("No fue posible obtener el tipo de producto.", ex);
        }
    }

    public void saveTipoProducto(TipoProducto tipoProducto, int actorId) {
        ValidationUtil.notBlank(tipoProducto.getNombre(), "El nombre del tipo de producto es obligatorio.");
        if (tipoProducto.getEstado() == null || tipoProducto.getEstado().isBlank()) {
            tipoProducto.setEstado("ACTIVO");
        }
        try {
            tipoProductoDao.save(tipoProducto);
            auditService.log(actorId, "TIPO_PRODUCTO", "CREAR", "Tipo de producto registrado: " + tipoProducto.getNombre());
        } catch (SQLException ex) {
            throw new AppException("No fue posible registrar el tipo de producto.", ex);
        }
    }

    public void updateTipoProducto(TipoProducto tipoProducto, int actorId) {
        ValidationUtil.notBlank(tipoProducto.getNombre(), "El nombre del tipo de producto es obligatorio.");
        try {
            tipoProductoDao.update(tipoProducto);
            auditService.log(actorId, "TIPO_PRODUCTO", "ACTUALIZAR", "Tipo de producto actualizado: " + tipoProducto.getNombre());
        } catch (SQLException ex) {
            throw new AppException("No fue posible actualizar el tipo de producto.", ex);
        }
    }
}
