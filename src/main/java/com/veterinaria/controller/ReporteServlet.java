package com.veterinaria.controller;

import com.veterinaria.service.ReporteService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/app/reportes")
public class ReporteServlet extends BaseServlet {
    private final ReporteService reporteService = new ReporteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String desde = request.getParameter("desde");
            String hasta = request.getParameter("hasta");
            if (desde == null || desde.isBlank()) {
                desde = LocalDate.now().minusDays(30).toString();
            }
            if (hasta == null || hasta.isBlank()) {
                hasta = LocalDate.now().toString();
            }
            request.setAttribute("desde", desde);
            request.setAttribute("hasta", hasta);
            request.setAttribute("citasRango", reporteService.citasPorRango(desde, hasta));
            request.setAttribute("ingresosRango", reporteService.ingresosPorRango(desde, hasta));
            request.setAttribute("bajoStock", reporteService.bajoStock());
            request.setAttribute("porVencer", reporteService.porVencer(30));
            request.setAttribute("movimientos", reporteService.movimientosRecientes());
            WebUtil.forward(request, response, "reportes.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }
}
