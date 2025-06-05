package com.gestorcitas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.gestorcitas.modelo.Usuario;
import com.gestorcitas.util.DatabaseUtil;

public class UsuarioDAO {
    
    public Usuario validarUsuario(String username, String password) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE username = ? AND password = ? AND activo = true";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password); // En producción, usar hash de contraseña
            
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
                    
                    // Actualizar último acceso
                    actualizarUltimoAcceso(usuario.getId());
                    
                    return usuario;
                }
            }
        }
        return null;
    }
    
    private void actualizarUltimoAcceso(int usuarioId) throws SQLException {
        String sql = "UPDATE usuarios SET ultimo_acceso = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            stmt.executeUpdate();
        }
    }

    public List<Usuario> listarTodos() throws SQLException {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY username";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
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
} 