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
            conexion = DatabaseUtil.getConnection();
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
        
        try (Statement stmt = conexion.createStatement();
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
        
        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            
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
        
        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public int contarTotal() throws SQLException {
        String sql = "SELECT COUNT(*) FROM doctores";
        
        try (Statement stmt = conexion.createStatement();
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

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {

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
                "FROM doctores d LEFT JOIN especialidades e ON d.especialidad_id = e.id";

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setNombres(rs.getString("nombres"));
                doctor.setDni(rs.getString("dni"));
                doctor.setApellidos(rs.getString("apellidos"));
                doctor.setEmail(rs.getString("email"));
                doctor.setTelefono(rs.getString("telefono"));

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

    public boolean existeDNI(String dni, Integer idExcluir) throws SQLException {
        String sql;
        if (idExcluir == null) {
            sql = "SELECT COUNT(*) FROM doctores WHERE dni = ?";
        } else {
            sql = "SELECT COUNT(*) FROM doctores WHERE dni = ? AND id != ?";
        }

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {

            stmt.setString(1, dni);
            if (idExcluir != null) {
                stmt.setInt(2, idExcluir);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public void agregarDoctor(Doctor doctor) throws SQLException{
        String sql = "INSERT INTO doctores (nombres, apellidos, dni, especialidad_id, email, telefono) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conexion.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, doctor.getNombres());
            stmt.setString(2, doctor.getApellidos());
            stmt.setString(3, doctor.getDni());
            stmt.setInt(4, doctor.getEspecialidad().getId());
            stmt.setString(5, doctor.getEmail());
            stmt.setString(6, doctor.getTelefono());

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    doctor.setId(rs.getInt(1));
                }
            }
        }
    }

    public boolean eliminarDoctor(int id)  throws SQLException {
        try {
            conexion.setAutoCommit(false); // Iniciar transacción

            // Primero eliminar las citas asociadas
            eliminarCitasDoctor(conexion, id);

            // Luego eliminar el doctor
            String sql = "DELETE FROM doctores WHERE id = ?";
            try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
                stmt.setInt(1, id);
                int filasAfectadas = stmt.executeUpdate();

                if (filasAfectadas > 0) {
                    conexion.commit(); // Confirmar transacción
                    return true;
                } else {
                    conexion.rollback(); // Revertir transacción
                    return false;
                }
            }
        } catch (SQLException e) {
            if (conexion != null) {
                try {
                    conexion.rollback(); // Revertir transacción en caso de error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (conexion != null) {
                try {
                    conexion.setAutoCommit(true); // Restaurar autocommit
                    conexion.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void eliminarCitasDoctor(Connection conn, int doctorId) {
        String sql = "DELETE FROM citas WHERE doctor_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Doctor obtenerDoctor(int id) throws SQLException {
        String sql = "SELECT d.*, e.id as especialidad_id, e.nombre as especialidad_nombre, e.descripcion as especialidad_descripcion " +
        "FROM doctores d  INNER JOIN especialidades e ON d.especialidad_id = e.id WHERE  d.id = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearDoctor(rs);
                }
            }
        }
        return null;
    }

    private Doctor mapearDoctor(ResultSet rs) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setId(rs.getInt("id"));
        doctor.setDni(rs.getString("dni"));
        doctor.setNombres(rs.getString("nombres"));
        doctor.setApellidos(rs.getString("apellidos"));
        doctor.setTelefono(rs.getString("telefono"));
        doctor.setEmail(rs.getString("email"));
        
        Especialidad especialidad = new Especialidad();
        especialidad.setId(rs.getInt("especialidad_id"));
        especialidad.setNombre(rs.getString("especialidad_nombre"));
        especialidad.setDescripcion(rs.getString("especialidad_descripcion"));
        doctor.setEspecialidad(especialidad);
        
        return doctor;
    }

    public void actualizarDoctor(Doctor doctor) throws SQLException {
        String sql = "UPDATE doctores SET nombres = ?, apellidos = ?, dni = ?, especialidad_id = ?, email = ?, telefono = ? WHERE id = ?";
        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setString(1, doctor.getNombres());
            stmt.setString(2, doctor.getApellidos());
            stmt.setString(3, doctor.getDni());
            stmt.setInt(4, doctor.getEspecialidad().getId());
            stmt.setString(5, doctor.getEmail());
            stmt.setString(6, doctor.getTelefono());
            stmt.setInt(7, doctor.getId());
            stmt.executeUpdate();
        }
    }

    public List<Doctor> listarPorEspecialidad(int especialidadId) throws SQLException {
        List<Doctor> doctores = new ArrayList<>();
        String sql = "SELECT d.*, e.nombre as especialidad_nombre, e.descripcion as especialidad_descripcion " +
                    "FROM doctores d " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE d.especialidad_id = ? " +
                    "ORDER BY d.apellidos, d.nombres";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, especialidadId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setDni(rs.getString("dni"));
                doctor.setNombres(rs.getString("nombres"));
                doctor.setApellidos(rs.getString("apellidos"));
                doctor.setEmail(rs.getString("email"));
                doctor.setTelefono(rs.getString("telefono"));
                
                Especialidad especialidad = new Especialidad();
                especialidad.setId(especialidadId);
                especialidad.setNombre(rs.getString("especialidad_nombre"));
                especialidad.setDescripcion(rs.getString("especialidad_descripcion"));
                doctor.setEspecialidad(especialidad);
                
                doctores.add(doctor);
            }
        }
        return doctores;
    }

    public Doctor buscarPorId(int id) throws SQLException {
        String sql = "SELECT d.*, e.nombre as especialidad_nombre, e.descripcion as especialidad_descripcion " +
                    "FROM doctores d " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE d.id = ?";
        
        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearDoctor(rs);
            }
        }
        return null;
    }
}