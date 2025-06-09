package com.gestorcitas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import com.gestorcitas.modelo.Doctor;
import com.gestorcitas.modelo.Horario;
import com.gestorcitas.util.DatabaseUtil;

public class HorarioDAO {
    private Connection conexion;

    public HorarioDAO() {
        try {
            this.conexion = DatabaseUtil.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Horario> listarTodos() {
        List<Horario> horarios = new ArrayList<>();
        String sql = "SELECT h.*, d.nombres, d.apellidos FROM horarios h " +
                "INNER JOIN doctores d ON h.doctor_id = d.id " +
                "WHERE h.activo = true";

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Horario horario = new Horario();
                horario.setId(rs.getInt("id"));
                horario.setDoctorId(rs.getInt("doctor_id"));
                horario.setNombreDoctor(rs.getString("nombres"));
                horario.setApellidoDoctor(rs.getString("apellidos"));
                horario.setDiaSemana(rs.getString("dia_semana"));
                horario.setHoraInicio(rs.getTime("hora_inicio").toLocalTime());
                horario.setHoraFin(rs.getTime("hora_fin").toLocalTime());
                horario.setActivo(rs.getBoolean("activo"));


                horarios.add(horario);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return horarios;
    }

    public void crearDoctor(Horario horario) throws SQLException {
        String sql = "INSERT INTO horarios (doctor_id, dia_semana, hora_inicio, hora_fin) VALUES (?, ?, ?, ?)";

        try (PreparedStatement pstmt = conexion.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, horario.getDoctorId());
            pstmt.setString(2, horario.getDiaSemana());
            pstmt.setTime(3, Time.valueOf(horario.getHoraInicio()));
            pstmt.setTime(4, Time.valueOf(horario.getHoraFin()));

            pstmt.executeUpdate();
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    horario.setId(rs.getInt(1));
                }
            }
        }
    }

    public Horario obtenerHorario(int id) throws SQLException {
        String sql = "SELECT h.*, d.nombres, d.apellidos FROM horarios h " +
                "INNER JOIN doctores d ON h.doctor_id = d.id " +
                "WHERE h.id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Horario horario = new Horario();
                    horario.setId(rs.getInt("id"));
                    horario.setDoctorId(rs.getInt("doctor_id"));
                    horario.setNombreDoctor(rs.getString("nombres"));
                    horario.setApellidoDoctor(rs.getString("apellidos"));
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

    public boolean eliminarHorario(int id) throws SQLException {
        String sql = "UPDATE horarios SET activo = false WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean actualizarHorario(Horario horario) throws SQLException {
        String sql = "UPDATE horarios SET doctor_id = ?, dia_semana = ?, hora_inicio = ?, hora_fin = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, horario.getDoctorId());
            stmt.setString(2, horario.getDiaSemana());
            stmt.setTime(3, Time.valueOf(horario.getHoraInicio()));
            stmt.setTime(4, Time.valueOf(horario.getHoraFin()));
            stmt.setInt(5, horario.getId());
            return stmt.executeUpdate() > 0;
             }
    }
}