<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : 'es'}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="es">
<head>
    <title><fmt:message key="login.title"/></title>
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

        .stat-card {
            background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 1rem;
            overflow: hidden;
        }

        .stat-card .icon {
            font-size: 2.5rem;
            opacity: 0.8;
            transition: transform 0.3s;
        }

        .stat-card:hover .icon {
            transform: scale(1.1);
        }

        .stat-card .number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }

        .stat-card .label {
            font-size: 1rem;
            opacity: 0.8;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .table {
            border-radius: 0.5rem;
            overflow: hidden;
        }

        .table thead {
            background: var(--primary-color);
            color: white;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .status-pendiente {
            background-color: var(--warning-color);
            color: #000;
        }

        .status-confirmada {
            background-color: var(--success-color);
            color: white;
        }

        .status-cancelada {
            background-color: var(--danger-color);
            color: white;
        }

        .welcome-section {
            background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .welcome-section h1 {
            font-size: 2.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .welcome-section p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .btn-action {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .btn-action:hover {
            transform: translateY(-2px);
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/inicio">
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

            <!-- Contenido principal -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <!-- Sección de bienvenida -->
                <div class="welcome-section">
                    <h1>Bienvenido al Sistema</h1>
                    <p>Gestiona tus citas médicas de manera eficiente y organizada</p>
                </div>

                <!-- Tarjetas de estadísticas -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="number">${totalPacientes}</div>
                                        <div class="label">Pacientes</div>
                                    </div>
                                    <div class="icon">
                                        <i class="bi bi-people"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="number">${totalDoctores}</div>
                                        <div class="label">Doctores</div>
                                    </div>
                                    <div class="icon">
                                        <i class="bi bi-person-badge"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="number">${citasHoy}</div>
                                        <div class="label">Citas Hoy</div>
                                    </div>
                                    <div class="icon">
                                        <i class="bi bi-calendar-check"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="number">${totalEspecialidades}</div>
                                        <div class="label">Especialidades</div>
                                    </div>
                                    <div class="icon">
                                        <i class="bi bi-list-check"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Próximas citas -->
                <div class="card">
                    <div class="card-header bg-white">
                        <h5 class="card-title mb-0">Próximas Citas</h5>
                    </div>
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

                                <c:if test="${empty proximasCitas}">
                                    <tr>
                                        <td colspan="7" class="text-center">
                                            <div class="alert alert-info">
                                                No hay citas próximas registradas
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                                
                                <c:if test="${not empty proximasCitas}">
                                    <c:forEach items="${proximasCitas}" var="cita">
                                        <tr>
                                            <td><fmt:formatDate value="${cita.fecha}" pattern="dd/MM/yyyy"/></td>
                                            <td>${cita.hora}</td>
                                            <td>${cita.paciente.nombres} ${cita.paciente.apellidos}</td>
                                            <td>${cita.doctor.nombres} ${cita.doctor.apellidos}</td>
                                            <td>${cita.doctor.especialidad}</td>
                                            <td>
                                                <span class="status-badge status-${cita.estado.toLowerCase()}">
                                                    ${cita.estado}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="btn-group">
                                                    <a href="${pageContext.request.contextPath}/admin/citas/comprobante?id=${cita.id}" 
                                                       class="btn btn-sm btn-info btn-action" target="_blank">
                                                        <i class="bi bi-file-earmark-pdf"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/admin/citas/editar?id=${cita.id}" 
                                                       class="btn btn-sm btn-primary btn-action">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 