<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.collegefeedback.dao.FeedbackDAO" %>
<%@ page import="com.collegefeedback.model.FeedbackAnalysis" %>
<c:if test="${empty sessionScope.currentUser || sessionScope.userRole != 'ADMIN'}">
    <c:redirect url="../login.jsp?error=Unauthorized+Admin+Access"/>
</c:if>

<%
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    FeedbackAnalysis analysis = feedbackDAO.getFeedbackAnalysis();
    request.setAttribute("analysis", analysis);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - College Feedback System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../css/style.css">
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                <li><a href="dashboard.jsp" class="active"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
                <li><a href="students.jsp"><i class="fa-solid fa-user-graduate"></i> Manage Students</a></li>
                <li><a href="faculty.jsp"><i class="fa-solid fa-chalkboard-user"></i> Manage Faculty</a></li>
                <li><a href="feedback.jsp"><i class="fa-solid fa-comments"></i> Feedback Log</a></li>
                <li><a href="reports.jsp"><i class="fa-solid fa-file-invoice"></i> Reports & Analysis</a></li>
                <li class="sidebar-title mt-3">Settings</li>
                <li><a href="profile.jsp"><i class="fa-solid fa-gear"></i> Admin Settings</a></li>
                <li><a href="../logout" class="text-danger"><i class="fa-solid fa-power-off"></i> Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="admin-main-content">

            <%-- Session Alerts --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("successMessage"); %>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-0">System Executive Dashboard</h3>
                    <p class="text-muted small">Real-time feedback metrics & submission analytics</p>
                </div>
                <a href="reports.jsp" class="btn btn-primary rounded-pill px-4 fw-semibold"><i class="fa-solid fa-print me-2"></i> Generate Full Report</a>
            </div>

            <!-- Dashboard KPI Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon icon-student">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <div>
                            <div class="stat-val text-primary">${analysis.totalStudents}</div>
                            <div class="stat-label">Total Registered Students</div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon icon-faculty">
                            <i class="fa-solid fa-user-tie"></i>
                        </div>
                        <div>
                            <div class="stat-val text-warning">${analysis.totalFaculty}</div>
                            <div class="stat-label">Total Active Faculty</div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon icon-admin">
                            <i class="fa-solid fa-comment-dots"></i>
                        </div>
                        <div>
                            <div class="stat-val text-purple" style="color: #7e22ce;">${analysis.totalFeedbacks}</div>
                            <div class="stat-label">Total Feedbacks Collected</div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-success-subtle text-success">
                            <i class="fa-solid fa-building-columns"></i>
                        </div>
                        <div>
                            <div class="stat-val text-success">${analysis.totalDepartments}</div>
                            <div class="stat-label">Academic Departments</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Charts Grid -->
            <div class="row g-4">

                <!-- 1. Department Feedback Share Chart -->
                <div class="col-lg-5">
                    <div class="chart-card h-100">
                        <div class="chart-header">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-chart-pie text-primary me-2"></i> Department Feedback Share</h5>
                            <span class="badge bg-light text-muted border">Submissions</span>
                        </div>
                        <div style="max-height: 290px;" class="d-flex justify-content-center">
                            <canvas id="departmentPerformanceChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- 2. Faculty Feedback Volume Bar Chart -->
                <div class="col-lg-7">
                    <div class="chart-card h-100">
                        <div class="chart-header">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-chart-column text-primary me-2"></i> Faculty Feedback Volume</h5>
                            <span class="badge bg-light text-muted border">Total Submissions Received</span>
                        </div>
                        <div>
                            <canvas id="facultyPerformanceChart" height="150"></canvas>
                        </div>
                    </div>
                </div>

                <!-- 3. Subject Feedback Breakdown Chart -->
                <div class="col-lg-12">
                    <div class="chart-card">
                        <div class="chart-header">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-book text-purple me-2" style="color:#8b5cf6;"></i> Subject Feedback Breakdown</h5>
                            <span class="badge bg-light text-muted border">Submissions Per Subject</span>
                        </div>
                        <div>
                            <canvas id="subjectPerformanceChart" height="100"></canvas>
                        </div>
                    </div>
                </div>

            </div>

        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/script.js"></script>
</body>
</html>
