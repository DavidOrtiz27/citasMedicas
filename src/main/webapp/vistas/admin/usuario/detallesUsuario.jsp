<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalles de Usuario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
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
    </style>
</head>
<body>
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/cita/citas">
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/usuario/usuarios">
                        <i class="bi bi-person-gear"></i>
                        Usuarios
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- Contenido principal -->
    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Detalles de Usuario</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
                <a href="${pageContext.request.contextPath}/admin/usuario/usuarios" class="btn btn-secondary me-2">
                    <i class="bi bi-arrow-left"></i> Volver
                </a>
                <a href="${pageContext.request.contextPath}/admin/usuario/editar/${usuario.id}" class="btn btn-primary">
                    <i class="bi bi-pencil"></i> Editar
                </a>
            </div>
        </div>

        <!-- Mensajes de alerta -->
        <c:if test="${not empty mensaje}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Detalles del usuario -->
        <div class="card">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h5 class="card-title mb-4">Información del Usuario</h5>
                        <table class="table">
                            <tr>
                                <th>ID:</th>
                                <td>${usuario.id}</td>
                            </tr>
                            <tr>
                                <th>Nombre de Usuario:</th>
                                <td>${usuario.username}</td>
                            </tr>
                            <tr>
                                <th>Rol:</th>
                                <td>${usuario.rol}</td>
                            </tr>
                            <tr>
                                <th>Estado:</th>
                                <td>
                                    <span class="badge ${usuario.activo ? 'bg-success' : 'bg-danger'}">
                                        ${usuario.activo ? 'Activo' : 'Inactivo'}
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>Fecha de Creación:</th>
                                <td><fmt:formatDate value="${usuario.fechaCreacion}" pattern="dd/MM/yyyy HH:mm"/></td>
                            </tr>
                            <tr>
                                <th>Último Acceso:</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty usuario.ultimoAcceso}">
                                            <fmt:formatDate value="${usuario.ultimoAcceso}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            Nunca
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 