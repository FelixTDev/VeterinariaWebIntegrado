package com.veterinaria.controller;

import com.veterinaria.model.Cliente;
import com.veterinaria.service.ClienteService;
import com.veterinaria.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/app/clientes")
public class ClienteServlet extends BaseServlet {
    private final ClienteService clienteService = new ClienteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            boolean openModal = false;
            if ("edit".equalsIgnoreCase(action)) {
                request.setAttribute("cliente", clienteService.get(WebUtil.getInt(request, "id", 0)));
                openModal = true;
            }
            List<Cliente> clientes = clienteService.list(request.getParameter("search"));
            request.setAttribute("clientes", clientes);
            request.setAttribute("openClienteModal", openModal);
            populateStats(request, clientes);
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
            List<Cliente> clientes = clienteService.list(request.getParameter("search"));
            request.setAttribute("clientes", clientes);
            request.setAttribute("openClienteModal", true);
            populateStats(request, clientes);
            WebUtil.forward(request, response, "clientes.jsp");
        }
    }

    private void populateStats(HttpServletRequest request, List<Cliente> clientes) {
        int total = clientes.size();
        int activos = 0;
        int nuevosMes = 0;
        LocalDate hoy = LocalDate.now();

        for (Cliente cliente : clientes) {
            if ("ACTIVO".equalsIgnoreCase(cliente.getEstado())) {
                activos++;
            }
            if (cliente.getFechaRegistro() != null
                    && cliente.getFechaRegistro().getYear() == hoy.getYear()
                    && cliente.getFechaRegistro().getMonthValue() == hoy.getMonthValue()) {
                nuevosMes++;
            }
        }

        request.setAttribute("statsTotalClientes", total);
        request.setAttribute("statsClientesActivos", activos);
        request.setAttribute("statsClientesInactivos", total - activos);
        request.setAttribute("statsClientesNuevosMes", nuevosMes);
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
