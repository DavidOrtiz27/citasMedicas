package com.gestorcitas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Especialidad;
import com.gestorcitas.util.DatabaseUtil;

public class DoctorDAO {
    private Connection conexion;

    public DoctorDAO() {
        try {
            this.conexion = DatabaseUtil.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Doctor> listarTodos() throws SQLException {
        List<Doctor> doctores = new ArrayList<>();
        String sql = "SELECT d.*, e.id as especialidad_id, e.nombre as especialidad_nombre, e.descripcion as especialidad_descripcion " +
                    "FROM doctores d " +
                    "LEFT JOIN especialidades e ON d.especialidad_id = e.id " +
                    "ORDER BY d.apellidos, d.nombres";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setNombres(rs.getString("nombres"));
                doctor.setApellidos(rs.getString("apellidos"));
                
                Especialidad especialidad = new Especialidad();
                especialidad.setId(rs.getInt("especialidad_id"));
                especialidad.setNombre(rs.getString("especialidad_nombre"));
                especialidad.setDescripcion(rs.getString("especialidad_descripcion"));
                doctor.setEspecialidad(especialidad);
                
                doctor.setEmail(rs.getString("email"));
                doctor.setTelefono(rs.getString("telefono"));
                doctores.add(doctor);
            }
        }
        return doctores;
    }
    
    public boolean guardar(Doctor doctor) throws SQLException {
        String sql;
        if (doctor.getId() == 0) {
            sql = "INSERT INTO doctores (nombres, apellidos, especialidad_id, email, telefono) " +
                  "VALUES (?, ?, ?, ?, ?)";
        } else {
            sql = "UPDATE doctores SET nombres = ?, apellidos = ?, " +
                  "especialidad_id = ?, email = ?, telefono = ? WHERE id = ?";
        }
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, doctor.getNombres());
            stmt.setString(2, doctor.getApellidos());
            stmt.setInt(3, doctor.getEspecialidad().getId());
            stmt.setString(4, doctor.getEmail());
            stmt.setString(5, doctor.getTelefono());
            
            if (doctor.getId() != 0) {
                stmt.setInt(6, doctor.getId());
            }
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean eliminar(int id) throws SQLException {
        String sql = "DELETE FROM doctores WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public int contarTotal() throws SQLException {
        String sql = "SELECT COUNT(*) FROM doctores";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }


    public List<Doctor> buscarDoctores(String buscar)  throws SQLException {
        List<Doctor> doctores = new ArrayList<>();
        String sql = "SELECT d.*, e.id as especialidad_id, e.nombre as especialidad_nombre, e.descripcion as especialidad_descripcion " +
                    "FROM doctores d " +
                    "LEFT JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE d.nombres LIKE ? OR d.apellidos LIKE ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String terminoBusqueda = "%" + buscar + "%";
            stmt.setString(1, terminoBusqueda);
            stmt.setString(2, terminoBusqueda);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setId(rs.getInt("id"));
                    doctor.setNombres(rs.getString("nombres"));
                    doctor.setApellidos(rs.getString("apellidos"));

                    Especialidad especialidad = new Especialidad();
                    especialidad.setId(rs.getInt("especialidad_id"));
                    especialidad.setNombre(rs.getString("especialidad_nombre"));
                    especialidad.setDescripcion(rs.getString("especialidad_descripcion"));
                    doctor.setEspecialidad(especialidad);
                    doctores.add(doctor);
                }
            }
        }
        return doctores;
    }

    public List<Doctor> listarDoctores() throws SQLException {
        List<Doctor> doctores = new ArrayList<>();
        String sql = "SELECT d.*, e.id as especialidad_id, e.nombre as especialidad_nombre, e.descripcion as especialidad_descripcion " +
                    "FROM doctores d " +
                    "LEFT JOIN especialidades e ON d.especialidad_id = e.id " +
                    "ORDER BY d.apellidos, d.nombres";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setNombres(rs.getString("nombres"));
                doctor.setApellidos(rs.getString("apellidos"));

                Especialidad especialidad = new Especialidad();
                especialidad.setId(rs.getInt("especialidad_id"));
                especialidad.setNombre(rs.getString("especialidad_nombre"));
                especialidad.setDescripcion(rs.getString("especialidad_descripcion"));
                doctor.setEspecialidad(especialidad);

                doctores.add(doctor);
            }
        }
        return doctores;
    }

    public Doctor buscarPorId(int id) throws SQLException {
        String sql = "SELECT d.*, e.id as especialidad_id, e.nombre as especialidad_nombre, e.descripcion as especialidad_descripcion " +
                    "FROM doctores d " +
                    "LEFT JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE d.id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setNombres(rs.getString("nombres"));
                doctor.setApellidos(rs.getString("apellidos"));
                doctor.setEmail(rs.getString("email"));
                doctor.setTelefono(rs.getString("telefono"));

                Especialidad especialidad = new Especialidad();
                especialidad.setId(rs.getInt("especialidad_id"));
                especialidad.setNombre(rs.getString("especialidad_nombre"));
                especialidad.setDescripcion(rs.getString("especialidad_descripcion"));
                doctor.setEspecialidad(especialidad);

                return doctor;
            }
        }
        return null;
    }

    public List<Doctor> listarPorEspecialidad(int especialidadId) throws SQLException {
        List<Doctor> doctores = new ArrayList<>();
        String sql = "SELECT d.*, e.nombre as especialidad_nombre " +
                    "FROM doctores d " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE d.especialidad_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, especialidadId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setId(rs.getInt("id"));
                    doctor.setNombres(rs.getString("nombres"));
                    doctor.setApellidos(rs.getString("apellidos"));
                    doctor.setTelefono(rs.getString("telefono"));
                    doctor.setEmail(rs.getString("email"));
                    
                    Especialidad especialidad = new Especialidad();
                    especialidad.setId(especialidadId);
                    especialidad.setNombre(rs.getString("especialidad_nombre"));
                    doctor.setEspecialidad(especialidad);
                    
                    doctores.add(doctor);
                }
            }
        }
        return doctores;
    }
}