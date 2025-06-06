package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.gestorcitas.dao.UsuarioDAO;
import com.gestorcitas.modelo.Usuario;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirigir al formulario de login
        request.getRequestDispatcher("/vistas/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            Usuario usuario = usuarioDAO.validarUsuario(username, password);
            
            if (usuario != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuario", usuario);
                
                // Redirigir según el rol
                switch (usuario.getRol().toLowerCase()) {
                    case "admin":
                        response.sendRedirect(request.getContextPath() + "/admin/inicio");
                        break;
                    case "doctor":
                        response.sendRedirect(request.getContextPath() + "/medico/inicio");
                        break;
                    case "recepcionista":
                        response.sendRedirect(request.getContextPath() + "/recepcionista/inicio");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp?error=rol_invalido");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/vistas/login.jsp?error=credenciales_invalidas");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp?error=error_sistema");
        }
    }
} 