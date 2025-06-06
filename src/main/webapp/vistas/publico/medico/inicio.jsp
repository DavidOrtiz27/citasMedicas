<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <title><fmt:message key="doctorLogin.title"/></title>
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
        }
        .sidebar .nav-link {
            color: var(--light-color);
            padding: 0.8rem 1rem;
            margin: 0.2rem 0;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: var(--accent-color);
            color: white;
        }
        .sidebar .nav-link i {
            margin-right: 0.5rem;
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
        .card-summary {
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.07);
            border: none;
            transition: transform 0.3s;
        }
        .card-summary:hover {
            transform: translateY(-5px);
        }
        .card-summary .card-body {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }
        .icon-circle {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
        }
        .icon-citas { background: var(--accent-color); }
        .icon-pacientes { background: var(--success-color); }
        .icon-horarios { background: var(--warning-color); }
        .icon-perfil { background: var(--secondary-color); }
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
                    <p class="text-light opacity-75">Panel Médico</p>
                </div>
                <ul class="nav flex-column px-3">
                    <li class="nav-item">
                        <a class="nav-link active" href="#"><i class="bi bi-house"></i> Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/medico/citas"><i class="bi bi-calendar-check"></i> Mis Citas</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/medico/horarios"><i class="bi bi-clock"></i> Horarios</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/medico/perfil"><i class="bi bi-person"></i> Perfil</a>
                    </li>
                </ul>
            </div>
        </nav>
        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="page-header">
                <h1>Bienvenido, Doctor</h1>
                <p>Este es tu panel principal. Aquí puedes ver un resumen de tus actividades y acceder rápidamente a tus funciones principales.</p>
            </div>
            <div class="row g-4 mb-4">
                <div class="col-md-6 col-xl-3">
                    <div class="card card-summary">
                        <div class="card-body">
                            <div class="icon-circle icon-citas"><i class="bi bi-calendar-check"></i></div>
                            <div>
                                <h5 class="mb-0">Próximas Citas</h5>
                                <span class="text-muted">4 hoy</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="card card-summary">
                        <div class="card-body">
                            <div class="icon-circle icon-pacientes"><i class="bi bi-people"></i></div>
                            <div>
                                <h5 class="mb-0">Pacientes del Día</h5>
                                <span class="text-muted">3 atendidos</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="card card-summary">
                        <div class="card-body">
                            <div class="icon-circle icon-horarios"><i class="bi bi-clock"></i></div>
                            <div>
                                <h5 class="mb-0">Horarios</h5>
                                <span class="text-muted">Ver y editar</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="card card-summary">
                        <div class="card-body">
                            <div class="icon-circle icon-perfil"><i class="bi bi-person"></i></div>
                            <div>
                                <h5 class="mb-0">Mi Perfil</h5>
                                <span class="text-muted">Actualizar datos</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Aquí puedes agregar más contenido, como tablas de próximas citas, mensajes, etc. -->
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
