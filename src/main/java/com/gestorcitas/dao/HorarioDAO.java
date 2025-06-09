package com.gestorcitas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import com.gestorcitas.modelo.Horario;
import com.gestorcitas.util.DatabaseUtil;

public class HorarioDAO {
    
    public List<Horario> listarTodos() throws SQLException {
        List<Horario> horarios = new ArrayList<>();
        String sql = "SELECT h.*, d.nombres, d.apellidos FROM horarios h " +
                    "INNER JOIN doctores d ON h.doctor_id = d.id " +
                    "WHERE h.activo = true";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Horario horario = new Horario();
                horario.setId(rs.getInt("id"));
                horario.setDoctorId(rs.getInt("doctor_id"));
                horario.setDiaSemana(rs.getString("dia_semana"));
                horario.setHoraInicio(rs.getTime("hora_inicio").toLocalTime());
                horario.setHoraFin(rs.getTime("hora_fin").toLocalTime());
                horario.setActivo(rs.getBoolean("activo"));
                horarios.add(horario);
            }
        }
        return horarios;
    }

    public Horario obtenerPorId(int id) throws SQLException {
        String sql = "SELECT h.*, d.nombres, d.apellidos FROM horarios h " +
                    "INNER JOIN doctores d ON h.doctor_id = d.id " +
                    "WHERE h.id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Horario horario = new Horario();
                    horario.setId(rs.getInt("id"));
                    horario.setDoctorId(rs.getInt("doctor_id"));
                    horario.setDiaSemana(rs.getString("dia_semana"));
                    horario.setHoraInicio(rs.getTime("hora_inicio").toLocalTime());
                    horario.setHoraFin(rs.getTime("hora_fin").toLocalTime());
                    horario.setActivo(rs.getBoolean("activo"));
                    return horario;
                }
            }
        }
        return null;
    }

    public boolean guardar(Horario horario) throws SQLException {
        String sql = horario.getId() == 0 ?
                "INSERT INTO horarios (doctor_id, dia_semana, hora_inicio, hora_fin, activo) VALUES (?, ?, ?, ?, ?)" :
                "UPDATE horarios SET doctor_id = ?, dia_semana = ?, hora_inicio = ?, hora_fin = ?, activo = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, horario.getDoctorId());
            pstmt.setString(2, horario.getDiaSemana());
            pstmt.setTime(3, Time.valueOf(horario.getHoraInicio()));
            pstmt.setTime(4, Time.valueOf(horario.getHoraFin()));
            pstmt.setBoolean(5, horario.isActivo());

            if (horario.getId() != 0) {
                pstmt.setInt(6, horario.getId());
            }

            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean eliminar(int id) throws SQLException {
        String sql = "UPDATE horarios SET activo = false WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public List<Horario> listarPorDoctor(int doctorId) throws SQLException {
        List<Horario> horarios = new ArrayList<>();
        String sql = "SELECT h.*, d.nombres, d.apellidos FROM horarios h " +
                    "INNER JOIN doctores d ON h.doctor_id = d.id " +
                    "WHERE h.doctor_id = ? AND h.activo = true";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Horario horario = new Horario();
                    horario.setId(rs.getInt("id"));
                    horario.setDoctorId(rs.getInt("doctor_id"));
                    horario.setDiaSemana(rs.getString("dia_semana"));
                    horario.setHoraInicio(rs.getTime("hora_inicio").toLocalTime());
                    horario.setHoraFin(rs.getTime("hora_fin").toLocalTime());
                    horario.setActivo(rs.getBoolean("activo"));
                    horarios.add(horario);
                }
            }
        }
        return horarios;
    }

    public boolean actualizar(Horario horario) throws SQLException {
        return guardar(horario);
    }

    public List<Horario> listarDisponibles(int doctorId, java.sql.Date fecha) throws SQLException {
        List<Horario> horarios = new ArrayList<>();
        String sql = "SELECT h.* FROM horarios h " +
                     "WHERE h.doctor_id = ? " +
                     "AND h.fecha = ? " +
                     "AND h.disponible = true " +
                     "AND h.hora > NOW() " +
                     "ORDER BY h.hora";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            stmt.setDate(2, fecha);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Horario horario = new Horario();
                    horario.setId(rs.getInt("id"));
                    horario.setDoctorId(rs.getInt("doctor_id"));
                    horario.setFecha(rs.getDate("fecha"));
                    horario.setHora(rs.getTime("hora"));
                    horario.setDisponible(rs.getBoolean("disponible"));
                    horarios.add(horario);
                }
            }
        }
        return horarios;
    }
} 