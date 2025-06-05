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
import com.gestorcitas.modelo.Cita;
import com.gestorcitas.util.DocumentoUtil;
import com.google.gson.Gson;
import com.itextpdf.text.DocumentException;

@WebServlet(urlPatterns = {"/admin/citas/citas", "/admin/citas/citas/*"})
public class CitaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CitaDAO citaDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        citaDAO = new CitaDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todas las citas
                List<Cita> citas = citaDAO.listarTodas();
                request.setAttribute("citas", citas);
                request.getRequestDispatcher("/vistas/admin/citas/citas.jsp").forward(request, response);
            } else if (pathInfo != null && pathInfo.startsWith("/comprobante/")) {
                // Generar comprobante PDF
                int citaId = Integer.parseInt(pathInfo.substring("/comprobante/".length()));
                Cita cita = citaDAO.buscarPorId(citaId);
                if (cita != null) {
                    try {
                        DocumentoUtil.generarComprobanteCita(cita, response);
                    } catch (DocumentException e) {
                        throw new ServletException("Error al generar el PDF", e);
                    }
                    return;
                }
            } else if (pathInfo != null && pathInfo.equals("/reporte")) {
                // Generar reporte Excel
                String fechaInicio = request.getParameter("fechaInicio");
                String fechaFin = request.getParameter("fechaFin");
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date inicio = sdf.parse(fechaInicio);
                Date fin = sdf.parse(fechaFin);
                
                List<Cita> citas = citaDAO.listarPorFecha(new java.sql.Date(inicio.getTime()), new java.sql.Date(fin.getTime()));
                DocumentoUtil.generarReporteCitas(citas, response);
                return;

            
            } else if (pathInfo.matches("/\\d+")) {
                // Obtener una cita específica
                int id = Integer.parseInt(pathInfo.substring(1));
                obtenerCita(id, response);
            } else if (pathInfo.equals("/paciente/paciente")) {
                // Listar citas por paciente
                int pacienteId = Integer.parseInt(request.getParameter("id"));
                listarCitasPorPaciente(pacienteId, response);
            } else if (pathInfo.equals("/doctor")) {
                // Listar citas por doctor
                int doctorId = Integer.parseInt(request.getParameter("id"));
                listarCitasPorDoctor(doctorId, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (ParseException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/citas/citas.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        try {
            switch (accion) {
                case "crear":
                    crearCita(request, response);
                    break;
                case "actualizar":
                    actualizarCita(request, response);
                    break;
                case "eliminar":
                    eliminarCita(request, response);
                    break;
                case "actualizarEstado":
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/vistas/admin/citas/citas.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || !pathInfo.matches("/\\d+/estado")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int id = Integer.parseInt(pathInfo.substring(1, pathInfo.length() - 6));
            String estado = request.getParameter("estado");
            
            if (estado == null || !estado.matches("PENDIENTE|CONFIRMADA|CANCELADA")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Estado no válido");
                return;
            }
            
            citaDAO.actualizarEstado(id, estado);
            response.setStatus(HttpServletResponse.SC_OK);
            
            Cita cita = citaDAO.buscarPorId(id);
            response.getWriter().write(gson.toJson(cita));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al actualizar el estado de la cita");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || !pathInfo.matches("/\\d+")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int id = Integer.parseInt(pathInfo.substring(1));
            citaDAO.eliminar(id);
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al eliminar la cita");
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

    private void listarCitasPorPaciente(int pacienteId, HttpServletResponse response) throws IOException {
        try {
            List<Cita> citas = citaDAO.listarPorPaciente(pacienteId);
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(citas));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al listar las citas del paciente");
        }
    }

    private void listarCitasPorDoctor(int doctorId, HttpServletResponse response) throws IOException {
        try {
            List<Cita> citas = citaDAO.listarPorDoctor(doctorId);
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(citas));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al listar las citas del doctor");
        }
    }

    private void crearCita(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        Cita cita = new Cita();
        mapearCita(request, cita);
        
        citaDAO.crear(cita);
        response.sendRedirect(request.getContextPath() + "/admin/citas/citas");
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
    
    private void mapearCita(HttpServletRequest request, Cita cita) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            cita.setFecha(sdf.parse(request.getParameter("fecha")));
            cita.setEstado(request.getParameter("estado"));
            // Aquí se deberían mapear también el doctor y el paciente
            // usando sus respectivos DAOs
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }
} 