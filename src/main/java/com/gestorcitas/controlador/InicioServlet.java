package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
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
        try {
            pacienteDAO = new PacienteDAO();
            doctorDAO = new DoctorDAO();
            especialidadDAO = new EspecialidadDAO();
            citaDAO = new CitaDAO();
        } catch (Exception e) {
            throw new ServletException("Error al inicializar los DAOs", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int totalPacientes = 0;
        int totalDoctores = 0;
        int totalEspecialidades = 0;
        int citasHoy = 0;
        List<Cita> proximasCitas = new ArrayList<>();
        
        try {
            // Obtener estadísticas con manejo individual de errores
            try {
                totalPacientes = pacienteDAO.contarTotal();
            } catch (SQLException e) {
                request.setAttribute("errorPacientes", "Error al obtener total de pacientes: " + e.getMessage());
            }
            
            try {
                totalDoctores = doctorDAO.contarTotal();
            } catch (SQLException e) {
                request.setAttribute("errorDoctores", "Error al obtener total de doctores: " + e.getMessage());
            }
            
            try {
                totalEspecialidades = especialidadDAO.contarTotal();
            } catch (SQLException e) {
                request.setAttribute("errorEspecialidades", "Error al obtener total de especialidades: " + e.getMessage());
            }
            
            try {
                citasHoy = citaDAO.contarCitasHoy();
            } catch (SQLException e) {
                request.setAttribute("errorCitasHoy", "Error al obtener citas de hoy: " + e.getMessage());
            }
            
            try {
                proximasCitas = citaDAO.listarProximasCitas();
            } catch (SQLException e) {
                request.setAttribute("errorProximasCitas", "Error al obtener próximas citas: " + e.getMessage());
            }
            
            // Establecer atributos
            request.setAttribute("totalPacientes", totalPacientes);
            request.setAttribute("totalDoctores", totalDoctores);
            request.setAttribute("totalEspecialidades", totalEspecialidades);
            request.setAttribute("citasHoy", citasHoy);
            request.setAttribute("proximasCitas", proximasCitas);
            
            // Redirigir a la vista
            request.getRequestDispatcher("/vistas/admin/inicio.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("errorGeneral", "Error al cargar la página de inicio: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/inicio.jsp").forward(request, response);
        }
    }
} 