<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${param.lang != null ? param.lang : 'es'}" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="login.title"/></title>
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
            background: linear-gradient(135deg, #2c3e50, #3498db);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            background: white;
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-header h1 {
            color: #2c3e50;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .login-header p {
            color: #7f8c8d;
            margin: 0;
        }

        .form-control {
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
        }

        .btn-login {
            background: #3498db;
            border: none;
            border-radius: 0.5rem;
            padding: 0.75rem;
            width: 100%;
            color: white;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-login:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }

        .alert {
            border-radius: 0.5rem;
            margin-bottom: 1rem;
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
            <h2><fmt:message key="login.systemName" /></h2>
            <p><fmt:message key="login.instructions" /></p>
        </div>
        
        

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-floating">
                <input type="text" class="form-control" id="username" name="username" placeholder="<fmt:message key='login.username' />" required>
                <label for="username"><i class="bi bi-person me-2"></i><fmt:message key="login.username" /></label>
            </div>
            
            <div class="form-floating">
                <input type="password" class="form-control" id="password" name="password" placeholder="<fmt:message key='login.password' />" required>
                <label for="password"><i class="bi bi-lock me-2"></i><fmt:message key="login.password" /></label>
            </div>
            <div class="captcha-container">
                <img src="${pageContext.request.contextPath}/captcha" 
                     class="captcha-image mb-3" 
                     alt="CAPTCHA"
                     onclick="this.src='${pageContext.request.contextPath}/captcha?' + Math.random()">
                <div class="form-floating">
                    <input type="text" class="form-control" id="captcha" name="captcha" placeholder="<fmt:message key='login.captcha.label' />" required>
                    <label for="captcha"><i class="bi bi-shield-lock me-2"></i><fmt:message key="login.captcha.label" /></label>
                </div>
                <small class="text-muted"><fmt:message key="login.captcha.refreshHint" /></small>
            </div>
            
            <button type="submit" class="btn btn-primary btn-login w-100">
                <i class="bi bi-box-arrow-in-right me-2"></i><fmt:message key="login.button" />
            </button>
        </form>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
