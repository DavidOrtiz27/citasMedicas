package com.gestorcitas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.gestorcitas.modelo.Usuario;
import com.gestorcitas.util.DatabaseUtil;

public class UsuarioDAO {

	public Usuario validarUsuario(String username, String password) throws SQLException {
		String sql = "SELECT * FROM usuarios WHERE username = ? AND password = ? AND activo = true";
		Usuario usuario = null;

		try (Connection conn = DatabaseUtil.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setString(1, username);
			stmt.setString(2, password); // En producción, usar hash de contraseña

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					usuario = new Usuario();
					usuario.setId(rs.getInt("id"));
					usuario.setUsername(rs.getString("username"));
					usuario.setPassword(rs.getString("password"));
					usuario.setRol(rs.getString("rol"));
					usuario.setActivo(rs.getBoolean("activo"));
					usuario.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
					usuario.setUltimoAcceso(rs.getTimestamp("ultimo_acceso"));

					// Actualizar último acceso
					actualizarUltimoAcceso(usuario.getId());
				}
			}
		}
		return usuario;
	}

	private boolean actualizarUltimoAcceso(int usuarioId) throws SQLException {
		String sql = "UPDATE usuarios SET ultimo_acceso = NOW() WHERE id = ?";

		try (Connection conn = DatabaseUtil.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, usuarioId);
			return stmt.executeUpdate() > 0;
		}
	}

	public List<Usuario> listarTodos() throws SQLException {
		List<Usuario> usuarios = new ArrayList<>();
		String sql = "SELECT * FROM usuarios ORDER BY id";

		try (Connection conn = DatabaseUtil.getConnection();
			 Statement stmt = conn.createStatement();
			 ResultSet rs = stmt.executeQuery(sql)) {

			while (rs.next()) {
				Usuario usuario = new Usuario();
				usuario.setId(rs.getInt("id"));
				usuario.setUsername(rs.getString("username"));
				usuario.setPassword(rs.getString("password"));
				usuario.setRol(rs.getString("rol"));
				usuario.setActivo(rs.getBoolean("activo"));
				usuario.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
				usuario.setUltimoAcceso(rs.getTimestamp("ultimo_acceso"));
				usuarios.add(usuario);
			}
		}
		return usuarios;
	}

	public Usuario buscarPorId(int id) throws SQLException {
		String sql = "SELECT * FROM usuarios WHERE id = ?";

		try (Connection conn = DatabaseUtil.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, id);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					Usuario usuario = new Usuario();
					usuario.setId(rs.getInt("id"));
					usuario.setUsername(rs.getString("username"));
					usuario.setPassword(rs.getString("password"));
					usuario.setRol(rs.getString("rol"));
					usuario.setActivo(rs.getBoolean("activo"));
					usuario.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
					usuario.setUltimoAcceso(rs.getTimestamp("ultimo_acceso"));
					return usuario;
				}
			}
		}
		return null;
	}

	public boolean crear(Usuario usuario) throws SQLException {
		String sql = "INSERT INTO usuarios (username, password, rol, activo, fecha_creacion) VALUES (?, ?, ?, ?, NOW())";

		try (Connection conn = DatabaseUtil.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setString(1, usuario.getUsername());
			stmt.setString(2, usuario.getPassword());
			stmt.setString(3, usuario.getRol());
			stmt.setBoolean(4, usuario.isActivo());

			return stmt.executeUpdate() > 0;
		}
	}

	public boolean actualizar(Usuario usuario) throws SQLException {
		String sql = "UPDATE usuarios SET username = ?, password = ?, rol = ?, activo = ? WHERE id = ?";

		try (Connection conn = DatabaseUtil.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setString(1, usuario.getUsername());
			stmt.setString(2, usuario.getPassword());
			stmt.setString(3, usuario.getRol());
			stmt.setBoolean(4, usuario.isActivo());
			stmt.setInt(5, usuario.getId());

			return stmt.executeUpdate() > 0;
		}
	}

	public boolean eliminar(int id) throws SQLException {
		String sql = "DELETE FROM usuarios WHERE id = ?";

		try (Connection conn = DatabaseUtil.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, id);
			return stmt.executeUpdate() > 0;
		}
	}

	private boolean usuarioEnUso(int usuarioId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM citas WHERE usuario_id = ?";

		try (Connection conn = DatabaseUtil.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, usuarioId);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1) > 0;
				}
			}
		}
		return false;
	}

	public boolean existeUsername(String username) throws SQLException {
		String sql = "SELECT COUNT(*) FROM usuarios WHERE username = ?";

		try (Connection conn = DatabaseUtil.getConnection();
			 PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setString(1, username);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1) > 0;
				}
			}
		}
		return false;
	}
} 