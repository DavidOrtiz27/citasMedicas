package com.gestorcitas.controlador;

import com.gestorcitas.dao.PacienteDAO;
import com.gestorcitas.modelo.Paciente;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import static java.lang.System.out;

@WebServlet(name = "PacienteServlet", urlPatterns = {"/admin/paciente/pacientes",           // GET - Listar pacientes
		"/admin/paciente/pacientes/nuevo",     // GET - Mostrar formulario nuevo
		"/admin/paciente/pacientes/editar",    // GET - Mostrar formulario editar
		"/admin/paciente/pacientes/guardar",   // POST - Crear paciente
		"/admin/paciente/pacientes/actualizar",// POST - Actualizar paciente
		"/admin/paciente/pacientes/eliminar"   // POST - Eliminar paciente
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
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String servletPath = request.getServletPath();

		try {
			if (servletPath.equals("/admin/paciente/pacientes")) {
				// Listar todos los pacientes
				String buscar = request.getParameter("buscar");
				List<Paciente> pacientes;

				if (buscar != null && !buscar.trim().isEmpty()) {
					pacientes = pacienteDAO.buscarPacientes(buscar);
				} else {
					pacientes = pacienteDAO.listarPacientes();
				}

				request.setAttribute("pacientes", pacientes);
				request.getRequestDispatcher("/vistas/admin/paciente/pacientes.jsp").forward(request, response);


			} else if (servletPath.equals("/admin/paciente/pacientes/nuevo")) {
				request.getRequestDispatcher("/vistas/admin/paciente/nuevo.jsp").forward(request, response);


			} else if (servletPath.equals("/admin/paciente/pacientes/editar")) {
				// Mostrar formulario editar
				int id = Integer.parseInt(request.getParameter("id"));
				Paciente paciente = pacienteDAO.obtenerPaciente(id);
				if (paciente != null) {
					request.setAttribute("paciente", paciente);
					request.getRequestDispatcher("/vistas/admin/paciente/editar.jsp").forward(request, response);
					out.println("Se ha mostrado el formulario de edición");
				} else {
					response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
			request.getRequestDispatcher("/vistas/admin/paciente/pacientes.jsp").forward(request, response);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String servletPath = request.getServletPath();
		out.println("Servlet path: " + servletPath);

		try {
			if (servletPath.equals("/admin/paciente/pacientes/guardar")) {
				crearPaciente(request, response);
			} else if (servletPath.equals("/admin/paciente/pacientes/actualizar")) {
				// Actualizar paciente
				actualizarPaciente(request, response);
				out.println("Se ha actualizado el paciente");


			} else if (servletPath.equals("/admin/paciente/pacientes/eliminar")) {
				eliminarPaciente(request, response);
			} else {
				response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
			request.getRequestDispatcher("/vistas/admin/paciente/pacientes.jsp").forward(request, response);
		}
	}

	private void crearPaciente(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
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

			pacienteDAO.agregarPaciente(paciente);
			out.println("Paciente creado correctamente");
			response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");

		} catch (ParseException e) {
			request.setAttribute("error", "Error en el formato de fecha. Use el formato YYYY-MM-DD");
			request.getRequestDispatcher("/vistas/admin/paciente/nuevo.jsp").forward(request, response);
		}
	}

	private void actualizarPaciente(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));
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

			pacienteDAO.actualizarPaciente(paciente);
			out.println("Paciente actualizado correctamente");

			// Redirigir a la lista de pacientes
			response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");

		} catch (ParseException e) {
			request.setAttribute("error", "Error en el formato de fecha. Use el formato YYYY-MM-DD");
			request.setAttribute("paciente", pacienteDAO.obtenerPaciente(id));
			request.getRequestDispatcher("/vistas/admin/paciente/editar.jsp").forward(request, response);
		} catch (SQLException e) {
			request.setAttribute("error", "Error al actualizar el paciente: " + e.getMessage());
			request.setAttribute("paciente", pacienteDAO.obtenerPaciente(id));
			request.getRequestDispatcher("/vistas/admin/paciente/editar.jsp").forward(request, response);
		}
	}

	private void eliminarPaciente(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
		try {
			// Obtener y validar el ID
			String idStr = request.getParameter("id");
			if (idStr == null || idStr.trim().isEmpty()) {
				request.setAttribute("error", "ID de paciente no proporcionado");
				response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");
				return;
			}

			int id = Integer.parseInt(idStr);
			out.println("Intentando eliminar paciente con ID: " + id);

			// Verificar si el paciente existe antes de eliminar
			Paciente paciente = pacienteDAO.obtenerPaciente(id);
			if (paciente == null) {
				request.setAttribute("error", "El paciente no existe");
				response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");
				return;
			}

			// Intentar eliminar el paciente
			boolean eliminado = pacienteDAO.eliminarPaciente(id);
			if (eliminado) {
				request.setAttribute("mensaje", "Paciente eliminado correctamente");
				out.println("Paciente eliminado correctamente");
			} else {
				request.setAttribute("error", "No se pudo eliminar el paciente");
				out.println("Error al eliminar el paciente");
			}

		} catch (NumberFormatException e) {
			request.setAttribute("error", "ID de paciente inválido");
			out.println("Error: ID de paciente inválido");
		} catch (SQLException e) {
			// Verificar si es un error de clave foránea
			if (e.getMessage().contains("foreign key constraint fails")) {
				request.setAttribute("error", "No se puede eliminar el paciente porque tiene citas médicas asociadas. Por favor, elimine primero las citas del paciente.");
			} else {
				request.setAttribute("error", "Error al eliminar el paciente: " + e.getMessage());
			}
			out.println("Error SQL: " + e.getMessage());
		}

		// Redirigir de vuelta a la lista de pacientes
		response.sendRedirect(request.getContextPath() + "/admin/paciente/pacientes");
	}
} 