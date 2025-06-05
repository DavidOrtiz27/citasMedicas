package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gestorcitas.dao.EspecialidadDAO;
import com.gestorcitas.modelo.Especialidad;
import com.google.gson.Gson;

@WebServlet(urlPatterns = {"/admin/especialidad/especialidades", "/admin/especialidad/especialidades/*"})
public class EspecialidadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private EspecialidadDAO especialidadDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        especialidadDAO = new EspecialidadDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Si es una petición AJAX o API
        if (request.getHeader("X-Requested-With") != null || 
            request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json")) {
            handleApiRequest(request, response);
            return;
        }
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todas las especialidades
                List<Especialidad> especialidades = especialidadDAO.listarTodas();
                request.setAttribute("especialidades", especialidades);
                request.getRequestDispatcher("/vistas/admin/especialidad/especialidades.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar las especialidades: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/especialidad/especialidades.jsp").forward(request, response);
        }
    }
    
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todas las especialidades
                List<Especialidad> especialidades = especialidadDAO.listarTodas();
                response.getWriter().write(gson.toJson(especialidades));
            } else if (pathInfo.matches("/\\d+")) {
                // Obtener una especialidad específica
                int id = Integer.parseInt(pathInfo.substring(1));
                Especialidad especialidad = especialidadDAO.buscarPorId(id);
                if (especialidad != null) {
                    response.getWriter().write(gson.toJson(especialidad));
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la solicitud");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Crear nueva especialidad
                Especialidad especialidad = gson.fromJson(request.getReader(), Especialidad.class);
                especialidadDAO.crear(especialidad);
                response.setStatus(HttpServletResponse.SC_CREATED);
            } else if (pathInfo.matches("/\\d+")) {
                // Actualizar especialidad existente
                int id = Integer.parseInt(pathInfo.substring(1));
                Especialidad especialidad = gson.fromJson(request.getReader(), Especialidad.class);
                especialidad.setId(id);
                especialidadDAO.actualizar(especialidad);
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la solicitud");
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null && pathInfo.matches("/\\d+")) {
                int id = Integer.parseInt(pathInfo.substring(1));
                especialidadDAO.eliminar(id);
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al eliminar la especialidad");
        }
    }
} 
