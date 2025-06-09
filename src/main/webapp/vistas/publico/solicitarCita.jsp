<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : 'es'}" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="es">
<head>
    <title><fmt:message key="makeAppointment.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .required-field::after {
            content: "*";
            color: red;
            margin-left: 4px;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Solicitar Nueva Cita</h4>
                    </div>
                    <div class="card-body">
                        <form id="solicitudForm" class="needs-validation" novalidate>
                            <!-- Datos del paciente -->
                            <div class="mb-4">
                                <h5 class="mb-3">Datos del Paciente</h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="dni" class="form-label required-field">DNI</label>
                                        <input type="text" class="form-control" id="dni" required
                                               pattern="[0-9]{8}" maxlength="8">
                                        <div class="invalid-feedback">
                                            Por favor ingrese un DNI válido (8 dígitos).
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="nombres" class="form-label required-field">Nombres</label>
                                        <input type="text" class="form-control" id="nombres" required>
                                        <div class="invalid-feedback">
                                            Por favor ingrese sus nombres.
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="apellidos" class="form-label required-field">Apellidos</label>
                                        <input type="text" class="form-control" id="apellidos" required>
                                        <div class="invalid-feedback">
                                            Por favor ingrese sus apellidos.
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="telefono" class="form-label required-field">Teléfono</label>
                                        <input type="tel" class="form-control" id="telefono" required
                                               pattern="[0-9]{9}" maxlength="9">
                                        <div class="invalid-feedback">
                                            Por favor ingrese un teléfono válido (9 dígitos).
                                        </div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label required-field">Correo Electrónico</label>
                                    <input type="email" class="form-control" id="email" required>
                                    <div class="invalid-feedback">
                                        Por favor ingrese un correo electrónico válido.
                                    </div>
                                </div>
                            </div>

                            <!-- Datos de la cita -->
                            <div class="mb-4">
                                <h5 class="mb-3">Datos de la Cita</h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="especialidad" class="form-label required-field">Especialidad</label>
                                        <select class="form-select" id="especialidad" required>
                                            <option value="">Seleccione una especialidad</option>
                                            <c:forEach items="${especialidades}" var="esp">
                                                <option value="${esp.id}">${esp.nombre}</option>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback">
                                            Por favor seleccione una especialidad.
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="doctor" class="form-label required-field">Doctor</label>
                                        <select class="form-select" id="doctor" required disabled>
                                            <option value="">Primero seleccione una especialidad</option>
                                        </select>
                                        <div class="invalid-feedback">
                                            Por favor seleccione un doctor.
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="fecha" class="form-label required-field">Fecha</label>
                                        <input type="date" class="form-control" id="fecha" required
                                               min="${minDate}">
                                        <div class="invalid-feedback">
                                            Por favor seleccione una fecha válida.
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="hora" class="form-label required-field">Hora</label>
                                        <select class="form-select" id="hora" required disabled>
                                            <option value="">Primero seleccione fecha y doctor</option>
                                        </select>
                                        <div class="invalid-feedback">
                                            Por favor seleccione una hora disponible.
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-send"></i> Enviar Solicitud
                                </button>
                                <a href="${pageContext.request.contextPath}/publico/citas" 
                                   class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left"></i> Volver a Consulta
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Cargar doctores al seleccionar especialidad
        document.getElementById('especialidad').addEventListener('change', function() {
            const especialidadId = this.value;
            const doctorSelect = document.getElementById('doctor');
            
            if (especialidadId) {
                doctorSelect.disabled = false;
                fetch('${pageContext.request.contextPath}/publico/doctores?especialidad=' + especialidadId)
                    .then(response => response.json())
                    .then(doctores => {
                        doctorSelect.innerHTML = '<option value="">Seleccione un doctor</option>';
                        doctores.forEach(doctor => {
                            doctorSelect.innerHTML += `
                                <option value="${doctor.id}">
                                    ${doctor.nombres} ${doctor.apellidos}
                                </option>
                            `;
                        });
                    })
                    .catch(error => {
                        console.error('Error al cargar doctores:', error);
                        alert('Error al cargar la lista de doctores');
                    });
            } else {
                doctorSelect.disabled = true;
                doctorSelect.innerHTML = '<option value="">Primero seleccione una especialidad</option>';
            }
        });

        // Cargar horarios disponibles al seleccionar fecha y doctor
        function cargarHorarios() {
            const fecha = document.getElementById('fecha').value;
            const doctorId = document.getElementById('doctor').value;
            const horaSelect = document.getElementById('hora');
            
            if (fecha && doctorId) {
                horaSelect.disabled = false;
                fetch('${pageContext.request.contextPath}/publico/horarios?fecha=' + fecha + '&doctor=' + doctorId)
                    .then(response => response.json())
                    .then(horarios => {
                        horaSelect.innerHTML = '<option value="">Seleccione una hora</option>';
                        horarios.forEach(horario => {
                            horaSelect.innerHTML += `
                                <option value="${horario}">${horario}</option>
                            `;
                        });
                    })
                    .catch(error => {
                        console.error('Error al cargar horarios:', error);
                        alert('Error al cargar los horarios disponibles');
                    });
            } else {
                horaSelect.disabled = true;
                horaSelect.innerHTML = '<option value="">Primero seleccione fecha y doctor</option>';
            }
        }

        document.getElementById('fecha').addEventListener('change', cargarHorarios);
        document.getElementById('doctor').addEventListener('change', cargarHorarios);

        // Manejar envío del formulario
        document.getElementById('solicitudForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (!this.checkValidity()) {
                this.classList.add('was-validated');
                return;
            }
            
            const datos = {
                dni: document.getElementById('dni').value,
                nombres: document.getElementById('nombres').value,
                apellidos: document.getElementById('apellidos').value,
                telefono: document.getElementById('telefono').value,
                email: document.getElementById('email').value,
                doctorId: document.getElementById('doctor').value,
                fecha: document.getElementById('fecha').value,
                hora: document.getElementById('hora').value
            };
            
            fetch('${pageContext.request.contextPath}/publico/citas/solicitar', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(datos)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error al enviar la solicitud de cita');
                }
                return response.json();
            })
            .then(() => {
                alert('Solicitud de cita enviada exitosamente. Se le notificará cuando sea confirmada.');
                window.location.href = '${pageContext.request.contextPath}/publico/citas';
            })
            .catch(error => {
                alert(error.message);
            });
        });
    </script>
</body>
</html>
