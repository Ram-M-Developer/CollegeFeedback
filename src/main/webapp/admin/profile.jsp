<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${empty sessionScope.currentUser || sessionScope.userRole != 'ADMIN'}">
    <c:redirect url="../login.jsp?error=Unauthorized+Admin+Access"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Settings - College Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>

    <!-- Admin Top Navbar -->
    <nav class="navbar navbar-expand-lg custom-navbar sticky-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand navbar-brand-custom" href="dashboard.jsp">
                <i class="fa-solid fa-graduation-cap"></i> EduFeedback <span class="badge bg-dark text-white fs-6 ms-2">Admin</span>
            </a>
            <div class="ms-auto d-flex align-items-center gap-3">
                <span class="text-muted small fw-semibold"><i class="fa-solid fa-user-shield me-1"></i> Admin (${sessionScope.currentUser.username})</span>
                <a href="../logout" class="btn btn-outline-danger btn-sm rounded-pill px-3"><i class="fa-solid fa-right-from-bracket me-1"></i> Logout</a>
            </div>
        </div>
    </nav>

    <div class="admin-wrapper">

        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-title">Core Navigation</div>
            <ul class="sidebar-menu">
                <li><a href="dashboard.jsp"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
                <li><a href="students.jsp"><i class="fa-solid fa-user-graduate"></i> Manage Students</a></li>
                <li><a href="faculty.jsp"><i class="fa-solid fa-chalkboard-user"></i> Manage Faculty</a></li>
                <li><a href="feedback.jsp"><i class="fa-solid fa-comments"></i> Feedback Log</a></li>
                <li><a href="reports.jsp"><i class="fa-solid fa-file-invoice"></i> Reports & Analysis</a></li>
                <li class="sidebar-title mt-3">Settings</li>
                <li><a href="profile.jsp" class="active"><i class="fa-solid fa-gear"></i> Admin Settings</a></li>
                <li><a href="../logout" class="text-danger"><i class="fa-solid fa-power-off"></i> Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="admin-main-content">

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("successMessage"); %>
            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i> ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            </c:if>

            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                        <div class="card-header bg-dark text-white p-4 text-center">
                            <div class="stat-icon icon-admin mx-auto mb-2 bg-white text-dark fs-3">
                                <i class="fa-solid fa-user-shield"></i>
                            </div>
                            <h4 class="fw-bold mb-0">System Administrator Profile</h4>
                            <span class="badge bg-primary mt-1">Superuser Access</span>
                        </div>

                        <div class="card-body p-4">
                            <form action="action" method="post">
                                <input type="hidden" name="action" value="updateAdminPassword">

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Admin Username</label>
                                    <input type="text" class="form-control bg-light" value="${sessionScope.currentUser.username}" readonly>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Admin Email</label>
                                    <input type="email" class="form-control bg-light" value="${sessionScope.currentUser.email}" readonly>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-semibold">New Password *</label>
                                    <input type="password" class="form-control" name="newPassword" placeholder="Enter new admin password" required>
                                </div>

                                <button type="submit" class="btn btn-dark w-100 py-2.5 fw-bold rounded-pill shadow-sm">
                                    <i class="fa-solid fa-key me-2"></i> Update Security Credentials
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
