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
            <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                <div class="position-sticky">
                    <div class="text-center py-4">
                        <h4 class="text-white">Sistema de Citas</h4>
                        <p class="text-light opacity-75">Panel de Administración</p>
                    </div>
                    
                    <ul class="nav flex-column px-3">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/inicio">
                                <i class="bi bi-house"></i>
                                Inicio
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/paciente/pacientes">
                                <i class="bi bi-people"></i>
                                Pacientes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/doctor/doctores">
                                <i class="bi bi-person-badge"></i>
                                Doctores
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/citas/citas">
                                <i class="bi bi-calendar-check"></i>
                                Citas
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/especialidad/especialidades">
                                <i class="bi bi-list-check"></i>
                                Especialidades
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/horario/horarios">
                                <i class="bi bi-clock"></i>
                                Horarios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/usuario/usuarios">
                                <i class="bi bi-person-gear"></i>
                                Usuarios
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

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
                                                    <button class="btn btn-sm btn-primary btn-action" onclick="editarCita('${cita.id}')">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
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
                    <form id="citaForm" class="needs-validation" novalidate>
                        <input type="hidden" id="citaId">
                        
                        <div class="mb-3">
                            <label for="paciente" class="form-label required-field">Paciente</label>
                            <select class="form-select" id="paciente" required>
                                <option value="">Seleccione un paciente</option>
                                <c:forEach items="${pacientes}" var="paciente">
                                    <option value="${paciente.id}">${paciente.nombres} ${paciente.apellidos}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Por favor seleccione un paciente.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="doctor" class="form-label required-field">Doctor</label>
                            <select class="form-select" id="doctor" required>
                                <option value="">Seleccione un doctor</option>
                                <c:forEach items="${doctores}" var="doctor">
                                    <option value="${doctor.id}">${doctor.nombres} ${doctor.apellidos} - ${doctor.especialidad.nombre}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Por favor seleccione un doctor.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="fecha" class="form-label required-field">Fecha</label>
                            <input type="date" class="form-control" id="fecha" required>
                            <div class="invalid-feedback">
                                Por favor seleccione una fecha.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="hora" class="form-label required-field">Hora</label>
                            <input type="time" class="form-control" id="hora" required>
                            <div class="invalid-feedback">
                                Por favor seleccione una hora.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="estado" class="form-label required-field">Estado</label>
                            <select class="form-select" id="estado" required>
                                <option value="PENDIENTE">Pendiente</option>
                                <option value="CONFIRMADA">Confirmada</option>
                                <option value="CANCELADA">Cancelada</option>
                            </select>
                            <div class="invalid-feedback">
                                Por favor seleccione un estado.
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" onclick="guardarCita()">Guardar</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para editar cita
        function editarCita(id) {
            fetch('${pageContext.request.contextPath}/admin/citas/' + id)
                .then(response => response.json())
                .then(cita => {
                    document.getElementById('citaId').value = cita.id;
                    document.getElementById('paciente').value = cita.paciente.id;
                    document.getElementById('doctor').value = cita.doctor.id;
                    document.getElementById('fecha').value = cita.fecha;
                    document.getElementById('hora').value = cita.hora;
                    document.getElementById('estado').value = cita.estado;
                    
                    document.getElementById('citaModalLabel').textContent = 'Editar Cita';
                    new bootstrap.Modal(document.getElementById('citaModal')).show();
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error al cargar los datos de la cita');
                });
        }

        // Función para eliminar cita
        function eliminarCita(id) {
            if (confirm('¿Está seguro de eliminar esta cita?')) {
                fetch('${pageContext.request.contextPath}/admin/citas/' + id, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        throw new Error('Error al eliminar la cita');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error al eliminar la cita');
                });
            }
        }

        // Función para guardar cita
        function guardarCita() {
            const form = document.getElementById('citaForm');
            if (!form.checkValidity()) {
                form.classList.add('was-validated');
                return;
            }

            const citaData = {
                id: document.getElementById('citaId').value,
                paciente: {
                    id: document.getElementById('paciente').value
                },
                doctor: {
                    id: document.getElementById('doctor').value
                },
                fecha: document.getElementById('fecha').value,
                hora: document.getElementById('hora').value,
                estado: document.getElementById('estado').value
            };

            const method = citaData.id ? 'PUT' : 'POST';
            const url = '${pageContext.request.contextPath}/admin/citas' + (citaData.id ? '/' + citaData.id : '');

            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(citaData)
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    throw new Error('Error al guardar la cita');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error al guardar la cita');
            });
        }
    </script>
</body>
</html>
