package com.veterinaria.util;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public final class WebUtil {
    private WebUtil() {
    }

    public static void forward(HttpServletRequest request, HttpServletResponse response, String view)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/" + view);
        dispatcher.forward(request, response);
    }

    public static void redirect(HttpServletRequest request, HttpServletResponse response, String path)
            throws IOException {
        response.sendRedirect(request.getContextPath() + path);
    }

    public static int getInt(HttpServletRequest request, String parameter, int defaultValue) {
        String raw = request.getParameter(parameter);
        if (raw == null || raw.isBlank()) {
            return defaultValue;
        }
        return Integer.parseInt(raw);
    }
}
