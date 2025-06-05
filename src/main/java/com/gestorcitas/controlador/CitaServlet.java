package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gestorcitas.dao.CitaDAO;
import com.gestorcitas.dao.DoctorDAO;
import com.gestorcitas.dao.PacienteDAO;
import com.gestorcitas.modelo.Cita;
import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Paciente;
import com.gestorcitas.util.DocumentoUtil;
import com.google.gson.Gson;
import com.itextpdf.text.DocumentException;

@WebServlet(urlPatterns = {"/admin/citas/citas", "/admin/citas/citas/*"})
public class CitaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CitaDAO citaDAO;
    private DoctorDAO doctorDAO;
    private PacienteDAO pacienteDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        citaDAO = new CitaDAO();
        doctorDAO = new DoctorDAO();
        pacienteDAO = new PacienteDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String accion = request.getParameter("accion");
        
        try {
            if ("editar".equals(accion)) {
                // Cargar datos para editar
                int id = Integer.parseInt(request.getParameter("id"));
                Cita cita = citaDAO.buscarPorId(id);
                List<Doctor> doctores = doctorDAO.listarTodos();
                List<Paciente> pacientes = pacienteDAO.listarTodos();
                
                request.setAttribute("cita", cita);
                request.setAttribute("doctores", doctores);
                request.setAttribute("pacientes", pacientes);
                request.getRequestDispatcher("/vistas/admin/citas/editarCita.jsp").forward(request, response);
                return;
            }
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todas las citas
                List<Cita> citas = citaDAO.listarTodas();
                List<Doctor> doctores = doctorDAO.listarTodos();
                List<Paciente> pacientes = pacienteDAO.listarTodos();
                
                request.setAttribute("citas", citas);
                request.setAttribute("doctores", doctores);
                request.setAttribute("pacientes", pacientes);
                request.getRequestDispatcher("/vistas/admin/citas/citas.jsp").forward(request, response);
            } else if (pathInfo != null && pathInfo.startsWith("/comprobante/")) {
                // Generar comprobante PDF
                int citaId = Integer.parseInt(pathInfo.substring("/comprobante/".length()));
                Cita cita = citaDAO.buscarPorId(citaId);
                if (cita != null) {
                    try {
                        DocumentoUtil.generarComprobanteCita(cita, response);
                    } catch (DocumentException e) {
                        throw new ServletException("Error al generar el PDF", e);
                    }
                    return;
                }
            } else if (pathInfo != null && pathInfo.equals("/reporte")) {
                // Generar reporte Excel
                String fechaInicio = request.getParameter("fechaInicio");
                String fechaFin = request.getParameter("fechaFin");
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date inicio = sdf.parse(fechaInicio);
                Date fin = sdf.parse(fechaFin);
                
                List<Cita> citas = citaDAO.listarPorFecha(new java.sql.Date(inicio.getTime()), new java.sql.Date(fin.getTime()));
                DocumentoUtil.generarReporteCitas(citas, response);
                return;
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (ParseException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/citas/citas.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        try {
            if ("crear".equals(accion)) {
                crearCita(request, response);
            } else if ("actualizar".equals(accion)) {
                actualizarCita(request, response);
            } else if ("eliminar".equals(accion)) {
                eliminarCita(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/citas/citas.jsp").forward(request, response);
        }
    }

    private void crearCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        Cita cita = new Cita();
        mapearCita(request, cita);
        
        // Verificar disponibilidad del horario
        if (citaDAO.existeCitaEnHorario(cita.getFecha(), cita.getHora(), cita.getDoctor().getId())) {
            request.setAttribute("error", "El horario seleccionado no está disponible");
            request.getRequestDispatcher("/vistas/admin/citas/citas.jsp").forward(request, response);
            return;
        }
        
        citaDAO.crear(cita);
        response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
    }
    
    private void actualizarCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Cita cita = new Cita();
        cita.setId(id);
        mapearCita(request, cita);
        
        citaDAO.modificar(cita);
        response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
    }
    
    private void eliminarCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        citaDAO.eliminar(id);
        response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
    }
    
    private void mapearCita(HttpServletRequest request, Cita cita) {
        try {
            // Mapear fecha y hora
            String fechaStr = request.getParameter("fecha");
            String horaStr = request.getParameter("hora");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            cita.setFecha(sdf.parse(fechaStr));
            cita.setHora(horaStr);
            
            // Mapear paciente
            int pacienteId = Integer.parseInt(request.getParameter("paciente"));
            Paciente paciente = new Paciente();
            paciente.setId(pacienteId);
            cita.setPaciente(paciente);
            
            // Mapear doctor
            int doctorId = Integer.parseInt(request.getParameter("doctor"));
            Doctor doctor = new Doctor();
            doctor.setId(doctorId);
            cita.setDoctor(doctor);
            
            // Mapear estado
            cita.setEstado(request.getParameter("estado"));
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }
} 