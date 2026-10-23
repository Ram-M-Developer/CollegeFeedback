<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - College Feedback System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100 py-4">

    <div class="container" style="max-width: 480px;">
        <div class="text-center mb-4">
            <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand navbar-brand-custom justify-content-center mb-2 fs-3">
                <i class="fa-solid fa-graduation-cap"></i> EduFeedback
            </a>
            <p class="text-muted small">Sign in to access your portal</p>
        </div>

        <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="card-header bg-white border-0 pt-4 px-4 pb-0">

                <%-- Session Notifications --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                        <i class="fa-solid fa-lock me-2"></i> ${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty param.info}">
                    <div class="alert alert-info alert-dismissible fade show mb-3" role="alert">
                        <i class="fa-solid fa-circle-info me-2"></i> ${param.info}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <%-- Role Selector Tabs --%>
                <c:set var="reqRole" value="${not empty selectedRole ? selectedRole : (not empty param.role ? param.role : 'STUDENT')}" />
                <ul class="nav nav-pills nav-fill bg-light p-1 rounded-3 mb-3" id="roleTabs">
                    <li class="nav-item">
                        <button class="nav-link ${reqRole == 'STUDENT' ? 'active' : ''}" type="button" onclick="setRole('STUDENT')">
                            <i class="fa-solid fa-user-graduate me-1"></i> Student
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link ${reqRole == 'FACULTY' ? 'active' : ''}" type="button" onclick="setRole('FACULTY')">
                            <i class="fa-solid fa-chalkboard-user me-1"></i> Faculty
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link ${reqRole == 'ADMIN' ? 'active' : ''}" type="button" onclick="setRole('ADMIN')">
                            <i class="fa-solid fa-user-shield me-1"></i> Admin
                        </button>
                    </li>
                </ul>
            </div>

            <div class="card-body p-4 pt-2">
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input type="hidden" name="role" id="roleInput" value="${reqRole}">

                    <div class="mb-3">
                        <label for="emailOrUsername" class="form-label fw-semibold" id="identifierLabel">
                            ${reqRole == 'ADMIN' ? 'Username or Email' : 'Email Address'}
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="fa-solid fa-envelope text-muted"></i></span>
                            <input type="text" class="form-control" id="emailOrUsername" name="emailOrUsername" 
                                   value="${emailOrUsername}" placeholder="Enter your credentials" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label fw-semibold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="fa-solid fa-key text-muted"></i></span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="••••••••" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2.5 fw-bold rounded-pill shadow-sm">
                        <i class="fa-solid fa-right-to-bracket me-2"></i> Log In
                    </button>
                </form>
            </div>

            <div class="card-footer bg-light text-center py-3 border-0">
                <span class="text-muted small">Don't have a student account?</span>
                <a href="${pageContext.request.contextPath}/register.jsp" class="fw-semibold text-primary ms-1 small">Register Here</a>
                <div class="mt-2 text-start bg-white p-2.5 rounded border">
                    <p class="small text-muted mb-1 fw-bold"><i class="fa-solid fa-lightbulb text-warning me-1"></i> Demo Credentials:</p>
                    <p class="small text-muted mb-0"><strong>Student:</strong> student@gmail.com / student123</p>
                    <p class="small text-muted mb-0"><strong>Faculty:</strong> robert.smith@college.edu / faculty123</p>
                    <p class="small text-muted mb-0"><strong>Admin:</strong> admin / admin123</p>
                </div>
            </div>
        </div>

        <div class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-muted small"><i class="fa-solid fa-arrow-left me-1"></i> Back to Home</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function setRole(role) {
            document.getElementById('roleInput').value = role;
            const buttons = document.querySelectorAll('#roleTabs button');
            buttons.forEach(btn => btn.classList.remove('active'));

            if (role === 'STUDENT') buttons[0].classList.add('active');
            if (role === 'FACULTY') buttons[1].classList.add('active');
            if (role === 'ADMIN') buttons[2].classList.add('active');

            const label = document.getElementById('identifierLabel');
            if (role === 'ADMIN') {
                label.textContent = 'Username or Email';
            } else {
                label.textContent = 'Email Address';
            }
        }
    </script>
</body>
</html>
