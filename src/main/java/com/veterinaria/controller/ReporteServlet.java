package com.veterinaria.controller;

import com.veterinaria.exception.AppException;
import com.veterinaria.service.ReporteService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/app/reportes")
public class ReporteServlet extends BaseServlet {
    private final ReporteService reporteService = new ReporteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        prepareRequest(request, response);
        try {
            LocalDate hasta = parseOptionalDate(request.getParameter("hasta"), LocalDate.now(), "La fecha hasta no es válida.");
            LocalDate desde = parseOptionalDate(request.getParameter("desde"), hasta.minusDays(30), "La fecha desde no es válida.");
            if (desde.isAfter(hasta)) {
                throw new AppException("La fecha desde no puede ser mayor que la fecha hasta.");
            }
            request.setAttribute("desde", desde.toString());
            request.setAttribute("hasta", hasta.toString());
            request.setAttribute("citasRango", reporteService.citasPorRango(desde.toString(), hasta.toString()));
            request.setAttribute("ingresosRango", reporteService.ingresosPorRango(desde.toString(), hasta.toString()));
            request.setAttribute("bajoStock", reporteService.bajoStock());
            request.setAttribute("porVencer", reporteService.porVencer(30));
            request.setAttribute("movimientos", reporteService.movimientosRecientes());
            WebUtil.forward(request, response, "reportes.jsp");
        } catch (AppException ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("desde", request.getParameter("desde"));
            request.setAttribute("hasta", request.getParameter("hasta"));
            request.setAttribute("citasRango", java.util.List.of());
            request.setAttribute("ingresosRango", java.util.List.of());
            request.setAttribute("bajoStock", reporteService.bajoStock());
            request.setAttribute("porVencer", reporteService.porVencer(30));
            request.setAttribute("movimientos", reporteService.movimientosRecientes());
            WebUtil.forward(request, response, "reportes.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }

    private LocalDate parseOptionalDate(String value, LocalDate defaultValue, String message) {
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        try {
            return LocalDate.parse(value);
        } catch (DateTimeParseException ex) {
            throw new AppException(message);
        }
    }
}
