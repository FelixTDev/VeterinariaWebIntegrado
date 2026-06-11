package com.veterinaria.controller;

import com.veterinaria.model.Cliente;
import com.veterinaria.service.ClienteService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/app/clientes")
public class ClienteServlet extends BaseServlet {
    private final ClienteService clienteService = new ClienteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if ("edit".equalsIgnoreCase(action)) {
                request.setAttribute("cliente", clienteService.get(WebUtil.getInt(request, "id", 0)));
            }
            request.setAttribute("clientes", clienteService.list(request.getParameter("search")));
            WebUtil.forward(request, response, "clientes.jsp");
        } catch (Exception ex) {
            handleException(request, response, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            requireRoles(request, "ADMINISTRADOR", "RECEPCIONISTA");
            Cliente cliente = buildCliente(request);
            if (cliente.getIdCliente() > 0) {
                clienteService.update(cliente, getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Cliente actualizado correctamente.");
            } else {
                clienteService.save(cliente, getUserSession(request).getIdUsuario());
                request.getSession().setAttribute("flash", "Cliente registrado correctamente.");
            }
            WebUtil.redirect(request, response, "/app/clientes");
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("cliente", buildCliente(request));
            request.setAttribute("clientes", clienteService.list(request.getParameter("search")));
            WebUtil.forward(request, response, "clientes.jsp");
        }
    }

    private Cliente buildCliente(HttpServletRequest request) {
        Cliente cliente = new Cliente();
        cliente.setIdCliente(WebUtil.getInt(request, "idCliente", 0));
        cliente.setNombres(request.getParameter("nombres"));
        cliente.setApellidos(request.getParameter("apellidos"));
        cliente.setDni(request.getParameter("dni"));
        cliente.setTelefono(request.getParameter("telefono"));
        cliente.setCorreo(request.getParameter("correo"));
        cliente.setDireccion(request.getParameter("direccion"));
        cliente.setEstado(request.getParameter("estado"));
        return cliente;
    }
}
