package com.veterinaria.controller;

import com.veterinaria.service.ReporteService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/app/dashboard")
public class DashboardServlet extends BaseServlet {
    private final ReporteService reporteService = new ReporteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("stats", reporteService.dashboard());
        request.setAttribute("movimientos", reporteService.movimientosRecientes());
        request.setAttribute("bajoStockItems", reporteService.bajoStock());
        WebUtil.forward(request, response, "dashboard.jsp");
    }
}
