<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : 'es'}" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="es">
<head>
    <title><fmt:message key="schedules.title"/></title>
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
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
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
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .table {
            border-radius: 0.5rem;
            overflow: hidden;
        }

        .table thead {
            background: var(--primary-color);
            color: white;
        }

        .btn-action {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .btn-action:hover {
            transform: translateY(-2px);
        }

        .modal-content {
            border-radius: 1rem;
            border: none;
        }

        .modal-header {
            background: var(--primary-color);
            color: white;
            border-radius: 1rem 1rem 0 0;
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

        .search-box {
            background: white;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }

        .search-box .form-control {
            border-radius: 0.5rem 0 0 0.5rem;
        }

        .search-box .btn {
            border-radius: 0 0.5rem 0.5rem 0;
        }

        .schedule-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .schedule-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--accent-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .schedule-details {
            display: flex;
            flex-direction: column;
        }

        .schedule-day {
            font-weight: 600;
            color: var(--primary-color);
        }

        .schedule-time {
            font-size: 0.875rem;
            color: var(--secondary-color);
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
        <%@ include file="../../../includes/sitebarAdmin.jsp" %>

        <!-- Contenido principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
            <!-- Encabezado de página -->
            <div class="page-header">
                <h1>Gestión de Horarios</h1>
                <p>Administra los horarios de atención de los médicos</p>
            </div>

            <!-- Barra de búsqueda -->
            <div class="search-box">
                <form class="row g-3" method="get">
                    <div class="col-md-8">
                        <div class="input-group">
                            <input type="text" oninput="buscarfront()" class="form-control" id="searchInput"
                                   name="buscar"
                                   placeholder="Buscar">
                            <button class="btn btn-primary" type="button" id="searchButton" disabled>
                                <i class="bi bi-search"></i> Buscar
                            </button>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <button type="button"
                                class="btn btn-success"
                                data-bs-toggle="modal"
                                data-bs-target="#horarioModal"
                        >
                            <i class="bi bi-plus-lg"></i> Nuevo Horario
                        </button>
                    </div>
                </form>
            </div>

            <nav class="navbar navbar-expand-lg navbar-light bg-light rounded mb-3">
                <div class="container-fluid">
                    <div class="navbar-nav mx-auto">
                        <button class="btn btn-outline-primary mx-1" onclick="buscarpordia('')">TODOS</button>
                        <button class="btn btn-outline-primary mx-1" onclick="buscarpordia('lunes')">Lunes</button>
                        <button class="btn btn-outline-primary mx-1" onclick="buscarpordia('martes')">Martes</button>
                        <button class="btn btn-outline-primary mx-1" onclick="buscarpordia('miercoles')">Miércoles</button>
                        <button class="btn btn-outline-primary mx-1" onclick="buscarpordia('jueves')">Jueves</button>
                        <button class="btn btn-outline-primary mx-1" onclick="buscarpordia('viernes')">Viernes</button>
                        <button class="btn btn-outline-primary mx-1" onclick="buscarpordia('sabado')">Sabado</button>
                    </div>
                </div>
            </nav>

            <!-- Tabla de horarios -->
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Médico</th>
                                <th>Día</th>
                                <th>Horario</th>
                                <th>Acciones</th>
                            </tr>
                            </thead>
                            <tbody id="horariosTableBody">
                            <c:forEach items="${horarios}" var="horario">
                                <tr>
                                    <td>
                                        <div class="schedule-info">
                                            <div class="schedule-icon">
                                                <i class="bi bi-person-badge"></i>
                                            </div>
                                            <div class="schedule-details">
                                                <span class="schedule-day">Dr. ${horario.nombreDoctor} ${horario.apellidoDoctor}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${horario.diaSemana}</td>
                                    <td>${horario.horaInicio} - ${horario.horaFin}</td>
                                    <td>
                                        <div class="btn-group">
                                            <button class="btn btn-sm btn-primary btn-action"
                                                    data-bs-toggle="modal" data-bs-target="#horarioModal"
                                                    title="Editar horario"
                                                    onclick="editarHorario('${horario.id}')">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger btn-action"
                                                    data-bs-toggle="modal" data-bs-target="#confirmacionModal"
                                                    title="Editar horario"
                                                    onclick="eliminarHorario('${horario.id}')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                        <div id="informacion${horario.id}"
                                             data-idDoctor="${horario.doctorId}"
                                             data-doctorNombre="${horario.nombreDoctor}"
                                             data-doctorApellido="${horario.apellidoDoctor}"
                                             data-diaSemana="${horario.diaSemana}"
                                             data-horaInicio="${horario.horaInicio}"
                                             data-horaFin="${horario.horaFin}"
                                        ></div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal para crear/editar horario -->
<div class="modal fade" id="horarioModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="horarioModalLabel">Nuevo Horario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="horarioForm" action="${pageContext.request.contextPath}/admin/horario/horarios/agregar" method="post" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label for="doctorId" class="form-label required-field">Doctor</label>
                        <select class="form-select" id="doctorId" name="doctorId" required>
                            <option value="">Seleccione un doctor</option>
                            <c:forEach items="${doctores}" var="doctor">
                                <option value="${doctor.id}">${doctor.nombres} ${doctor.apellidos}  || ${doctor.especialidad.nombre}</option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">
                            Por favor seleccione un doctor.
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="diaSemana" class="form-label required-field">Día de la Semana</label>
                        <select class="form-select" id="diaSemana" name="diaSemana" required>
                            <option value="">Seleccione un día</option>
                            <option value="Lunes">Lunes</option>
                            <option value="Martes">Martes</option>
                            <option value="Miercoles">Miércoles</option>
                            <option value="Jueves">Jueves</option>
                            <option value="Viernes">Viernes</option>
                            <option value="Sabado">Sábado</option>
                        </select>
                        <div class="invalid-feedback">
                            Por favor seleccione un día.
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="horaInicio" class="form-label required-field">Hora de Inicio</label>
                        <input type="time" class="form-control" id="horaInicio" name="horaInicio" required>
                        <div class="invalid-feedback">
                            Por favor ingrese la hora de inicio.
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="horaFin" class="form-label required-field">Hora de Fin</label>
                        <input type="time" class="form-control" id="horaFin" name="horaFin" required>
                        <div class="invalid-feedback">
                            Por favor ingrese la hora de fin.
                        </div>
                    </div>
                    <input type="hidden" id="horarioId" name="id" value="">
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary" data-modo="agregar" id="guardar">Guardar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal de Eliminación -->

<dialog class="modal fade" id="confirmacionModal" tabindex="-1"
        aria-labelledby="eliminarModalLabel"
        aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="eliminarModalLabel">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Confirmar Eliminación
                </h5>
                <button type="button"
                        class="btn-close btn-close-white"
                        data-bs-dismiss="modal"
                        aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger mb-3">
                    <i class="bi bi-exclamation-circle me-2"></i>
                    Esta acción no se puede deshacer.
                </div>

                <div class="card mb-3">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">Información del horario</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-2">
                                <label class="fw-bold">Nombre doctor</label>
                                <p id="nombreDoctorEliminar"></p>
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="fw-bold">Día de la semana</label>
                                <p id="diaSemanaEliminar"></p>
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="fw-bold">Hora de inicio</label>
                                <p id="horaInicioEliminar"></p>
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="fw-bold">Hora de fin</label>
                                <p id="horaFinEliminar"></p>
                            </div>
                        </div>
                    </div>
                </div>

                <p class="text-center mb-0">
                    <i class="bi bi-question-circle me-2"></i>
                    ¿Está seguro que desea eliminar este horario?
                </p>
            </div>
            <div class="modal-footer">
                <button type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal">
                    <i class="bi bi-x-circle me-1"></i>
                    Cancelar
                </button>
                <form action="${pageContext.request.contextPath}/admin/horario/horarios/eliminar"
                      method="POST"
                      class="d-inline">
                    <input type="hidden" id="id_horarioEliminar" name="id" value="">
                    <button type="submit"
                            class="btn btn-danger">
                        <i class="bi bi-trash me-1"></i>
                        Eliminar Horario
                    </button>
                </form>
            </div>
        </div>
    </div>
</dialog>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>

    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("horarioForm");
        const botonGuardar = document.getElementById("guardar");

        // Escuchar el evento submit del formulario
        form.addEventListener("submit", function (e) {
            const modo = botonGuardar.dataset.modo;

            // Define la URL base
            let actionURL = "";

            // Define la URL dependiendo del modo
            if (modo === "agregar") {
                actionURL = `${pageContext.request.contextPath}/admin/horario/horarios/agregar`;
            } else if (modo === "actualizar") {
                actionURL = `${pageContext.request.contextPath}/admin/horario/horarios/actualizar`;
            }

            // Establece el action al formulario antes de enviarlo
            form.action = actionURL;
        });
    });


    // Función para editar horario
    function editarHorario(id) {
        console.log(id);
        const div = document.getElementById('informacion' + id);


        const doctorId = div.dataset.iddoctor;
        const diaSemana = div.dataset.diasemana;
        const horaInicio = div.dataset.horainicio;
        const horaFin = div.dataset.horafin;


        console.log({
            doctorId,
            diaSemana,
            horaInicio,
            horaFin
        });


        document.getElementById('doctorId').value = doctorId;
        document.getElementById('horarioId').value = id;
        document.getElementById('diaSemana').value = diaSemana;
        document.getElementById('horaInicio').value = horaInicio;
        document.getElementById('horaFin').value = horaFin;


        document.getElementById('horarioModalLabel').innerHTML = 'Editar Horario';
        document.getElementById('guardar').dataset.modo = 'actualizar';

    }

    // Función para eliminar horario
    function eliminarHorario(id) {
        const div = document.getElementById('informacion' + id);

        const doctorNombre = div.dataset.doctornombre;
        const doctorApellido = div.dataset.doctorapellido;
        const diaSemana = div.dataset.diasemana;
        const horaInicio = div.dataset.horainicio;
        const horaFin = div.dataset.horafin;

        document.getElementById('id_horarioEliminar').value = id;
        document.getElementById('nombreDoctorEliminar').innerHTML = `${doctorNombre} ${doctorApellido}`;
        document.getElementById('diaSemanaEliminar').innerHTML = diaSemana;
        document.getElementById('horaInicioEliminar').innerHTML = horaInicio;
        document.getElementById('horaFinEliminar').innerHTML = horaFin;

    }

    document.addEventListener("DOMContentLoaded", function () {
        const modal = document.getElementById('horarioModal');
        const form = document.getElementById('horarioForm');
        const modalTitle = document.getElementById('horarioModalLabel');
        const botonGuardar = document.getElementById('guardar');

        modal.addEventListener('hidden.bs.modal', function () {
            // Resetear formulario
            form.reset();

            // Restaurar valores predeterminados
            modalTitle.textContent = 'Nueva horario';
            botonGuardar.textContent = 'Guardar';
            botonGuardar.dataset.modo = 'agregar';

            // Limpiar campo oculto de ID
            document.getElementById('id_horarioActualizar').value = '';
        });
    });

    // Búsqueda en la tabla (solo frontend)
    function buscarfront() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.getElementById('horariosTableBody').getElementsByTagName('tr');
        for (let row of rows) {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm) ? '' : 'none';
        }
    }

    function buscarpordia(dia) {
        const rows = document.getElementById('horariosTableBody').getElementsByTagName('tr');
        for (let row of rows) {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(dia) ? '' : 'none';
        }
    }

</script>
</body>
</html> 