<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Gestión de Doctores - Sistema de Citas Médicas</title>
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

        .page-header {
            background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            margin-top: 2rem;
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

        .doctor-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .doctor-avatar {
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
        .doctor-details {
            display: flex;
            flex-direction: column;
        }
        .doctor-name {
            font-weight: 600;
            color: var(--primary-color);
        }
        .doctor-specialty {
            font-size: 0.875rem;
            color: var(--secondary-color);
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/doctor/doctores">
                                <i class="bi bi-person-badge"></i>
                                Doctores
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/citas/citas">
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
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="page-header">
                    <h1>Gestión de Doctores</h1>
                    <p>Administra los doctores del sistema</p>
                </div>
                <!-- Barra de búsqueda y botón -->
                <div class="search-box mb-3">
                    <form class="row g-3" action="${pageContext.request.contextPath}/admin/doctores" method="get">
                        <div class="col-md-8">
                            <div class="input-group">
                                <input type="text" class="form-control" id="searchInput" name="buscar" placeholder="Buscar por nombre, especialidad o DNI...">
                                <button class="btn btn-primary" type="button" id="searchButton">
                                    <i class="bi bi-search"></i> Buscar
                                </button>
                            </div>
                        </div>
                        <div class="col-md-4 text-end">
                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#doctorModal">
                                <i class="bi bi-plus-lg"></i> Nuevo Doctor
                            </button>
                        </div>
                    </form>
                </div>
                <!-- Tabla de doctores -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Doctor</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="doctoresTableBody">
                                    <c:forEach items="${doctores}" var="doctor">
                                        <tr>
                                            <td>
                                                <div class="doctor-info">
                                                    <div class="doctor-avatar">
                                                        <c:out value="${fn:substring(doctor.nombres,0,1)}${fn:substring(doctor.apellidos,0,1)}"/>
                                                    </div>
                                                    <div class="doctor-details">
                                                        <span class="doctor-name">${doctor.nombres} ${doctor.apellidos}</span>
                                                        <span class="doctor-specialty">${doctor.especialidad}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="btn-group">
                                                    <button class="btn btn-sm btn-primary btn-action" onclick="editDoctor('${doctor.id}')">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-danger btn-action" onclick="deleteDoctor('${doctor.id}')">
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
    <!-- Doctor Modal -->
    <div class="modal fade" id="doctorModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Nuevo Doctor</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="doctorForm">
                        <input type="hidden" id="doctorId">
                        <div class="mb-3">
                            <label for="nombres" class="form-label">Nombres</label>
                            <input type="text" class="form-control" id="nombres" required>
                        </div>
                        <div class="mb-3">
                            <label for="apellidos" class="form-label">Apellidos</label>
                            <input type="text" class="form-control" id="apellidos" required>
                        </div>
                        <div class="mb-3">
                            <label for="especialidad" class="form-label">Especialidad</label>
                            <select class="form-select" id="especialidad" required>
                                <!-- Opciones cargadas dinámicamente -->
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" id="saveDoctor">Guardar</button>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Cargar especialidades para el modal
        function loadEspecialidades() {
            fetch('${pageContext.request.contextPath}/admin/especialidades')
                .then(response => response.json())
                .then(especialidades => {
                    const select = document.getElementById('especialidad');
                    select.innerHTML = '<option value="">Seleccione una especialidad</option>';
                    especialidades.forEach(esp => {
                        select.innerHTML += `<option value="${esp.id}">${esp.nombre}</option>`;
                    });
                })
                .catch(error => console.error('Error:', error));
        }
        // Guardar doctor (crear o actualizar)
        document.getElementById('saveDoctor').addEventListener('click', function() {
            const doctor = {
                id: document.getElementById('doctorId').value || 0,
                nombres: document.getElementById('nombres').value,
                apellidos: document.getElementById('apellidos').value,
                especialidad: {
                    id: document.getElementById('especialidad').value
                }
            };
            const method = doctor.id ? 'PUT' : 'POST';
            const url = '${pageContext.request.contextPath}/admin/doctores' + (doctor.id ? '/' + doctor.id : '');
            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(doctor)
            })
            .then(response => {
                if (response.ok) {
                    bootstrap.Modal.getInstance(document.getElementById('doctorModal')).hide();
                    location.reload();
                } else {
                    throw new Error('Error al guardar el doctor');
                }
            })
            .catch(error => console.error('Error:', error));
        });
        // Editar doctor
        function editDoctor(id) {
            fetch('${pageContext.request.contextPath}/admin/doctores/' + id)
                .then(response => response.json())
                .then(doctor => {
                    document.getElementById('doctorId').value = doctor.id;
                    document.getElementById('nombres').value = doctor.nombres;
                    document.getElementById('apellidos').value = doctor.apellidos;
                    document.getElementById('especialidad').value = doctor.especialidad.id;
                    document.getElementById('modalTitle').textContent = 'Editar Doctor';
                    new bootstrap.Modal(document.getElementById('doctorModal')).show();
                })
                .catch(error => console.error('Error:', error));
        }
        // Eliminar doctor
        function deleteDoctor(id) {
            if (confirm('¿Está seguro de eliminar este doctor?')) {
                fetch('${pageContext.request.contextPath}/admin/doctores/' + id, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        throw new Error('Error al eliminar el doctor');
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        }
        // Cargar especialidades al abrir el modal
        document.getElementById('doctorModal').addEventListener('show.bs.modal', loadEspecialidades);
        // Búsqueda en la tabla (solo frontend)
        document.getElementById('searchButton').addEventListener('click', function() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.getElementById('doctoresTableBody').getElementsByTagName('tr');
            for (let row of rows) {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            }
        });
    </script>
</body>
</html>
