package com.veterinaria.controller;

import com.veterinaria.model.Especie;
import com.veterinaria.model.TipoProducto;
import com.veterinaria.service.CatalogoService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/app/catalogos")
public class CatalogoServlet extends BaseServlet {
    private final CatalogoService catalogoService = new CatalogoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String tipo = request.getParameter("tipo");
            int id = WebUtil.getInt(request, "id", 0);
            if ("especie".equalsIgnoreCase(tipo) && id > 0) {
                request.setAttribute("especie", catalogoService.getEspecie(id));
            }
            if ("tipoProducto".equalsIgnoreCase(tipo) && id > 0) {
                request.setAttribute("tipoProducto", catalogoService.getTipoProducto(id));
            }
            request.setAttribute("especies", catalogoService.listEspecies());
            request.setAttribute("tiposProducto", catalogoService.listTiposProducto());
            WebUtil.forward(request, response, "catalogos.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            requireRoles(request, "ADMINISTRADOR");
            String form = request.getParameter("formType");
            if ("especie".equals(form)) {
                Especie especie = new Especie();
                especie.setIdEspecie(WebUtil.getInt(request, "idEspecie", 0));
                especie.setNombre(request.getParameter("nombreEspecie"));
                especie.setDescripcion(request.getParameter("descripcionEspecie"));
                especie.setEstado(request.getParameter("estadoEspecie"));
                if (especie.getIdEspecie() > 0) {
                    catalogoService.updateEspecie(especie, getUserSession(request).getIdUsuario());
                } else {
                    catalogoService.saveEspecie(especie, getUserSession(request).getIdUsuario());
                }
            }
            if ("tipoProducto".equals(form)) {
                TipoProducto tipoProducto = new TipoProducto();
                tipoProducto.setIdTipoProducto(WebUtil.getInt(request, "idTipoProducto", 0));
                tipoProducto.setNombre(request.getParameter("nombreTipoProducto"));
                tipoProducto.setDescripcion(request.getParameter("descripcionTipoProducto"));
                tipoProducto.setEstado(request.getParameter("estadoTipoProducto"));
                if (tipoProducto.getIdTipoProducto() > 0) {
                    catalogoService.updateTipoProducto(tipoProducto, getUserSession(request).getIdUsuario());
                } else {
                    catalogoService.saveTipoProducto(tipoProducto, getUserSession(request).getIdUsuario());
                }
            }
            request.getSession().setAttribute("flash", "Catálogo actualizado correctamente.");
            WebUtil.redirect(request, response, "/app/catalogos");
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("especies", catalogoService.listEspecies());
            request.setAttribute("tiposProducto", catalogoService.listTiposProducto());
            WebUtil.forward(request, response, "catalogos.jsp");
        }
    }
}
