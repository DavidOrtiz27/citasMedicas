package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gestorcitas.dao.CitaDAO;
import com.gestorcitas.dao.DoctorDAO;
import com.gestorcitas.dao.EspecialidadDAO;
import com.gestorcitas.dao.PacienteDAO;
import com.gestorcitas.modelo.Cita;

@WebServlet("/admin/inicio")
public class InicioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private PacienteDAO pacienteDAO;
    private DoctorDAO doctorDAO;
    private EspecialidadDAO especialidadDAO;
    private CitaDAO citaDAO;
    
    @Override
    public void init() throws ServletException {
        pacienteDAO = new PacienteDAO();
        doctorDAO = new DoctorDAO();
        especialidadDAO = new EspecialidadDAO();
        citaDAO = new CitaDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Obtener estadísticas
            int totalPacientes = pacienteDAO.contarTotal();
            int totalDoctores = doctorDAO.contarTotal();
            int totalEspecialidades = especialidadDAO.contarTotal();
            int citasHoy = citaDAO.contarCitasHoy();
            
            // Obtener próximas citas
            List<Cita> proximasCitas = citaDAO.listarProximasCitas();
            
            // Establecer atributos
            request.setAttribute("totalPacientes", totalPacientes);
            request.setAttribute("totalDoctores", totalDoctores);
            request.setAttribute("totalEspecialidades", totalEspecialidades);
            request.setAttribute("citasHoy", citasHoy);
            request.setAttribute("proximasCitas", proximasCitas);
            
            // Redirigir a la vista
            request.getRequestDispatcher("/vistas/admin/inicio.jsp").forward(request, response);
            
        } catch (SQLException e) {
            throw new ServletException("Error al cargar la página de inicio", e);
        }
    }
} 