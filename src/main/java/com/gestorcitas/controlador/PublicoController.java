package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Especialidad;
import com.gestorcitas.modelo.Paciente;
import com.google.gson.Gson;

@WebServlet("/publico/*")
public class PublicoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CitaDAO citaDAO;
    private PacienteDAO pacienteDAO;
    private DoctorDAO doctorDAO;
    private EspecialidadDAO especialidadDAO;
    private Gson gson;
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    
    @Override
    public void init() throws ServletException {
        citaDAO = new CitaDAO();
        pacienteDAO = new PacienteDAO();
        doctorDAO = new DoctorDAO();
        especialidadDAO = new EspecialidadDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getPathInfo();
        
        try {
            if (path == null || path.equals("/")) {
                // Mostrar página principal
                request.getRequestDispatcher("/vistas/publico/inicio.jsp").forward(request, response);
            } else if (path.equals("/consultar")) {
                consultarCitas(request, response);
            } else if (path.equals("/cancelar")) {
                cancelarCita(request, response);
            } else if (path.equals("/solicitar")) {
                // Mostrar formulario de solicitud
                List<Especialidad> especialidades = especialidadDAO.listarTodas();
                request.setAttribute("especialidades", especialidades);
                request.getRequestDispatcher("/vistas/publico/solicitar.jsp").forward(request, response);
            } else if (path.equals("/doctores")) {
                listarDoctores(request, response);
            } else if (path.equals("/doctor")) {
                buscarDoctor(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            enviarError(response, "Error del sistema: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getPathInfo();
        
        try {
            if (path != null && path.equals("/solicitar")) {
                solicitarCita(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            enviarError(response, "Error del sistema: " + e.getMessage());
        }
    }
    
    private void consultarCitas(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String documento = request.getParameter("documento");
        String captcha = request.getParameter("captcha");
        
        // Validar CAPTCHA
        if (!validarCaptcha(request, captcha)) {
            enviarError(response, "Código CAPTCHA inválido");
            return;
        }
        
        // Buscar paciente
        Paciente paciente = pacienteDAO.buscarPorDNI(documento);
        if (paciente == null) {
            enviarError(response, "No se encontró ningún paciente con ese documento");
            return;
        }
        
        // Obtener citas
        List<Cita> citas = citaDAO.listarPorPaciente(paciente.getId());
        enviarJson(response, citas);
    }
    
    private void cancelarCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String documento = request.getParameter("documento");
        int citaId = Integer.parseInt(request.getParameter("citaId"));
        String captcha = request.getParameter("captcha");
        
        // Validar CAPTCHA
        if (!validarCaptcha(request, captcha)) {
            enviarError(response, "Código CAPTCHA inválido");
            return;
        }
        
        // Buscar paciente
        Paciente paciente = pacienteDAO.buscarPorDNI(documento);
        if (paciente == null) {
            enviarError(response, "No se encontró ningún paciente con ese documento");
            return;
        }
        
        // Buscar cita
        Cita cita = citaDAO.buscarPorId(citaId);
        if (cita == null || cita.getPaciente().getId() != paciente.getId()) {
            enviarError(response, "La cita no existe o no pertenece al paciente");
            return;
        }
        
        // Validar tiempo de cancelación (24 horas antes)
        LocalDateTime fechaCita = LocalDateTime.parse(DATE_FORMAT.format(cita.getFecha()), 
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        LocalDateTime ahora = LocalDateTime.now();
        
        if (ahora.plusHours(24).isAfter(fechaCita)) {
            enviarError(response, "No se puede cancelar la cita con menos de 24 horas de anticipación");
            return;
        }
        
        // Cancelar cita
        citaDAO.actualizarEstado(citaId, "CANCELADA", "Cancelada por el paciente");
        
        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("message", "Cita cancelada exitosamente");
        enviarJson(response, respuesta);
    }
    
    private void solicitarCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String documento = request.getParameter("documento");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");
        int especialidadId = Integer.parseInt(request.getParameter("especialidad"));
        int doctorId = Integer.parseInt(request.getParameter("doctor"));
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
        String motivo = request.getParameter("motivo");
        String captcha = request.getParameter("captcha");
        
        // Validar CAPTCHA
        if (!validarCaptcha(request, captcha)) {
            enviarError(response, "Código CAPTCHA inválido");
            return;
        }
        
        // Buscar o crear paciente
        Paciente paciente = pacienteDAO.buscarPorDNI(documento);
        if (paciente == null) {
            paciente = new Paciente();
            paciente.setDni(documento);
            paciente.setNombres(nombres);
            paciente.setApellidos(apellidos);
            paciente.setEmail(email);
            paciente.setTelefono(telefono);
            pacienteDAO.agregarPaciente(paciente);
        }
        
        // Crear cita
        Cita cita = new Cita();
        cita.setPaciente(paciente);
        cita.setDoctor(doctorDAO.obtenerDoctor(doctorId));
        try {
            cita.setFecha(DATE_FORMAT.parse(fecha + " " + hora + ":00"));
        } catch (ParseException e) {
            enviarError(response, "Error en el formato de fecha");
            return;
        }
        cita.setHora(hora);
        cita.setEstado("PENDIENTE");
        cita.setFechaCreacion(new Date());
        
        citaDAO.crear(cita);
        
        Map<String, String> respuesta = new HashMap<>();
        respuesta.put("message", "Solicitud de cita enviada exitosamente");
        enviarJson(response, respuesta);
    }
    
    private void listarDoctores(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String especialidadIdStr = request.getParameter("especialidadId");
        System.out.println("Especialidad ID recibido: " + especialidadIdStr);
        
        if (especialidadIdStr == null || especialidadIdStr.trim().isEmpty()) {
            System.out.println("Especialidad ID vacío o nulo");
            enviarJson(response, new ArrayList<>());
            return;
        }

        try {
            int especialidadId = Integer.parseInt(especialidadIdStr);
            System.out.println("Buscando doctores para especialidad ID: " + especialidadId);
            
            List<Doctor> doctores = doctorDAO.listarDoctores();
            System.out.println("Doctores encontrados: " + doctores.size());
            
            // Filtrar doctores por especialidad
            List<Doctor> doctoresFiltrados = doctores.stream()
                .filter(d -> d.getEspecialidad() != null && d.getEspecialidad().getId() == especialidadId)
                .collect(Collectors.toList());
            
            enviarJson(response, doctoresFiltrados);
        } catch (NumberFormatException e) {
            System.err.println("Error al parsear especialidadId: " + e.getMessage());
            e.printStackTrace();
            enviarJson(response, new ArrayList<>());
        }
    }
    
    private void buscarDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.getWriter().write("null");
                return;
            }

            int id = Integer.parseInt(idStr);
            Doctor doctor = doctorDAO.obtenerDoctor(id);
            
            String jsonResponse = gson.toJson(doctor);
            response.getWriter().write(jsonResponse);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().write("null");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("null");
        }
    }
    
    private boolean validarCaptcha(HttpServletRequest request, String captcha) {
        String captchaSession = (String) request.getSession().getAttribute("captcha");
        return captchaSession != null && captchaSession.equals(captcha);
    }
    
    private void enviarJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }
    
    private void enviarError(HttpServletResponse response, String mensaje) throws IOException {
        Map<String, String> error = new HashMap<>();
        error.put("error", mensaje);
        enviarJson(response, error);
    }
} 