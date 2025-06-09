package com.gestorcitas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.gestorcitas.modelo.Especialidad;
import com.gestorcitas.util.DatabaseUtil;

public class EspecialidadDAO {
    
    public List<Especialidad> listarTodas() throws SQLException {
        List<Especialidad> especialidades = new ArrayList<>();
        String sql = "SELECT * FROM especialidades ORDER BY nombre";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                especialidades.add(mapearEspecialidad(rs));
            }
        }
        return especialidades;
    }
    
    public Especialidad buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM especialidades WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearEspecialidad(rs);
                }
            }
        }
        return null;
    }
    
    public void crear(Especialidad especialidad) throws SQLException {
        String sql = "INSERT INTO especialidades (nombre, descripcion) VALUES (?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, especialidad.getNombre());
            stmt.setString(2, especialidad.getDescripcion());
            
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    especialidad.setId(rs.getInt(1));
                }
            }
        }
    }
    
    public void actualizar(Especialidad especialidad) throws SQLException {
        String sql = "UPDATE especialidades SET nombre = ?, descripcion = ? WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, especialidad.getNombre());
            stmt.setString(2, especialidad.getDescripcion());
            stmt.setInt(3, especialidad.getId());
            
            stmt.executeUpdate();
        }
    }
    
    public boolean eliminar(int id) throws SQLException {
        String sqlCitas = "DELETE FROM citas WHERE doctor_id IN (SELECT id FROM doctores WHERE especialidad_id = ?)";
        String sqlDoctores = "DELETE FROM doctores WHERE especialidad_id = ?";
        String sqlEspecialidad = "DELETE FROM especialidades WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Primero eliminar las citas asociadas
                try (PreparedStatement stmt = conn.prepareStatement(sqlCitas)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }

                // Luego eliminar los doctores asociados
                try (PreparedStatement stmt = conn.prepareStatement(sqlDoctores)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }

                // Finalmente eliminar la especialidad
                try (PreparedStatement stmt = conn.prepareStatement(sqlEspecialidad)) {
                    stmt.setInt(1, id);
                    int filasAfectadas = stmt.executeUpdate();
                    
                    if (filasAfectadas > 0) {
                        conn.commit();
                        return true;
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
    
    public int contarTotal() throws SQLException {
        String sql = "SELECT COUNT(*) FROM especialidades";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    private Especialidad mapearEspecialidad(ResultSet rs) throws SQLException {
        Especialidad especialidad = new Especialidad();
        especialidad.setId(rs.getInt("id"));
        especialidad.setNombre(rs.getString("nombre"));
        especialidad.setDescripcion(rs.getString("descripcion"));
        return especialidad;
    }
} 