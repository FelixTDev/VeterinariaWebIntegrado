package com.veterinaria.controller;

import com.veterinaria.exception.AppException;
import com.veterinaria.service.AuthService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/", "/login"})
public class LoginServlet extends BaseServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (getUserSession(request) != null) {
            WebUtil.redirect(request, response, "/app/dashboard");
            return;
        }
        WebUtil.forward(request, response, "login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            var userSession = authService.login(request.getParameter("username"), request.getParameter("password"));
            request.getSession().setAttribute("userSession", userSession);
            WebUtil.redirect(request, response, "/app/dashboard");
        } catch (AppException ex) {
            request.setAttribute("error", ex.getMessage());
            WebUtil.forward(request, response, "login.jsp");
        }
    }
}
