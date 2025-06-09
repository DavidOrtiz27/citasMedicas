<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : 'es'}" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="es">
<head>
    <title><fmt:message key="users.title"/></title>
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

        .card:hover {
            transform: translateY(-5px);
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

        .btn-action {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .btn-action:hover {
            transform: translateY(-2px);
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-weight: 500;
        }

        .status-active {
            background-color: var(--success-color);
            color: white;
        }

        .status-inactive {
            background-color: var(--danger-color);
            color: white;
        }

        .table {
            border-radius: 1rem;
            overflow: hidden;
        }

        .table thead th {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 1rem;
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background-color: rgba(52, 152, 219, 0.1);
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/citas/citas">
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/usuario/usuarios">
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
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1>Usuarios</h1>
                            <p>Gestión de usuarios del sistema</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/usuario/nuevo" class="btn btn-primary btn-action">
                            <i class="bi bi-plus-lg"></i> Nuevo Usuario
                        </a>
                    </div>
                </div>

                <!-- Tabla de usuarios -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Usuario</th>
                                        <th>Rol</th>
                                        <th>Estado</th>
                                        <th>Último Acceso</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${usuarios}" var="usuario">
                                        <tr>
                                            <td>${usuario.id}</td>
                                            <td>${usuario.username}</td>
                                            <td>${usuario.rol}</td>
                                            <td>
                                                <span class="status-badge ${usuario.activo ? 'status-active' : 'status-inactive'}">
                                                    ${usuario.activo ? 'Activo' : 'Inactivo'}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty usuario.ultimoAcceso}">
                                                        <fmt:formatDate value="${usuario.ultimoAcceso}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        Nunca
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/admin/usuario/${usuario.id}" 
                                                       class="btn btn-sm btn-info btn-action" 
                                                       title="Ver detalles">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/admin/usuario/editar/${usuario.id}" 
                                                       class="btn btn-sm btn-warning btn-action" 
                                                       title="Editar">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-sm btn-danger btn-action" 
                                                            title="Eliminar"
                                                            onclick="confirmarEliminacion(${usuario.id})">
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
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
    <script>
        function confirmarEliminacion(id) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: "Esta acción no se puede deshacer",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    eliminarUsuario(id);
                }
            });
        }

        function eliminarUsuario(id) {
            fetch('${pageContext.request.contextPath}/admin/usuario/eliminar/' + id, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        title: '¡Eliminado!',
                        text: data.message,
                        icon: 'success'
                    }).then(() => {
                        window.location.reload();
                    });
                } else {
                    Swal.fire({
                        title: 'Error',
                        text: data.message,
                        icon: 'error'
                    });
                }
            })
            .catch(error => {
                Swal.fire({
                    title: 'Error',
                    text: 'Ocurrió un error al eliminar el usuario',
                    icon: 'error'
                });
            });
        }
    </script>
</body>
</html> 