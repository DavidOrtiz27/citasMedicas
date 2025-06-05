package com.gestorcitas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.gestorcitas.modelo.Paciente;
import com.gestorcitas.util.DatabaseUtil;

public class PacienteDAO {
    
    public List<Paciente> listarPacientes() throws SQLException {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT * FROM pacientes ORDER BY apellidos, nombres";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setId(rs.getInt("id"));
                paciente.setDni(rs.getString("dni"));
                paciente.setNombres(rs.getString("nombres"));
                paciente.setApellidos(rs.getString("apellidos"));
                paciente.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                paciente.setGenero(rs.getString("genero"));
                paciente.setDireccion(rs.getString("direccion"));
                paciente.setTelefono(rs.getString("telefono"));
                paciente.setEmail(rs.getString("email"));
                pacientes.add(paciente);
            }
        }
        return pacientes;
    }

    public List<Paciente> buscarPacientes(String termino) throws SQLException {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT * FROM pacientes WHERE nombres LIKE ? OR apellidos LIKE ? OR dni LIKE ? ORDER BY apellidos, nombres";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String terminoBusqueda = "%" + termino + "%";
            stmt.setString(1, terminoBusqueda);
            stmt.setString(2, terminoBusqueda);
            stmt.setString(3, terminoBusqueda);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Paciente paciente = new Paciente();
                    paciente.setId(rs.getInt("id"));
                    paciente.setDni(rs.getString("dni"));
                    paciente.setNombres(rs.getString("nombres"));
                    paciente.setApellidos(rs.getString("apellidos"));
                    paciente.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    paciente.setGenero(rs.getString("genero"));
                    paciente.setDireccion(rs.getString("direccion"));
                    paciente.setTelefono(rs.getString("telefono"));
                    paciente.setEmail(rs.getString("email"));
                    pacientes.add(paciente);
                }
            }
        }
        return pacientes;
    }

    public Paciente obtenerPaciente(int id) throws SQLException {
        String sql = "SELECT * FROM pacientes WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Paciente paciente = new Paciente();
                    paciente.setId(rs.getInt("id"));
                    paciente.setDni(rs.getString("dni"));
                    paciente.setNombres(rs.getString("nombres"));
                    paciente.setApellidos(rs.getString("apellidos"));
                    paciente.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    paciente.setGenero(rs.getString("genero"));
                    paciente.setDireccion(rs.getString("direccion"));
                    paciente.setTelefono(rs.getString("telefono"));
                    paciente.setEmail(rs.getString("email"));
                    return paciente;
                }
            }
        }
        return null;
    }

    public void agregarPaciente(Paciente paciente) throws SQLException {
        String sql = "INSERT INTO pacientes (dni, nombres, apellidos, fecha_nacimiento, genero, direccion, telefono, email) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, paciente.getDni());
            stmt.setString(2, paciente.getNombres());
            stmt.setString(3, paciente.getApellidos());
            
            // Manejar fecha nula
            if (paciente.getFechaNacimiento() != null) {
                stmt.setDate(4, new java.sql.Date(paciente.getFechaNacimiento().getTime()));
            } else {
                stmt.setNull(4, java.sql.Types.DATE);
            }
            
            stmt.setString(5, paciente.getGenero());
            stmt.setString(6, paciente.getDireccion());
            stmt.setString(7, paciente.getTelefono());
            stmt.setString(8, paciente.getEmail());
            
            stmt.executeUpdate();
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    paciente.setId(generatedKeys.getInt(1));
                }
            }
        }
    }

    public void actualizarPaciente(Paciente paciente) throws SQLException {
        String sql = "UPDATE pacientes SET dni = ?, nombres = ?, apellidos = ?, " +
                    "fecha_nacimiento = ?, genero = ?, direccion = ?, telefono = ?, email = ? " +
                    "WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, paciente.getDni());
            stmt.setString(2, paciente.getNombres());
            stmt.setString(3, paciente.getApellidos());
            
            // Manejar fecha nula
            if (paciente.getFechaNacimiento() != null) {
                stmt.setDate(4, new java.sql.Date(paciente.getFechaNacimiento().getTime()));
            } else {
                stmt.setNull(4, java.sql.Types.DATE);
            }
            
            stmt.setString(5, paciente.getGenero());
            stmt.setString(6, paciente.getDireccion());
            stmt.setString(7, paciente.getTelefono());
            stmt.setString(8, paciente.getEmail());
            stmt.setInt(9, paciente.getId());
            
            stmt.executeUpdate();
        }
    }

    public boolean eliminarPaciente(int id) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false); // Iniciar transacción
            
            // Primero eliminar las citas asociadas
            eliminarCitasPaciente(conn, id);
            
            // Luego eliminar el paciente
            String sql = "DELETE FROM pacientes WHERE id = ?";
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

    private void eliminarCitasPaciente(Connection conn, int pacienteId) throws SQLException {
        String sql = "DELETE FROM citas WHERE paciente_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pacienteId);
            stmt.executeUpdate();
        }
    }

    public boolean existeDNI(String dni, Integer idExcluir) throws SQLException {
        String sql;
        if (idExcluir == null) {
            sql = "SELECT COUNT(*) FROM pacientes WHERE dni = ?";
        } else {
            sql = "SELECT COUNT(*) FROM pacientes WHERE dni = ? AND id != ?";
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
    
    public Paciente buscarPorDNI(String dni) throws SQLException {
        String sql = "SELECT * FROM pacientes WHERE dni = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dni);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Paciente paciente = new Paciente();
                    paciente.setId(rs.getInt("id"));
                    paciente.setDni(rs.getString("dni"));
                    paciente.setNombres(rs.getString("nombres"));
                    paciente.setApellidos(rs.getString("apellidos"));
                    paciente.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    paciente.setGenero(rs.getString("genero"));
                    paciente.setDireccion(rs.getString("direccion"));
                    paciente.setTelefono(rs.getString("telefono"));
                    paciente.setEmail(rs.getString("email"));
                    return paciente;
                }
            }
        }
        return null;
    }
    
    public int contarTotal() throws SQLException {
        String sql = "SELECT COUNT(*) FROM pacientes";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Paciente> listarTodos() throws SQLException {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT * FROM pacientes ORDER BY apellidos, nombres";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setId(rs.getInt("id"));
                paciente.setNombres(rs.getString("nombres"));
                paciente.setApellidos(rs.getString("apellidos"));
                paciente.setDni(rs.getString("dni"));
                paciente.setTelefono(rs.getString("telefono"));
                paciente.setEmail(rs.getString("email"));
                pacientes.add(paciente);
            }
        }
        
        return pacientes;
    }

    public List<Paciente> buscarPorTermino(String termino) throws SQLException {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT * FROM pacientes WHERE dni LIKE ? OR nombres LIKE ? OR apellidos LIKE ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String terminoBusqueda = "%" + termino + "%";
            stmt.setString(1, terminoBusqueda);
            stmt.setString(2, terminoBusqueda);
            stmt.setString(3, terminoBusqueda);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Paciente paciente = new Paciente();
                    paciente.setId(rs.getInt("id"));
                    paciente.setDni(rs.getString("dni"));
                    paciente.setNombres(rs.getString("nombres"));
                    paciente.setApellidos(rs.getString("apellidos"));
                    paciente.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    paciente.setGenero(rs.getString("genero"));
                    paciente.setDireccion(rs.getString("direccion"));
                    paciente.setTelefono(rs.getString("telefono"));
                    paciente.setEmail(rs.getString("email"));
                    pacientes.add(paciente);
                }
            }
        }
        return pacientes;
    }
} 