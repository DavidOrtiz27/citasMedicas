<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Login - Sistema de Citas Médicas</title>
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
            min-height: 100vh;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            width: 100%;
            max-width: 450px;
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 1rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            padding: 40px;
            transition: transform 0.3s ease;
        }

        .login-container:hover {
            transform: translateY(-5px);
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header i {
            font-size: 3rem;
            color: var(--accent-color);
            margin-bottom: 15px;
        }

        .login-header h2 {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 5px;
        }

        .login-header p {
            color: var(--secondary-color);
            font-size: 0.9rem;
        }

        .form-floating {
            margin-bottom: 20px;
        }

        .form-floating > .form-control {
            padding: 1rem 0.75rem;
            border-radius: 0.5rem;
        }

        .form-floating > label {
            padding: 1rem 0.75rem;
        }

        .form-control:focus {
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
            border-color: var(--accent-color);
        }

        .captcha-container {
            background-color: var(--light-color);
            border-radius: 0.5rem;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
        }

        .captcha-image {
            border-radius: 0.5rem;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .captcha-image:hover {
            transform: scale(1.02);
        }

        .btn-login {
            background: linear-gradient(135deg, var(--accent-color) 0%, var(--primary-color) 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
            letter-spacing: 0.5px;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);
        }

        .alert {
            border-radius: 0.5rem;
            border: none;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .alert-danger {
            background-color: var(--danger-color);
            color: white;
        }

        .alert i {
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <i class="bi bi-hospital"></i>
            <h2>Sistema de Citas Médicas</h2>
            <p>Ingrese sus credenciales para continuar</p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-floating">
                <input type="text" class="form-control" id="username" name="username" placeholder="Usuario" required>
                <label for="username"><i class="bi bi-person me-2"></i>Usuario</label>
            </div>
            
            <div class="form-floating">
                <input type="password" class="form-control" id="password" name="password" placeholder="Contraseña" required>
                <label for="password"><i class="bi bi-lock me-2"></i>Contraseña</label>
            </div>
            
            <div class="captcha-container">
                <img src="${pageContext.request.contextPath}/captcha" 
                     class="captcha-image mb-3" 
                     alt="CAPTCHA"
                     onclick="this.src='${pageContext.request.contextPath}/captcha?' + Math.random()">
                <div class="form-floating">
                    <input type="text" class="form-control" id="captcha" name="captcha" placeholder="Código CAPTCHA" required>
                    <label for="captcha"><i class="bi bi-shield-lock me-2"></i>Código CAPTCHA</label>
                </div>
                <small class="text-muted">Haga clic en la imagen para actualizar el código</small>
            </div>
            
            <button type="submit" class="btn btn-primary btn-login w-100">
                <i class="bi bi-box-arrow-in-right me-2"></i>Iniciar Sesión
            </button>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
