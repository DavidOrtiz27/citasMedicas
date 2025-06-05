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
    "/admin/citas/doctoresPorEspecialidad" // GET: Obtener doctores por especialidad
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
            } else if (servletPath.equals("/admin/citas/editar") && pathInfo != null) {
                // Mostrar formulario de edición
                mostrarFormularioEdicion(request, response);
            } else if (servletPath.equals("/admin/citas/comprobante") && pathInfo != null) {
                // Generar comprobante PDF
                generarComprobante(request, response);
            } else if (servletPath.equals("/admin/citas/reporte")) {
                // Generar reporte Excel
                generarReporte(request, response);
            } else if (servletPath.equals("/admin/citas/buscarPaciente")) {
                buscarPaciente(request, response);
            } else if (servletPath.equals("/admin/citas/doctoresPorEspecialidad")) {
                obtenerDoctoresPorEspecialidad(request, response);
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
        String accion = request.getParameter("accion");
        
        try {
            if ("crear".equals(accion)) {
                crearCita(request, response);
            } else if ("actualizar".equals(accion)) {
                actualizarCita(request, response);
            } else if ("eliminar".equals(accion)) {
                eliminarCita(request, response);
            } else if ("cancelar".equals(accion)) {
                cancelarCita(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/citas/crearCita.jsp").forward(request, response);
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
        int id = Integer.parseInt(request.getPathInfo().substring(1));
        Cita cita = citaDAO.buscarPorId(id);
        
        if (cita != null) {
            cargarDatosFormulario(request);
            request.setAttribute("cita", cita);
            request.getRequestDispatcher("/vistas/admin/citas/editarCita.jsp").forward(request, response);
        } else {
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
        int especialidadId = Integer.parseInt(request.getParameter("especialidadId"));
        List<Doctor> doctores = doctorDAO.listarPorEspecialidad(especialidadId);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(doctores));
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

    private void cancelarCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String motivo = request.getParameter("motivo");
        
        citaDAO.actualizarEstado(id, "CANCELADA", motivo);
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
            int pacienteId = Integer.parseInt(request.getParameter("pacienteId"));
            Paciente paciente = new Paciente();
            paciente.setId(pacienteId);
            cita.setPaciente(paciente);
            
            // Mapear doctor
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
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
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String fechaMinima = sdf.format(new Date());
        
        request.setAttribute("pacientes", pacientes);
        request.setAttribute("doctores", doctores);
        request.setAttribute("especialidades", especialidades);
        request.setAttribute("fechaMinima", fechaMinima);
    }
} 