<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${empty sessionScope.currentUser || sessionScope.userRole != 'FACULTY'}">
    <c:redirect url="../login.jsp?error=Unauthorized+Faculty+Access"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Profile - College Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>

    <!-- Faculty Navbar -->
    <nav class="navbar navbar-expand-lg custom-navbar sticky-top">
        <div class="container">
            <a class="navbar-brand navbar-brand-custom" href="dashboard.jsp">
                <i class="fa-solid fa-graduation-cap"></i> EduFeedback <span class="badge bg-warning text-dark fs-6 ms-2">Faculty</span>
            </a>
            <div class="collapse navbar-collapse" id="facultyNav">
                <ul class="navbar-nav ms-auto align-items-center gap-2">
                    <li class="nav-item"><a class="nav-link" href="dashboard.jsp"><i class="fa-solid fa-house me-1"></i> Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link active" href="profile.jsp"><i class="fa-solid fa-user me-1"></i> Profile</a></li>
                    <li class="nav-item ms-lg-2">
                        <a href="../logout" class="btn btn-outline-danger btn-sm rounded-pill px-3"><i class="fa-solid fa-right-from-bracket me-1"></i> Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container py-5" style="max-width: 600px;">

        <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="card-header bg-warning text-dark p-4 text-center">
                <div class="stat-icon icon-faculty mx-auto mb-2 bg-white text-dark fs-3">
                    <i class="fa-solid fa-chalkboard-user"></i>
                </div>
                <h4 class="fw-bold mb-0">${sessionScope.currentUser.facultyName}</h4>
                <span class="badge bg-dark text-white mt-1">${sessionScope.currentUser.department}</span>
            </div>

            <div class="card-body p-4">
                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">FACULTY NAME</label>
                    <div class="form-control bg-light fw-bold">${sessionScope.currentUser.facultyName}</div>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">DEPARTMENT</label>
                    <div class="form-control bg-light">${sessionScope.currentUser.department}</div>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">ASSIGNED SUBJECT / COURSE</label>
                    <div class="form-control bg-light">${sessionScope.currentUser.subject}</div>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">EMAIL ADDRESS</label>
                    <div class="form-control bg-light">${sessionScope.currentUser.email}</div>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
