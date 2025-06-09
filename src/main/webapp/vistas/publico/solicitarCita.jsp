<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Solicitar Cita - Sistema de Citas Médicas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
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

        .navbar {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .navbar-brand, .nav-link {
            color: white !important;
        }

        .navbar-brand {
            font-weight: 600;
        }

        .nav-link:hover {
            opacity: 0.9;
        }

        .card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 1rem 1rem 0 0 !important;
            padding: 1.5rem;
        }

        .card-header h4 {
            margin: 0;
            font-weight: 600;
        }

        .btn-primary {
            background: var(--accent-color);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            background: var(--primary-color);
            transform: translateY(-2px);
        }

        .form-control {
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            border: 1px solid #dee2e6;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }

        .alert {
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .alert i {
            margin-right: 0.5rem;
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
            transition: transform 0.2s ease;
        }

        .captcha-image:hover {
            transform: scale(1.02);
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-hospital"></i> Sistema de Citas Médicas
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">
                            <i class="bi bi-house"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/publico/consultar">
                            <i class="bi bi-calendar-check"></i> Consultar Citas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/publico/solicitar">
                            <i class="bi bi-calendar-plus"></i> Solicitar Cita
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="bi bi-calendar-plus"></i> Solicitar Nueva Cita
                        </h4>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                <i class="bi bi-exclamation-circle"></i> ${error}
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty mensaje}">
                            <div class="alert alert-success" role="alert">
                                <i class="bi bi-check-circle"></i> ${mensaje}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/publico/solicitar" method="post" class="needs-validation" novalidate>
                            <div class="mb-4">
                                <label for="dni" class="form-label">DNI del Paciente</label>
                                <input type="text" class="form-control" id="dni" name="dni" required
                                       pattern="[0-9]{8}" maxlength="8"
                                       placeholder="Ingrese su DNI (8 dígitos)">
                                <div class="invalid-feedback">
                                    Por favor ingrese un DNI válido de 8 dígitos.
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="especialidad" class="form-label">Especialidad</label>
                                <select class="form-select" id="especialidad" name="especialidad" required>
                                    <option value="">Seleccione una especialidad</option>
                                    <c:forEach items="${especialidades}" var="especialidad">
                                        <option value="${especialidad.id}">${especialidad.nombre}</option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    Por favor seleccione una especialidad.
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="doctor" class="form-label">Doctor</label>
                                <select class="form-select" id="doctor" name="doctor" required disabled>
                                    <option value="">Primero seleccione una especialidad</option>
                                </select>
                                <div class="invalid-feedback">
                                    Por favor seleccione un doctor.
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="fecha" class="form-label">Fecha</label>
                                <input type="date" class="form-control" id="fecha" name="fecha" required
                                       min="${fechaMinima}">
                                <div class="invalid-feedback">
                                    Por favor seleccione una fecha válida.
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="hora" class="form-label">Hora</label>
                                <select class="form-select" id="hora" name="hora" required disabled>
                                    <option value="">Primero seleccione una fecha</option>
                                </select>
                                <div class="invalid-feedback">
                                    Por favor seleccione una hora.
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="captcha" class="form-label">CAPTCHA</label>
                                <div class="captcha-container">
                                    <div class="d-flex align-items-center gap-3">
                                        <input type="text" class="form-control" id="captcha" name="captcha" required
                                               placeholder="Ingrese el código mostrado">
                                        <img src="${pageContext.request.contextPath}/captcha" alt="CAPTCHA" 
                                             class="captcha-image" style="height: 38px;">
                                        <button type="button" class="btn btn-outline-light" 
                                                onclick="this.previousElementSibling.src='${pageContext.request.contextPath}/captcha?' + Math.random()">
                                            <i class="bi bi-arrow-clockwise"></i>
                                        </button>
                                    </div>
                                    <small class="text-muted mt-2 d-block">
                                        Haga clic en la imagen para actualizar el código
                                    </small>
                                </div>
                                <div class="invalid-feedback">
                                    Por favor ingrese el código CAPTCHA.
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-calendar-plus"></i> Solicitar Cita
                                </button>
                                <a href="${pageContext.request.contextPath}/publico/consultar" 
                                   class="btn btn-outline-primary">
                                    <i class="bi bi-calendar-check"></i> Consultar Mis Citas
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
    <script>
        // Validación del formulario
        (function() {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();

        // Cargar doctores cuando se selecciona una especialidad
        document.getElementById('especialidad').addEventListener('change', function() {
            const especialidadId = this.value;
            const doctorSelect = document.getElementById('doctor');
            
            if (especialidadId) {
                console.log('Cargando doctores para especialidad:', especialidadId);
                doctorSelect.disabled = true;
                doctorSelect.innerHTML = '<option value="">Cargando doctores...</option>';
                
                fetch('${pageContext.request.contextPath}/publico/doctores?especialidadId=' + especialidadId, {
                    method: 'GET',
                    headers: {
                        'Accept': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => {
                    console.log('Respuesta del servidor:', response.status);
                    if (!response.ok) {
                        return response.text().then(text => {
                            try {
                                const errorData = JSON.parse(text);
                                throw new Error(errorData.error || 'Error en la respuesta del servidor: ' + response.status);
                            } catch (e) {
                                throw new Error('Error en la respuesta del servidor: ' + response.status);
                            }
                        });
                    }
                    return response.text();
                })
                .then(text => {
                    console.log('Respuesta texto:', text);
                    try {
                        const doctores = JSON.parse(text);
                        console.log('Doctores parseados:', doctores);
                        
                        // Limpiar el select
                        doctorSelect.innerHTML = '';
                        
                        // Agregar opción por defecto
                        const defaultOption = document.createElement('option');
                        defaultOption.value = '';
                        defaultOption.textContent = 'Seleccione un doctor';
                        doctorSelect.appendChild(defaultOption);
                        
                        if (Array.isArray(doctores) && doctores.length > 0) {
                            doctores.forEach(doctor => {
                                if (doctor && doctor.id && doctor.nombres && doctor.apellidos) {
                                    console.log('Procesando doctor:', doctor);
                                    const option = document.createElement('option');
                                    option.value = doctor.id;
                                    option.textContent = doctor.nombres + ' ' + doctor.apellidos;
                                    doctorSelect.appendChild(option);
                                }
                            });
                        } else {
                            const noDoctorsOption = document.createElement('option');
                            noDoctorsOption.value = '';
                            noDoctorsOption.disabled = true;
                            noDoctorsOption.textContent = 'No hay doctores disponibles';
                            doctorSelect.appendChild(noDoctorsOption);
                        }
                        
                        // Habilitar el select
                        doctorSelect.disabled = false;
                        
                        // Disparar evento change para actualizar la UI
                        doctorSelect.dispatchEvent(new Event('change'));
                    } catch (e) {
                        console.error('Error al parsear JSON:', e);
                        throw new Error('Error al procesar la respuesta del servidor');
                    }
                })
                .catch(error => {
                    console.error('Error al cargar doctores:', error);
                    doctorSelect.innerHTML = '<option value="" disabled>Error al cargar doctores</option>';
                    doctorSelect.disabled = true;
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'No se pudieron cargar los doctores: ' + error.message
                    });
                });
            } else {
                doctorSelect.innerHTML = '<option value="">Primero seleccione una especialidad</option>';
                doctorSelect.disabled = true;
            }
        });

        // Agregar evento change al select de doctores
        document.getElementById('doctor').addEventListener('change', function() {
            console.log('Doctor seleccionado:', this.value);
            // Aquí puedes agregar lógica adicional cuando se selecciona un doctor
        });

        // Cargar horas disponibles cuando se selecciona una fecha o un doctor
        function cargarHorasDisponibles() {
            const fecha = document.getElementById('fecha').value;
            const doctorId = document.getElementById('doctor').value;
            const horaSelect = document.getElementById('hora');
            
            if (fecha && doctorId) {
                console.log('Cargando horas disponibles para fecha:', fecha, 'y doctor:', doctorId);
                horaSelect.disabled = true;
                horaSelect.innerHTML = '<option value="">Cargando horas disponibles...</option>';
                
                fetch('${pageContext.request.contextPath}/publico/horasDisponibles?fecha=' + fecha + '&doctorId=' + doctorId, {
                    method: 'GET',
                    headers: {
                        'Accept': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => {
                    console.log('Respuesta del servidor (horas):', response.status);
                    if (!response.ok) {
                        throw new Error('Error en la respuesta del servidor: ' + response.status);
                    }
                    return response.text();
                })
                .then(text => {
                    console.log('Respuesta texto (horas):', text);
                    try {
                        const horas = JSON.parse(text);
                        console.log('Horas parseadas:', horas);
                        
                        // Limpiar el select
                        horaSelect.innerHTML = '';
                        
                        // Agregar opción por defecto
                        const defaultOption = document.createElement('option');
                        defaultOption.value = '';
                        defaultOption.textContent = 'Seleccione una hora';
                        horaSelect.appendChild(defaultOption);
                        
                        if (Array.isArray(horas) && horas.length > 0) {
                            horas.forEach(hora => {
                                const option = document.createElement('option');
                                option.value = hora;
                                option.textContent = hora;
                                horaSelect.appendChild(option);
                            });
                        } else {
                            const noHoursOption = document.createElement('option');
                            noHoursOption.value = '';
                            noHoursOption.disabled = true;
                            noHoursOption.textContent = 'No hay horas disponibles';
                            horaSelect.appendChild(noHoursOption);
                        }
                        
                        horaSelect.disabled = false;
                    } catch (e) {
                        console.error('Error al parsear JSON de horas:', e);
                        throw new Error('Error al procesar la respuesta del servidor');
                    }
                })
                .catch(error => {
                    console.error('Error al cargar horas:', error);
                    horaSelect.innerHTML = '<option value="" disabled>Error al cargar horas</option>';
                    horaSelect.disabled = true;
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'No se pudieron cargar las horas disponibles: ' + error.message
                    });
                });
            } else {
                horaSelect.innerHTML = '<option value="">Seleccione fecha y doctor</option>';
                horaSelect.disabled = true;
            }
        }

        // Agregar eventos para cargar horas
        document.getElementById('fecha').addEventListener('change', cargarHorasDisponibles);
        document.getElementById('doctor').addEventListener('change', cargarHorasDisponibles);
    </script>
</body>
</html> 