package com.gestorcitas.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.gestorcitas.modelo.Cita;
import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Especialidad;
import com.gestorcitas.modelo.Paciente;
import com.gestorcitas.util.DatabaseUtil;

public class CitaDAO {
    public List<Cita> listarTodas() throws SQLException {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres as paciente_nombres, p.apellidos as paciente_apellidos, " +
                    "d.nombres as doctor_nombres, d.apellidos as doctor_apellidos, " +
                    "d.especialidad_id, e.nombre as especialidad_nombre " +
                    "FROM citas c " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "ORDER BY c.fecha DESC, c.hora DESC";

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                while (rs.next()) {
                    citas.add(mapearCita(rs));
                }
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
        return citas;
    }

    public boolean crear(Cita cita) throws SQLException {
        String sql = "INSERT INTO citas (fecha, hora, paciente_id, doctor_id, estado, fecha_creacion) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setDate(1, new java.sql.Date(cita.getFecha().getTime()));
                stmt.setString(2, cita.getHora());
                stmt.setInt(3, cita.getPaciente().getId());
                stmt.setInt(4, cita.getDoctor().getId());
                stmt.setString(5, cita.getEstado());
                stmt.setTimestamp(6, new java.sql.Timestamp(cita.getFechaCreacion().getTime()));

                return stmt.executeUpdate() > 0;
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
    }

    public boolean modificar(Cita cita) throws SQLException {
        String sql = "UPDATE citas SET fecha = ?, hora = ?, paciente_id = ?, " +
                    "doctor_id = ?, estado = ?, motivo_cancelacion = ? WHERE id = ?";

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setDate(1, new java.sql.Date(cita.getFecha().getTime()));
                stmt.setString(2, cita.getHora());
                stmt.setInt(3, cita.getPaciente().getId());
                stmt.setInt(4, cita.getDoctor().getId());
                stmt.setString(5, cita.getEstado());
                stmt.setString(6, cita.getMotivoCancelacion());
                stmt.setInt(7, cita.getId());

                return stmt.executeUpdate() > 0;
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
    }

    public boolean eliminar(int id) throws SQLException {
        String sql = "DELETE FROM citas WHERE id = ?";

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                return stmt.executeUpdate() > 0;
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
    }

    public Cita buscarPorId(int id) throws SQLException {
        String sql = "SELECT c.*, p.nombres as paciente_nombres, p.apellidos as paciente_apellidos, " +
                    "d.nombres as doctor_nombres, d.apellidos as doctor_apellidos, " +
                    "d.especialidad_id, e.nombre as especialidad_nombre " +
                    "FROM citas c " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE c.id = ?";

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return mapearCita(rs);
                    }
                }
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
        return null;
    }

    public boolean existeCitaEnHorario(Date fecha, String hora, int doctorId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM citas WHERE fecha = ? AND hora = ? AND doctor_id = ? AND estado != 'CANCELADA'";

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setDate(1, new java.sql.Date(fecha.getTime()));
                stmt.setString(2, hora);
                stmt.setInt(3, doctorId);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
        return false;
    }

    public boolean actualizarEstado(int id, String estado, String motivoCancelacion) throws SQLException {
        String sql = "UPDATE citas SET estado = ?, motivo_cancelacion = ? WHERE id = ?";

        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, estado);
                stmt.setString(2, motivoCancelacion);
                stmt.setInt(3, id);

                return stmt.executeUpdate() > 0;
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
    }

    public List<Cita> listarPorPaciente(int pacienteId) throws SQLException {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres as paciente_nombres, p.apellidos as paciente_apellidos, " +
                    "d.nombres as doctor_nombres, d.apellidos as doctor_apellidos, " +
                    "d.especialidad_id, e.nombre as especialidad_nombre " +
                    "FROM citas c " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE c.paciente_id = ? " +
                    "ORDER BY c.fecha DESC, c.hora";
                    
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, pacienteId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        citas.add(mapearCita(rs));
                    }
                }
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
        return citas;
    }
    
    public List<Cita> listarPorDoctor(int doctorId) throws SQLException {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres as paciente_nombres, p.apellidos as paciente_apellidos, " +
                    "d.nombres as doctor_nombres, d.apellidos as doctor_apellidos, " +
                    "d.especialidad_id, e.nombre as especialidad_nombre " +
                    "FROM citas c " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE c.doctor_id = ? " +
                    "ORDER BY c.fecha DESC, c.hora";
                    
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, doctorId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        citas.add(mapearCita(rs));
                    }
                }
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
        return citas;
    }
    
    public List<Cita> listarProximasCitas() throws SQLException {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres as paciente_nombres, p.apellidos as paciente_apellidos, " +
                    "d.nombres as doctor_nombres, d.apellidos as doctor_apellidos, " +
                    "d.especialidad_id, e.nombre as especialidad_nombre " +
                    "FROM citas c " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE c.fecha >= CURDATE() " +
                    "ORDER BY c.fecha ASC, c.hora ASC " +
                    "LIMIT 10";
        
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    citas.add(mapearCita(rs));
                }
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
        return citas;
    }
    
    public int contarCitasHoy() throws SQLException {
        String sql = "SELECT COUNT(*) FROM citas WHERE fecha = CURDATE()";
        
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
        return 0;
    }
    
    public List<Cita> listarPorFecha(Date fechaInicio, Date fechaFin) throws SQLException {
        String sql = "SELECT c.*, p.nombres as paciente_nombres, p.apellidos as paciente_apellidos, " +
                    "d.nombres as doctor_nombres, d.apellidos as doctor_apellidos, " +
                    "d.especialidad_id, e.nombre as especialidad_nombre " +
                    "FROM citas c " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE c.fecha BETWEEN ? AND ? " +
                    "ORDER BY c.fecha ASC, c.hora ASC";
                    
        List<Cita> citas = new ArrayList<>();
        
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setDate(1, new java.sql.Date(fechaInicio.getTime()));
                stmt.setDate(2, new java.sql.Date(fechaFin.getTime()));
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        citas.add(mapearCita(rs));
                    }
                }
            }
        } finally {
            if (conn != null) {
                DatabaseUtil.releaseConnection(conn);
            }
        }
        return citas;
    }
    
    private Cita mapearCita(ResultSet rs) throws SQLException {
        Cita cita = new Cita();
        cita.setId(rs.getInt("id"));
        cita.setFecha(rs.getDate("fecha"));
        cita.setHora(rs.getString("hora"));
        cita.setEstado(rs.getString("estado"));
        cita.setMotivoCancelacion(rs.getString("motivo_cancelacion"));
        cita.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        
        // Mapear doctor
        Doctor doctor = new Doctor();
        doctor.setId(rs.getInt("doctor_id"));
        doctor.setNombres(rs.getString("doctor_nombres"));
        doctor.setApellidos(rs.getString("doctor_apellidos"));
        
        // Mapear especialidad del doctor
        Especialidad especialidad = new Especialidad();
        especialidad.setId(rs.getInt("d.especialidad_id"));
        especialidad.setNombre(rs.getString("especialidad_nombre"));
        doctor.setEspecialidad(especialidad);
        
        cita.setDoctor(doctor);
        
        // Mapear paciente
        Paciente paciente = new Paciente();
        paciente.setId(rs.getInt("paciente_id"));
        paciente.setNombres(rs.getString("paciente_nombres"));
        paciente.setApellidos(rs.getString("paciente_apellidos"));
        cita.setPaciente(paciente);
        
        return cita;
    }
} 