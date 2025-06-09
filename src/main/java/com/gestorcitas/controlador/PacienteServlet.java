package com.gestorcitas.controlador;

import java.io.IOException;
import static java.lang.System.out;
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

import com.gestorcitas.dao.PacienteDAO;
import com.gestorcitas.modelo.Paciente;
import com.google.gson.Gson;

@WebServlet(urlPatterns = {
    "/admin/paciente/pacientes",      // GET: Listar pacientes
    "/admin/paciente/crear",          // GET/POST: Crear paciente
    "/admin/paciente/editar/*",       // GET/POST: Editar paciente
    "/admin/paciente/eliminar/*",     // POST: Eliminar paciente
    "/admin/paciente/*"               // GET: Ver detalles de paciente
})
public class PacienteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
	private PacienteDAO pacienteDAO;

	@Override
	public void init() throws ServletException {
		pacienteDAO = new PacienteDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		String requestURI = request.getRequestURI();
		String contextPath = request.getContextPath();
		String path = requestURI.substring(contextPath.length());
		
		System.out.println("doGet - requestURI: " + requestURI);
		System.out.println("doGet - contextPath: " + contextPath);
		System.out.println("doGet - path: " + path);
		
		try {
			if (path.equals("/admin/paciente/pacientes")) {
				listarPacientes(request, response);
			} else if (path.equals("/admin/paciente/crear")) {
				mostrarFormularioCreacion(request, response);
			} else if (path.matches("/admin/paciente/editar/\\d+")) {
				mostrarFormularioEdicion(request, response);
			} else if (path.matches("/admin/paciente/\\d+")) {
				verDetallesPaciente(request, response);
			} else {
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			request.getSession().setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
			response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		String requestURI = request.getRequestURI();
		String contextPath = request.getContextPath();
		String path = requestURI.substring(contextPath.length());
		
		System.out.println("doPost - requestURI: " + requestURI);
		System.out.println("doPost - contextPath: " + contextPath);
		System.out.println("doPost - path: " + path);
		
		try {
			if (path.equals("/admin/paciente/crear")) {
				crearPaciente(request, response);
			} else if (path.matches("/admin/paciente/editar/\\d+")) {
				actualizarPaciente(request, response);
			} else if (path.matches("/admin/paciente/eliminar/\\d+")) {
				eliminarPaciente(request, response);
			} else {
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			request.getSession().setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
			response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");
		}
	}

	private void listarPacientes(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		String buscar = request.getParameter("buscar");
		List<Paciente> pacientes;

		if (buscar != null && !buscar.trim().isEmpty()) {
			pacientes = pacienteDAO.buscarPacientes(buscar);
		} else {
			pacientes = pacienteDAO.listarPacientes();
		}

		request.setAttribute("pacientes", pacientes);
		request.getRequestDispatcher("/vistas/admin/paciente/pacientes.jsp").forward(request, response);
	}

	private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		request.getRequestDispatcher("/vistas/admin/paciente/nuevo.jsp").forward(request, response);
	}

	private void mostrarFormularioEdicion(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException, SQLException {
		String path = request.getRequestURI().substring(request.getContextPath().length());
		String idStr = path.substring("/admin/paciente/editar/".length());
		int id = Integer.parseInt(idStr);
		
		Paciente paciente = pacienteDAO.obtenerPaciente(id);
		if (paciente != null) {
			request.setAttribute("paciente", paciente);
			request.getRequestDispatcher("/vistas/admin/paciente/editar.jsp").forward(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void verDetallesPaciente(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		String path = request.getRequestURI().substring(request.getContextPath().length());
		String idStr = path.substring("/admin/paciente/".length());
		int id = Integer.parseInt(idStr);
		
		Paciente paciente = pacienteDAO.obtenerPaciente(id);
		if (paciente != null) {
			request.setAttribute("paciente", paciente);
			request.getRequestDispatcher("/vistas/admin/paciente/detallesPaciente.jsp").forward(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void crearPaciente(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		String dni = request.getParameter("dni");

		// Validar DNI duplicado
		if (pacienteDAO.existeDNI(dni, null)) {
			request.setAttribute("error", "El DNI ya está registrado");
			request.getRequestDispatcher("/vistas/admin/paciente/nuevo.jsp").forward(request, response);
			return;
		}

		try {
			Paciente paciente = new Paciente();
			paciente.setDni(dni);
			paciente.setNombres(request.getParameter("nombres"));
			paciente.setApellidos(request.getParameter("apellidos"));

			// Convertir fecha de nacimiento
			String fechaNacStr = request.getParameter("fechaNacimiento");
			if (fechaNacStr != null && !fechaNacStr.trim().isEmpty()) {
				java.util.Date fechaNac = DATE_FORMAT.parse(fechaNacStr);
				paciente.setFechaNacimiento(new Date(fechaNac.getTime()));
			}

			paciente.setGenero(request.getParameter("genero"));
			paciente.setDireccion(request.getParameter("direccion"));
			paciente.setTelefono(request.getParameter("telefono"));
			paciente.setEmail(request.getParameter("email"));

			if (pacienteDAO.agregarPaciente(paciente)) {
				request.getSession().setAttribute("mensaje", "Paciente creado exitosamente");
				response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");
			} else {
				request.setAttribute("error", "No se pudo crear el paciente");
				request.getRequestDispatcher("/vistas/admin/paciente/nuevo.jsp").forward(request, response);
			}
		} catch (ParseException e) {
			request.setAttribute("error", "Error en el formato de fecha. Use el formato YYYY-MM-DD");
			request.getRequestDispatcher("/vistas/admin/paciente/nuevo.jsp").forward(request, response);
		}
	}

	private void actualizarPaciente(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		String path = request.getRequestURI().substring(request.getContextPath().length());
		String idStr = path.substring("/admin/paciente/editar/".length());
		int id = Integer.parseInt(idStr);
		String dni = request.getParameter("dni");

		try {
			// Validar DNI duplicado
			if (pacienteDAO.existeDNI(dni, id)) {
				request.setAttribute("error", "El DNI ya está registrado");
				request.setAttribute("paciente", pacienteDAO.obtenerPaciente(id));
				request.getRequestDispatcher("/vistas/admin/paciente/editar.jsp").forward(request, response);
				return;
			}

			Paciente paciente = new Paciente();
			paciente.setId(id);
			paciente.setDni(dni);
			paciente.setNombres(request.getParameter("nombres"));
			paciente.setApellidos(request.getParameter("apellidos"));

			// Convertir fecha de nacimiento
			String fechaNacStr = request.getParameter("fechaNacimiento");
			if (fechaNacStr != null && !fechaNacStr.trim().isEmpty()) {
				java.util.Date fechaNac = DATE_FORMAT.parse(fechaNacStr);
				paciente.setFechaNacimiento(new Date(fechaNac.getTime()));
			}

			paciente.setGenero(request.getParameter("genero"));
			paciente.setDireccion(request.getParameter("direccion"));
			paciente.setTelefono(request.getParameter("telefono"));
			paciente.setEmail(request.getParameter("email"));

			if (pacienteDAO.actualizarPaciente(paciente)) {
				request.getSession().setAttribute("mensaje", "Paciente actualizado exitosamente");
				response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");
			} else {
				request.setAttribute("error", "No se pudo actualizar el paciente");
				request.getRequestDispatcher("/vistas/admin/paciente/editar.jsp").forward(request, response);
			}
		} catch (ParseException e) {
			request.setAttribute("error", "Error en el formato de fecha. Use el formato YYYY-MM-DD");
			request.getRequestDispatcher("/vistas/admin/paciente/editar.jsp").forward(request, response);
		}
	}

	private void eliminarPaciente(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		String path = request.getRequestURI().substring(request.getContextPath().length());
		String idStr = path.substring("/admin/paciente/eliminar/".length());
		int id = Integer.parseInt(idStr);
		
		if (pacienteDAO.eliminarPaciente(id)) {
			response.setContentType("application/json");
			response.getWriter().write("{\"success\": true, \"message\": \"Paciente eliminado exitosamente\"}");
		} else {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.setContentType("application/json");
			response.getWriter().write("{\"success\": false, \"message\": \"No se pudo eliminar el paciente\"}");
		}
	}
} 