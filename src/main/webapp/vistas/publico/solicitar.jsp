<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solicitar Cita - Sistema de Citas Médicas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #34495e;
            --accent-color: #3498db;
            --success-color: #2ecc71;
            --warning-color: #f1c40f;
            --danger-color: #e74c3c;
            --light-color: #ecf0f1;
        }

        body {
            background-color: #f8f9fa;
            min-height: 100vh;
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }

        .form-container {
            background: white;
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .btn-action {
            background: var(--accent-color);
            color: white;
            border: none;
            border-radius: 0.5rem;
            padding: 0.75rem 1.5rem;
            transition: all 0.3s;
        }

        .btn-action:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
        }

        .captcha-container {
            background-color: var(--light-color);
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        .captcha-image {
            border-radius: 0.5rem;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: transform 0.2s;
        }

        .captcha-image:hover {
            transform: scale(1.02);
        }

        .alert {
            border-radius: 0.5rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1 class="text-center">Solicitar Nueva Cita</h1>
            <p class="text-center mb-0">Complete el formulario para solicitar una cita médica</p>
        </div>
    </div>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="form-container">
                    <form id="solicitarForm" action="${pageContext.request.contextPath}/publico/solicitar" method="POST">
                        <!-- Datos del Paciente -->
                        <h4 class="mb-4">Datos del Paciente</h4>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="documento" class="form-label">Documento de Identidad</label>
                                <input type="text" class="form-control" id="documento" name="documento" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="tipoDocumento" class="form-label">Tipo de Documento</label>
                                <select class="form-select" id="tipoDocumento" name="tipoDocumento" required>
                                    <option value="">Seleccione...</option>
                                    <option value="DNI">DNI</option>
                                    <option value="CE">CE</option>
                                    <option value="PASAPORTE">Pasaporte</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="nombres" class="form-label">Nombres</label>
                                <input type="text" class="form-control" id="nombres" name="nombres" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="apellidos" class="form-label">Apellidos</label>
                                <input type="text" class="form-control" id="apellidos" name="apellidos" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">Correo Electrónico</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="telefono" class="form-label">Teléfono</label>
                                <input type="tel" class="form-control" id="telefono" name="telefono" required>
                            </div>
                        </div>

                        <!-- Datos de la Cita -->
                        <h4 class="mb-4 mt-5">Datos de la Cita</h4>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="especialidad" class="form-label">Especialidad</label>
                                <select class="form-select" id="especialidad" name="especialidad" required>
                                    <option value="">Seleccione...</option>
                                    <c:forEach items="${especialidades}" var="esp">
                                        <option value="${esp.id}">${esp.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="doctor" class="form-label">Doctor</label>
                                <select class="form-select" id="doctor" name="doctor" required>
                                    <option value="">Seleccione...</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="fecha" class="form-label">Fecha Preferida</label>
                                <input type="date" class="form-control" id="fecha" name="fecha" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="hora" class="form-label">Hora Preferida</label>
                                <select class="form-select" id="hora" name="hora" required>
                                    <option value="">Seleccione...</option>
                                    <option value="09:00">09:00 AM</option>
                                    <option value="10:00">10:00 AM</option>
                                    <option value="11:00">11:00 AM</option>
                                    <option value="15:00">03:00 PM</option>
                                    <option value="16:00">04:00 PM</option>
                                    <option value="17:00">05:00 PM</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="motivo" class="form-label">Motivo de la Consulta</label>
                            <textarea class="form-control" id="motivo" name="motivo" rows="3" required></textarea>
                        </div>

                        <!-- CAPTCHA -->
                        <div class="captcha-container">
                            <img src="${pageContext.request.contextPath}/captcha" 
                                 class="captcha-image mb-3" 
                                 alt="CAPTCHA"
                                 onclick="this.src='${pageContext.request.contextPath}/captcha?' + Math.random()">
                            <div class="mb-3">
                                <input type="text" class="form-control" id="captcha" name="captcha" 
                                       placeholder="Ingrese el código CAPTCHA" required>
                            </div>
                            <small class="text-muted">Haga clic en la imagen para actualizar el código</small>
                        </div>

                        <div id="resultado" class="mt-3"></div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                            <a href="${pageContext.request.contextPath}/publico/inicio" class="btn btn-secondary me-md-2">Cancelar</a>
                            <button type="submit" class="btn btn-action">Solicitar Cita</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Cargar doctores cuando se selecciona una especialidad
        document.getElementById('especialidad').addEventListener('change', function() {
            const especialidadId = this.value;
            const doctorSelect = document.getElementById('doctor');
            doctorSelect.innerHTML = '<option value="">Seleccione...</option>';
            
            if (especialidadId) {
                console.log('Cargando doctores para especialidad:', especialidadId);
                doctorSelect.disabled = true;
                doctorSelect.innerHTML = '<option value="">Cargando doctores...</option>';
                
                fetch('${pageContext.request.contextPath}/publico/doctores?especialidadId=' + especialidadId)
                    .then(response => {
                        console.log('Respuesta del servidor:', response.status);
                        if (!response.ok) {
                            throw new Error('Error en la respuesta del servidor: ' + response.status);
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log('Doctores recibidos:', data);
                        doctorSelect.innerHTML = '<option value="">Seleccione...</option>';
                        
                        if (data && data.length > 0) {
                            data.forEach(doctor => {
                                const option = document.createElement('option');
                                option.value = doctor.id;
                                option.textContent = doctor.nombres + ' ' + doctor.apellidos;
                                doctorSelect.appendChild(option);
                            });
                        } else {
                            doctorSelect.innerHTML = '<option value="">No hay doctores disponibles</option>';
                        }
                    })
                    .catch(error => {
                        console.error('Error al cargar doctores:', error);
                        doctorSelect.innerHTML = '<option value="">Error al cargar doctores</option>';
                        alert('Error al cargar la lista de doctores. Por favor, intente nuevamente.');
                    })
                    .finally(() => {
                        doctorSelect.disabled = false;
                    });
            } else {
                doctorSelect.disabled = true;
                doctorSelect.innerHTML = '<option value="">Primero seleccione una especialidad</option>';
            }
        });

        // Manejar el envío del formulario
        document.getElementById('solicitarForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            
            fetch('${pageContext.request.contextPath}/publico/solicitar', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                const resultado = document.getElementById('resultado');
                if (data.error) {
                    resultado.innerHTML = '<div class="alert alert-danger">' + data.error + '</div>';
                } else {
                    resultado.innerHTML = '<div class="alert alert-success">' + data.message + '</div>';
                    this.reset();
                }
            })
            .catch(error => {
                document.getElementById('resultado').innerHTML = 
                    '<div class="alert alert-danger">Error al procesar la solicitud</div>';
            });
        });

        // Establecer fecha mínima como mañana
        const fechaInput = document.getElementById('fecha');
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        fechaInput.min = tomorrow.toISOString().split('T')[0];
    </script>
</body>
</html> 