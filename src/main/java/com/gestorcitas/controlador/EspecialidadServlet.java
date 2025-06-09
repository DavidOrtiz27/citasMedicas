package com.gestorcitas.controlador;

import java.io.IOException;
import java.io.Serial;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gestorcitas.dao.EspecialidadDAO;
import com.gestorcitas.modelo.Especialidad;
import com.google.gson.Gson;

@WebServlet(urlPatterns = {
        "/admin/especialidad/especialidades",
        "/admin/especialidad/especialidades/agregar",
        "/admin/especialidad/especialidades/eliminar",
        "/admin/especialidad/especialidades/actualizar"
})
public class EspecialidadServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;
    
    private EspecialidadDAO especialidadDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        especialidadDAO = new EspecialidadDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        try {
            if (servletPath.equals("/admin/especialidad/especialidades")) {
                // Cargar las especialidades
                List<Especialidad> especialidades = especialidadDAO.listarTodos();

                request.setAttribute("especialidades", especialidades);
                request.getRequestDispatcher("/vistas/admin/especialidad/especialidades.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/especialidad/especialidades.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        try {
            if (servletPath.equals("/admin/especialidad/especialidades/agregar")) {
                crearEspecialidad(request, response);
            }else if(servletPath.equals("/admin/especialidad/especialidades/eliminar")){
                eliminarEspecialidad(request, response);
            } else if(servletPath.equals("/admin/especialidad/especialidades/actualizar")){
                actualizarEspecialidad(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al guardar el doctor: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/especialidad/especialidades.jsp").forward(request, response);
        }
    }

    private void actualizarEspecialidad(HttpServletRequest request, HttpServletResponse response)  throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try{
            Especialidad especialidad = new Especialidad();
            especialidad.setId(id);
            especialidad.setNombre(request.getParameter("nombre"));
            especialidad.setDescripcion(request.getParameter("descripcion"));

            especialidadDAO.actualizar(especialidad);
            response.sendRedirect(request.getContextPath() + "/admin/especialidad/especialidades");
        } catch (SQLException e){
            request.setAttribute("error", "Error al actualizar la especialidad: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/especialidad/especialidades");
        } catch (IOException e){
            throw new RuntimeException(e);
        }


    }

    private void eliminarEspecialidad(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try{
            // Obtener y validar el ID
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("error", "ID de especialidad no proporcionado");
                response.sendRedirect(request.getContextPath() + "/admin/especialidad/especialidades");
                return;
            }

            int id = Integer.parseInt(request.getParameter("id"));

            // Verificar si la especialidad existe antes de eliminar
            Especialidad especialidad = especialidadDAO.buscarPorId(id);
            if (especialidad == null) {
                request.setAttribute("error", "Especialidad no encontrada");
                response.sendRedirect(request.getContextPath() + "/admin/especialidad/especialidades");
                return;
            }

            // intentar eliminar la especialidad
            boolean eliminado = especialidadDAO.eliminar(id);
            if (eliminado) {
                request.setAttribute("mensaje", "Especialidad eliminada correctamente");
            } else {
                request.setAttribute("error", "No se pudo eliminar la especialidad");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de especialidad no válido: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/especialidad/especialidades");
        }catch (SQLException e){
            // verificar si es un error de clave foránea
            if (e.getMessage().contains("foreign key constraint fails")) {
                request.setAttribute("error", "No se puede eliminar la especialidad porque tiene doctores asociados.");
            } else {
                request.setAttribute("error", "Error al eliminar la especialidad: " + e.getMessage());
            }
        }
        // Redirigir a la lista de especialidades
        response.sendRedirect(request.getContextPath() + "/admin/especialidad/especialidades");
    }

    private void crearEspecialidad(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException  {
        try{
            Especialidad especialidad = new Especialidad();
            especialidad.setNombre(request.getParameter("nombre"));
            especialidad.setDescripcion(request.getParameter("descripcion"));

            especialidadDAO.crear(especialidad);
            response.sendRedirect(request.getContextPath() + "/admin/especialidad/especialidades");
        } catch (Exception e){
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/adminespecialidad/especialidades.jsp").forward(request, response);
        }
    }
} 
