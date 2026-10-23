<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.collegefeedback.dao.FeedbackDAO" %>
<%@ page import="com.collegefeedback.model.Faculty" %>
<%@ page import="com.collegefeedback.model.Feedback" %>
<%@ page import="java.util.List" %>
<c:if test="${empty sessionScope.currentUser || sessionScope.userRole != 'FACULTY'}">
    <c:redirect url="../login.jsp?error=Unauthorized+Faculty+Access"/>
</c:if>

<%
    Faculty faculty = (Faculty) session.getAttribute("currentUser");
    if (faculty != null) {
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        double avgRating = feedbackDAO.getFacultyAverageRating(faculty.getFacultyId());
        List<Feedback> feedbackList = feedbackDAO.getFeedbacksByFaculty(faculty.getFacultyId());
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("feedbackList", feedbackList);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Portal - College Feedback</title>
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
                    <li class="nav-item"><a class="nav-link active" href="dashboard.jsp"><i class="fa-solid fa-house me-1"></i> Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="profile.jsp"><i class="fa-solid fa-user me-1"></i> Profile</a></li>
                    <li class="nav-item ms-lg-2">
                        <a href="../logout" class="btn btn-outline-danger btn-sm rounded-pill px-3"><i class="fa-solid fa-right-from-bracket me-1"></i> Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container py-4">

        <%-- Notifications --%>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>

        <!-- Welcome Banner -->
        <div class="card border-0 bg-warning text-dark rounded-4 shadow-sm mb-4 overflow-hidden position-relative">
            <div class="card-body p-4 p-md-5">
                <span class="badge bg-dark text-white mb-2 px-3 py-1 rounded-pill fw-bold">Faculty Portal</span>
                <h2 class="fw-bold mb-1">Prof. ${sessionScope.currentUser.facultyName}</h2>
                <p class="mb-0 text-dark-50">Department: <strong>${sessionScope.currentUser.department}</strong> | Course Subject: <strong>${sessionScope.currentUser.subject}</strong></p>
            </div>
        </div>

        <!-- Overview Stat Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-6">
                <div class="stat-card">
                    <div class="stat-icon icon-student">
                        <i class="fa-solid fa-comments"></i>
                    </div>
                    <div>
                        <div class="stat-val text-primary">${feedbackList.size()}</div>
                        <span class="stat-label">Total Student Feedbacks Received</span>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="stat-card">
                    <div class="stat-icon icon-faculty">
                        <i class="fa-solid fa-book-open"></i>
                    </div>
                    <div>
                        <div class="stat-val text-dark fs-5 text-truncate">${sessionScope.currentUser.subject}</div>
                        <span class="stat-label">Department: ${sessionScope.currentUser.department}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Student Reviews List -->
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-header bg-white py-3 px-4 border-0">
                <h5 class="fw-bold mb-0"><i class="fa-solid fa-message text-warning me-2"></i> Student Feedback & Reviews</h5>
            </div>
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 70px;">#</th>
                            <th>Student Feedback / Comments</th>
                            <th style="width: 180px;">Submission Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty feedbackList}">
                                <c:forEach var="fb" items="${feedbackList}" varStatus="status">
                                    <tr>
                                        <td class="fw-semibold text-muted">${status.count}</td>
                                        <td class="text-dark">${not empty fb.comments ? fb.comments : '<span class="text-muted fst-italic">Evaluation completed</span>'}</td>
                                        <td class="small text-muted">${fb.feedbackDate}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="3" class="text-center py-4 text-muted">
                                        No student feedback recorded for your course subject yet.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <!-- Footer -->
    <footer>
        <div class="container text-center">
            <p class="mb-0 text-muted small">College Feedback Management System &copy; 2026 Faculty Portal</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
