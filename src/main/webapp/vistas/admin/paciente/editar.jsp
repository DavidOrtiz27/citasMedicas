<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : 'es'}" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="es">
<head>
    <title><fmt:message key="edit.title"/></title>
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
            <%@ include file="../../../includes/sitebarAdmin.jsp" %>

            <!-- Contenido principal -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <!-- Encabezado de página -->
                <div class="page-header">
                    <h1><fmt:message key="form.header"/></h1>
                    <p><fmt:message key="form.subtext"/></p>
                </div>

                <!-- Formulario -->
                <div class="card">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/paciente/pacientes/actualizar" method="POST" class="needs-validation" novalidate>
                            <input type="hidden" name="id" value="${paciente.id}">
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="nombres" class="form-label required-field"><fmt:message key="form.fields.names"/></label>
                                    <input type="text" class="form-control" id="nombres" name="nombres" value="${paciente.nombres}" required>
                                    <div class="invalid-feedback">
                                        <fmt:message key="form.fields.warnings.names"/>
                                    </div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="apellidos" class="form-label required-field"><fmt:message key="form.fields.lastname"/></label>
                                    <input type="text" class="form-control" id="apellidos" name="apellidos" value="${paciente.apellidos}" required>
                                    <div class="invalid-feedback">
                                        <fmt:message key="form.fields.warnings.lastname"/>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="dni" class="form-label required-field"><fmt:message key="form.fields.id"/></label>
                                    <input type="text" class="form-control" id="dni" name="dni" value="${paciente.dni}" required>
                                    <div class="invalid-feedback">
                                        <fmt:message key="form.fields.warnings.id"/>
                                    </div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="telefono" class="form-label required-field"><fmt:message key="form.fields.phone"/></label>
                                    <input type="tel" class="form-control" id="telefono" name="telefono" value="${paciente.telefono}" required>
                                    <div class="invalid-feedback">
                                        <fmt:message key="form.fields.warnings.phone"/>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label required-field"><fmt:message key="form.fields.email"/></label>
                                <input type="email" class="form-control" id="email" name="email" value="${paciente.email}" required>
                                <div class="invalid-feedback">
                                    <fmt:message key="form.fields.warnings.email"/>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/admin/paciente/pacientes" class="btn btn-secondary">
                                    <fmt:message key="form.fields.cancel"/>
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <fmt:message key="form.edit.fields.submit"/>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>