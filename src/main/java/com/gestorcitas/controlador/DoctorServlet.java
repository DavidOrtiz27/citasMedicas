package com.gestorcitas.controlador;

import java.io.IOException;
import java.io.Serial;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
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
import com.gestorcitas.modelo.Paciente;
import com.google.gson.Gson;

import static java.lang.System.out;

@WebServlet(urlPatterns = {
        "/admin/doctor/doctores",
        "/admin/doctor/doctores/agregar",
        "/admin/doctor/doctores/eliminar",
        "/admin/doctor/doctores/actualizar"
})
public class DoctorServlet extends HttpServlet {
    @Serial
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
        String servletPath = request.getServletPath();

        try {
            if (servletPath.equals("/admin/doctor/doctores")) {
                // Cargar las especialidades
                List<Especialidad> especialidades = especialidadDAO.listarTodos();
                // Listar todos los doctores
                String buscar = request.getParameter("buscar");
                List<Doctor> doctores;

                if (buscar != null && !buscar.trim().isEmpty()) {
                    doctores = doctorDAO.buscarDoctores(buscar);
                } else {
                    doctores = doctorDAO.listarDoctores();
                }

                request.setAttribute("especialidades", especialidades);
                request.setAttribute("doctores", doctores);
                request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        try {
            if (servletPath.equals("/admin/doctor/doctores/agregar")) {
                crearDoctor(request, response);
            }else if(servletPath.equals("/admin/doctor/doctores/eliminar")){
                eliminarDoctor(request, response);
            } else if(servletPath.equals("/admin/doctor/doctores/actualizar")){
                actualizarDoctor(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al guardar el doctor: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
        }
    }

    private void actualizarDoctor(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String dni = request.getParameter("dni");


        try {
            // Validar DNI duplicado
            if (doctorDAO.existeDNI(dni, id)){
                request.setAttribute("error", "El DNI ya está registrado");
                request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
                return;
            }

            Doctor doctor = new Doctor();
            doctor.setDni(dni);
            doctor.setNombres(request.getParameter("nombres"));
            doctor.setApellidos(request.getParameter("apellidos"));
            doctor.setEmail(request.getParameter("email"));
            doctor.setTelefono(request.getParameter("telefono"));
            doctor.setEspecialidad(especialidadDAO.buscarPorId(Integer.parseInt(request.getParameter("especialidad"))));
            doctor.setId(id);

            doctorDAO.actualizarDoctor(doctor);
            out.println("Doctor actualizado correctamente");

            // Redirigir a la lista de doctores
            response.sendRedirect(request.getContextPath() + "/admin/doctor/doctores");

        } catch (SQLException e) {
            request.setAttribute("error", "Error al actualizar el paciente: " + e.getMessage());
            request.setAttribute("paciente", doctorDAO.obtenerDoctor(id));
            request.getRequestDispatcher("/vistas/admin/paciente/editar.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            throw new RuntimeException(e);
        }
    }

    private void eliminarDoctor(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            // Obtener y validar el ID
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("error", "ID del doctor no proporcionado");
                response.sendRedirect(request.getContextPath() + "/admin/doctor/doctores");
                return;
            }

            int id = Integer.parseInt(idStr);

            // Verificar si el doctor existe antes de eliminar
            Doctor doctor = doctorDAO.obtenerDoctor(id);
            if (doctor == null) {
                request.setAttribute("error", "El doctor no existe");
                response.sendRedirect(request.getContextPath() + "/admin/doctor/doctores");
                return;
            }



            // Intentar eliminar el doctor
            boolean eliminado = doctorDAO.eliminarDoctor(id);
            if (eliminado) {
                request.setAttribute("mensaje", "Doctor eliminado correctamente");
                out.println("Doctor eliminado correctamente");
            } else {
                request.setAttribute("error", "No se pudo eliminar el doctor");
                out.println("Error al eliminar el doctor");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de doctor inválido");
            out.println("Error: ID de doctor inválido");
        } catch (SQLException e) {
            // Verificar si es un error de clave foránea
            if (e.getMessage().contains("foreign key constraint fails")) {
                request.setAttribute("error", "No se puede eliminar el doctor porque tiene citas médicas asociadas. Por favor, elimine primero las citas del doctor.");
            } else {
                request.setAttribute("error", "Error al eliminar el doctor: " + e.getMessage());
            }
            out.println("Error SQL: " + e.getMessage());
        }

        // Redirigir de vuelta a la lista de doctors
        response.sendRedirect(request.getContextPath() + "/admin/doctor/doctores");
    }

    private void crearDoctor(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {

        // Validar DNI duplicado

        String dni = request.getParameter("dni");

        if (doctorDAO.existeDNI(dni, null)) {
            request.setAttribute("error", "El DNI ya está registrado");
            request.getRequestDispatcher("/vistas/admin/doctores/nuevo.jsp").forward(request, response);
            return;
        }


        try {
            Doctor doctor = new Doctor();
            doctor.setDni(dni);
            doctor.setNombres(request.getParameter("nombres"));
            doctor.setApellidos(request.getParameter("apellidos"));
            doctor.setEmail(request.getParameter("email"));
            doctor.setTelefono(request.getParameter("telefono"));
            doctor.setEspecialidad(especialidadDAO.buscarPorId(Integer.parseInt(request.getParameter("especialidad"))));

            doctorDAO.agregarDoctor(doctor);
            response.sendRedirect(request.getContextPath() + "/admin/doctor/doctores");

        } catch (Exception e){
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
        }

    }
}

    
