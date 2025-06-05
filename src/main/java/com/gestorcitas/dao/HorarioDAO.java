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

    public Horario obtenerPorId(int id) {
        String sql = "SELECT h.*, d.nombres, d.apellidos FROM horarios h " +
                    "INNER JOIN doctores d ON h.doctor_id = d.id " +
                    "WHERE h.id = ?";
        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean guardar(Horario horario) {
        String sql = horario.getId() == 0 ?
                "INSERT INTO horarios (doctor_id, dia_semana, hora_inicio, hora_fin, activo) VALUES (?, ?, ?, ?, ?)" :
                "UPDATE horarios SET doctor_id = ?, dia_semana = ?, hora_inicio = ?, hora_fin = ?, activo = ? WHERE id = ?";

        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setInt(1, horario.getDoctorId());
            pstmt.setString(2, horario.getDiaSemana());
            pstmt.setTime(3, Time.valueOf(horario.getHoraInicio()));
            pstmt.setTime(4, Time.valueOf(horario.getHoraFin()));
            pstmt.setBoolean(5, horario.isActivo());

            if (horario.getId() != 0) {
                pstmt.setInt(6, horario.getId());
            }

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "UPDATE horarios SET activo = false WHERE id = ?";
        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Horario> listarPorDoctor(int doctorId) {
        List<Horario> horarios = new ArrayList<>();
        String sql = "SELECT h.*, d.nombres, d.apellidos FROM horarios h " +
                    "INNER JOIN doctores d ON h.doctor_id = d.id " +
                    "WHERE h.doctor_id = ? AND h.activo = true";

        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();

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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return horarios;
    }

	public boolean actualizar(Horario horario) {
        return false;
	}
} 