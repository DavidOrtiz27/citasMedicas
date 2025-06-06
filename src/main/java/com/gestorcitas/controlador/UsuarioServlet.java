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

@WebServlet(urlPatterns = {
    "/admin/usuario/usuarios",      // GET: Listar usuarios
    "/admin/usuario/usuarios/*",    // GET: Ver detalles de usuario
    "/admin/usuario/crear",         // POST: Crear usuario
    "/admin/usuario/nuevo",         // GET: Mostrar formulario de creación
    "/admin/usuario/editar/*",      // GET/POST: Editar usuario
    "/admin/usuario/eliminar/*",    // POST: Eliminar usuario
    "/admin/usuario/*"              // GET: Ver detalles de usuario (ruta alternativa)
})
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
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        System.out.println("doGet - requestURI: " + requestURI);
        System.out.println("doGet - contextPath: " + contextPath);
        System.out.println("doGet - path: " + path);
        
        try {
            // Manejar la ruta /admin/usuario/7
            if (path.matches("/admin/usuario/\\d+")) {
                String idStr = path.substring("/admin/usuario/".length());
                int id = Integer.parseInt(idStr);
                Usuario usuario = usuarioDAO.buscarPorId(id);
                
                if (usuario != null) {
                    request.setAttribute("usuario", usuario);
                    request.getRequestDispatcher("/vistas/admin/usuario/detallesUsuario.jsp").forward(request, response);
                    return;
                }
            }
            
            // Manejar la ruta /admin/usuario/usuarios/7
            if (path.matches("/admin/usuario/usuarios/\\d+")) {
                String idStr = path.substring("/admin/usuario/usuarios/".length());
                int id = Integer.parseInt(idStr);
                Usuario usuario = usuarioDAO.buscarPorId(id);
                
                if (usuario != null) {
                    request.setAttribute("usuario", usuario);
                    request.getRequestDispatcher("/vistas/admin/usuario/detallesUsuario.jsp").forward(request, response);
                    return;
                }
            }
            
            // Manejar otras rutas
            if (path.equals("/admin/usuario/usuarios")) {
                listarUsuarios(request, response);
            } else if (path.equals("/admin/usuario/nuevo")) {
                mostrarFormularioCreacion(request, response);
            } else if (path.matches("/admin/usuario/editar/\\d+")) {
                mostrarFormularioEdicion(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.out.println("Error en doGet: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/usuario/usuarios");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        System.out.println("doPost - requestURI: " + requestURI);
        System.out.println("doPost - contextPath: " + contextPath);
        System.out.println("doPost - path: " + path);
        
        try {
            if (path.equals("/admin/usuario/crear")) {
                crearUsuario(request, response);
            } else if (path.matches("/admin/usuario/editar/\\d+")) {
                actualizarUsuario(request, response);
            } else if (path.matches("/admin/usuario/eliminar/\\d+")) {
                eliminarUsuario(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/usuario/usuarios");
        }
    }
    
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        List<Usuario> usuarios = usuarioDAO.listarTodos();
        request.setAttribute("usuarios", usuarios);
        request.getRequestDispatcher("/vistas/admin/usuario/usuarios.jsp").forward(request, response);
    }
    
    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        request.getRequestDispatcher("/vistas/admin/usuario/nuevo.jsp").forward(request, response);
    }
    
    private void mostrarFormularioEdicion(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        String idStr = path.substring("/admin/usuario/editar/".length());
        int id = Integer.parseInt(idStr);
        
        Usuario usuario = usuarioDAO.buscarPorId(id);
        if (usuario != null) {
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/vistas/admin/usuario/editar.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void crearUsuario(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol");
        boolean activo = request.getParameter("activo") != null;
        
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            rol == null || rol.trim().isEmpty()) {
            request.setAttribute("error", "Todos los campos son obligatorios");
            request.getRequestDispatcher("/vistas/admin/usuario/nuevo.jsp").forward(request, response);
            return;
        }
        
        if (usuarioDAO.existeUsername(username)) {
            request.setAttribute("error", "El nombre de usuario ya existe");
            request.getRequestDispatcher("/vistas/admin/usuario/nuevo.jsp").forward(request, response);
            return;
        }
        
        Usuario usuario = new Usuario();
        usuario.setUsername(username);
        usuario.setPassword(password);
        usuario.setRol(rol);
        usuario.setActivo(activo);
        
        if (usuarioDAO.crear(usuario)) {
            request.getSession().setAttribute("mensaje", "Usuario creado exitosamente");
            response.sendRedirect(request.getContextPath() + "/admin/usuario/usuarios");
        } else {
            request.setAttribute("error", "No se pudo crear el usuario");
            request.getRequestDispatcher("/vistas/admin/usuario/nuevo.jsp").forward(request, response);
        }
    }
    
    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        String idStr = path.substring("/admin/usuario/editar/".length());
        int id = Integer.parseInt(idStr);
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol");
        boolean activo = request.getParameter("activo") != null;
        
        if (username == null || username.trim().isEmpty() || 
            rol == null || rol.trim().isEmpty()) {
            request.setAttribute("error", "El nombre de usuario y el rol son obligatorios");
            request.getRequestDispatcher("/vistas/admin/usuario/editar.jsp").forward(request, response);
            return;
        }
        
        Usuario usuarioActual = usuarioDAO.buscarPorId(id);
        if (usuarioActual == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Verificar si el username ya existe (excluyendo el usuario actual)
        if (!username.equals(usuarioActual.getUsername()) && usuarioDAO.existeUsername(username)) {
            request.setAttribute("error", "El nombre de usuario ya existe");
            request.getRequestDispatcher("/vistas/admin/usuario/editar.jsp").forward(request, response);
            return;
        }
        
        Usuario usuario = new Usuario();
        usuario.setId(id);
        usuario.setUsername(username);
        usuario.setPassword(password != null && !password.trim().isEmpty() ? password : usuarioActual.getPassword());
        usuario.setRol(rol);
        usuario.setActivo(activo);
        
        if (usuarioDAO.actualizar(usuario)) {
            request.getSession().setAttribute("mensaje", "Usuario actualizado exitosamente");
            response.sendRedirect(request.getContextPath() + "/admin/usuario/usuarios");
        } else {
            request.setAttribute("error", "No se pudo actualizar el usuario");
            request.getRequestDispatcher("/vistas/admin/usuario/editar.jsp").forward(request, response);
        }
    }
    
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        String idStr = path.substring("/admin/usuario/eliminar/".length());
        int id = Integer.parseInt(idStr);
        
        if (usuarioDAO.eliminar(id)) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"message\": \"Usuario eliminado exitosamente\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"No se pudo eliminar el usuario\"}");
        }
    }
} 