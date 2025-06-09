<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : 'es'}" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="patients.title"/></title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #34495e;
            --accent-color: #3498db;
            --danger-color: #e74c3c;
        }

        body {
            background-color: #f8f9fa;
        }

        .sidebar {
            background: var(--primary-color);
            min-height: 100vh;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        }

        .sidebar .nav-link {
            color: white;
            padding: 0.8rem 1rem;
            margin: 0.2rem 0;
            border-radius: 0.5rem;
        }

        .sidebar .nav-link:hover {
            background: var(--secondary-color);
            color: white;
        }

        .sidebar .nav-link.active {
            background: var(--accent-color);
            color: white;
        }

        .page-header {
            background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .table thead {
            background: var(--primary-color);
            color: white;
        }

        .btn-action {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
        }

        .search-box {
            background: white;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
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
                        <h4 class="text-white"><fmt:message key="sidebar.header"/></h4>
                        <p class="text-light opacity-75"><fmt:message key="sidebar.subtext"/></p>
                    </div>
                    
                    <ul class="nav flex-column px-3">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/inicio">
                                <i class="bi bi-house"></i>
                                <fmt:message key="sidebar.home"/>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/paciente/pacientes">
                                <i class="bi bi-people"></i>
                                <fmt:message key="sidebar.patients"/>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/doctor/doctores">
                                <i class="bi bi-person-badge"></i>
                                <fmt:message key="sidebar.doctors"/>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/citas/citas">
                                <i class="bi bi-calendar-check"></i>
                                <fmt:message key="sidebar.appointments"/>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/especialidad/especialidades">
                                <i class="bi bi-list-check"></i>
                                <fmt:message key="sidebar.specialties"/>
                               
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/horario/horarios">
                                <i class="bi bi-clock"></i>
                                <fmt:message key="sidebar.schedules"/>
                                
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/usuario/usuarios">
                                <i class="bi bi-people-fill"></i>
                                <fmt:message key="sidebar.appointments"/>
                                
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Contenido principal -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <!-- Encabezado -->
                <div class="page-header">
                    <h1><fmt:message key="patients.header"/></h1>
                    <p><fmt:message key="patients.subtext"/></p>
                </div>

                <!-- Mensajes de alerta -->
                <c:if test="${not empty mensaje}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle"></i> ${mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Barra de búsqueda -->
                <div class="search-box">
                    <form action="${pageContext.request.contextPath}/admin/paciente/pacientes" method="GET" class="d-flex">
                        <input type="text" name="buscar" class="form-control" placeholder="Buscar pacientes..." value="${param.buscar}">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search"></i>
                        </button>
                    </form>
                </div>

                <!-- Botón Nuevo Paciente -->
                <div class="mb-4">
                    <a href="${pageContext.request.contextPath}/admin/paciente/pacientes/nuevo" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> <fmt:message key="patients.newPatient.button"/>
                    </a>
                </div>

                <!-- Tabla de Pacientes -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th><fmt:message key="form.fields.id"/></th>
                                        <th><fmt:message key="form.fields.names"/></th>
                                        <th><fmt:message key="form.fields.lastname"/></th>
                                        <th><fmt:message key="form.fields.email"/></th>
                                        <th><fmt:message key="form.fields.phone"/></th>
                                        <th><fmt:message key="form.fields.actions"/></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="paciente" items="${pacientes}">
                                        <tr>
                                            <td>${paciente.id}</td>
                                            <td>${paciente.dni}</td>
                                            <td>${paciente.nombres}</td>
                                            <td>${paciente.apellidos}</td>
                                            <td>${paciente.email}</td>
                                            <td>${paciente.telefono}</td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/admin/paciente/pacientes/editar?id=${paciente.id}" 
                                                       class="btn btn-sm btn-primary" 
                                                       title="Editar paciente">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-sm btn-danger" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#eliminarModal${paciente.id}"
                                                            title="Eliminar paciente">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>

                                                <!-- Modal de Eliminación -->
                                                <div class="modal fade" 
                                                     id="eliminarModal${paciente.id}" 
                                                     tabindex="-1" 
                                                     aria-labelledby="eliminarModalLabel${paciente.id}" 
                                                     aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content">
                                                            <div class="modal-header bg-danger text-white">
                                                                <h5 class="modal-title" id="eliminarModalLabel${paciente.id}">
                                                                    <i class="bi bi-exclamation-triangle me-2"></i>
                                                                    <fmt:message key="form.fields.id"/><fmt:message key="btn.confirm.deletion"/>
                                                                </h5>
                                                                <button type="button" 
                                                                        class="btn-close btn-close-white" 
                                                                        data-bs-dismiss="modal" 
                                                                        aria-label="Cerrar"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="alert alert-danger mb-3">
                                                                    <i class="bi bi-exclamation-circle me-2"></i>
                                                                    <fmt:message key="btn.confirm.deletion"/>
                                                                </div>
                                                                
                                                                <div class="card mb-3">
                                                                    <div class="card-header bg-light">
                                                                        <h6 class="mb-0"><fmt:message key="patient.fullinfo"/></h6>
                                                                    </div>
                                                                    <div class="card-body">
                                                                        <div class="row">
                                                                            <div class="col-md-6 mb-2">
                                                                                <label class="fw-bold"><fmt:message key="patient.fullname"/>:</label>
                                                                                <p>${paciente.nombres} ${paciente.apellidos}</p>
                                                                            </div>
                                                                            <div class="col-md-6 mb-2">
                                                                                <label class="fw-bold"><fmt:message key="form.fields.id"/>:</label>
                                                                                <p>${paciente.dni}</p>
                                                                            </div>
                                                                            <div class="col-md-6 mb-2">
                                                                                <label class="fw-bold"><fmt:message key="form.fields.email"/>:</label>
                                                                                <p>${paciente.email}</p>
                                                                            </div>
                                                                            <div class="col-md-6 mb-2">
                                                                                <label class="fw-bold"><fmt:message key="form.fields.phone"/>:</label>
                                                                                <p>${paciente.telefono}</p>
                                                                            </div>
                                                                            <c:if test="${not empty paciente.direccion}">
                                                                                <div class="col-12 mb-2">
                                                                                    <label class="fw-bold"><fmt:message key="patient.address"/>:</label>
                                                                                    <p>${paciente.direccion}</p>
                                                                                </div>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                
                                                                <p class="text-center mb-0">
                                                                    <i class="bi bi-question-circle me-2"></i>
                                                                    <fmt:message key="patients.delete.warningtwo"/>
                                                                </p>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" 
                                                                        class="btn btn-secondary" 
                                                                        data-bs-dismiss="modal">
                                                                    <i class="bi bi-x-circle me-1"></i>
                                                                    <fmt:message key="form.fields.cancel"/>
                                                                </button>
                                                                <form action="${pageContext.request.contextPath}/admin/paciente/pacientes/eliminar" 
                                                                      method="POST" 
                                                                      class="d-inline">
                                                                    <input type="hidden" name="id" value="${paciente.id}">
                                                                    <button type="submit" 
                                                                            class="btn btn-danger">
                                                                        <i class="bi bi-trash me-1"></i>
                                                                        <fmt:message key="btn.confirm.deletion"/>
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
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

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
            eliminarPaciente(id);
        }
    });
}

function eliminarPaciente(id) {
    fetch('${pageContext.request.contextPath}/admin/paciente/eliminar/' + id, {
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
            text: 'Ocurrió un error al eliminar el paciente',
            icon: 'error'
        });
    });
}
</script>
</body>
</html>