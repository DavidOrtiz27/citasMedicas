<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Crear Nueva Cita</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
        }

        .sidebar {
            background: #2c3e50;
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            z-index: 100;
            padding-top: 20px;
        }

        .sidebar .nav-link {
            color: #ecf0f1;
            padding: 0.8rem 1rem;
            margin: 0.2rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .sidebar .nav-link:hover {
            background: #34495e;
            color: white;
            transform: translateX(5px);
        }

        .sidebar .nav-link.active {
            background: #3498db;
            color: white;
        }

        .sidebar .nav-link i {
            margin-right: 0.5rem;
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
        }

        .card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.1);
        }

        .form-control, .form-select {
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            border: 1px solid #dee2e6;
        }

        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
            border-color: #3498db;
        }

        .required-field::after {
            content: " *";
            color: red;
        }

        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .btn-secondary {
            background-color: #95a5a6;
            border-color: #95a5a6;
        }

        .btn-secondary:hover {
            background-color: #7f8c8d;
            border-color: #7f8c8d;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="text-center mb-4">
            <h4 class="text-white">Sistema de Citas</h4>
        </div>
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-house-door"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/citas">
                    <i class="bi bi-calendar-check"></i> Citas
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/pacientes">
                    <i class="bi bi-people"></i> Pacientes
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/doctores">
                    <i class="bi bi-person-badge"></i> Doctores
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/especialidades">
                    <i class="bi bi-list-check"></i> Especialidades
                </a>
            </li>
        </ul>
    </div>

    <!-- Contenido principal -->
    <div class="main-content">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Crear Nueva Cita</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
                <a href="${pageContext.request.contextPath}/admin/citas" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Volver
                </a>
            </div>
        </div>

        <!-- Mensajes de alerta -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Formulario de creación -->
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/citas" method="post" id="citaForm">
                    <input type="hidden" name="accion" value="crear">
                    
                    <!-- Paciente -->
                    <div class="row mb-3">
                        <div class="col-md-12">
                            <label for="paciente" class="form-label required-field">Paciente</label>
                            <select class="form-select" id="paciente" name="pacienteId" required>
                                <option value="">Seleccione un paciente</option>
                                <c:forEach items="${pacientes}" var="paciente">
                                    <option value="${paciente.id}">${paciente.nombres} ${paciente.apellidos} - DNI: ${paciente.dni}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Especialidad y Doctor -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="especialidad" class="form-label required-field">Especialidad</label>
                            <select class="form-select" id="especialidad" name="especialidadId" required onchange="cargarDoctores()">
                                <option value="">Seleccione una especialidad</option>
                                <c:forEach items="${especialidades}" var="especialidad">
                                    <option value="${especialidad.id}">${especialidad.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="doctor" class="form-label required-field">Doctor</label>
                            <select class="form-select" id="doctor" name="doctorId" required>
                                <option value="">Seleccione un doctor</option>
                                <c:forEach items="${doctores}" var="doctor">
                                    <option value="${doctor.id}">${doctor.nombres} ${doctor.apellidos}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Fecha y Hora -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="fecha" class="form-label required-field">Fecha</label>
                            <input type="date" class="form-control" id="fecha" name="fecha" 
                                   min="${fechaMinima}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="hora" class="form-label required-field">Hora</label>
                            <select class="form-select" id="hora" name="hora" required>
                                <option value="">Seleccione una hora</option>
                                <option value="08:00">08:00</option>
                                <option value="09:00">09:00</option>
                                <option value="10:00">10:00</option>
                                <option value="11:00">11:00</option>
                                <option value="12:00">12:00</option>
                                <option value="14:00">14:00</option>
                                <option value="15:00">15:00</option>
                                <option value="16:00">16:00</option>
                                <option value="17:00">17:00</option>
                            </select>
                        </div>
                    </div>

                    <!-- Estado -->
                    <div class="row mb-3">
                        <div class="col-md-12">
                            <label for="estado" class="form-label required-field">Estado</label>
                            <select class="form-select" id="estado" name="estado" required>
                                <option value="">Seleccione un estado</option>
                                <option value="PENDIENTE">Pendiente</option>
                                <option value="CONFIRMADA">Confirmada</option>
                                <option value="CANCELADA">Cancelada</option>
                                <option value="COMPLETADA">Completada</option>
                            </select>
                        </div>
                    </div>

                    <div class="text-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> Guardar Cita
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>

    <script>
        // Función para cargar doctores por especialidad
        function cargarDoctores() {
            const especialidadId = document.getElementById('especialidad').value;
            const doctorSelect = document.getElementById('doctor');
            
            // Limpiar el selector de doctores
            doctorSelect.innerHTML = '<option value="">Seleccione un doctor</option>';
            
            if (!especialidadId) {
                return;
            }

            // Mostrar indicador de carga
            doctorSelect.disabled = true;
            doctorSelect.innerHTML = '<option value="">Cargando doctores...</option>';

            // Realizar la petición al servidor
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/citas/doctoresPorEspecialidad',
                type: 'GET',
                data: { especialidadId: especialidadId },
                dataType: 'json',
                success: function(doctores) {
                    doctorSelect.innerHTML = '<option value="">Seleccione un doctor</option>';
                    
                    if (doctores && doctores.length > 0) {
                        doctores.forEach(function(doctor) {
                            const option = document.createElement('option');
                            option.value = doctor.id;
                            option.textContent = doctor.nombres + ' ' + doctor.apellidos;
                            doctorSelect.appendChild(option);
                        });
                    } else {
                        Swal.fire({
                            icon: 'info',
                            title: 'Sin doctores',
                            text: 'No hay doctores disponibles para esta especialidad'
                        });
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error:', error);
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Error al cargar los doctores'
                    });
                    doctorSelect.innerHTML = '<option value="">Error al cargar doctores</option>';
                },
                complete: function() {
                    doctorSelect.disabled = false;
                }
            });
        }

        // Establecer fecha mínima como hoy
        document.getElementById('fecha').min = new Date().toISOString().split('T')[0];

        // Inicializar el selector de doctores cuando se carga la página
        $(document).ready(function() {
            const especialidadSelect = document.getElementById('especialidad');
            if (especialidadSelect.value) {
                cargarDoctores();
            }
        });
    </script>
</body>
</html> 