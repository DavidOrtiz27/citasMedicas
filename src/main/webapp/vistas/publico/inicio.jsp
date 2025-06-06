<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal de Pacientes - Sistema de Citas Médicas</title>
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
            min-height: 100vh;
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }

        .card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.1);
            transition: transform 0.3s;
            margin-bottom: 2rem;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--accent-color);
        }

        .btn-action {
            background: var(--accent-color);
            color: white;
            border: none;
            border-radius: 0.5rem;
            padding: 0.75rem 1.5rem;
            transition: all 0.3s;
        }

        .btn-action:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
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
            transition: transform 0.2s;
        }

        .captcha-image:hover {
            transform: scale(1.02);
        }

        .alert {
            border-radius: 0.5rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1 class="text-center">Portal de Pacientes</h1>
            <p class="text-center mb-0">Gestiona tus citas médicas de manera fácil y rápida</p>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <!-- Consultar Citas -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-check card-icon"></i>
                        <h5 class="card-title">Consultar Citas</h5>
                        <p class="card-text">Revisa tus citas programadas usando tu documento de identidad.</p>
                        <button type="button" class="btn btn-action" data-bs-toggle="modal" data-bs-target="#consultarModal">
                            Consultar Ahora
                        </button>
                    </div>
                </div>
            </div>

            <!-- Cancelar Citas -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-x card-icon"></i>
                        <h5 class="card-title">Cancelar Citas</h5>
                        <p class="card-text">Cancela tus citas con 24 horas de anticipación.</p>
                        <button type="button" class="btn btn-action" data-bs-toggle="modal" data-bs-target="#cancelarModal">
                            Cancelar Cita
                        </button>
                    </div>
                </div>
            </div>

            <!-- Solicitar Citas -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-plus card-icon"></i>
                        <h5 class="card-title">Solicitar Citas</h5>
                        <p class="card-text">Solicita una nueva cita médica.</p>
                        <a href="${pageContext.request.contextPath}/publico/solicitar" class="btn btn-action">
                            Solicitar Ahora
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Consultar Citas -->
    <div class="modal fade" id="consultarModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Consultar Citas</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="consultarForm">
                        <div class="mb-3">
                            <label for="documentoConsulta" class="form-label">Documento de Identidad</label>
                            <input type="text" class="form-control" id="documentoConsulta" required>
                        </div>
                        <div class="captcha-container">
                            <img src="${pageContext.request.contextPath}/captcha" 
                                 class="captcha-image mb-3" 
                                 alt="CAPTCHA"
                                 onclick="this.src='${pageContext.request.contextPath}/captcha?' + Math.random()">
                            <div class="mb-3">
                                <input type="text" class="form-control" id="captchaConsulta" 
                                       placeholder="Ingrese el código CAPTCHA" required>
                            </div>
                            <small class="text-muted">Haga clic en la imagen para actualizar el código</small>
                        </div>
                    </form>
                    <div id="resultadoConsulta" class="mt-3"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-primary" onclick="consultarCitas()">Consultar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Cancelar Citas -->
    <div class="modal fade" id="cancelarModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Cancelar Cita</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="cancelarForm">
                        <div class="mb-3">
                            <label for="documentoCancelar" class="form-label">Documento de Identidad</label>
                            <input type="text" class="form-control" id="documentoCancelar" required>
                        </div>
                        <div class="mb-3">
                            <label for="citaId" class="form-label">ID de la Cita</label>
                            <input type="number" class="form-control" id="citaId" required>
                        </div>
                        <div class="captcha-container">
                            <img src="${pageContext.request.contextPath}/captcha" 
                                 class="captcha-image mb-3" 
                                 alt="CAPTCHA"
                                 onclick="this.src='${pageContext.request.contextPath}/captcha?' + Math.random()">
                            <div class="mb-3">
                                <input type="text" class="form-control" id="captchaCancelar" 
                                       placeholder="Ingrese el código CAPTCHA" required>
                            </div>
                            <small class="text-muted">Haga clic en la imagen para actualizar el código</small>
                        </div>
                    </form>
                    <div id="resultadoCancelar" class="mt-3"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-danger" onclick="cancelarCita()">Cancelar Cita</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function consultarCitas() {
            const documento = document.getElementById('documentoConsulta').value;
            const captcha = document.getElementById('captchaConsulta').value;
            
            fetch('${pageContext.request.contextPath}/publico/consultar?documento=' + documento + '&captcha=' + captcha)
                .then(response => response.json())
                .then(data => {
                    const resultado = document.getElementById('resultadoConsulta');
                    if (data.error) {
                        resultado.innerHTML = '<div class="alert alert-danger">' + data.error + '</div>';
                    } else {
                        let html = '<div class="table-responsive"><table class="table">';
                        html += '<thead><tr><th>Fecha</th><th>Hora</th><th>Doctor</th><th>Estado</th></tr></thead>';
                        html += '<tbody>';
                        data.forEach(cita => {
                            html += '<tr>';
                            html += '<td>' + new Date(cita.fecha).toLocaleDateString() + '</td>';
                            html += '<td>' + new Date(cita.fecha).toLocaleTimeString() + '</td>';
                            html += '<td>' + cita.doctor.nombres + ' ' + cita.doctor.apellidos + '</td>';
                            html += '<td>' + cita.estado + '</td>';
                            html += '</tr>';
                        });
                        html += '</tbody></table></div>';
                        resultado.innerHTML = html;
                    }
                })
                .catch(error => {
                    document.getElementById('resultadoConsulta').innerHTML = 
                        '<div class="alert alert-danger">Error al consultar las citas</div>';
                });
        }

        function cancelarCita() {
            const documento = document.getElementById('documentoCancelar').value;
            const citaId = document.getElementById('citaId').value;
            const captcha = document.getElementById('captchaCancelar').value;
            
            fetch('${pageContext.request.contextPath}/publico/cancelar?documento=' + documento + 
                  '&citaId=' + citaId + '&captcha=' + captcha)
                .then(response => response.json())
                .then(data => {
                    const resultado = document.getElementById('resultadoCancelar');
                    if (data.error) {
                        resultado.innerHTML = '<div class="alert alert-danger">' + data.error + '</div>';
                    } else {
                        resultado.innerHTML = '<div class="alert alert-success">' + data.message + '</div>';
                        document.getElementById('cancelarForm').reset();
                    }
                })
                .catch(error => {
                    document.getElementById('resultadoCancelar').innerHTML = 
                        '<div class="alert alert-danger">Error al cancelar la cita</div>';
                });
        }
    </script>
</body>
</html> 