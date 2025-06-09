<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : 'es'}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="es">
<head>
    <title><fmt:message key="appointmentsQuery.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .required-field::after {
            content: "*";
            color: red;
            margin-left: 4px;
        }
        .captcha-container {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
            font-family: 'Courier New', monospace;
            font-size: 24px;
            letter-spacing: 5px;
            user-select: none;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Consulta de Citas Médicas</h4>
                    </div>
                    <div class="card-body">
                        <form id="consultaForm" class="needs-validation" novalidate>
                            <div class="mb-3">
                                <label for="dni" class="form-label required-field">DNI</label>
                                <input type="text" class="form-control" id="dni" required
                                       pattern="[0-9]{8}" maxlength="8">
                                <div class="invalid-feedback">
                                    Por favor ingrese un DNI válido (8 dígitos).
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label required-field">CAPTCHA</label>
                                <div class="captcha-container mb-2" id="captchaText"></div>
                                <input type="text" class="form-control" id="captcha" required>
                                <div class="invalid-feedback">
                                    Por favor ingrese el código CAPTCHA correctamente.
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-search"></i> Consultar Citas
                                </button>
                                <a href="${pageContext.request.contextPath}/publico/citas/solicitar" 
                                   class="btn btn-outline-primary">
                                    <i class="bi bi-plus-lg"></i> Solicitar Nueva Cita
                                </a>
                            </div>
                        </form>
                        
                        <!-- Resultados de la consulta -->
                        <div id="resultados" class="mt-4" style="display: none;">
                            <h5 class="mb-3">Mis Citas</h5>
                            <div class="table-responsive">
                                <table class="table table-striped">
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
                                    <tbody id="citasTableBody">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Generar CAPTCHA
        function generarCaptcha() {
            const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            let captcha = '';
            for (let i = 0; i < 6; i++) {
                captcha += caracteres.charAt(Math.floor(Math.random() * caracteres.length));
            }
            document.getElementById('captchaText').textContent = captcha;
            return captcha;
        }

        // Inicializar CAPTCHA
        let captchaActual = generarCaptcha();
        
        // Manejar envío del formulario
        document.getElementById('consultaForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (!this.checkValidity()) {
                this.classList.add('was-validated');
                return;
            }
            
            const dni = document.getElementById('dni').value;
            const captcha = document.getElementById('captcha').value;
            
            fetch('${pageContext.request.contextPath}/publico/citas', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `dni=${dni}&captcha=${captcha}`
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error(response.status === 400 ? 'CAPTCHA incorrecto' : 
                                  response.status === 404 ? 'Paciente no encontrado' : 
                                  'Error al consultar las citas');
                }
                return response.json();
            })
            .then(citas => {
                const tbody = document.getElementById('citasTableBody');
                tbody.innerHTML = '';
                
                citas.forEach(cita => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td>${new Date(cita.fecha).toLocaleDateString()}</td>
                        <td>${cita.hora}</td>
                        <td>${cita.doctor.nombres} ${cita.doctor.apellidos}</td>
                        <td>${cita.doctor.especialidad.nombre}</td>
                        <td>
                            <span class="badge bg-${cita.estado === 'PENDIENTE' ? 'warning' : 
                                                 cita.estado === 'CONFIRMADA' ? 'success' : 
                                                 cita.estado === 'CANCELADA' ? 'danger' : 'secondary'}">
                                ${cita.estado}
                            </span>
                        </td>
                        <td>
                            ${cita.estado !== 'CANCELADA' ? 
                              `<button class="btn btn-sm btn-danger" onclick="cancelarCita(${cita.id})">
                                <i class="bi bi-x-circle"></i> Cancelar
                              </button>` : ''}
                        </td>
                    `;
                    tbody.appendChild(tr);
                });
                
                document.getElementById('resultados').style.display = 'block';
                document.getElementById('captcha').value = '';
                captchaActual = generarCaptcha();
            })
            .catch(error => {
                alert(error.message);
                document.getElementById('captcha').value = '';
                captchaActual = generarCaptcha();
            });
        });

        // Función para cancelar cita
        function cancelarCita(id) {
            if (confirm('¿Está seguro de cancelar esta cita?')) {
                fetch('${pageContext.request.contextPath}/publico/citas/' + id + '/cancelar', {
                    method: 'POST'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error(response.status === 403 ? 
                            'No se puede cancelar una cita con menos de 24 horas de anticipación' : 
                            'Error al cancelar la cita');
                    }
                    return response.json();
                })
                .then(() => {
                    alert('Cita cancelada exitosamente');
                    document.getElementById('consultaForm').dispatchEvent(new Event('submit'));
                })
                .catch(error => {
                    alert(error.message);
                });
            }
        }
    </script>
</body>
</html>
