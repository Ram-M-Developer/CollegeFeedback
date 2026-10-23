<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${empty sessionScope.currentUser || sessionScope.userRole != 'STUDENT'}">
    <c:redirect url="/login.jsp?error=Unauthorized+Access"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Profile - College Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>

    <!-- Student Navbar -->
    <nav class="navbar navbar-expand-lg custom-navbar sticky-top">
        <div class="container">
            <a class="navbar-brand navbar-brand-custom" href="dashboard.jsp">
                <i class="fa-solid fa-graduation-cap"></i> EduFeedback
            </a>
            <div class="collapse navbar-collapse" id="studentNav">
                <ul class="navbar-nav ms-auto align-items-center gap-2">
                    <li class="nav-item"><a class="nav-link" href="dashboard.jsp"><i class="fa-solid fa-house me-1"></i> Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="../feedback"><i class="fa-solid fa-comment-dots me-1"></i> Give Feedback</a></li>
                    <li class="nav-item"><a class="nav-link active" href="action?action=viewProfile"><i class="fa-solid fa-user me-1"></i> Profile</a></li>
                    <li class="nav-item ms-lg-2">
                        <a href="../logout" class="btn btn-outline-danger btn-sm rounded-pill px-3"><i class="fa-solid fa-right-from-bracket me-1"></i> Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container py-5" style="max-width: 600px;">

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show mb-4 rounded-3" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show mb-4 rounded-3" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="card-header bg-primary text-white p-4 text-center">
                <div class="stat-icon icon-student mx-auto mb-2 bg-white text-primary fs-3">
                    <i class="fa-solid fa-user-graduate"></i>
                </div>
                <h4 class="fw-bold mb-0">${sessionScope.currentUser.studentName}</h4>
                <span class="badge bg-white text-primary mt-1">${sessionScope.currentUser.regNo}</span>
            </div>

            <div class="card-body p-4">
                <form action="action" method="post">
                    <input type="hidden" name="action" value="updateProfile">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Register Number</label>
                        <input type="text" class="form-control bg-light" value="${sessionScope.currentUser.regNo}" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email Address</label>
                        <input type="email" class="form-control bg-light" value="${sessionScope.currentUser.email}" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Full Name *</label>
                        <input type="text" class="form-control" name="name" value="${sessionScope.currentUser.studentName}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Department *</label>
                        <select class="form-select" name="department" required>
                            <option value="Computer Science" ${sessionScope.currentUser.department == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                            <option value="Electrical Engineering" ${sessionScope.currentUser.department == 'Electrical Engineering' ? 'selected' : ''}>Electrical Engineering</option>
                            <option value="Mechanical Engineering" ${sessionScope.currentUser.department == 'Mechanical Engineering' ? 'selected' : ''}>Mechanical Engineering</option>
                            <option value="Information Technology" ${sessionScope.currentUser.department == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">New Password (leave blank to keep current)</label>
                        <input type="password" class="form-control" name="password" placeholder="••••••••">
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2.5 fw-bold rounded-pill shadow-sm">
                        <i class="fa-solid fa-floppy-disk me-2"></i> Update Profile
                    </button>
                </form>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
