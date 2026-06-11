package com.veterinaria.controller;

import com.veterinaria.model.Mascota;
import com.veterinaria.service.CatalogoService;
import com.veterinaria.service.ClienteService;
import com.veterinaria.service.MascotaService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet("/app/mascotas")
public class MascotaServlet extends BaseServlet {
    private final MascotaService mascotaService = new MascotaService();
    private final ClienteService clienteService = new ClienteService();
    private final CatalogoService catalogoService = new CatalogoService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if ("edit".equalsIgnoreCase(action)) {
                request.setAttribute("mascota", mascotaService.get(WebUtil.getInt(request, "id", 0)));
            }
            request.setAttribute("mascotas", mascotaService.list(request.getParameter("search")));
            loadCatalogs(request);
            WebUtil.forward(request, response, "mascotas.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            requireRoles(request, "ADMINISTRADOR", "RECEPCIONISTA");
            Mascota mascota = buildMascota(request);
            if (mascota.getIdMascota() > 0) {
                mascotaService.update(mascota, getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Mascota actualizada correctamente.");
            } else {
                mascotaService.save(mascota, getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Mascota registrada correctamente.");
            }
            WebUtil.redirect(request, response, "/app/mascotas");
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("mascota", buildMascota(request));
            request.setAttribute("mascotas", mascotaService.list(request.getParameter("search")));
            loadCatalogs(request);
            WebUtil.forward(request, response, "mascotas.jsp");
        }
    }

    private void loadCatalogs(HttpServletRequest request) {
        request.setAttribute("clientes", clienteService.listActive());
        request.setAttribute("especies", catalogoService.listEspeciesActivas());
    }

    private Mascota buildMascota(HttpServletRequest request) {
        Mascota mascota = new Mascota();
        mascota.setIdMascota(WebUtil.getInt(request, "idMascota", 0));
        mascota.setIdCliente(WebUtil.getInt(request, "idCliente", 0));
        mascota.setIdEspecie(WebUtil.getInt(request, "idEspecie", 0));
        mascota.setNombre(request.getParameter("nombre"));
        mascota.setRaza(request.getParameter("raza"));
        mascota.setSexo(request.getParameter("sexo"));
        mascota.setColor(request.getParameter("color"));
        if (request.getParameter("fechaNacimiento") != null && !request.getParameter("fechaNacimiento").isBlank()) {
            mascota.setFechaNacimiento(LocalDate.parse(request.getParameter("fechaNacimiento")));
        }
        if (request.getParameter("peso") != null && !request.getParameter("peso").isBlank()) {
            mascota.setPeso(new BigDecimal(request.getParameter("peso")));
        }
        mascota.setObservaciones(request.getParameter("observaciones"));
        mascota.setEstado(request.getParameter("estado"));
        return mascota;
    }
}
