<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Gestión de Especialidades - Sistema de Citas Médicas</title>
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
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }

        .search-box .form-control {
            border-radius: 0.5rem 0 0 0.5rem;
        }

        .search-box .btn {
            border-radius: 0 0.5rem 0.5rem 0;
        }

        .specialty-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .patient-avatar {
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

        .specialty-icon {
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

        .specialty-details {
            display: flex;
            flex-direction: column;
        }

        .specialty-name {
            font-weight: 600;
            color: var(--primary-color);
        }

        .specialty-description {
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
                    <h1>Gestión de Especialidades</h1>
                    <p>Administra las especialidades médicas del sistema</p>
                </div>

                <!-- Barra de búsqueda -->
                <div class="search-box">
                    <form class="row g-3"  method="get">
                        <div class="col-md-8">
                            <div class="input-group">
                                <input type="text" oninput="buscarfront()" class="form-control" id="searchInput" name="buscar"
                                       placeholder="Buscar">
                                <button class="btn btn-primary" type="button" id="searchButton" disabled>
                                    <i class="bi bi-search"></i> Buscar
                                </button>
                            </div>
                        </div>
                        <div class="col-md-4 text-end">
                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#especialidadModal">
                                <i class="bi bi-plus-lg"></i> Nueva Especialidad
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Tabla de especialidades -->
                <div class="card">
                    
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Especialidad</th>
                                        <th>Descripción</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="especialidadTableBody">
                                    <c:forEach items="${especialidades}" var="especialidad">
                                        <tr>
                                            <td>
                                                <div class="specialty-info">
                                                    <div class="patient-avatar">
                                                        ${paciente.nombres.charAt(0)}}
                                                    </div>
                                                    <div class="specialty-details">
                                                        <span class="specialty-name">${especialidad.nombre}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${especialidad.descripcion}</td>
                                            <td>
                                                <div class="btn-group">
                                                    <button class="btn btn-sm btn-primary btn-action"
                                                            data-bs-toggle="modal" data-bs-target="#especialidadModal"
                                                            title="Editar especialidad"
                                                            onclick="editarEspecialidad('${especialidad.id}')">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-danger btn-action"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#confirmacionModal"
                                                            title="Eliminar especialidad"
                                                            onclick="eliminarEspecialidad('${especialidad.id}')">
                                                        <i class="bi bi-trash"></i>
                                                    </button>

                                                </div>
                                                <div id="informacion${especialidad.id}"
                                                     data-nombre="${especialidad.nombre}"
                                                     data-descripcion="${especialidad.descripcion}">
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

    <!-- Modal para crear/editar especialidad -->
    <div class="modal fade" id="especialidadModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="especialidadModalLabel">Nueva Especialidad</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="especialidadForm" action="${pageContext.request.contextPath}/admin/especialidad/especialidades/agregar" method="POST" class="needs-validation" novalidate>
                        <div class="mb-3">
                            <label for="nombre" class="form-label required-field">Nombre</label>
                            <input type="text" class="form-control" id="nombre" name="nombre" required>
                            <div class="invalid-feedback">
                                Por favor ingrese el nombre de la especialidad.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="descripcion" class="form-label required-field">Descripción</label>
                            <textarea class="form-control" id="descripcion" name="descripcion" rows="3" required></textarea>
                            <div class="invalid-feedback">
                                Por favor ingrese una descripción.
                            </div>
                        </div>
                        <input type="hidden" id="especialidadId" name="id" value="">
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
                            <h6 class="mb-0">Información de la especialidad</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-2">
                                    <label class="fw-bold">Nombre</label>
                                    <p id="nombreEliminar"></p>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <label class="fw-bold">Descripcion:</label>
                                    <p id="descripcionEliminar"></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <p class="text-center mb-0">
                        <i class="bi bi-question-circle me-2"></i>
                        ¿Está seguro que desea eliminar esta especialidad?
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">
                        <i class="bi bi-x-circle me-1"></i>
                        Cancelar
                    </button>
                    <form action="${pageContext.request.contextPath}/admin/especialidad/especialidades/eliminar"
                          method="POST"
                          class="d-inline">
                        <input type="hidden" id="id_especialidadEliminar" name="id" value="">
                        <button type="submit"
                                class="btn btn-danger">
                            <i class="bi bi-trash me-1"></i>
                            Eliminar Especialidad
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </dialog>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>

        document.addEventListener("DOMContentLoaded", function () {
            const form = document.getElementById("especialidadForm");
            const botonGuardar = document.getElementById("guardar");

            // Escuchar el evento submit del formulario
            form.addEventListener("submit", function (e) {
                const modo = botonGuardar.dataset.modo;

                // Define la URL base
                let actionURL = "";

                // Define la URL dependiendo del modo
                if (modo === "agregar") {
                    actionURL = `${pageContext.request.contextPath}/admin/especialidad/especialidades/agregar`;
                } else if (modo === "actualizar") {
                    actionURL = `${pageContext.request.contextPath}/admin/especialidad/especialidades/actualizar`;
                }

                // Establece el action al formulario antes de enviarlo
                form.action = actionURL;
            });
        });

        // Búsqueda en la tabla (solo frontend)
        function buscarfront(){
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.getElementById('especialidadTableBody').getElementsByTagName('tr');
            for (let row of rows) {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            }
        }


        // Función para editar especialidad
        function editarEspecialidad(id) {
                const div = document.getElementById('informacion' + id);

            const nombre = div.dataset.nombre;
            const descripcion = div.dataset.descripcion;

            document.getElementById('especialidadId').value = id;
            document.getElementById('nombre').value = nombre;
            document.getElementById('descripcion').value = descripcion;
            document.getElementById('especialidadModalLabel').innerHTML = 'Editar Especialidad';
            document.getElementById('guardar').dataset.modo = 'actualizar';
        }

        // Función para eliminar especialidad
        function eliminarEspecialidad(id) {
            const div = document.getElementById('informacion' + id);

            const nombre = div.dataset.nombre;
            const descripcion = div.dataset.descripcion;

            document.getElementById('nombreEliminar').innerHTML = nombre;
            document.getElementById('descripcionEliminar').innerHTML = descripcion;
            document.getElementById('id_especialidadEliminar').value = id;
        }


        document.addEventListener("DOMContentLoaded", function () {
            const modal = document.getElementById('especialidadModal');
            const form = document.getElementById('especialidadForm');
            const modalTitle = document.getElementById('especialidadModalLabel');
            const botonGuardar = document.getElementById('guardar');

            modal.addEventListener('hidden.bs.modal', function () {
                // Resetear formulario
                form.reset();

                // Restaurar valores predeterminados
                modalTitle.textContent = 'Nueva especialidad';
                botonGuardar.textContent = 'Guardar';
                botonGuardar.dataset.modo = 'agregar';

                // Limpiar campo oculto de ID
                document.getElementById('id_especialidadActualizar').value = '';
            });
        });
    </script>
</body>
</html>
