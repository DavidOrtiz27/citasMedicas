-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS gestor_citas;
USE gestor_citas;

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(20) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso TIMESTAMP NULL
);

-- Tabla de especialidades
CREATE TABLE IF NOT EXISTS especialidades (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Tabla de doctores
CREATE TABLE IF NOT EXISTS doctores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    dni VARCHAR(8) NOT NULL UNIQUE,
    telefono VARCHAR(9),
    email VARCHAR(100),
    especialidad_id INT,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(id)
);

-- Tabla de pacientes
CREATE TABLE IF NOT EXISTS pacientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    dni VARCHAR(8) NOT NULL UNIQUE,
    fecha_nacimiento DATE,
    genero VARCHAR(1),
    direccion TEXT,
    telefono VARCHAR(9),
    email VARCHAR(100)
);

-- Tabla de citas
CREATE TABLE IF NOT EXISTS citas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora VARCHAR(5) NOT NULL,
    paciente_id INT NOT NULL,
    doctor_id INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    motivo_cancelacion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (doctor_id) REFERENCES doctores(id)
);

-- Insertar usuarios de ejemplo (la contraseña es 'admin123' encriptada)
INSERT INTO usuarios (username, password, rol) VALUES
('admin', 'admin123', 'ADMIN'),
('recepcionista', 'recepcionista123', 'RECEPCIONISTA'),
('dr.perez', 'dr.perez123', 'DOCTOR'),
('dr.garcia', 'dr.garcia123', 'DOCTOR'),
('dr.lopez', 'dr.lopez123', 'DOCTOR');

-- Insertar especialidades de ejemplo
INSERT INTO especialidades (nombre, descripcion) VALUES
('Medicina General', 'Atención primaria y general para adultos'),
('Pediatría', 'Atención médica especializada para niños y adolescentes'),
('Ginecología', 'Salud reproductiva femenina y atención prenatal'),
('Cardiología', 'Diagnóstico y tratamiento de enfermedades del corazón'),
('Dermatología', 'Tratamiento de enfermedades de la piel, cabello y uñas'),
('Oftalmología', 'Cuidado de la salud visual y ocular'),
('Ortopedia', 'Tratamiento de lesiones y enfermedades del sistema musculoesquelético'),
('Neurología', 'Diagnóstico y tratamiento de enfermedades del sistema nervioso');

-- Insertar doctores de ejemplo
INSERT INTO doctores (nombres, apellidos, dni, telefono, email, especialidad_id, activo) VALUES
('Juan Carlos', 'Pérez Rodríguez', '12345678', '987654321', 'dr.perez@clinica.com', 1, true),
('María Elena', 'García Torres', '23456789', '987654322', 'dr.garcia@clinica.com', 2, true),
('Carlos Alberto', 'López Mendoza', '34567890', '987654323', 'dr.lopez@clinica.com', 3, true),
('Roberto José', 'Sánchez Vargas', '45678901', '987654324', 'dr.sanchez@clinica.com', 4, true),
('Ana María', 'Martínez Ríos', '56789012', '987654325', 'dra.martinez@clinica.com', 5, true),
('Luis Miguel', 'Torres Flores', '67890123', '987654326', 'dr.torres@clinica.com', 6, true),
('Carmen Rosa', 'Vargas Díaz', '78901234', '987654327', 'dra.vargas@clinica.com', 7, true),
('Pedro Antonio', 'Ramírez Soto', '89012345', '987654328', 'dr.ramirez@clinica.com', 8, true);

-- Insertar pacientes de ejemplo
INSERT INTO pacientes (nombres, apellidos, dni, fecha_nacimiento, genero, direccion, telefono, email) VALUES
('José Luis', 'González Pérez', '12345679', '1985-05-15', 'M', 'Av. Arequipa 123, Lima', '987654329', 'jose.gonzalez@email.com'),
('María Isabel', 'Rodríguez García', '23456780', '1990-08-22', 'F', 'Calle Tacna 456, Lima', '987654330', 'maria.rodriguez@email.com'),
('Carlos Eduardo', 'Martínez López', '34567891', '1995-03-10', 'M', 'Jr. Lima 789, Lima', '987654331', 'carlos.martinez@email.com'),
('Ana Patricia', 'Sánchez Torres', '45678902', '1988-11-30', 'F', 'Av. La Marina 321, Lima', '987654332', 'ana.sanchez@email.com'),
('Roberto Carlos', 'Vargas Ramírez', '56789013', '1992-07-18', 'M', 'Calle Los Robles 654, Lima', '987654333', 'roberto.vargas@email.com'),
('Laura Beatriz', 'Torres Mendoza', '67890124', '1998-04-25', 'F', 'Av. Primavera 987, Lima', '987654334', 'laura.torres@email.com'),
('Miguel Ángel', 'Ramírez Soto', '78901235', '1983-09-12', 'M', 'Jr. Huancavelica 147, Lima', '987654335', 'miguel.ramirez@email.com'),
('Carmen Rosa', 'Flores Díaz', '89012346', '1994-12-05', 'F', 'Calle Los Pinos 258, Lima', '987654336', 'carmen.flores@email.com');

-- Insertar citas de ejemplo
INSERT INTO citas (fecha, hora, paciente_id, doctor_id, estado, motivo_cancelacion, fecha_creacion) VALUES
-- Citas para hoy
(CURDATE(), '09:00', 1, 1, 'CONFIRMADA', NULL, NOW()),
(CURDATE(), '10:00', 2, 2, 'CONFIRMADA', NULL, NOW()),
(CURDATE(), '11:00', 3, 3, 'CONFIRMADA', NULL, NOW()),
(CURDATE(), '15:00', 4, 4, 'PENDIENTE', NULL, NOW()),
(CURDATE(), '16:00', 5, 5, 'CONFIRMADA', NULL, NOW()),
(CURDATE(), '17:00', 6, 6, 'PENDIENTE', NULL, NOW()),

-- Citas para mañana
(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00', 7, 7, 'CONFIRMADA', NULL, NOW()),
(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00', 8, 8, 'CONFIRMADA', NULL, NOW()),
(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '11:00', 1, 1, 'PENDIENTE', NULL, NOW()),
(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '15:00', 2, 2, 'CONFIRMADA', NULL, NOW()),
(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '16:00', 3, 3, 'PENDIENTE', NULL, NOW()),
(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '17:00', 4, 4, 'CONFIRMADA', NULL, NOW()),

-- Citas para pasado mañana
(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '09:00', 5, 5, 'CONFIRMADA', NULL, NOW()),
(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '10:00', 6, 6, 'PENDIENTE', NULL, NOW()),
(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '11:00', 7, 7, 'CONFIRMADA', NULL, NOW()),
(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '15:00', 8, 8, 'PENDIENTE', NULL, NOW()),
(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '16:00', 1, 1, 'CONFIRMADA', NULL, NOW()),
(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '17:00', 2, 2, 'CONFIRMADA', NULL, NOW()); 