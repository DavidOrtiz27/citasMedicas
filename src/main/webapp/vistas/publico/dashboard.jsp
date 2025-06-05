<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema de Citas Médicas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 100px 0;
            margin-bottom: 50px;
        }
        .feature-card {
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body>
    <!-- Barra de navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/publico/dashboard">
                <i class="bi bi-hospital"></i> Sistema de Citas Médicas
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/publico/dashboard">
                            <i class="bi bi-house"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/publico/consultaCitas">
                            <i class="bi bi-calendar-check"></i> Consultar Citas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/publico/solicitarCita">
                            <i class="bi bi-calendar-plus"></i> Solicitar Cita
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Sección Hero -->
    <section class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 mb-4">Bienvenido a Nuestro Sistema de Citas Médicas</h1>
            <p class="lead mb-4">Agenda tu cita médica de manera rápida y sencilla</p>
            <a href="${pageContext.request.contextPath}/publico/solicitarCita" class="btn btn-primary btn-lg">
                <i class="bi bi-calendar-plus"></i> Agendar Cita
            </a>
        </div>
    </section>

    <!-- Estadísticas -->
    <section class="container mb-5">
        <div class="row">
            <div class="col-md-4">
                <div class="card text-white bg-primary">
                    <div class="card-body text-center">
                        <i class="bi bi-person-badge display-4 mb-3"></i>
                        <h5 class="card-title">Médicos Disponibles</h5>
                        <p class="card-text display-4">${totalDoctores}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-success">
                    <div class="card-body text-center">
                        <i class="bi bi-list-check display-4 mb-3"></i>
                        <h5 class="card-title">Especialidades</h5>
                        <p class="card-text display-4">${totalEspecialidades}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-info">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-check display-4 mb-3"></i>
                        <h5 class="card-title">Citas Hoy</h5>
                        <p class="card-text display-4">${citasHoy}</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Próximas Citas -->
    <section class="container mb-5">
        <h2 class="text-center mb-4">Próximas Citas Disponibles</h2>
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Fecha</th>
                        <th>Hora</th>
                        <th>Doctor</th>
                        <th>Especialidad</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${proximasCitas}" var="cita">
                        <tr>
                            <td><fmt:formatDate value="${cita.fecha}" pattern="dd/MM/yyyy"/></td>
                            <td>${cita.hora}</td>
                            <td>${cita.doctor.nombres} ${cita.doctor.apellidos}</td>
                            <td>${cita.doctor.especialidad.nombre}</td>
                            <td>
                                <span class="badge bg-${cita.estado eq 'PENDIENTE' ? 'warning' : 
                                                   cita.estado eq 'CONFIRMADA' ? 'success' : 
                                                   cita.estado eq 'CANCELADA' ? 'danger' : 'secondary'}">
                                    ${cita.estado}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </section>

    <!-- Características -->
    <section class="container mb-5">
        <h2 class="text-center mb-4">Nuestros Servicios</h2>
        <div class="row">
            <div class="col-md-4">
                <div class="card feature-card">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-check display-4 text-primary mb-3"></i>
                        <h5 class="card-title">Agenda Online</h5>
                        <p class="card-text">Reserva tu cita médica de manera rápida y sencilla a través de nuestra plataforma.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card">
                    <div class="card-body text-center">
                        <i class="bi bi-person-badge display-4 text-success mb-3"></i>
                        <h5 class="card-title">Especialistas</h5>
                        <p class="card-text">Contamos con un equipo de médicos especialistas altamente calificados.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card">
                    <div class="card-body text-center">
                        <i class="bi bi-clock display-4 text-info mb-3"></i>
                        <h5 class="card-title">Atención Rápida</h5>
                        <p class="card-text">Sistema eficiente que te permite gestionar tus citas de manera oportuna.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Sistema de Citas Médicas</h5>
                    <p>Tu salud es nuestra prioridad</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <h5>Contacto</h5>
                    <p>
                        <i class="bi bi-telephone"></i> (01) 123-4567<br>
                        <i class="bi bi-envelope"></i> info@clinica.com
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 