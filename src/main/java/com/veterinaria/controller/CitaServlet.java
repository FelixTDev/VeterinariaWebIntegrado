package com.veterinaria.controller;

import com.veterinaria.exception.AppException;
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
import java.time.format.DateTimeParseException;

@WebServlet("/app/citas")
public class CitaServlet extends BaseServlet {
    private final CitaService citaService = new CitaService();
    private final ClienteService clienteService = new ClienteService();
    private final MascotaService mascotaService = new MascotaService();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        prepareRequest(request, response);
        try {
            if ("edit".equalsIgnoreCase(request.getParameter("action"))) {
                request.setAttribute("cita", citaService.get(parseRequiredInt(request, "id", "La cita a editar no es válida.")));
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
        prepareRequest(request, response);
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
            request.setAttribute("cita", safeBuildCita(request));
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
        cita.setIdCita(parseOptionalInt(request, "idCita", 0, "El identificador de la cita no es válido."));
        cita.setIdCliente(parseRequiredInt(request, "idCliente", "Selecciona un cliente válido."));
        cita.setIdMascota(parseRequiredInt(request, "idMascota", "Selecciona una mascota válida."));
        int idVeterinario = parseOptionalInt(request, "idVeterinario", 0, "Selecciona un veterinario válido.");
        cita.setIdVeterinario(idVeterinario > 0 ? idVeterinario : null);
        cita.setFechaCita(parseRequiredDate(request, "fechaCita", "Ingresa una fecha de cita válida."));
        cita.setHoraCita(parseRequiredTime(request, "horaCita", "Ingresa una hora de cita válida."));
        cita.setMotivo(request.getParameter("motivo"));
        cita.setObservaciones(request.getParameter("observaciones"));
        cita.setEstado(request.getParameter("estado"));
        return cita;
    }

    private Cita safeBuildCita(HttpServletRequest request) {
        try {
            return buildCita(request);
        } catch (AppException ex) {
            return new Cita();
        }
    }

    private int parseRequiredInt(HttpServletRequest request, String parameter, String message) {
        return parseInt(request.getParameter(parameter), message);
    }

    private int parseOptionalInt(HttpServletRequest request, String parameter, int defaultValue, String message) {
        String value = request.getParameter(parameter);
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        return parseInt(value, message);
    }

    private int parseInt(String value, String message) {
        try {
            return Integer.parseInt(value);
        } catch (Exception ex) {
            throw new AppException(message);
        }
    }

    private LocalDate parseRequiredDate(HttpServletRequest request, String parameter, String message) {
        try {
            return LocalDate.parse(request.getParameter(parameter));
        } catch (DateTimeParseException | NullPointerException ex) {
            throw new AppException(message);
        }
    }

    private LocalTime parseRequiredTime(HttpServletRequest request, String parameter, String message) {
        try {
            return LocalTime.parse(request.getParameter(parameter));
        } catch (DateTimeParseException | NullPointerException ex) {
            throw new AppException(message);
        }
    }
}
