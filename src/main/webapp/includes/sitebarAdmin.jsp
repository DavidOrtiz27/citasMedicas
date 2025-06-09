<%@ page pageEncoding="UTF-8" %>


<nav class="col-md-3 col-lg-2 d-md-block sidebar">
    <div class="position-sticky">
        <div class="text-center py-4">
            <h4 class="text-white">Sistema de Citas</h4>
            <p class="text-light opacity-75">Panel de Administración</p>
        </div>

        <ul class="nav flex-column px-3">
            <li class="nav-item">
                <a class="nav-link" id="sidebarInicio" href="${pageContext.request.contextPath}/admin/inicio">
                    <i class="bi bi-house"></i>
                    Inicio
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="sidebarPacientes" href="${pageContext.request.contextPath}/admin/paciente/pacientes">
                    <i class="bi bi-people"></i>
                    Pacientes
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="sidebarDoctores" href="${pageContext.request.contextPath}/admin/doctor/doctores">
                    <i class="bi bi-person-badge"></i>
                    Doctores
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="sidebarCitas" href="${pageContext.request.contextPath}/admin/citas/citas">
                    <i class="bi bi-calendar-check"></i>
                    Citas
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="sidebarEspecialidades" href="${pageContext.request.contextPath}/admin/especialidad/especialidades">
                    <i class="bi bi-list-check"></i>
                    Especialidades
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="sidebarHorarios" href="${pageContext.request.contextPath}/admin/horario/horarios">
                    <i class="bi bi-clock"></i>
                    Horarios
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-box-arrow-right"></i>
                    Cerrar Sesión
                </a>
            </li>
        </ul>
    </div>
</nav>


<script>
    document.addEventListener('DOMContentLoaded', function () {
        const links = document.querySelectorAll('.sidebar .nav-link');
        const currentPath = window.location.pathname;

        links.forEach(link => {
            const href = link.getAttribute('href');
            if (!href) return;

            // Create an anchor element to parse the href properly
            const tempAnchor = document.createElement('a');
            tempAnchor.href = href;
            const linkPath = tempAnchor.pathname;

            // Match startsWith for base path matching
            if (currentPath.startsWith(linkPath)) {
                link.classList.add('active');
            }
        });
    });
</script>
