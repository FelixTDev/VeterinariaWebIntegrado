package com.veterinaria.controller;

import com.veterinaria.model.Cita;
import com.veterinaria.service.AuthService;
import com.veterinaria.service.CitaService;
import com.veterinaria.service.ClienteService;
import com.veterinaria.service.MascotaService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/app/citas")
public class CitaServlet extends BaseServlet {
    private final CitaService citaService = new CitaService();
    private final ClienteService clienteService = new ClienteService();
    private final MascotaService mascotaService = new MascotaService();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            if ("edit".equalsIgnoreCase(request.getParameter("action"))) {
                request.setAttribute("cita", citaService.get(WebUtil.getInt(request, "id", 0)));
            }
            request.setAttribute("citas", citaService.list(request.getParameter("fecha"), request.getParameter("estado"), request.getParameter("search")));
            loadCatalogs(request);
            WebUtil.forward(request, response, "citas.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            requireRoles(request, "ADMINISTRADOR", "RECEPCIONISTA");
            Cita cita = buildCita(request);
            if (cita.getIdCita() > 0) {
                citaService.update(cita, getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Cita actualizada correctamente.");
            } else {
                citaService.save(cita, getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Cita registrada correctamente.");
            }
            WebUtil.redirect(request, response, "/app/citas");
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("cita", buildCita(request));
            request.setAttribute("citas", citaService.list(request.getParameter("fecha"), request.getParameter("estado"), request.getParameter("search")));
            loadCatalogs(request);
            WebUtil.forward(request, response, "citas.jsp");
        }
    }

    private void loadCatalogs(HttpServletRequest request) {
        request.setAttribute("clientes", clienteService.listActive());
        request.setAttribute("mascotas", mascotaService.list(null));
        request.setAttribute("veterinarios", authService.listVeterinarios());
    }

    private Cita buildCita(HttpServletRequest request) {
        Cita cita = new Cita();
        cita.setIdCita(WebUtil.getInt(request, "idCita", 0));
        cita.setIdCliente(WebUtil.getInt(request, "idCliente", 0));
        cita.setIdMascota(WebUtil.getInt(request, "idMascota", 0));
        int idVeterinario = WebUtil.getInt(request, "idVeterinario", 0);
        cita.setIdVeterinario(idVeterinario > 0 ? idVeterinario : null);
        cita.setFechaCita(LocalDate.parse(request.getParameter("fechaCita")));
        cita.setHoraCita(LocalTime.parse(request.getParameter("horaCita")));
        cita.setMotivo(request.getParameter("motivo"));
        cita.setObservaciones(request.getParameter("observaciones"));
        cita.setEstado(request.getParameter("estado"));
        return cita;
    }
}
