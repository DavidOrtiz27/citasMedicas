<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : 'es'}" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="es">
<head>
    <title><fmt:message key="index.title"/></title>
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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .navbar {
            background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 600;
            color: white !important;
        }

        .navbar-brand i {
            margin-right: 0.5rem;
        }

        .nav-link {
            color: rgba(255,255,255,0.9) !important;
            font-weight: 500;
            padding: 0.5rem 1rem !important;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .nav-link:hover {
            color: white !important;
            background: rgba(255,255,255,0.1);
            transform: translateY(-2px);
        }

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), 
                        url('https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            color: white;
            padding: 150px 0;
            margin-bottom: 80px;
            position: relative;
        }

        .hero-section::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 100px;
            background: linear-gradient(to top, #f8f9fa, transparent);
        }

        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .hero-section p {
            font-size: 1.25rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .btn-hero {
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 0.5rem;
            transition: all 0.3s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-hero:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        .feature-section {
            padding: 80px 0;
            background-color: #f8f9fa;
        }

        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-title h2 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .section-title p {
            font-size: 1.1rem;
            color: var(--secondary-color);
            max-width: 600px;
            margin: 0 auto;
        }

        .feature-card {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s;
            height: 100%;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .icon-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(45deg, var(--primary-color), var(--accent-color));
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            transition: all 0.3s;
        }

        .feature-card:hover .icon-circle {
            transform: scale(1.1);
        }

        .icon-circle i {
            font-size: 2rem;
            color: white;
        }

        .feature-card h5 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .feature-card p {
            color: var(--secondary-color);
            margin-bottom: 0;
            line-height: 1.6;
        }

        footer {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 60px 0 30px;
        }

        footer h5 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: white;
        }

        footer p {
            opacity: 0.8;
            line-height: 1.8;
        }

        footer i {
            margin-right: 0.5rem;
            color: var(--accent-color);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.1);
            margin-top: 40px;
            padding-top: 20px;
            text-align: center;
        }

        .footer-bottom p {
            margin-bottom: 0;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <!-- Barra de navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-hospital"></i> <fmt:message key="index.systemName" />
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/vistas/publico/consultaCitas.jsp">
                            <i class="bi bi-search"></i> <fmt:message key="index.query" />
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/vistas/publico/solicitarCita.jsp">
                            <i class="bi bi-calendar-plus"></i> <fmt:message key="index.make" />
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/vistas/login.jsp">
                            <i class="bi bi-box-arrow-in-right"></i> <fmt:message key="index.login" />
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Sección Hero -->
    <section class="hero-section text-center">
        <div class="container">
            <h1> <fmt:message key="index.header" /></h1>
            <p class="lead"> <fmt:message key="index.lead " /></p>
            <div class="d-flex justify-content-center gap-4">
                <a href="${pageContext.request.contextPath}/vistas/publico/solicitarCita.jsp" 
                   class="btn btn-primary btn-hero">
                    <i class="bi bi-calendar-plus"></i> <fmt:message key="index.make" />
                </a>
                <a href="${pageContext.request.contextPath}/vistas/publico/consultaCitas.jsp" 
                   class="btn btn-outline-light btn-hero">
                    <i class="bi bi-search"></i> <fmt:message key="index.query" />
                </a>
            </div>
        </div>
    </section>

    <!-- Sección de Características -->
    <section class="feature-section">
        <div class="container">
            <div class="section-title">
                <h2><fmt:message key="index.services.header" /> </h2>
                <p><fmt:message key="index.services.paragraph" /></p>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="icon-circle">
                            <i class="bi bi-person-badge"></i>
                        </div>
                        <h5><fmt:message key="index.services.cardone" /></h5>
                        <p><fmt:message key="index.services.cardparagraph" /></p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="icon-circle">
                            <i class="bi bi-clock"></i>
                        </div>
                        <h5><fmt:message key="index.services.cardtwo" /></h5>
                        <p><fmt:message key="index.services.cardtwoparagraph" /></p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="icon-circle">
                            <i class="bi bi-calendar-check"></i>
                        </div>
                        <h5><fmt:message key="index.services.cardthree" /></h5>
                        <p><fmt:message key="index.services.cardthreeparagraph" /></p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Pie de página -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Contacto</h5>
                    <p>
                        <i class="bi bi-telephone"></i> <fmt:message key="index.footer.phone" /><br>
                        <i class="bi bi-envelope"></i> <fmt:message key="index.footer.email" /> <br>
                        <i class="bi bi-geo-alt"></i> <fmt:message key="index.footer.address" />
                    </p>
                </div>
                <div class="col-md-6 text-md-end">
                    <h5>Horario de Atención</h5>
                    <p>
                        <i class="bi bi-clock"></i> <fmt:message key="index.footer.schedule" /><br>
                        <i class="bi bi-clock"></i> <fmt:message key="index.footer.scheduleweekend" /><br>
                        <i class="bi bi-x-circle"></i> <fmt:message key="index.footer.shcedulesunday" />
                    </p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; <fmt:message key="index.footer.copyright" /> </p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
