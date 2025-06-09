<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Gestión de Citas - Sistema de Citas Médicas</title>
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
        }

        .sidebar {
            background: var(--primary-color);
            min-height: 100vh;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }

        .sidebar .nav-link {
            color: var(--light-color);
            padding: 0.8rem 1rem;
            margin: 0.2rem 0;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .sidebar .nav-link:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateX(5px);
        }

        .sidebar .nav-link.active {
            background: var(--accent-color);
            color: white;
        }

        .sidebar .nav-link i {
            margin-right: 0.5rem;
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

        .table {
            border-radius: 0.5rem;
            overflow: hidden;
        }

        .table thead {
            background: var(--primary-color);
            color: white;
        }

        .btn-action {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .btn-action:hover {
            transform: translateY(-2px);
        }

        .modal-content {
            border-radius: 1rem;
            border: none;
        }

        .modal-header {
            background: var(--primary-color);
            color: white;
            border-radius: 1rem 1rem 0 0;
        }

        .form-control, .form-select {
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            border: 1px solid #dee2e6;
            transition: all 0.3s;
        }

        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
            border-color: var(--accent-color);
        }

        .required-field::after {
            content: "*";
            color: var(--danger-color);
            margin-left: 4px;
        }

        .search-box {
            background: white;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }

        .search-box .form-control {
            border-radius: 0.5rem 0 0 0.5rem;
        }

        .search-box .btn {
            border-radius: 0 0.5rem 0.5rem 0;
        }

        .appointment-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .appointment-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--accent-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
        }

        .appointment-details {
            display: flex;
            flex-direction: column;
        }

        .appointment-name {
            font-weight: 600;
            color: var(--primary-color);
        }

        .appointment-specialty {
            font-size: 0.875rem;
            color: var(--secondary-color);
        }

        .badge {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .page-header {
            background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .page-header p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 0;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <%@ include file="../../../includes/sitebarAdmin.jsp" %>

            <!-- Contenido principal -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <!-- Encabezado de página -->
                <div class="page-header">
                    <h1>Gestión de Citas</h1>
                    <p>Administra las citas médicas del sistema</p>
                </div>

                <!-- Barra de búsqueda -->
                <div class="search-box">
                    <form class="row g-3" action="${pageContext.request.contextPath}/admin/citas" method="get">
                        <div class="col-md-8">
                            <div class="input-group">
                                <input type="text" class="form-control" name="buscar" placeholder="Buscar por paciente, doctor o especialidad...">
                                <button class="btn btn-primary" type="submit">
                                    <i class="bi bi-search"></i> Buscar
                                </button>
                            </div>
                        </div>
                        <div class="col-md-4 text-end">
                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#citaModal">
                                <i class="bi bi-plus-lg"></i> Nueva Cita
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Tabla de citas -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Fecha</th>
                                        <th>Hora</th>
                                        <th>Paciente</th>
                                        <th>Doctor</th>
                                        <th>Especialidad</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${citas}" var="cita">
                                        <tr>
                                            <td><fmt:formatDate value="${cita.fecha}" pattern="dd/MM/yyyy"/></td>
                                            <td>${cita.hora}</td>
                                            <td>
                                                <div class="appointment-info">
                                                    <div class="appointment-avatar">
                                                        ${cita.paciente.nombres.charAt(0)}${cita.paciente.apellidos.charAt(0)}
                                                    </div>
                                                    <div class="appointment-details">
                                                        <span class="appointment-name">${cita.paciente.nombres} ${cita.paciente.apellidos}</span>
                                                        <span class="appointment-specialty">${cita.doctor.especialidad.nombre}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${cita.doctor.nombres} ${cita.doctor.apellidos}</td>
                                            <td>${cita.doctor.especialidad.nombre}</td>
                                            <td>
                                                <span class="badge bg-${cita.estado eq 'PENDIENTE' ? 'warning' : 
                                                                   cita.estado eq 'CONFIRMADA' ? 'success' : 
                                                                   cita.estado eq 'CANCELADA' ? 'danger' : 'secondary'}">
                                                    ${cita.estado}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="btn-group">
                                                    <a href="${pageContext.request.contextPath}/admin/citas/citas?accion=editar&id=${cita.id}" class="btn btn-sm btn-primary btn-action">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button class="btn btn-sm btn-danger btn-action" onclick="eliminarCita('${cita.id}')">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Modal para crear/editar cita -->
    <div class="modal fade" id="citaModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="citaModalLabel">Nueva Cita</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="citaForm" action="${pageContext.request.contextPath}/admin/citas/citas" method="post" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="crear">
                        
                        <div class="mb-3">
                            <label for="buscarPaciente" class="form-label required-field">Buscar Paciente</label>
                            <input type="text" class="form-control" id="buscarPaciente" placeholder="Ingrese nombre, apellido o DNI del paciente">
                        </div>
                        
                        <div class="mb-3">
                            <label for="paciente" class="form-label required-field">Paciente</label>
                            <select class="form-select" id="paciente" name="paciente" required>
                                <option value="">Seleccione un paciente</option>
                            </select>
                            <div class="invalid-feedback">
                                Por favor seleccione un paciente.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="especialidad" class="form-label required-field">Especialidad</label>
                            <select class="form-select" id="especialidad" required>
                                <option value="">Seleccione una especialidad</option>
                            </select>
                            <div class="invalid-feedback">
                                Por favor seleccione una especialidad.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="doctor" class="form-label required-field">Doctor</label>
                            <select class="form-select" id="doctor" name="doctor" required>
                                <option value="">Seleccione un doctor</option>
                            </select>
                            <div class="invalid-feedback">
                                Por favor seleccione un doctor.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="fecha" class="form-label required-field">Fecha</label>
                            <input type="date" class="form-control" id="fecha" name="fecha" required>
                            <div class="invalid-feedback">
                                Por favor seleccione una fecha.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="hora" class="form-label required-field">Hora</label>
                            <input type="time" class="form-control" id="hora" name="hora" required>
                            <div class="invalid-feedback">
                                Por favor seleccione una hora.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="estado" class="form-label required-field">Estado</label>
                            <select class="form-select" id="estado" name="estado" required>
                                <option value="PENDIENTE">Pendiente</option>
                                <option value="CONFIRMADA">Confirmada</option>
                                <option value="CANCELADA">Cancelada</option>
                            </select>
                            <div class="invalid-feedback">
                                Por favor seleccione un estado.
                            </div>
                        </div>
                        
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">Guardar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Formulario para eliminar cita -->
    <form id="eliminarForm" action="${pageContext.request.contextPath}/admin/citas/citas" method="post" style="display: none;">
        <input type="hidden" name="accion" value="eliminar">
        <input type="hidden" name="id" id="eliminarId">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para eliminar cita
        function eliminarCita(id) {
            if (confirm('¿Está seguro de eliminar esta cita?')) {
                document.getElementById('eliminarId').value = id;
                document.getElementById('eliminarForm').submit();
            }
        }

        // Establecer fecha mínima como hoy
        document.getElementById('fecha').min = new Date().toISOString().split('T')[0];

        // Función para cargar los doctores de una especialidad
        function cargarDoctores(especialidadId) {
            const doctorSelect = document.getElementById('doctor');
            doctorSelect.innerHTML = '<option value="">Seleccione un doctor</option>';
            
            if (!especialidadId) return;

            fetch('${pageContext.request.contextPath}/admin/doctor/doctores?especialidad=' + especialidadId)
                .then(response => response.json())
                .then(doctores => {
                    doctores.forEach(doctor => {
                        const option = document.createElement('option');
                        option.value = doctor.id;
                        option.textContent = `${doctor.nombres} ${doctor.apellidos} - ${doctor.especialidad.nombre}`;
                        doctorSelect.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error al cargar los doctores');
                });
        }

        // Función para cargar las especialidades
        function cargarEspecialidades() {
            const especialidadSelect = document.getElementById('especialidad');
            especialidadSelect.innerHTML = '<option value="">Seleccione una especialidad</option>';

            fetch('${pageContext.request.contextPath}/admin/especialidad/especialidades')
                .then(response => response.json())
                .then(especialidades => {
                    especialidades.forEach(especialidad => {
                        const option = document.createElement('option');
                        option.value = especialidad.id;
                        option.textContent = especialidad.nombre;
                        especialidadSelect.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error al cargar las especialidades');
                });
        }

        // Función para buscar pacientes
        function buscarPacientes(termino) {
            const pacienteSelect = document.getElementById('paciente');
            pacienteSelect.innerHTML = '<option value="">Seleccione un paciente</option>';
            
            if (!termino) return;

            fetch('${pageContext.request.contextPath}/admin/paciente/pacientes?buscar=' + termino)
                .then(response => response.json())
                .then(pacientes => {
                    pacientes.forEach(paciente => {
                        const option = document.createElement('option');
                        option.value = paciente.id;
                        option.textContent = `${paciente.nombres} ${paciente.apellidos}`;
                        pacienteSelect.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error al buscar pacientes');
                });
        }

        // Cargar especialidades al abrir el modal
        document.getElementById('citaModal').addEventListener('show.bs.modal', function () {
            cargarEspecialidades();
        });

        // Evento para buscar pacientes
        document.getElementById('buscarPaciente').addEventListener('input', function(e) {
            buscarPacientes(e.target.value);
        });

        // Evento para cargar doctores cuando se selecciona una especialidad
        document.getElementById('especialidad').addEventListener('change', function(e) {
            cargarDoctores(e.target.value);
        });
    </script>
</body>
</html>
