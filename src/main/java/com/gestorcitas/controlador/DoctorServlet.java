package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gestorcitas.dao.DoctorDAO;
import com.gestorcitas.dao.EspecialidadDAO;
import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Especialidad;
import com.google.gson.Gson;

@WebServlet(urlPatterns = {"/admin/doctor/doctores", "/admin/doctor/doctores/*"})
public class DoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DoctorDAO doctorDAO;
    private EspecialidadDAO especialidadDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        especialidadDAO = new EspecialidadDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String requestURI = request.getRequestURI();
        String pathInfo = request.getPathInfo();
        
        // Si es una petición AJAX o API
        if (request.getHeader("X-Requested-With") != null || 
            request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json")) {
            handleApiRequest(request, response);
            return;
        }
        
        // Si es una petición normal de página
        try {
            List<Doctor> doctores = doctorDAO.listarTodos();
            List<Especialidad> especialidades = especialidadDAO.listarTodas();
            request.setAttribute("doctores", doctores);
            request.setAttribute("especialidades", especialidades);
            request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los doctores: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Doctor doctor = new Doctor();
            doctor.setNombres(request.getParameter("nombres"));
            doctor.setApellidos(request.getParameter("apellidos"));
            
            // Obtener la especialidad por ID
            int especialidadId = Integer.parseInt(request.getParameter("especialidad_id"));
            Especialidad especialidad = especialidadDAO.buscarPorId(especialidadId);
            doctor.setEspecialidad(especialidad);
            
            doctor.setEmail(request.getParameter("email"));
            doctor.setTelefono(request.getParameter("telefono"));
            
            if (doctorDAO.guardar(doctor)) {
                response.sendRedirect(request.getContextPath() + "/admin/doctor/doctores");
            } else {
                request.setAttribute("error", "Error al guardar el doctor");
                request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al guardar el doctor: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Doctor doctor = new Doctor();
            doctor.setId(Integer.parseInt(request.getParameter("id")));
            doctor.setNombres(request.getParameter("nombres"));
            doctor.setApellidos(request.getParameter("apellidos"));
            
            // Obtener la especialidad por ID
            int especialidadId = Integer.parseInt(request.getParameter("especialidad_id"));
            Especialidad especialidad = especialidadDAO.buscarPorId(especialidadId);
            doctor.setEspecialidad(especialidad);
            
            doctor.setEmail(request.getParameter("email"));
            doctor.setTelefono(request.getParameter("telefono"));
            
            if (doctorDAO.guardar(doctor)) {
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.length() > 1) {
            try {
                int id = Integer.parseInt(pathInfo.substring(1));
                if (doctorDAO.eliminar(id)) {
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } catch (SQLException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todos los doctores
                List<Doctor> doctores = doctorDAO.listarTodos();
                response.getWriter().write(gson.toJson(doctores));
            } else {
                // Obtener un doctor específico
                int id = Integer.parseInt(pathInfo.substring(1));
                Doctor doctor = doctorDAO.obtenerPorId(id);
                if (doctor != null) {
                    response.getWriter().write(gson.toJson(doctor));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
} 