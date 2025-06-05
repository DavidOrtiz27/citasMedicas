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

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-avatar {
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

        .user-details {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-weight: 600;
            color: var(--primary-color);
        }

        .user-role {
            font-size: 0.875rem;
            color: var(--secondary-color);
        }

        .role-badge {
            background: var(--accent-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/pacientes">
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/citas">
                                <i class="bi bi-calendar-check"></i>
                                Citas
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/especialidades">
                                <i class="bi bi-list-check"></i>
                                Especialidades
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/horarios">
                                <i class="bi bi-clock"></i>
                                Horarios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/usuarios">
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
                    <h1>Gestión de Usuarios</h1>
                    <p>Administra los usuarios del sistema</p>
                </div>

                <!-- Barra de búsqueda -->
                <div class="search-box">
                    <form class="row g-3" action="${pageContext.request.contextPath}/admin/usuario/usuarios" method="get">
                        <div class="col-md-8">
                            <div class="input-group">
                                <input type="text" class="form-control" name="buscar" placeholder="Buscar por nombre, email o rol...">
                                <button class="btn btn-primary" type="submit">
                                    <i class="bi bi-search"></i> Buscar
                                </button>
                            </div>
                        </div>
                        <div class="col-md-4 text-end">
                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#usuarioModal">
                                <i class="bi bi-plus-lg"></i> Nuevo Usuario
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Tabla de usuarios -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Usuario</th>
                                        <th>Email</th>
                                        <th>Rol</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${usuarios}" var="usuario">
                                        <tr>
                                            <td>
                                                <div class="user-info">
                                                    <div class="user-avatar">
                                                        ${usuario.nombre.charAt(0)}${usuario.apellido.charAt(0)}
                                                    </div>
                                                    <div class="user-details">
                                                        <span class="user-name">${usuario.nombre} ${usuario.apellido}</span>
                                                        <span class="user-role">${usuario.rol}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${usuario.email}</td>
                                            <td>
                                                <span class="role-badge">
                                                    ${usuario.rol}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-${usuario.activo ? 'success' : 'danger'}">
                                                    ${usuario.activo ? 'Activo' : 'Inactivo'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="btn-group">
                                                    <button class="btn btn-sm btn-primary btn-action" onclick="editarUsuario('${usuario.id}')">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-danger btn-action" onclick="eliminarUsuario('${usuario.id}')">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-warning btn-action" onclick="cambiarEstadoUsuario('${usuario.id}', ${!usuario.activo})">
                                                        <i class="bi bi-${usuario.activo ? 'person-x' : 'person-check'}"></i>
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

    <!-- Modal para crear/editar usuario -->
    <div class="modal fade" id="usuarioModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="usuarioModalLabel">Nuevo Usuario</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="usuarioForm" class="needs-validation" novalidate>
                        <input type="hidden" id="usuarioId">
                        
                        <div class="mb-3">
                            <label for="nombre" class="form-label required-field">Nombre</label>
                            <input type="text" class="form-control" id="nombre" required>
                            <div class="invalid-feedback">
                                Por favor ingrese el nombre.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="apellido" class="form-label required-field">Apellido</label>
                            <input type="text" class="form-control" id="apellido" required>
                            <div class="invalid-feedback">
                                Por favor ingrese el apellido.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="email" class="form-label required-field">Email</label>
                            <input type="email" class="form-control" id="email" required>
                            <div class="invalid-feedback">
                                Por favor ingrese un email válido.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="password" class="form-label required-field">Contraseña</label>
                            <input type="password" class="form-control" id="password" required>
                            <div class="invalid-feedback">
                                Por favor ingrese una contraseña.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="rol" class="form-label required-field">Rol</label>
                            <select class="form-select" id="rol" required>
                                <option value="">Seleccione un rol</option>
                                <option value="ADMIN">Administrador</option>
                                <option value="DOCTOR">Doctor</option>
                                <option value="PACIENTE">Paciente</option>
                            </select>
                            <div class="invalid-feedback">
                                Por favor seleccione un rol.
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" onclick="guardarUsuario()">Guardar</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para editar usuario
        function editarUsuario(id) {
            fetch('${pageContext.request.contextPath}/admin/usuarios/' + id)
                .then(response => response.json())
                .then(usuario => {
                    document.getElementById('usuarioId').value = usuario.id;
                    document.getElementById('nombre').value = usuario.nombre;
                    document.getElementById('apellido').value = usuario.apellido;
                    document.getElementById('email').value = usuario.email;
                    document.getElementById('rol').value = usuario.rol;
                    document.getElementById('password').required = false;
                    
                    document.getElementById('usuarioModalLabel').textContent = 'Editar Usuario';
                    new bootstrap.Modal(document.getElementById('usuarioModal')).show();
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error al cargar los datos del usuario');
                });
        }

        // Función para eliminar usuario
        function eliminarUsuario(id) {
            if (confirm('¿Está seguro de eliminar este usuario?')) {
                fetch('${pageContext.request.contextPath}/admin/usuarios/' + id, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        throw new Error('Error al eliminar el usuario');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error al eliminar el usuario');
                });
            }
        }

        // Función para cambiar estado del usuario
        function cambiarEstadoUsuario(id, nuevoEstado) {
            if (confirm(`¿Está seguro de ${nuevoEstado ? 'activar' : 'desactivar'} este usuario?`)) {
                fetch('${pageContext.request.contextPath}/admin/usuarios/' + id + '/estado', {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ activo: nuevoEstado })
                })
                .then(response => {
                    if (response.ok) {
                        window.location.reload();
                    } else {
                        throw new Error('Error al cambiar el estado del usuario');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error al cambiar el estado del usuario');
                });
            }
        }

        // Función para guardar usuario
        function guardarUsuario() {
            const form = document.getElementById('usuarioForm');
            if (!form.checkValidity()) {
                form.classList.add('was-validated');
                return;
            }

            const usuarioData = {
                id: document.getElementById('usuarioId').value,
                nombre: document.getElementById('nombre').value,
                apellido: document.getElementById('apellido').value,
                email: document.getElementById('email').value,
                password: document.getElementById('password').value,
                rol: document.getElementById('rol').value,
                activo: true
            };

            const method = usuarioData.id ? 'PUT' : 'POST';
            const url = '${pageContext.request.contextPath}/admin/usuarios' + (usuarioData.id ? '/' + usuarioData.id : '');

            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(usuarioData)
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    throw new Error('Error al guardar el usuario');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error al guardar el usuario');
            });
        }
    </script>
</body>
</html> 