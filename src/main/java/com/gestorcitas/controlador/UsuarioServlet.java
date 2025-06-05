package com.gestorcitas.controlador;

import com.gestorcitas.modelo.Usuario;
import com.gestorcitas.dao.UsuarioDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/admin/usuario/usuarios", "/admin/usuario/usuarios/*"})
public class UsuarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todos los usuarios
                List<Usuario> usuarios = usuarioDAO.listarTodos();
                request.setAttribute("usuarios", usuarios);
                request.getRequestDispatcher("/vistas/admin/usuario/usuarios.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los usuarios: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/usuario/usuarios.jsp").forward(request, response);
        }
    }
} 