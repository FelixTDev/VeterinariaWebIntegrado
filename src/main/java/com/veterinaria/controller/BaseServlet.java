package com.veterinaria.controller;

import com.veterinaria.exception.AppException;
import com.veterinaria.model.UserSession;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;

public abstract class BaseServlet extends HttpServlet {
    protected UserSession getUserSession(HttpServletRequest request) {
        return (UserSession) request.getSession().getAttribute("userSession");
    }

    protected void requireRoles(HttpServletRequest request, String... roles) {
        UserSession user = getUserSession(request);
        if (user == null || Arrays.stream(roles).noneMatch(role -> role.equalsIgnoreCase(user.getRolNombre()))) {
            throw new AppException("No tienes permisos para realizar esta acción.");
        }
    }

    protected void handleException(HttpServletRequest request, HttpServletResponse response, Exception ex)
            throws ServletException, IOException {
        request.setAttribute("error", ex.getMessage());
        WebUtil.forward(request, response, "error.jsp");
    }
}
