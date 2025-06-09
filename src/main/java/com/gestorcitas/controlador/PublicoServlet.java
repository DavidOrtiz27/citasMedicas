package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.gestorcitas.dao.CitaDAO;
import com.gestorcitas.dao.DoctorDAO;
import com.gestorcitas.dao.EspecialidadDAO;
import com.gestorcitas.dao.PacienteDAO;
import com.gestorcitas.modelo.Cita;
import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Especialidad;
import com.gestorcitas.modelo.Paciente;
import com.google.gson.Gson;

@WebServlet(urlPatterns = {
    "/publico/consultar",    // GET/POST: Consultar citas
    "/publico/solicitar",    // GET/POST: Mostrar formulario de solicitud
    "/publico/cancelar",     // POST: Cancelar cita
    "/publico/doctores",     // GET: Obtener doctores por especialidad
    "/publico/horasDisponibles" // GET: Obtener horas disponibles
})
public class PublicoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final CitaDAO citaDAO = new CitaDAO();
    private final EspecialidadDAO especialidadDAO = new EspecialidadDAO();
    private DoctorDAO doctorDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        try {
            if (path.equals("/publico/consultar")) {
                request.getRequestDispatcher("/vistas/publico/consultaCitas.jsp").forward(request, response);
            } else if (path.equals("/publico/solicitar")) {
                mostrarFormularioSolicitud(request, response);
            } else if (path.equals("/publico/doctores")) {
                obtenerDoctoresPorEspecialidad(request, response);
            } else if (path.equals("/publico/horasDisponibles")) {
                obtenerHorasDisponibles(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            if (path.equals("/publico/consultar")) {
                consultarCitas(request, response);
            } else if (path.equals("/publico/solicitar")) {
                solicitarCita(request, response);
            } else if (path.equals("/publico/cancelar")) {
                cancelarCita(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/publico/consultar");
        }
    }
    
    private void mostrarFormularioSolicitud(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        // Obtener especialidades
        List<Especialidad> especialidades = especialidadDAO.listarTodos();
        request.setAttribute("especialidades", especialidades);
        
        // Establecer fecha mínima (mañana)
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, 1);
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        request.setAttribute("fechaMinima", dateFormat.format(calendar.getTime()));
        
        request.getRequestDispatcher("/vistas/publico/solicitarCita.jsp").forward(request, response);
    }
    
    private void solicitarCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        String dni = request.getParameter("dni");
        String captcha = request.getParameter("captcha");
        int doctorId = Integer.parseInt(request.getParameter("doctor"));
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
        
        HttpSession session = request.getSession();
        
        // Validar CAPTCHA
        String captchaSession = (String) session.getAttribute("captcha");
        if (captchaSession == null || !captchaSession.equals(captcha)) {
            request.setAttribute("error", "El código CAPTCHA es incorrecto");
            mostrarFormularioSolicitud(request, response);
            return;
        }
        
        // Buscar paciente por DNI
        Paciente paciente = pacienteDAO.buscarPorDNI(dni);
        if (paciente == null) {
            request.setAttribute("error", "No se encontró ningún paciente con el DNI proporcionado");
            mostrarFormularioSolicitud(request, response);
            return;
        }
        
        // Buscar doctor
        Doctor doctor = doctorDAO.buscarPorId(doctorId);
        if (doctor == null) {
            request.setAttribute("error", "El doctor seleccionado no existe");
            mostrarFormularioSolicitud(request, response);
            return;
        }
        
        // Crear nueva cita
        Cita cita = new Cita();
        cita.setPaciente(paciente);
        cita.setDoctor(doctor);
        try {
            cita.setFecha(new SimpleDateFormat("yyyy-MM-dd").parse(fecha));
            cita.setHora(hora);
            cita.setEstado("PENDIENTE");
            
            citaDAO.crear(cita);
            request.setAttribute("mensaje", "La cita ha sido solicitada exitosamente");
            response.sendRedirect(request.getContextPath() + "/publico/consultar");
        } catch (ParseException e) {
            request.setAttribute("error", "Error en el formato de fecha: " + e.getMessage());
            mostrarFormularioSolicitud(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Error al crear la cita: " + e.getMessage());
            mostrarFormularioSolicitud(request, response);
        }
    }
    
    private void consultarCitas(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        String dni = request.getParameter("dni");
        String captcha = request.getParameter("captcha");
        HttpSession session = request.getSession();
        
        // Validar CAPTCHA
        String captchaSession = (String) session.getAttribute("captcha");
        if (captchaSession == null || !captchaSession.equals(captcha)) {
            request.setAttribute("error", "El código CAPTCHA es incorrecto");
            request.getRequestDispatcher("/vistas/publico/consultaCitas.jsp").forward(request, response);
            return;
        }
        
        // Buscar paciente por DNI
        Paciente paciente = pacienteDAO.buscarPorDNI(dni);
        if (paciente == null) {
            request.setAttribute("error", "No se encontró ningún paciente con el DNI proporcionado");
            request.getRequestDispatcher("/vistas/publico/consultaCitas.jsp").forward(request, response);
            return;
        }
        
        // Obtener citas del paciente
        List<Cita> citas = citaDAO.listarPorPaciente(paciente.getId());
        request.setAttribute("citas", citas);
        request.getRequestDispatcher("/vistas/publico/consultaCitas.jsp").forward(request, response);
    }
    
    private void cancelarCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int citaId = Integer.parseInt(request.getParameter("id"));
        Cita cita = citaDAO.buscarPorId(citaId);
        
        if (cita != null) {
            cita.setEstado("CANCELADA");
            citaDAO.modificar(cita);
            request.setAttribute("mensaje", "La cita ha sido cancelada exitosamente");
        } else {
            request.setAttribute("error", "No se encontró la cita especificada");
        }
        
        response.sendRedirect(request.getContextPath() + "/publico/consultar");
    }
    
    private boolean validarFechaFutura(String fechaStr) {
        try {
            Date fecha = parseFecha(fechaStr);
            return fecha.after(new Date());
        } catch (ParseException e) {
            return false;
        }
    }
    
    private Date parseFecha(String fechaStr) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.parse(fechaStr);
    }
    
    private boolean validarCancelacionCita(Cita cita) {
        Date ahora = new Date();
        long diferencia = cita.getFecha().getTime() - ahora.getTime();
        long horas = diferencia / (60 * 60 * 1000);
        return horas >= 24;
    }
    
    private static class ErrorResponse {
        private final String error;
        
        public ErrorResponse(String error) {
            this.error = error;
        }
        
        public String getError() {
            return error;
        }
    }
    
    private static class SuccessResponse {
        private final String message;
        
        public SuccessResponse(String message) {
            this.message = message;
        }
        
        public String getMessage() {
            return message;
        }
    }
    
    private void obtenerDoctoresPorEspecialidad(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String especialidadIdStr = request.getParameter("especialidadId");
            if (especialidadIdStr == null || especialidadIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"El ID de especialidad es requerido\"}");
                return;
            }

            int especialidadId = Integer.parseInt(especialidadIdStr);
            List<Doctor> doctores = doctorDAO.listarPorEspecialidad(especialidadId);
            
            // Log para depuración
            System.out.println("Doctores encontrados para especialidad " + especialidadId + ": " + doctores.size());
            for (Doctor d : doctores) {
                System.out.println("Doctor: " + d.getNombres() + " " + d.getApellidos() + 
                                 " (ID: " + d.getId() + ", Especialidad: " + d.getEspecialidad().getNombre() + ")");
            }
            
            String jsonResponse = gson.toJson(doctores);
            System.out.println("JSON Response: " + jsonResponse);
            
            response.getWriter().write(jsonResponse);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"ID de especialidad inválido\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error al obtener los doctores: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error inesperado: " + e.getMessage() + "\"}");
        } finally {
            response.getWriter().flush();
            response.getWriter().close();
        }
    }
    
    private void obtenerHorasDisponibles(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String fechaStr = request.getParameter("fecha");
        String doctorIdStr = request.getParameter("doctorId");
        
        if (fechaStr == null || doctorIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan parámetros requeridos");
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            java.util.Date fechaUtil = new SimpleDateFormat("yyyy-MM-dd").parse(fechaStr);
            java.sql.Date fecha = new java.sql.Date(fechaUtil.getTime());
            
            List<String> horasDisponibles = citaDAO.obtenerHorasDisponibles(fecha, doctorId);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(horasDisponibles));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
} 