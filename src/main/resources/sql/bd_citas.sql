-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS gestor_citas;
USE gestor_citas;

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'medico', 'recepcionista', 'paciente') NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de especialidades
CREATE TABLE IF NOT EXISTS especialidades (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    activa BOOLEAN DEFAULT TRUE
);

-- Tabla de médicos
CREATE TABLE IF NOT EXISTS medicos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    especialidad_id INT NOT NULL,
    numero_colegiado VARCHAR(50) NOT NULL UNIQUE,
    consultorio VARCHAR(50),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(id)
);

-- Tabla de pacientes
CREATE TABLE IF NOT EXISTS pacientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    tipo_documento ENUM('DNI', 'CE', 'PASAPORTE') NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabla de horarios disponibles
CREATE TABLE IF NOT EXISTS horarios_disponibles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    medico_id INT NOT NULL,
    dia_semana ENUM('LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    duracion_cita INT NOT NULL COMMENT 'Duración en minutos',
    FOREIGN KEY (medico_id) REFERENCES medicos(id),
    UNIQUE KEY unique_horario (medico_id, dia_semana, hora_inicio)
);

-- Tabla de citas
CREATE TABLE IF NOT EXISTS citas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL,
    medico_id INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado ENUM('PROGRAMADA', 'COMPLETADA', 'CANCELADA') NOT NULL DEFAULT 'PROGRAMADA',
    motivo_cancelacion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (medico_id) REFERENCES medicos(id),
    UNIQUE KEY unique_cita (medico_id, fecha, hora)
);

-- Insertar usuario administrador por defecto
INSERT INTO usuarios (username, password, rol, nombre, email) 
VALUES ('admin', 'admin123', 'admin', 'Administrador', 'admin@hospital.com');

-- Insertar usuario médico de prueba
INSERT INTO usuarios (username, password, rol, nombre, email) 
VALUES ('medico', 'medico123', 'medico', 'Dr. Juan Pérez', 'medico@hospital.com');

-- Insertar usuario recepcionista de prueba
INSERT INTO usuarios (username, password, rol, nombre, email) 
VALUES ('recepcionista', 'recepcionista123', 'recepcionista', 'Ana López', 'recepcionista@hospital.com');

-- Insertar especialidades de prueba
INSERT INTO especialidades (nombre, descripcion) VALUES
('Medicina General', 'Atención primaria y diagnóstico general'),
('Cardiología', 'Especialidad médica que estudia el corazón y el sistema circulatorio'),
('Dermatología', 'Especialidad médica que estudia la piel y sus enfermedades'),
('Pediatría', 'Especialidad médica que estudia al niño y sus enfermedades');

-- Insertar médico de prueba
INSERT INTO medicos (usuario_id, especialidad_id, numero_colegiado, consultorio)
VALUES (2, 1, 'MED-001', 'Consultorio 101');

-- Insertar horarios disponibles para el médico
INSERT INTO horarios_disponibles (medico_id, dia_semana, hora_inicio, hora_fin, duracion_cita)
VALUES 
(1, 'LUNES', '09:00:00', '13:00:00', 30),
(1, 'LUNES', '15:00:00', '19:00:00', 30),
(1, 'MIERCOLES', '09:00:00', '13:00:00', 30),
(1, 'MIERCOLES', '15:00:00', '19:00:00', 30),
(1, 'VIERNES', '09:00:00', '13:00:00', 30);
