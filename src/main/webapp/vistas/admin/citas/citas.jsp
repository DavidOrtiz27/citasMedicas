<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Citas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
        }

        .sidebar {
            background: #2c3e50;
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            z-index: 100;
            padding-top: 20px;
        }

        .sidebar .nav-link {
            color: #ecf0f1;
            padding: 0.8rem 1rem;
            margin: 0.2rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .sidebar .nav-link:hover {
            background: #34495e;
            color: white;
            transform: translateX(5px);
        }

        .sidebar .nav-link.active {
            background: #3498db;
            color: white;
        }

        .sidebar .nav-link i {
            margin-right: 0.5rem;
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
        }

        .card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.1);
        }

        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
        }

        .btn-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .btn-secondary {
            background-color: #95a5a6;
            border-color: #95a5a6;
        }

        .btn-secondary:hover {
            background-color: #7f8c8d;
            border-color: #7f8c8d;
        }

        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
        }

        .estado-badge {
            padding: 0.5em 1em;
            border-radius: 0.5rem;
            font-weight: 500;
        }

        .estado-pendiente {
            background-color: #ffeeba;
            color: #856404;
        }

        .estado-confirmada {
            background-color: #d4edda;
            color: #155724;
        }

        .estado-cancelada {
            background-color: #f8d7da;
            color: #721c24;
        }

        .estado-completada {
            background-color: #cce5ff;
            color: #004085;
        }

        .dt-buttons {
            margin-bottom: 1rem;
        }

        .dt-button {
            background-color: #3498db !important;
            color: white !important;
            border: none !important;
            padding: 0.5rem 1rem !important;
            border-radius: 0.5rem !important;
            margin-right: 0.5rem !important;
        }

        .dt-button:hover {
            background-color: #2980b9 !important;
        }
    </style>
</head>
<body>
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/citas/citas">
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
        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Gestión de Citas</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
                <a href="${pageContext.request.contextPath}/admin/citas/crear" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> Nueva Cita
                </a>
            </div>
        </div>

        <!-- Mensajes de alerta -->
        <c:if test="${not empty mensaje}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Tabla de citas -->
        <div class="card">
            <div class="card-body">
                <table id="tablaCitas" class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
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
                                <td>${cita.id}</td>
                                <td><fmt:formatDate value="${cita.fecha}" pattern="dd/MM/yyyy"/></td>
                                <td>${cita.hora}</td>
                                <td>${fn:escapeXml(cita.paciente.nombres)} ${fn:escapeXml(cita.paciente.apellidos)}</td>
                                <td>${fn:escapeXml(cita.doctor.nombres)} ${fn:escapeXml(cita.doctor.apellidos)}</td>
                                <td>${not empty cita.doctor.especialidad ? fn:escapeXml(cita.doctor.especialidad.nombre) : 'No asignada'}</td>
                                <td>
                                    <span class="estado-badge estado-${cita.estado.toLowerCase()}">
                                        ${cita.estado}
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <a href="${pageContext.request.contextPath}/admin/citas/editar/${cita.id}" 
                                           class="btn btn-sm btn-primary" title="Editar">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/citas/comprobante/${cita.id}" 
                                           class="btn btn-sm btn-info" title="Comprobante">
                                            <i class="bi bi-file-earmark-text"></i>
                                        </a>
                                        <c:if test="${cita.estado != 'CANCELADA'}">
                                            <button type="button" class="btn btn-sm btn-warning" 
                                                    onclick="mostrarModalCancelar('${cita.id}')" title="Cancelar">
                                                <i class="bi bi-x-circle"></i>
                                            </button>
                                        </c:if>
                                        <button type="button" class="btn btn-sm btn-danger" 
                                                onclick="eliminarCita('${cita.id}')" title="Eliminar">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Modal de Cancelación -->
    <div class="modal fade" id="modalCancelar" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Cancelar Cita</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/citas/citas" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="accion" value="cancelar">
                        <input type="hidden" name="id" id="citaIdCancelar">
                        <div class="mb-3">
                            <label for="motivo" class="form-label">Motivo de cancelación</label>
                            <textarea class="form-control" id="motivo" name="motivo" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <button type="submit" class="btn btn-warning">Confirmar Cancelación</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/es.js"></script>

    <script>
        $(document).ready(function() {
            $('#tablaCitas').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
                },
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'excel',
                        text: '<i class="bi bi-file-earmark-excel"></i> Excel',
                        className: 'btn btn-success',
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6]
                        }
                    },
                    {
                        extend: 'pdf',
                        text: '<i class="bi bi-file-earmark-pdf"></i> PDF',
                        className: 'btn btn-danger',
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6]
                        }
                    }
                ],
                order: [[1, 'desc'], [2, 'asc']],
                pageLength: 10,
                responsive: true,
                processing: true,
                serverSide: false
            });
        });

        function mostrarModalCancelar(id) {
            $('#citaIdCancelar').val(id);
            $('#modalCancelar').modal('show');
        }

        // Función para eliminar cita
        async function eliminarCita(id) {
            try {
                const result = await Swal.fire({
                    title: '¿Estás seguro?',
                    text: "Esta acción no se puede deshacer",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Sí, eliminar',
                    cancelButtonText: 'Cancelar'
                });

                if (result.isConfirmed) {
                    const formData = new URLSearchParams();
                    formData.append('accion', 'eliminar');
                    formData.append('id', id);

                    const response = await fetch('${pageContext.request.contextPath}/admin/citas/citas', {
                        method: 'POST',
                        body: formData,
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    });

                    // Si la respuesta es una redirección, seguirla
                    if (response.redirected) {
                        window.location.href = response.url;
                        return;
                    }

                    const text = await response.text();
                    let result;
                    try {
                        result = JSON.parse(text);
                        if (result.success) {
                            await Swal.fire({
                                icon: 'success',
                                title: 'Éxito',
                                text: result.message || 'Cita eliminada correctamente',
                                showConfirmButton: false,
                                timer: 1500
                            });
                            window.location.reload();
                        } else {
                            throw new Error(result.message || 'Error al eliminar la cita');
                        }
                    } catch (e) {
                        throw new Error('Error al procesar la respuesta del servidor');
                    }
                }
            } catch (error) {
                console.error('Error:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: error.message || 'Error al eliminar la cita'
                });
            }
        }
    </script>
</body>
</html>
