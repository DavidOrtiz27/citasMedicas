package com.gestorcitas.controlador;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gestorcitas.dao.CitaDAO;
import com.gestorcitas.dao.PacienteDAO;
import com.gestorcitas.modelo.Cita;
import com.gestorcitas.modelo.Paciente;
import com.google.gson.Gson;

@WebServlet("/publico/citas/*")
public class ConsultaCitaServlet extends HttpServlet {
    private CitaDAO citaDAO;
    private PacienteDAO pacienteDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        citaDAO = new CitaDAO();
        pacienteDAO = new PacienteDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Mostrar formulario de consulta
                request.getRequestDispatcher("/vistas/publico/consultaCitas.jsp").forward(request, response);
            } else if (pathInfo.equals("/solicitar")) {
                // Mostrar formulario de solicitud
                request.getRequestDispatcher("/vistas/publico/solicitarCita.jsp").forward(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                // Obtener una cita específica
                int id = Integer.parseInt(pathInfo.substring(1));
                obtenerCita(id, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
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
                // Consultar citas por DNI
                String dni = request.getParameter("dni");
                String captcha = request.getParameter("captcha");
                String captchaSession = (String) request.getSession().getAttribute("captcha");
                
                if (captcha == null || !captcha.equals(captchaSession)) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "CAPTCHA incorrecto");
                    return;
                }
                
                Paciente paciente = pacienteDAO.buscarPorDNI(dni);
                if (paciente == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Paciente no encontrado");
                    return;
                }
                
                List<Cita> citas = citaDAO.listarPorPaciente(paciente.getId());
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(citas));
                
            } else if (pathInfo.equals("/solicitar")) {
                // Solicitar nueva cita
                Cita cita = parsearCita(request);
                cita.setEstado("PENDIENTE");
                
                // Validar disponibilidad del horario
                if (citaDAO.existeCitaEnHorario(new java.sql.Date(cita.getFecha().getTime()), 
                    cita.getHora(), cita.getDoctor().getId())) {
                    response.sendError(HttpServletResponse.SC_CONFLICT, "El horario seleccionado no está disponible");
                    return;
                }
                
                citaDAO.crear(cita);
                response.setStatus(HttpServletResponse.SC_CREATED);
                response.getWriter().write(gson.toJson(cita));
                
            } else if (pathInfo.matches("/\\d+/cancelar")) {
                // Cancelar cita
                int id = Integer.parseInt(pathInfo.substring(1, pathInfo.length() - 9));
                Cita cita = citaDAO.buscarPorId(id);
                
                if (cita == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                
                // Verificar que falten más de 24 horas
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.HOUR, 24);
                Date limite = cal.getTime();
                
                if (cita.getFecha().before(limite)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, 
                        "No se puede cancelar una cita con menos de 24 horas de anticipación");
                    return;
                }
                
                citaDAO.actualizarEstado(id, "CANCELADA", "Cancelada por el paciente");
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(cita));
                
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la solicitud");
        }
    }

    private void obtenerCita(int id, HttpServletResponse response) throws IOException {
        try {
            Cita cita = citaDAO.buscarPorId(id);
            if (cita != null) {
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(cita));
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al obtener la cita");
        }
    }

    private Cita parsearCita(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = request.getReader().readLine()) != null) {
            sb.append(line);
        }
        return gson.fromJson(sb.toString(), Cita.class);
    }
} 