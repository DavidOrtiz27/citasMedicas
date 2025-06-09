<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Gestión de Doctores - Sistema de Citas Médicas</title>
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

        .page-header {
            background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            margin-top: 2rem;
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

        .doctor-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .doctor-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--accent-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
        }

        .doctor-details {
            display: flex;
            flex-direction: column;
        }

        .doctor-name {
            font-weight: 600;
            color: var(--primary-color);
        }

        .doctor-specialty {
            font-size: 0.875rem;
            color: var(--secondary-color);
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">

        <%@ include file="../../../includes/sitebarAdmin.jsp" %>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="page-header">
                <h1>Gestión de Doctores</h1>
                <p>Administra los doctores del sistema</p>
            </div>
            <!-- Barra de búsqueda y botón -->
            <div class="search-box mb-3">
                <form class="row g-3" method="get">
                    <div class="col-md-8">
                        <div class="input-group">
                            <input type="text" oninput="buscarfront()" class="form-control" id="searchInput" name="buscar"
                                   placeholder="Buscar por nombre, especialidad o DNI...">
                            <button class="btn btn-primary" type="button" id="searchButton" disabled>
                                <i class="bi bi-search"></i> Buscar
                            </button>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <button type="button" class="btn btn-success" data-bs-toggle="modal"
                                data-bs-target="#doctorModal">
                            <i class="bi bi-plus-lg"></i> Nuevo Doctor
                        </button>
                    </div>
                </form>
            </div>
            <!-- Tabla de doctores -->
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Doctor</th>
                                <th>Acciones</th>
                            </tr>
                            </thead>
                            <tbody id="doctoresTableBody">
                            <c:forEach items="${doctores}" var="doctor">
                                <tr>
                                    <td>
                                        <div class="doctor-info">
                                            <div class="doctor-avatar">
                                                <c:out value="${fn:substring(doctor.nombres,0,1)}${fn:substring(doctor.apellidos,0,1)}"/>
                                            </div>
                                            <div class="doctor-details">
                                                <span class="doctor-name">${doctor.nombres} ${doctor.apellidos}</span>
                                                <span class="doctor-specialty">ESPECIALIDAD: ${doctor.especialidad.nombre} | DESCRIPCION: ${doctor.especialidad.descripcion}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button type="button"
                                                    class="btn btn-sm btn-primary"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#doctorModal"
                                                    title="Actualizar doctor"
                                                    onclick="actualizardatos(${doctor.id})">
                                                <i class="bi bi-pencil"></i>

                                            </button>
                                            <button type="button"
                                                    class="btn btn-sm btn-danger"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#eliminarModal"
                                                    onclick=" cargarDatosModal(${doctor.id})"
                                                    title="Eliminar doctor">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>

                                        <div id="informacion${doctor.id}"
                                             data-nombres="${doctor.nombres}"
                                             data-apellidos="${doctor.apellidos}"
                                             data-dni="${doctor.dni}"
                                             data-email="${doctor.email}"
                                             data-telefono="${doctor.telefono}"
                                             data-especialidad="${doctor.especialidad.nombre}">
                                        </div>
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

<!-- Modal de Eliminación -->

<dialog class="modal fade" id="eliminarModal" tabindex="-1"
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
                        <h6 class="mb-0">Información del Doctor</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-2">
                                <label class="fw-bold">Nombre Completo:</label>
                                <p id="text-nombreD"></p>
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="fw-bold">DNI:</label>
                                <p id="text-dniD"></p>
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="fw-bold">Email:</label>
                                <p id="text-emailD"></p>
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="fw-bold">Teléfono:</label>
                                <p id="text-telefono"></p>
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="fw-bold">Especialidad:</label>
                                <p id="text-especialidad"></p>
                            </div>
                        </div>
                    </div>
                </div>

                <p class="text-center mb-0">
                    <i class="bi bi-question-circle me-2"></i>
                    ¿Está seguro que desea eliminar este doctor?
                </p>
            </div>
            <div class="modal-footer">
                <button type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal">
                    <i class="bi bi-x-circle me-1"></i>
                    Cancelar
                </button>
                <form action="${pageContext.request.contextPath}/admin/doctor/doctores/eliminar"
                      method="POST"
                      class="d-inline">
                    <input type="hidden" id="id_doctorEliminar" name="id" value="">
                    <button type="submit"
                            class="btn btn-danger">
                        <i class="bi bi-trash me-1"></i>
                        Eliminar Doctor
                    </button>
                </form>
            </div>
        </div>
    </div>
</dialog>

<!-- Doctor Modal -->
<div class="modal fade" id="doctorModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Nuevo Doctor</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="form-doctor" action="${pageContext.request.contextPath}/admin/doctor/doctores/agregar" method="POST"
                      class="needs-validation" novalidate>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="nombres" class="form-label required-field">Nombres</label>
                            <input type="text" class="form-control" id="nombres" name="nombres" required>
                            <div class="invalid-feedback">
                                Por favor ingrese los nombres.
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="apellidos" class="form-label required-field">Apellidos</label>
                            <input type="text" class="form-control" id="apellidos" name="apellidos" required>
                            <div class="invalid-feedback">
                                Por favor ingrese los apellidos.
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="dni" class="form-label required-field">CC</label>
                            <input type="text" class="form-control" id="dni" name="dni" required>
                            <div class="invalid-feedback">
                                Por favor ingrese el CC.
                            </div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="telefono" class="form-label required-field">Teléfono</label>
                            <input type="tel" class="form-control" id="telefono" name="telefono" required>
                            <div class="invalid-feedback">
                                Por favor ingrese el teléfono.
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label required-field">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                        <div class="invalid-feedback">
                            Por favor ingrese un email válido.
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="especialidad" class="form-label">Especialidad</label>
                        <select class="form-select" name="especialidad" required>
                            <option value="" disabled selected>Seleccione una especialidad</option>
                            <c:forEach items="${especialidades}" var="especialidad">
                                <option value="${especialidad.id}">${especialidad.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <input type="hidden" id="id_doctorActualizar" name="id" value="">
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" id="guardar" data-modo="agregar" class="btn btn-primary">Guardar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>

    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById("form-doctor");
        const botonGuardar = document.getElementById("guardar");

        // Escuchar el evento submit del formulario
        form.addEventListener("submit", function (e) {
            const modo = botonGuardar.dataset.modo;

            // Define la URL base
            let actionURL = "";

            // Define la URL dependiendo del modo
            if (modo === "agregar") {
                actionURL = `${pageContext.request.contextPath}/admin/doctor/doctores/agregar`;
            } else if (modo === "actualizar") {
                actionURL = `${pageContext.request.contextPath}/admin/doctor/doctores/actualizar`;
            }

            // Establece el action al formulario antes de enviarlo
            form.action = actionURL;
        });
    });




    // Búsqueda en la tabla (solo frontend)
    function buscarfront(){
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.getElementById('doctoresTableBody').getElementsByTagName('tr');
        for (let row of rows) {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm) ? '' : 'none';
        }
    }

    // cargar datos del modal de eliminación
    function cargarDatosModal(idD){

        const div = document.getElementById('informacion' + idD);

        const nombres = div.dataset.nombres;
        const apellidos = div.dataset.apellidos;
        const dni = div.dataset.dni;
        const email = div.dataset.email;
        const telefono = div.dataset.telefono;
        const especialidad = div.dataset.especialidad;

        const nombreC = nombres + " " + apellidos;

        document.getElementById('text-nombreD').innerHTML = nombreC;
        document.getElementById('text-dniD').innerHTML = dni;
        document.getElementById('text-emailD').innerHTML = email;
        document.getElementById('text-telefono').innerHTML = telefono;
        document.getElementById('text-especialidad').innerHTML = especialidad;
        document.getElementById('id_doctorEliminar').value = idD;

    }

    // insertar datos en el modal con el formulario

    function actualizardatos(id){

        const div = document.getElementById('informacion' + id);

        const nombres = div.dataset.nombres;
        const apellidos = div.dataset.apellidos;
        const dni = div.dataset.dni;
        const email = div.dataset.email;
        const telefono = div.dataset.telefono;
        const especialidad = div.dataset.especialidad;

        // cmabiar nombre del modal
        document.getElementById('modalTitle').innerHTML = "Editar Doctor";

        // cambiar el boton de guardar por actualizar
        const btn_guardar = document.getElementById('guardar');

        btn_guardar.innerHTML = "Actualizar";
        btn_guardar.dataset.modo = "actualizar";

        // insertar datos en el formulario
        document.getElementById('id_doctorActualizar').value = id;
        document.getElementById('nombres').value = nombres;
        document.getElementById('apellidos').value = apellidos;
        document.getElementById('dni').value = dni;
        document.getElementById('email').value = email;
        document.getElementById('telefono').value = telefono;
        document.getElementById('especialidad').value = especialidad;
    }

    document.addEventListener("DOMContentLoaded", function () {
        const modal = document.getElementById('doctorModal');
        const form = document.getElementById('form-doctor');
        const modalTitle = document.getElementById('modalTitle');
        const botonGuardar = document.getElementById('guardar');

        modal.addEventListener('hidden.bs.modal', function () {
            // Resetear formulario
            form.reset();

            // Restaurar valores predeterminados
            modalTitle.textContent = 'Nuevo Doctor';
            botonGuardar.textContent = 'Guardar';
            botonGuardar.dataset.modo = 'agregar';

            // Limpiar campo oculto de ID
            document.getElementById('id_doctorActualizar').value = '';
        });
    });

</script>
</body>
</html>
