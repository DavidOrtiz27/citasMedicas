package com.gestorcitas.controlador;

import java.io.IOException;
import java.sql.SQLException;
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
import com.google.gson.Gson;

@WebServlet(urlPatterns = {
        "/admin/doctor/doctores",
        "/admin/doctor/doctores/agregar"
})
public class DoctorServlet extends HttpServlet {
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
                // Listar todos los doctores
                String buscar = request.getParameter("buscar");
                List<Doctor> doctores;

                if (buscar != null && !buscar.trim().isEmpty()) {
                    doctores = doctorDAO.buscarDoctores(buscar);
                } else {
                    doctores = doctorDAO.listarDoctores();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/paciente/pacientes.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        try {
            if (servletPath.equals("/admin/doctor/doctores/agregar")) {
                crearDoctor(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al guardar el doctor: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/doctor/doctores.jsp").forward(request, response);
        }
    }

    private void crearDoctor(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        Doctor doctor = new Doctor();
        mapearDoctor(request, doctor);
        doctorDAO.crear(doctor);
        response.sendRedirect(request.getContextPath() + "/admin/doctor/doctores");
    }
}

    
