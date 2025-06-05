package com.gestorcitas.controlador;

import java.io.IOException;
import java.time.LocalTime;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gestorcitas.dao.HorarioDAO;
import com.gestorcitas.modelo.Horario;
import com.gestorcitas.util.LocalTimeAdapter;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

@WebServlet(urlPatterns = {"/admin/horario/horarios", "/admin/horario/horarios/*"})
public class HorarioServlet extends HttpServlet {
    private HorarioDAO horarioDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        horarioDAO = new HorarioDAO();
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalTime.class, new LocalTimeAdapter())
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Si es una petición AJAX o API
        if (request.getHeader("X-Requested-With") != null || 
            request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json")) {
            handleApiRequest(request, response);
            return;
        }
        
        // Si es una petición normal de página
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todos los horarios
                List<Horario> horarios = horarioDAO.listarTodos();
                request.setAttribute("horarios", horarios);
                request.getRequestDispatcher("/vistas/admin/horario/horarios.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los horarios: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/horario/horarios.jsp").forward(request, response);
        }
    }
    
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todos los horarios
                List<Horario> horarios = horarioDAO.listarTodos();
                response.getWriter().write(gson.toJson(horarios));
            } else if (pathInfo.matches("/\\d+")) {
                // Obtener un horario específico
                int id = Integer.parseInt(pathInfo.substring(1));
                Horario horario = horarioDAO.obtenerPorId(id);
                if (horario != null) {
                    response.getWriter().write(gson.toJson(horario));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Crear nuevo horario
                Horario horario = gson.fromJson(request.getReader(), Horario.class);
                horario.setActivo(true);
                if (horarioDAO.guardar(horario)) {
                    response.setStatus(HttpServletResponse.SC_CREATED);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
            } else if (pathInfo.matches("/\\d+")) {
                // Actualizar horario existente
                int id = Integer.parseInt(pathInfo.substring(1));
                Horario horario = gson.fromJson(request.getReader(), Horario.class);
                horario.setId(id);
                if (horarioDAO.actualizar(horario)) {
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null && pathInfo.matches("/\\d+")) {
                int id = Integer.parseInt(pathInfo.substring(1));
                if (horarioDAO.eliminar(id)) {
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}