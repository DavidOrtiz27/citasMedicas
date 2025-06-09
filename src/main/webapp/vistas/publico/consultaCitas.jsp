<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Consulta de Citas - Sistema de Citas Médicas</title>
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

        .table {
            border-radius: 0.5rem;
            overflow: hidden;
        }

        .table th {
            background: var(--primary-color);
            color: white;
            font-weight: 500;
            padding: 1rem;
        }

        .table td {
            padding: 1rem;
            vertical-align: middle;
        }

        .badge {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
        }

        .badge-pendiente {
            background-color: var(--warning-color);
            color: #000;
        }

        .badge-confirmada {
            background-color: var(--success-color);
            color: white;
        }

        .badge-cancelada {
            background-color: var(--danger-color);
            color: white;
        }

        .badge-completada {
            background-color: var(--accent-color);
            color: white;
        }

        .btn-danger {
            background: var(--danger-color);
            border: none;
            padding: 0.5rem 1rem;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-danger:hover {
            background: #c0392b;
            transform: translateY(-2px);
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/publico/consultar">
                            <i class="bi bi-calendar-check"></i> Consultar Citas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/publico/solicitar">
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
                            <i class="bi bi-calendar-check"></i> Consulta de Citas
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

                        <form action="${pageContext.request.contextPath}/publico/consultar" method="post" class="needs-validation" novalidate>
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
                                    <i class="bi bi-search"></i> Consultar Citas
                                </button>
                                <a href="${pageContext.request.contextPath}/publico/solicitar" 
                                   class="btn btn-outline-primary">
                                    <i class="bi bi-plus-lg"></i> Solicitar Nueva Cita
                                </a>
                            </div>
                        </form>

                        <c:if test="${not empty citas}">
                            <div class="mt-5">
                                <h5 class="mb-4">Resultados de la Consulta</h5>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Fecha</th>
                                                <th>Hora</th>
                                                <th>Doctor</th>
                                                <th>Especialidad</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${citas}" var="cita">
                                                <tr>
                                                    <td>
                                                        <fmt:formatDate value="${cita.fecha}" pattern="dd/MM/yyyy"/>
                                                    </td>
                                                    <td>${cita.hora}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty cita.doctor}">
                                                                ${cita.doctor.nombres} ${cita.doctor.apellidos}
                                                            </c:when>
                                                            <c:otherwise>
                                                                No disponible
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty cita.doctor and not empty cita.doctor.especialidad}">
                                                                ${cita.doctor.especialidad.nombre}
                                                            </c:when>
                                                            <c:otherwise>
                                                                No disponible
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${cita.estado == 'PENDIENTE'}">
                                                                <span class="badge badge-pendiente">Pendiente</span>
                                                            </c:when>
                                                            <c:when test="${cita.estado == 'CONFIRMADA'}">
                                                                <span class="badge badge-confirmada">Confirmada</span>
                                                            </c:when>
                                                            <c:when test="${cita.estado == 'CANCELADA'}">
                                                                <span class="badge badge-cancelada">Cancelada</span>
                                                            </c:when>
                                                            <c:when test="${cita.estado == 'COMPLETADA'}">
                                                                <span class="badge badge-completada">Completada</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${cita.estado == 'PENDIENTE' or cita.estado == 'CONFIRMADA'}">
                                                            <button type="button" 
                                                                    class="btn btn-danger btn-sm"
                                                                    onclick="confirmarCancelacion(
                                                                        '${cita.id}',
                                                                        '<fmt:formatDate value="${cita.fecha}" pattern="dd/MM/yyyy"/>',
                                                                        '${cita.hora}',
                                                                        '${cita.doctor.nombres} ${cita.doctor.apellidos}',
                                                                        '${cita.doctor.especialidad.nombre}'
                                                                    )">
                                                                <i class="bi bi-x-circle"></i> Cancelar
                                                            </button>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:if>
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

        function confirmarCancelacion(citaId, fecha, hora, doctor, especialidad) {
            Swal.fire({
                title: "¿Cancelar esta cita?",
                html: 
                    "<div class='text-start'>" +
                    "<p><strong>Fecha:</strong> " + fecha + "</p>" +
                    "<p><strong>Hora:</strong> " + hora + "</p>" +
                    "<p><strong>Doctor:</strong> " + doctor + "</p>" +
                    "<p><strong>Especialidad:</strong> " + especialidad + "</p>" +
                    "</div>",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#e74c3c",
                cancelButtonColor: "#7f8c8d",
                confirmButtonText: "Sí, cancelar cita",
                cancelButtonText: "No, mantener cita",
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    const form = document.createElement("form");
                    form.method = "POST";
                    form.action = "${pageContext.request.contextPath}/publico/cancelar";
                    
                    const input = document.createElement("input");
                    input.type = "hidden";
                    input.name = "id";
                    input.value = citaId;
                    
                    form.appendChild(input);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }
    </script>
</body>
</html>
