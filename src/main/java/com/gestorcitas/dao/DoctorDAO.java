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
import com.gestorcitas.modelo.Paciente;
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
                "FROM doctores d LEFT JOIN especialidades e ON d.especialidad_id = e.id";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
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

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false); // Iniciar transacción

            // Primero eliminar las citas asociadas
            eliminarCitasDoctor(conn, id);

            // Luego eliminar el doctor
            String sql = "DELETE FROM doctores WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                int filasAfectadas = stmt.executeUpdate();

                if (filasAfectadas > 0) {
                    conn.commit(); // Confirmar transacción
                    return true;
                } else {
                    conn.rollback(); // Revertir transacción
                    return false;
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Revertir transacción en caso de error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Restaurar autocommit
                    conn.close();
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

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setId(rs.getInt("id"));
                    doctor.setDni(rs.getString("dni"));
                    doctor.setNombres(rs.getString("nombres"));
                    doctor.setApellidos(rs.getString("apellidos"));
                    doctor.setTelefono(rs.getString("telefono"));
                    doctor.setEmail(rs.getString("email"));
                    doctor.setEspecialidad(new Especialidad(rs.getInt("especialidad_id"), rs.getString("especialidad_nombre"), rs.getString("especialidad_descripcion")));
                    return doctor;
                }
            }
        }
        return null;
    }

    public void actualizarDoctor(Doctor doctor) throws SQLException {
        String sql = "UPDATE doctores SET nombres = ?, apellidos = ?, dni = ?, especialidad_id = ?, email = ?, telefono = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
}