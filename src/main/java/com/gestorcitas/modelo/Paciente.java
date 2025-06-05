package com.gestorcitas.modelo;

import java.util.Date;

public class Paciente {
    private int id;
    private String dni;
    private String nombres;
    private String apellidos;
    private Date fechaNacimiento;
    private String genero;
    private String direccion;
    private String telefono;
    private String email;

    // Constructor vacío
    public Paciente() {}

    public Paciente(int id, String nombres, String apellidos, String dni, String telefono, String email) {
        this.id = id;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.dni = dni;
        this.telefono = telefono;
        this.email = email;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public Date getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(Date fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getGenero() {
        return genero;
    }

    public void setGenero(String genero) {
        this.genero = genero;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // Método para validar los datos del paciente
    public String validar() {
        if (dni == null || dni.trim().isEmpty()) {
            return "El DNI es obligatorio";
        }
        if (nombres == null || nombres.trim().isEmpty()) {
            return "Los nombres son obligatorios";
        }
        if (apellidos == null || apellidos.trim().isEmpty()) {
            return "Los apellidos son obligatorios";
        }
        if (fechaNacimiento == null) {
            return "La fecha de nacimiento es obligatoria";
        }
        if (genero == null || genero.trim().isEmpty()) {
            return "El género es obligatorio";
        }
        if (direccion == null || direccion.trim().isEmpty()) {
            return "La dirección es obligatoria";
        }
        if (telefono == null || telefono.trim().isEmpty()) {
            return "El teléfono es obligatorio";
        }
        if (email == null || email.trim().isEmpty()) {
            return "El email es obligatorio";
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return "El formato del email no es válido";
        }
        return null;
    }
} 