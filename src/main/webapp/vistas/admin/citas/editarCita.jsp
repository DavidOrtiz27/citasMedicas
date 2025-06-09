<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Editar Cita - Sistema de Citas Médicas</title>
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

        .required-field::after {
            content: "*";
            color: var(--danger-color);
            margin-left: 4px;
        }

        .page-header {
            background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/doctor/doctores">
                                <i class="bi bi-person-badge"></i>
                                Doctores
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/citas">
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
                <!-- Encabezado de página -->
                <div class="page-header">
                    <h1>Editar Cita</h1>
                    <p>Modifica los datos de la cita médica</p>
                </div>

                <!-- Formulario de edición -->
                <div class="card">
                    <div class="card-body">
                        <form id="formEditarCita">
                            <input type="hidden" name="accion" value="actualizar">
                            <input type="hidden" name="id" value="${cita.id}">
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="paciente" class="form-label required-field">Paciente</label>
                                    <select class="form-select" id="paciente" name="paciente" required>
                                        <option value="">Seleccione un paciente</option>
                                        <c:forEach items="${pacientes}" var="paciente">
                                            <option value="${paciente.id}" ${cita.paciente.id == paciente.id ? 'selected' : ''}>
                                                ${paciente.nombres} ${paciente.apellidos}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="especialidad" class="form-label required-field">Especialidad</label>
                                    <select class="form-select" id="especialidad" name="especialidad" required>
                                        <option value="">Seleccione una especialidad</option>
                                        <c:forEach items="${especialidades}" var="especialidad">
                                            <option value="${especialidad.id}" ${cita.doctor.especialidad.id == especialidad.id ? 'selected' : ''}>
                                                ${especialidad.nombre}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="doctor" class="form-label required-field">Doctor</label>
                                    <select class="form-select" id="doctor" name="doctor" required>
                                        <option value="">Seleccione un doctor</option>
                                        <c:forEach items="${doctores}" var="doctor">
                                            <option value="${doctor.id}" ${cita.doctor.id == doctor.id ? 'selected' : ''}>
                                                ${doctor.nombres} ${doctor.apellidos}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="estado" class="form-label required-field">Estado</label>
                                    <select class="form-select" id="estado" name="estado" required>
                                        <option value="PENDIENTE" ${cita.estado == 'PENDIENTE' ? 'selected' : ''}>Pendiente</option>
                                        <option value="CONFIRMADA" ${cita.estado == 'CONFIRMADA' ? 'selected' : ''}>Confirmada</option>
                                        <option value="CANCELADA" ${cita.estado == 'CANCELADA' ? 'selected' : ''}>Cancelada</option>
                                        <option value="COMPLETADA" ${cita.estado == 'COMPLETADA' ? 'selected' : ''}>Completada</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="fecha" class="form-label required-field">Fecha</label>
                                    <input type="date" class="form-control" id="fecha" name="fecha" 
                                           value="<fmt:formatDate value="${cita.fecha}" pattern="yyyy-MM-dd"/>" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="hora" class="form-label required-field">Hora</label>
                                    <select class="form-select" id="hora" name="hora" required>
                                        <option value="">Seleccione una hora</option>
                                        <c:forEach items="${horasDisponibles}" var="hora">
                                            <option value="${hora}" ${cita.hora == hora ? 'selected' : ''}>${hora}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/admin/citas" class="btn btn-secondary">
                                    <i class="bi bi-x-lg"></i> Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-lg"></i> Guardar Cambios
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('formEditarCita');
            const especialidadSelect = document.getElementById('especialidad');
            const doctorSelect = document.getElementById('doctor');
            const fechaInput = document.getElementById('fecha');
            const horaSelect = document.getElementById('hora');
            const estadoSelect = document.getElementById('estado');
            
            // Establecer fecha mínima como hoy
            const hoy = new Date().toISOString().split('T')[0];
            fechaInput.min = hoy;
            
            // Guardar el ID del doctor actual
            const doctorIdActual = '${cita.doctor.id}';
            console.log('ID del doctor actual:', doctorIdActual);
            
            // Función para cargar doctores por especialidad
            async function cargarDoctores(especialidadId) {
                try {
                    console.log('Cargando doctores para especialidad:', especialidadId);
                    doctorSelect.innerHTML = '<option value="">Seleccione un doctor</option>';
                    
                    if (!especialidadId) {
                        console.log('No hay especialidad seleccionada');
                        return;
                    }
                    
                    const url = '/citasMedicas_war_exploded/admin/citas/doctoresPorEspecialidad?especialidadId=' + especialidadId;
                    console.log('URL de la petición:', url);
                    
                    const response = await fetch(url, {
                        headers: {
                            'Accept': 'application/json'
                        }
                    });
                    
                    if (!response.ok) {
                        throw new Error('Error al cargar doctores: ' + response.status);
                    }
                    
                    const contentType = response.headers.get('content-type');
                    if (!contentType || !contentType.includes('application/json')) {
                        throw new Error('La respuesta no es JSON válido');
                    }
                    
                    const doctores = await response.json();
                    console.log('Doctores recibidos:', doctores);
                    
                    if (doctores && doctores.length > 0) {
                        doctores.forEach(doctor => {
                            const option = document.createElement('option');
                            option.value = doctor.id;
                            option.textContent = doctor.nombres + ' ' + doctor.apellidos;
                            if (doctor.id === parseInt(doctorIdActual)) {
                                option.selected = true;
                            }
                            doctorSelect.appendChild(option);
                        });
                    } else {
                        console.log('No se encontraron doctores para esta especialidad');
                        // Si no hay doctores en la lista pero tenemos un doctor actual, intentar cargarlo
                        if (doctorIdActual) {
                            const doctorResponse = await fetch('/citasMedicas_war_exploded/admin/doctor/buscar?id=' + doctorIdActual, {
                                headers: {
                                    'Accept': 'application/json'
                                }
                            });
                            
                            if (doctorResponse.ok) {
                                const contentType = doctorResponse.headers.get('content-type');
                                if (contentType && contentType.includes('application/json')) {
                                    const doctor = await doctorResponse.json();
                                    if (doctor) {
                                        const option = document.createElement('option');
                                        option.value = doctor.id;
                                        option.textContent = doctor.nombres + ' ' + doctor.apellidos;
                                        option.selected = true;
                                        doctorSelect.appendChild(option);
                                    }
                                }
                            }
                        }
                    }
                } catch (error) {
                    console.error('Error al cargar doctores:', error);
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'No se pudieron cargar los doctores: ' + error.message
                    });
                }
            }
            
            // Cargar doctores cuando cambie la especialidad
            especialidadSelect.addEventListener('change', function() {
                console.log('Cambio de especialidad detectado:', this.value);
                cargarDoctores(this.value);
            });
            
            // Cargar doctores inicialmente si hay una especialidad seleccionada
            if (especialidadSelect.value) {
                console.log('Cargando doctores iniciales para especialidad:', especialidadSelect.value);
                cargarDoctores(especialidadSelect.value);
            } else {
                console.log('No hay especialidad seleccionada inicialmente');
            }
            
            // Manejar el envío del formulario
            form.addEventListener('submit', async function(e) {
                e.preventDefault();
                
                if (!form.checkValidity()) {
                    e.stopPropagation();
                    form.classList.add('was-validated');
                    return;
                }
                
                try {
                    const formData = new URLSearchParams();
                    formData.append('accion', 'actualizar');
                    formData.append('id', form.querySelector('[name="id"]').value);
                    formData.append('paciente', form.querySelector('[name="paciente"]').value);
                    formData.append('especialidad', form.querySelector('[name="especialidad"]').value);
                    formData.append('doctor', form.querySelector('[name="doctor"]').value);
                    formData.append('fecha', form.querySelector('[name="fecha"]').value);
                    formData.append('hora', form.querySelector('[name="hora"]').value);
                    formData.append('estado', form.querySelector('[name="estado"]').value);
                    
                    console.log('Datos del formulario:');
                    for (let pair of formData.entries()) {
                        console.log(pair[0] + ': ' + pair[1]);
                    }
                    
                    const response = await fetch('/citasMedicas_war_exploded/admin/citas', {
                        method: 'POST',
                        body: formData,
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'Accept': 'application/json'
                        }
                    });
                    
                    // Si la respuesta es una redirección, seguirla
                    if (response.redirected) {
                        window.location.href = response.url;
                        return;
                    }
                    
                    const text = await response.text();
                    console.log('Respuesta del servidor:', text);
                    
                    let result;
                    try {
                        result = JSON.parse(text);
                        console.log('JSON parseado:', result);
                        
                        if (result.success) {
                            await Swal.fire({
                                icon: 'success',
                                title: 'Éxito',
                                text: result.message || 'Operación realizada correctamente',
                                showConfirmButton: false,
                                timer: 1500
                            });
                            
                            setTimeout(() => {
                                if (result.redirect) {
                                    window.location.href = result.redirect;
                                } else {
                                    window.location.href = '/citasMedicas_war_exploded/admin/citas';
                                }
                            }, 1500);
                        } else {
                            throw new Error(result.message || 'Error en la operación');
                        }
                    } catch (e) {
                        console.error('Error al parsear JSON:', e);
                        throw new Error('La respuesta del servidor no es JSON válido: ' + text);
                    }
                } catch (error) {
                    console.error('Error:', error);
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: error.message || 'Error en la operación'
                    });
                }
            });
        });
    </script>
</body>
</html> 