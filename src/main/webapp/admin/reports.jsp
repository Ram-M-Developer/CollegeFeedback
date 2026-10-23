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
    <title>Reports & Analysis - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>

    <!-- Admin Top Navbar -->
    <nav class="navbar navbar-expand-lg custom-navbar sticky-top no-print">
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
        <aside class="sidebar no-print">
            <div class="sidebar-title">Core Navigation</div>
            <ul class="sidebar-menu">
                <li><a href="dashboard.jsp"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
                <li><a href="students.jsp"><i class="fa-solid fa-user-graduate"></i> Manage Students</a></li>
                <li><a href="faculty.jsp"><i class="fa-solid fa-chalkboard-user"></i> Manage Faculty</a></li>
                <li><a href="feedback.jsp"><i class="fa-solid fa-comments"></i> Feedback Log</a></li>
                <li><a href="reports.jsp" class="active"><i class="fa-solid fa-file-invoice"></i> Reports & Analysis</a></li>
                <li class="sidebar-title mt-3">Settings</li>
                <li><a href="profile.jsp"><i class="fa-solid fa-gear"></i> Admin Settings</a></li>
                <li><a href="../logout" class="text-danger"><i class="fa-solid fa-power-off"></i> Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="admin-main-content">

            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h3 class="fw-bold mb-0">Institutional Feedback Report</h3>
                    <p class="text-muted small">Comprehensive academic evaluation & institutional feedback summary</p>
                </div>
                <div class="no-print">
                    <button onclick="window.print()" class="btn btn-primary rounded-pill px-4 fw-bold">
                        <i class="fa-solid fa-print me-2"></i> Print / Export Report
                    </button>
                </div>
            </div>

            <!-- Report Header Summary -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-4 bg-primary text-white rounded-4">
                    <div class="row align-items-center text-center text-md-start">
                        <div class="col-md-8">
                            <h4 class="fw-bold mb-1"><i class="fa-solid fa-building-columns me-2"></i> Overall Academic Feedback Summary</h4>
                            <p class="mb-0 text-white-50">Aggregated feedback submissions across all departments and academic faculty</p>
                        </div>
                        <div class="col-md-4 text-center mt-3 mt-md-0">
                            <div class="fs-1 fw-bold">${analysis.totalFeedbacks}</div>
                            <div class="small text-white-50 text-uppercase fw-semibold">Total Submissions Recorded</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Faculty Wise Performance Table -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-header bg-white py-3 px-4 border-0">
                    <h5 class="fw-bold mb-0"><i class="fa-solid fa-user-check text-primary me-2"></i> Faculty Feedback Submissions Matrix</h5>
                </div>
                <div class="custom-table">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Faculty Name</th>
                                <th>Total Feedbacks Received</th>
                                <th>Engagement Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="entry" items="${analysis.facultyFeedbackCounts}">
                                <tr>
                                    <td class="fw-bold text-dark">${entry.key}</td>
                                    <td>
                                        <span class="badge bg-primary-subtle text-primary fs-6 px-3 py-1 fw-bold">${entry.value} Reviews</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${entry.value > 0}">
                                                <span class="badge bg-success-subtle text-success px-3 py-1 fw-bold">Active Submissions</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-muted px-3 py-1 fw-bold">No Submissions Yet</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Department Wise Matrix -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-header bg-white py-3 px-4 border-0">
                    <h5 class="fw-bold mb-0"><i class="fa-solid fa-building-columns text-success me-2"></i> Department Feedback Distribution</h5>
                </div>
                <div class="custom-table">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Department Name</th>
                                <th>Total Submissions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="dEntry" items="${analysis.departmentFeedbackCounts}">
                                <tr>
                                    <td class="fw-bold text-dark">${dEntry.key}</td>
                                    <td>
                                        <span class="fw-bold text-success fs-6">${dEntry.value} Submissions</span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
