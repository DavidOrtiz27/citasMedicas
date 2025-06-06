package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.gestorcitas.util.DocumentoUtil;
import com.google.gson.Gson;
import com.itextpdf.text.DocumentException;

@WebServlet(urlPatterns = {
    "/admin/citas/citas",           // GET: Listar citas, POST: Crear/Actualizar/Eliminar
    "/admin/citas/crear",          // GET: Mostrar formulario de creación
    "/admin/citas/editar/*",       // GET: Mostrar formulario de edición
    "/admin/citas/comprobante/*",  // GET: Generar comprobante PDF
    "/admin/citas/reporte",         // GET: Generar reporte Excel
    "/admin/citas/buscarPaciente",  // GET: Buscar paciente por DNI o nombre
    "/admin/citas/doctoresPorEspecialidad", // GET: Obtener doctores por especialidad
    "/admin/doctor/buscar"         // GET: Buscar doctor por ID
})
public class CitaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CitaDAO citaDAO;
    private DoctorDAO doctorDAO;
    private PacienteDAO pacienteDAO;
    private EspecialidadDAO especialidadDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        citaDAO = new CitaDAO();
        doctorDAO = new DoctorDAO();
        pacienteDAO = new PacienteDAO();
        especialidadDAO = new EspecialidadDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        try {
            if (servletPath.equals("/admin/citas/citas")) {
                // Listar todas las citas
                listarCitas(request, response);
            } else if (servletPath.equals("/admin/citas/crear")) {
                // Mostrar formulario de creación
                mostrarFormularioCreacion(request, response);
            } else if (servletPath.startsWith("/admin/citas/editar")) {
                // Mostrar formulario de edición
                mostrarFormularioEdicion(request, response);
            } else if (servletPath.startsWith("/admin/citas/comprobante")) {
                // Generar comprobante PDF
                generarComprobante(request, response);
            } else if (servletPath.equals("/admin/citas/reporte")) {
                // Generar reporte Excel
                generarReporte(request, response);
            } else if (servletPath.equals("/admin/citas/buscarPaciente")) {
                buscarPaciente(request, response);
            } else if (servletPath.equals("/admin/citas/doctoresPorEspecialidad")) {
                obtenerDoctoresPorEspecialidad(request, response);
            } else if (servletPath.equals("/admin/doctor/buscar")) {
                buscarDoctor(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            if (servletPath.equals("/admin/citas/citas")) {
                request.getRequestDispatcher("/vistas/admin/citas/citas.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String accion = request.getParameter("accion");
        System.out.println("Acción recibida: " + accion);
        System.out.println("Método de la petición: " + request.getMethod());
        System.out.println("Content-Type: " + request.getContentType());
        
        // Imprimir todos los parámetros recibidos
        System.out.println("Parámetros recibidos:");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String[] paramValues = request.getParameterValues(paramName);
            for (String paramValue : paramValues) {
                System.out.println(paramName + ": " + paramValue);
            }
        }
        
        try {
            if (accion == null || accion.trim().isEmpty()) {
                System.out.println("Error: Acción no especificada");
                response.getWriter().write("{\"success\":false,\"message\":\"Acción no especificada\"}");
                return;
            }
            
            switch (accion.trim()) {
                case "crear":
                    crearCita(request, response);
                    break;
                case "actualizar":
                    actualizarCita(request, response);
                    break;
                case "eliminar":
                    eliminarCita(request, response);
                    break;
                case "cancelar":
                    cancelarCita(request, response);
                    break;
                default:
                    System.out.println("Error: Acción no válida: " + accion);
                    response.getWriter().write("{\"success\":false,\"message\":\"Acción no válida: " + accion + "\"}");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"Error al procesar la solicitud: " + e.getMessage() + "\"}");
        }
    }

    private void listarCitas(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        List<Cita> citas = citaDAO.listarTodas();
        List<Doctor> doctores = doctorDAO.listarTodos();
        List<Paciente> pacientes = pacienteDAO.listarTodos();
        
        request.setAttribute("citas", citas);
        request.setAttribute("doctores", doctores);
        request.setAttribute("pacientes", pacientes);
        
        // Asegurar que la respuesta no se haya enviado antes
        if (!response.isCommitted()) {
            request.getRequestDispatcher("/vistas/admin/citas/citas.jsp").forward(request, response);
        }
    }

    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        try {
            // Cargar datos para los selectores
            List<Paciente> pacientes = pacienteDAO.listarTodos();
            List<Especialidad> especialidades = especialidadDAO.listarTodas();
            List<Doctor> doctores = doctorDAO.listarTodos();
            
            // Establecer la fecha mínima como hoy
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String fechaMinima = sdf.format(new Date());
            
            // Agregar los datos al request
            request.setAttribute("pacientes", pacientes);
            request.setAttribute("especialidades", especialidades);
            request.setAttribute("doctores", doctores);
            request.setAttribute("fechaMinima", fechaMinima);
            
            // Redirigir al formulario
            request.getRequestDispatcher("/vistas/admin/citas/crearCita.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los datos: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/citas/citas.jsp").forward(request, response);
        }
    }

    private void mostrarFormularioEdicion(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getPathInfo().substring(1));
            System.out.println("Buscando cita con ID: " + id);
            
            Cita cita = citaDAO.buscarPorId(id);
            System.out.println("Cita encontrada: " + (cita != null));
            
            if (cita != null) {
                // Cargar datos para los selectores
                List<Paciente> pacientes = pacienteDAO.listarTodos();
                List<Especialidad> especialidades = especialidadDAO.listarTodas();
                
                // Obtener el doctor con su especialidad
                Doctor doctor = doctorDAO.buscarPorId(cita.getDoctor().getId());
                System.out.println("Doctor encontrado: " + (doctor != null));
                if (doctor != null) {
                    System.out.println("ID del doctor: " + doctor.getId());
                    System.out.println("Nombre del doctor: " + doctor.getNombres() + " " + doctor.getApellidos());
                    System.out.println("Especialidad del doctor: " + (doctor.getEspecialidad() != null ? doctor.getEspecialidad().getId() : "null"));
                    cita.setDoctor(doctor);
                }
                
                // Cargar doctores según la especialidad del doctor de la cita
                List<Doctor> doctores;
                if (doctor != null && doctor.getEspecialidad() != null) {
                    System.out.println("Cargando doctores para especialidad: " + doctor.getEspecialidad().getId());
                    doctores = doctorDAO.listarPorEspecialidad(doctor.getEspecialidad().getId());
                    System.out.println("Doctores encontrados: " + doctores.size());
                } else {
                    System.out.println("Cargando todos los doctores");
                    doctores = doctorDAO.listarTodos();
                }
                
                // Definir las horas disponibles
                List<String> horasDisponibles = Arrays.asList(
                    "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
                    "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30",
                    "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30"
                );
                
                // Establecer la fecha mínima como hoy
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                String fechaMinima = sdf.format(new Date());
                
                // Agregar los datos al request
                request.setAttribute("cita", cita);
                request.setAttribute("pacientes", pacientes);
                request.setAttribute("especialidades", especialidades);
                request.setAttribute("doctores", doctores);
                request.setAttribute("fechaMinima", fechaMinima);
                request.setAttribute("horasDisponibles", horasDisponibles);
                
                // Redirigir al formulario
                request.getRequestDispatcher("/vistas/admin/citas/editarCita.jsp").forward(request, response);
            } else {
                System.out.println("No se encontró la cita");
                response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
            }
        } catch (Exception e) {
            System.err.println("Error al cargar el formulario de edición: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los datos: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
        }
    }

    private void generarComprobante(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int citaId = Integer.parseInt(request.getPathInfo().substring(1));
        Cita cita = citaDAO.buscarPorId(citaId);
        
        if (cita != null) {
            try {
                DocumentoUtil.generarComprobanteCita(cita, response);
            } catch (DocumentException e) {
                throw new ServletException("Error al generar el PDF", e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void generarReporte(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        try {
            String fechaInicio = request.getParameter("fechaInicio");
            String fechaFin = request.getParameter("fechaFin");
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date inicio = sdf.parse(fechaInicio);
            Date fin = sdf.parse(fechaFin);
            
            List<Cita> citas = citaDAO.listarPorFecha(new java.sql.Date(inicio.getTime()), new java.sql.Date(fin.getTime()));
            DocumentoUtil.generarReporteCitas(citas, response);
        } catch (ParseException e) {
            throw new ServletException("Error al procesar las fechas del reporte", e);
        }
    }

    private void buscarPaciente(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String termino = request.getParameter("termino");
        List<Paciente> pacientes = pacienteDAO.buscarPorTermino(termino);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(pacientes));
    }

    private void obtenerDoctoresPorEspecialidad(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String especialidadIdStr = request.getParameter("especialidadId");
            System.out.println("Especialidad ID recibido: " + especialidadIdStr);
            
            if (especialidadIdStr == null || especialidadIdStr.trim().isEmpty()) {
                System.out.println("Especialidad ID vacío o nulo");
                response.getWriter().write("[]");
                return;
            }

            int especialidadId = Integer.parseInt(especialidadIdStr);
            System.out.println("Buscando doctores para especialidad ID: " + especialidadId);
            
            List<Doctor> doctores = doctorDAO.listarPorEspecialidad(especialidadId);
            System.out.println("Doctores encontrados: " + doctores.size());
            
            String jsonResponse = gson.toJson(doctores);
            System.out.println("Respuesta JSON: " + jsonResponse);
            response.getWriter().write(jsonResponse);
            
        } catch (NumberFormatException e) {
            System.err.println("Error al parsear especialidadId: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("[]");
        } catch (Exception e) {
            System.err.println("Error al obtener doctores: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("[]");
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
            Doctor doctor = doctorDAO.buscarPorId(id);
            
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

    private void crearCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        // Validar que todos los campos requeridos estén presentes
        String pacienteId = request.getParameter("pacienteId");
        String especialidadId = request.getParameter("especialidadId");
        String doctorId = request.getParameter("doctorId");
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
        String estado = request.getParameter("estado");

        System.out.println("Valores recibidos:");
        System.out.println("pacienteId: " + pacienteId);
        System.out.println("especialidadId: " + especialidadId);
        System.out.println("doctorId: " + doctorId);
        System.out.println("fecha: " + fecha);
        System.out.println("hora: " + hora);
        System.out.println("estado: " + estado);

        if (pacienteId == null || especialidadId == null || doctorId == null || 
            fecha == null || hora == null || estado == null) {
            request.setAttribute("error", "Todos los campos son obligatorios");
            cargarDatosFormulario(request);
            request.getRequestDispatcher("/vistas/admin/citas/crearCita.jsp").forward(request, response);
            return;
        }

        // Validar que el doctor pertenezca a la especialidad seleccionada
        Doctor doctor = doctorDAO.buscarPorId(Integer.parseInt(doctorId));
        if (doctor == null || doctor.getEspecialidad().getId() != Integer.parseInt(especialidadId)) {
            request.setAttribute("error", "El doctor seleccionado no pertenece a la especialidad elegida");
            cargarDatosFormulario(request);
            request.getRequestDispatcher("/vistas/admin/citas/crearCita.jsp").forward(request, response);
            return;
        }

        Cita cita = new Cita();
        mapearCita(request, cita);
        cita.setFechaCreacion(new Date());
        
        // Verificar disponibilidad solo si el estado no es CANCELADA
        if (!"CANCELADA".equals(estado) && 
            citaDAO.existeCitaEnHorario(new java.sql.Date(cita.getFecha().getTime()), cita.getHora(), cita.getDoctor().getId())) {
            request.setAttribute("error", "El horario seleccionado no está disponible");
            mostrarFormularioCreacion(request, response);
            return;
        }
        
        citaDAO.crear(cita);
        
        // Usar forward en lugar de redirect
        request.setAttribute("mensaje", "Cita creada exitosamente");
        listarCitas(request, response);
    }
    
    private void actualizarCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> jsonResponse = new HashMap<>();
        
        try {
            System.out.println("Parámetros recibidos:");
            System.out.println("id: " + request.getParameter("id"));
            System.out.println("paciente: " + request.getParameter("paciente"));
            System.out.println("especialidad: " + request.getParameter("especialidad"));
            System.out.println("doctor: " + request.getParameter("doctor"));
            System.out.println("fecha: " + request.getParameter("fecha"));
            System.out.println("hora: " + request.getParameter("hora"));
            System.out.println("estado: " + request.getParameter("estado"));
            
            int id = Integer.parseInt(request.getParameter("id"));
            String pacienteId = request.getParameter("paciente");
            String especialidadId = request.getParameter("especialidad");
            String doctorId = request.getParameter("doctor");
            String fecha = request.getParameter("fecha");
            String hora = request.getParameter("hora");
            String estado = request.getParameter("estado");

            // Validar campos requeridos
            if (pacienteId == null || especialidadId == null || doctorId == null || 
                fecha == null || hora == null || estado == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Todos los campos son obligatorios");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // Validar que el doctor pertenezca a la especialidad seleccionada
            Doctor doctor = doctorDAO.buscarPorId(Integer.parseInt(doctorId));
            if (doctor == null || doctor.getEspecialidad().getId() != Integer.parseInt(especialidadId)) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "El doctor seleccionado no pertenece a la especialidad elegida");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            Cita cita = new Cita();
            cita.setId(id);
            
            // Mapear fecha y hora
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            cita.setFecha(sdf.parse(fecha));
            cita.setHora(hora);
            
            // Mapear paciente
            Paciente paciente = new Paciente();
            paciente.setId(Integer.parseInt(pacienteId));
            cita.setPaciente(paciente);
            
            // Mapear doctor
            cita.setDoctor(doctor);
            
            // Mapear estado
            cita.setEstado(estado);
            
            // Verificar disponibilidad solo si el estado no es CANCELADA
            if (!"CANCELADA".equals(estado)) {
                Cita citaExistente = citaDAO.buscarPorId(id);
                if (!citaExistente.getHora().equals(hora) || !citaExistente.getFecha().equals(sdf.parse(fecha))) {
                    if (citaDAO.existeCitaEnHorario(new java.sql.Date(cita.getFecha().getTime()), 
                        cita.getHora(), cita.getDoctor().getId())) {
                        jsonResponse.put("success", false);
                        jsonResponse.put("message", "El horario seleccionado no está disponible");
                        response.getWriter().write(gson.toJson(jsonResponse));
                        return;
                    }
                }
            }
            
            citaDAO.modificar(cita);
            
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Cita actualizada exitosamente");
            response.getWriter().write(gson.toJson(jsonResponse));
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error al actualizar la cita: " + e.getMessage());
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
    
    private void eliminarCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean eliminado = citaDAO.eliminar(id);
            
            if (eliminado) {
                response.getWriter().write("{\"success\":true,\"message\":\"Cita eliminada correctamente\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"No se pudo eliminar la cita\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"ID de cita inválido\"}");
        }
    }

    private void cancelarCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String motivo = request.getParameter("motivo");
            
            citaDAO.actualizarEstado(id, "CANCELADA", motivo);
            
            // Redirigir directamente a la lista de citas
            response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cancelar la cita: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
        }
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
            
            // Mapear motivo de cancelación si existe
            String motivoCancelacion = request.getParameter("motivoCancelacion");
            if (motivoCancelacion != null && !motivoCancelacion.isEmpty()) {
                cita.setMotivoCancelacion(motivoCancelacion);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    private void cargarDatosFormulario(HttpServletRequest request) throws SQLException {
        List<Paciente> pacientes = pacienteDAO.listarTodos();
        List<Doctor> doctores = doctorDAO.listarTodos();
        List<Especialidad> especialidades = especialidadDAO.listarTodas();
        
        // Definir las horas disponibles
        List<String> horasDisponibles = Arrays.asList(
            "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
            "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30",
            "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30"
        );
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String fechaMinima = sdf.format(new Date());
        
        request.setAttribute("pacientes", pacientes);
        request.setAttribute("doctores", doctores);
        request.setAttribute("especialidades", especialidades);
        request.setAttribute("fechaMinima", fechaMinima);
        request.setAttribute("horasDisponibles", horasDisponibles);
    }
} 