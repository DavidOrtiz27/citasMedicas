<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : 'es'}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="report.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <!-- Barra de navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="bi bi-hospital"></i> Sistema de Citas Médicas
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-house"></i> Dashboard
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/citas">
                            <i class="bi bi-calendar-check"></i> Citas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/reportes">
                            <i class="bi bi-file-earmark-text"></i> Reportes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right"></i> Cerrar Sesión
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Contenido principal -->
    <div class="container mt-4">
        <h2 class="mb-4">Generación de Reportes</h2>

        <!-- Mensaje de error -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row">
            <!-- Reporte de Citas -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-calendar-check"></i> Reporte de Citas
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/citas/reporte" method="get">
                            <div class="mb-3">
                                <label for="fechaInicio" class="form-label">Fecha Inicio</label>
                                <input type="date" class="form-control" id="fechaInicio" name="fechaInicio" required>
                            </div>
                            <div class="mb-3">
                                <label for="fechaFin" class="form-label">Fecha Fin</label>
                                <input type="date" class="form-control" id="fechaFin" name="fechaFin" required>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-file-earmark-excel"></i> Generar Excel
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Estadísticas -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="bi bi-graph-up"></i> Estadísticas
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="card bg-primary text-white">
                                    <div class="card-body">
                                        <h6 class="card-title">Citas Hoy</h6>
                                        <h2 class="card-text">${citasHoy}</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="card bg-success text-white">
                                    <div class="card-body">
                                        <h6 class="card-title">Citas Confirmadas</h6>
                                        <h2 class="card-text">${citasConfirmadas}</h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validar que la fecha fin no sea menor que la fecha inicio
        document.getElementById('fechaFin').addEventListener('change', function() {
            const fechaInicio = document.getElementById('fechaInicio').value;
            const fechaFin = this.value;
            
            if (fechaInicio && fechaFin && fechaFin < fechaInicio) {
                alert('La fecha fin no puede ser menor que la fecha inicio');
                this.value = fechaInicio;
            }
        });
    </script>
</body>
</html>
