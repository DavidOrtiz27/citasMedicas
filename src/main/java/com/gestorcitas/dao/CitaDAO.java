package com.gestorcitas.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
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
                    "e.nombre as especialidad_nombre " +
                    "FROM citas c " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "ORDER BY c.fecha DESC, c.hora";
                    
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                citas.add(mapearCita(rs));
            }
        }
        return citas;
    }
    
    public List<Cita> listarPorPaciente(int pacienteId) throws SQLException {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres as paciente_nombres, p.apellidos as paciente_apellidos, " +
                    "d.nombres as doctor_nombres, d.apellidos as doctor_apellidos, " +
                    "e.nombre as especialidad_nombre " +
                    "FROM citas c " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE c.paciente_id = ? " +
                    "ORDER BY c.fecha DESC, c.hora";
                    
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, pacienteId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    citas.add(mapearCita(rs));
                }
            }
        }
        return citas;
    }
    
    public List<Cita> listarPorDoctor(int doctorId) throws SQLException {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres as paciente_nombres, p.apellidos as paciente_apellidos, " +
                    "d.nombres as doctor_nombres, d.apellidos as doctor_apellidos, " +
                    "e.nombre as especialidad_nombre " +
                    "FROM citas c " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "WHERE c.doctor_id = ? " +
                    "ORDER BY c.fecha DESC, c.hora";
                    
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    citas.add(mapearCita(rs));
                }
            }
        }
        return citas;
    }
    
    public Cita buscarPorId(int id) throws SQLException {
        String sql = "SELECT c.*, d.*, e.*, p.* FROM citas c " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "WHERE c.id = ?";
                    
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearCita(rs);
            }
        }
        return null;
    }
    
    public void crear(Cita cita) throws SQLException {
        String sql = "INSERT INTO citas (fecha, hora, paciente_id, doctor_id, estado) " +
                    "VALUES (?, ?, ?, ?, ?)";
                    
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setDate(1, new java.sql.Date(cita.getFecha().getTime()));
            stmt.setString(2, cita.getHora());
            stmt.setInt(3, cita.getPaciente().getId());
            stmt.setInt(4, cita.getDoctor().getId());
            stmt.setString(5, cita.getEstado());
            
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    cita.setId(rs.getInt(1));
                }
            }
        }
    }
    
    public void actualizarEstado(int id, String estado) throws SQLException {
        String sql = "UPDATE citas SET estado = ? WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, estado);
            stmt.setInt(2, id);
            stmt.executeUpdate();
        }
    }
    
    public void eliminar(int id) throws SQLException {
        String sql = "DELETE FROM citas WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
    
    public boolean existeCitaEnHorario(Date fecha, String hora, int doctorId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM citas WHERE fecha = ? AND hora = ? AND doctor_id = ? " +
                    "AND estado != 'CANCELADA'";
                    
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, new java.sql.Date(fecha.getTime()));
            stmt.setString(2, hora);
            stmt.setInt(3, doctorId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    public List<Cita> listarProximasCitas() throws SQLException {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres as paciente_nombres, p.apellidos as paciente_apellidos, " +
                    "d.nombres as doctor_nombres, d.apellidos as doctor_apellidos, " +
                    "e.nombre as especialidad_nombre " +
                    "FROM citas c " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "ORDER BY c.fecha ASC, c.hora ASC " +
                    "LIMIT 10";
        
        System.out.println("Ejecutando consulta: " + sql);
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("Conexión establecida correctamente");
            
            while (rs.next()) {
                System.out.println("Procesando cita ID: " + rs.getInt("c.id") + 
                                 ", Fecha: " + rs.getDate("c.fecha"));
                citas.add(mapearCita(rs));
            }
            
            System.out.println("Total de citas encontradas: " + citas.size());
        } catch (SQLException e) {
            System.err.println("Error al listar próximas citas: " + e.getMessage());
            throw e;
        }
        return citas;
    }
    
    public int contarCitasHoy() throws SQLException {
        String sql = "SELECT COUNT(*) FROM citas WHERE fecha = CURDATE()";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public List<Cita> listarPorFecha(Date fechaInicio, Date fechaFin) throws SQLException {
        String sql = "SELECT c.*, d.*, e.*, p.* FROM citas c " +
                    "JOIN doctores d ON c.doctor_id = d.id " +
                    "JOIN especialidades e ON d.especialidad_id = e.id " +
                    "JOIN pacientes p ON c.paciente_id = p.id " +
                    "WHERE c.fecha BETWEEN ? AND ? " +
                    "ORDER BY c.fecha ASC";
                    
        List<Cita> citas = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, new java.sql.Date(fechaInicio.getTime()));
            stmt.setDate(2, new java.sql.Date(fechaFin.getTime()));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                citas.add(mapearCita(rs));
            }
        }
        return citas;
    }
    
    public void modificar(Cita cita) throws SQLException {
        String sql = "UPDATE citas SET fecha = ?, doctor_id = ?, paciente_id = ?, estado = ? WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, new Timestamp(cita.getFecha().getTime()));
            stmt.setInt(2, cita.getDoctor().getId());
            stmt.setInt(3, cita.getPaciente().getId());
            stmt.setString(4, cita.getEstado());
            stmt.setInt(5, cita.getId());
            
            stmt.executeUpdate();
        }
    }
    
    private Cita mapearCita(ResultSet rs) throws SQLException {
        try {
            Cita cita = new Cita();
            cita.setId(rs.getInt("c.id"));
            cita.setFecha(rs.getDate("c.fecha"));
            cita.setHora(rs.getString("c.hora"));
            cita.setEstado(rs.getString("c.estado"));
            
            // Mapear doctor
            Doctor doctor = new Doctor();
            doctor.setNombres(rs.getString("doctor_nombres"));
            doctor.setApellidos(rs.getString("doctor_apellidos"));
            
            // Mapear especialidad
            Especialidad especialidad = new Especialidad();
            especialidad.setNombre(rs.getString("especialidad_nombre"));
            doctor.setEspecialidad(especialidad);
            
            cita.setDoctor(doctor);
            
            // Mapear paciente
            Paciente paciente = new Paciente();
            paciente.setNombres(rs.getString("paciente_nombres"));
            paciente.setApellidos(rs.getString("paciente_apellidos"));
            cita.setPaciente(paciente);
            
            System.out.println("Cita mapeada correctamente - ID: " + cita.getId() + 
                             ", Fecha: " + cita.getFecha() + 
                             ", Doctor: " + doctor.getNombres() + " " + doctor.getApellidos());
            
            return cita;
        } catch (SQLException e) {
            System.err.println("Error al mapear cita: " + e.getMessage());
            throw e;
        }
    }
} 