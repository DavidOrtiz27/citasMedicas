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
        .required-field::after {
            content: "*";
            color: red;
            margin-left: 4px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-light sidebar">
                <div class="position-sticky">
                    <div class="text-center mb-4">
                        <h4>Sistema de Citas</h4>
                        <p class="text-muted">Panel de Recepción</p>
                    </div>
                    
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/recepcionista/dashboard">
                                <i class="bi bi-speedometer2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/recepcionista/pacientes">
                                <i class="bi bi-people"></i>
                                Pacientes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/recepcionista/citas">
                                <i class="bi bi-calendar-check"></i>
                                Citas
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Contenido principal -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Gestión de Citas</h1>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#citaModal">
                        <i class="bi bi-plus-lg"></i> Nueva Cita
                    </button>
                </div>

                <!-- Filtros -->
                <div class="row mb-3">
                    <div class="col-md-3">
                        <select class="form-select" id="filtroEstado">
                            <option value="">Todos los estados</option>
                            <option value="PENDIENTE">Pendientes</option>
                            <option value="CONFIRMADA">Confirmadas</option>
                            <option value="CANCELADA">Canceladas</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <input type="date" class="form-control" id="filtroFecha">
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filtroDoctor">
                            <option value="">Todos los doctores</option>
                            <c:forEach items="${doctores}" var="doctor">
                                <option value="${doctor.id}">${doctor.nombres} ${doctor.apellidos}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button class="btn btn-secondary w-100" onclick="aplicarFiltros()">
                            <i class="bi bi-funnel"></i> Filtrar
                        </button>
                    </div>
                </div>

                <!-- Tabla de citas -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
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
                                    <td>${cita.paciente.nombres} ${cita.paciente.apellidos}</td>
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
                                        <button class="btn btn-sm btn-primary" onclick="editarCita(${cita.id})">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="eliminarCita(${cita.id})">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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
                            <label for="fecha" class="form-label required-field">Fecha</label>
                            <input type="date" class="form-control" id="fecha" required
                                   min="${pageContext.request.contextPath}/recepcionista/citas">
                            <div class="invalid-feedback">
                                Por favor seleccione una fecha válida.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="hora" class="form-label required-field">Hora</label>
                            <select class="form-select" id="hora" required>
                                <option value="">Seleccione una hora</option>
                                <option value="09:00">09:00</option>
                                <option value="10:00">10:00</option>
                                <option value="11:00">11:00</option>
                                <option value="12:00">12:00</option>
                                <option value="15:00">15:00</option>
                                <option value="16:00">16:00</option>
                                <option value="17:00">17:00</option>
                                <option value="18:00">18:00</option>
                            </select>
                            <div class="invalid-feedback">
                                Por favor seleccione una hora.
                            </div>
                        </div>
                        
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
            fetch('${pageContext.request.contextPath}/recepcionista/citas/' + id)
                .then(response => response.json())
                .then(cita => {
                    document.getElementById('citaId').value = cita.id;
                    document.getElementById('fecha').value = new Date(cita.fecha).toISOString().split('T')[0];
                    document.getElementById('hora').value = cita.hora;
                    document.getElementById('paciente').value = cita.paciente.id;
                    document.getElementById('doctor').value = cita.doctor.id;
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
                fetch('${pageContext.request.contextPath}/recepcionista/citas/' + id, {
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

            const cita = {
                id: document.getElementById('citaId').value || null,
                fecha: document.getElementById('fecha').value,
                hora: document.getElementById('hora').value,
                paciente: {
                    id: document.getElementById('paciente').value
                },
                doctor: {
                    id: document.getElementById('doctor').value
                },
                estado: document.getElementById('estado').value
            };

            const method = cita.id ? 'PUT' : 'POST';
            const url = '${pageContext.request.contextPath}/recepcionista/citas' + 
                       (cita.id ? '/' + cita.id : '');

            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(cita)
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else if (response.status === 409) {
                    throw new Error('El horario seleccionado no está disponible');
                } else {
                    throw new Error('Error al guardar la cita');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert(error.message);
            });
        }

        // Función para aplicar filtros
        function aplicarFiltros() {
            const estado = document.getElementById('filtroEstado').value;
            const fecha = document.getElementById('filtroFecha').value;
            const doctor = document.getElementById('filtroDoctor').value;
            
            window.location.href = '${pageContext.request.contextPath}/recepcionista/citas?' +
                                 'estado=' + estado +
                                 '&fecha=' + fecha +
                                 '&doctor=' + doctor;
        }

        // Limpiar formulario al cerrar el modal
        document.getElementById('citaModal').addEventListener('hidden.bs.modal', function () {
            document.getElementById('citaForm').reset();
            document.getElementById('citaForm').classList.remove('was-validated');
            document.getElementById('citaId').value = '';
            document.getElementById('citaModalLabel').textContent = 'Nueva Cita';
        });

        // Establecer fecha mínima como hoy
        document.getElementById('fecha').min = new Date().toISOString().split('T')[0];
    </script>
</body>
</html>
