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
import com.gestorcitas.dao.HorarioDAO;
import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Especialidad;
import com.gestorcitas.modelo.Horario;
import com.google.gson.Gson;

@WebServlet("/api/*")
public class ApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private EspecialidadDAO especialidadDAO;
    private DoctorDAO doctorDAO;
    private HorarioDAO horarioDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        especialidadDAO = new EspecialidadDAO();
        doctorDAO = new DoctorDAO();
        horarioDAO = new HorarioDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        response.setContentType("application/json");
        
        try {
            switch (pathInfo) {
                case "/especialidades":
                    listarEspecialidades(response);
                    break;
                case "/doctores":
                    listarDoctores(request, response);
                    break;
                case "/horarios":
                    listarHorarios(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void listarEspecialidades(HttpServletResponse response) throws SQLException, IOException {
        List<Especialidad> especialidades = especialidadDAO.listarTodos();
        response.getWriter().write(gson.toJson(especialidades));
    }
    
    private void listarDoctores(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String especialidadId = request.getParameter("especialidad");
        if (especialidadId == null || especialidadId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        List<Doctor> doctores = doctorDAO.listarPorEspecialidad(Integer.parseInt(especialidadId));
        response.getWriter().write(gson.toJson(doctores));
    }
    
    private void listarHorarios(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String doctorId = request.getParameter("doctor");
        String fecha = request.getParameter("fecha");
        
        if (doctorId == null || fecha == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        List<Horario> horarios = horarioDAO.listarDisponibles(
            Integer.parseInt(doctorId), 
            java.sql.Date.valueOf(fecha)
        );
        response.getWriter().write(gson.toJson(horarios));
    }
} 