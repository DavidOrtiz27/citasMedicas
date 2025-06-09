package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalTime;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gestorcitas.dao.DoctorDAO;
import com.gestorcitas.dao.HorarioDAO;
import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Horario;
import com.gestorcitas.util.LocalTimeAdapter;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import static java.lang.System.out;

@WebServlet(urlPatterns = {
        "/admin/horario/horarios",
        "/admin/horario/horarios/agregar",
        "/admin/horario/horarios/actualizar",
        "/admin/horario/horarios/eliminar"
})
public class HorarioServlet extends HttpServlet {
    private HorarioDAO horarioDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        horarioDAO = new HorarioDAO();
        doctorDAO = new DoctorDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        try{
            if (servletPath.equals("/admin/horario/horarios")){
                List<Horario> horarios = horarioDAO.listarTodos();
                List<Doctor> doctores = doctorDAO.listarDoctores();

                request.setAttribute("horarios", horarios);
                request.setAttribute("doctores", doctores);
                request.getRequestDispatcher("/vistas/admin/horario/horarios.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/horario/horarios.jsp").forward(request, response);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        try {
            if (servletPath.equals("/admin/horario/horarios/agregar")) {
                // Crear horario
                crearHorario(request, response);
            } else if (servletPath.equals("/admin/horario/horarios/actualizar")) {
                // Actualizar horario
                actualizarHorario(request, response);
            } else if (servletPath.equals("/admin/horario/horarios/eliminar")) {
                // Eliminar horario
                eliminarHorario(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Error al guardar el doctor: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
        }
    }

    private void actualizarHorario(HttpServletRequest request, HttpServletResponse response) {
        try{
            // Obtener el id del horario a actualizar
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("error", "ID del horario no proporcionado");
                response.sendRedirect(request.getContextPath() + "/admin/horario/horarios");
                return;
            }
            int id = Integer.parseInt(idStr);
            // Obtener los datos del horario a actualizar
            Horario horario = new Horario();
            horario.setId(id);
            horario.setDoctorId(Integer.parseInt(request.getParameter("doctorId")));
            horario.setNombreDoctor(request.getParameter("nombreDoctor"));
            horario.setApellidoDoctor(request.getParameter("apellidoDoctor"));
            horario.setDiaSemana(request.getParameter("diaSemana"));
            horario.setHoraInicio(LocalTime.parse(request.getParameter("horaInicio")));
            horario.setHoraFin(LocalTime.parse(request.getParameter("horaFin")));
            boolean actualizado = horarioDAO.actualizarHorario(horario);
            if (actualizado) {
                request.setAttribute("mensaje", "Horario actualizado correctamente");
            } else {
                request.setAttribute("error", "No se pudo actualizar el horario");
            }
            response.sendRedirect(request.getContextPath() + "/admin/horario/horarios");
        } catch (IOException | SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void eliminarHorario(HttpServletRequest request, HttpServletResponse response)  throws SQLException, ServletException, IOException {
        try{
            // Obtener el id del horario a eliminar
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("error", "ID del horario no proporcionado");
                response.sendRedirect(request.getContextPath() + "/admin/horario/horarios");
                return;
            }

            int id = Integer.parseInt(idStr);
            // verificar si el doctor existe antes de eliminar
            Horario horario = horarioDAO.obtenerHorario(id);
            if (horario == null) {
                request.setAttribute("error", "El horario no existe");
                response.sendRedirect(request.getContextPath() + "/admin/horario/horarios");
                return;
            }

            boolean eliminado = horarioDAO.eliminarHorario(id);
            if (eliminado) {
                request.setAttribute("mensaje", "Horario eliminado correctamente");
            } else {
                request.setAttribute("error", "No se pudo eliminar el horario");
            }


        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de doctor inválido");
            out.println("Error: ID de doctor inválido");
        } catch (SQLException e) {
            request.setAttribute("error", "Error al eliminar el horario: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/horario/horarios");

    }

    private void crearHorario(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException  {
        try {
            Horario horario = new Horario();
            horario.setDoctorId(Integer.parseInt(request.getParameter("doctorId")));
            horario.setNombreDoctor(request.getParameter("nombreDoctor"));
            horario.setApellidoDoctor(request.getParameter("apellidoDoctor"));
            horario.setDiaSemana(request.getParameter("diaSemana"));
            horario.setHoraInicio(LocalTime.parse(request.getParameter("horaInicio")));
            horario.setHoraFin(LocalTime.parse(request.getParameter("horaFin")));
            horarioDAO.crearDoctor(horario);
            response.sendRedirect(request.getContextPath() + "/admin/horario/horarios");
        } catch (Exception e){

        }
    }
}