<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${empty sessionScope.currentUser || sessionScope.userRole != 'STUDENT'}">
    <c:redirect url="/login.jsp?error=Unauthorized+Access"/>
</c:if>
<%
    if (request.getAttribute("myFeedbacks") == null) {
        com.collegefeedback.model.Student curStudent = (com.collegefeedback.model.Student) session.getAttribute("currentUser");
        if (curStudent != null) {
            com.collegefeedback.dao.FeedbackDAO fbDao = new com.collegefeedback.dao.FeedbackDAO();
            request.setAttribute("myFeedbacks", fbDao.getFeedbacksByStudent(curStudent.getStudentId()));
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - College Feedback</title>
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
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#studentNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="studentNav">
                <ul class="navbar-nav ms-auto align-items-center gap-2">
                    <li class="nav-item"><a class="nav-link active" href="dashboard.jsp"><i class="fa-solid fa-house me-1"></i> Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="../feedback"><i class="fa-solid fa-comment-dots me-1"></i> Give Feedback</a></li>
                    <li class="nav-item"><a class="nav-link" href="action?action=viewProfile"><i class="fa-solid fa-user me-1"></i> Profile</a></li>
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
            <div class="alert alert-success alert-dismissible fade show shadow-sm rounded-3 mb-4" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm rounded-3 mb-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        <!-- Welcome Banner -->
        <div class="card border-0 bg-primary text-white rounded-4 shadow-sm mb-4 overflow-hidden position-relative">
            <div class="card-body p-4 p-md-5">
                <span class="badge bg-white text-primary mb-2 px-3 py-1 rounded-pill fw-bold">Student Portal</span>
                <h2 class="fw-bold mb-1">Welcome back, ${sessionScope.currentUser.studentName}!</h2>
                <p class="mb-0 text-white-50">Reg No: <strong>${sessionScope.currentUser.regNo}</strong> | Department: <strong>${sessionScope.currentUser.department}</strong></p>
            </div>
        </div>

        <!-- Quick Action Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon icon-student">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </div>
                    <div>
                        <a href="../feedback" class="text-dark fw-bold h5 mb-1 d-block">Submit Feedback</a>
                        <span class="stat-label">Evaluate your faculty & subjects</span>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon icon-faculty">
                        <i class="fa-solid fa-id-card"></i>
                    </div>
                    <div>
                        <a href="action?action=viewProfile" class="text-dark fw-bold h5 mb-1 d-block">My Profile</a>
                        <span class="stat-label">Manage account information</span>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon icon-admin">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <div>
                        <div class="stat-val text-primary">${not empty myFeedbacks ? myFeedbacks.size() : 0}</div>
                        <span class="stat-label">Total Submissions Recorded</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Feedback History Table -->
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-header bg-white py-3 px-4 border-0 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0"><i class="fa-solid fa-clock-rotate-left text-primary me-2"></i> My Submitted Feedback</h5>
                <a href="../feedback" class="btn btn-primary btn-sm rounded-pill px-3"><i class="fa-solid fa-plus me-1"></i> New Feedback</a>
            </div>



            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Faculty Name</th>
                            <th>Subject</th>
                            <th>Department</th>
                            <th>Comments</th>
                            <th>Status</th>
                            <th>Date Submitted</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty myFeedbacks}">
                                <c:forEach var="fb" items="${myFeedbacks}" varStatus="status">
                                    <tr>
                                        <td class="fw-semibold text-muted">${status.count}</td>
                                        <td class="fw-bold text-dark">${fb.facultyName}</td>
                                        <td><span class="badge bg-light text-dark border">${fb.subject}</span></td>
                                        <td>${fb.department}</td>
                                        <td class="text-muted small">${not empty fb.comments ? fb.comments : '<span class="text-muted fst-italic">Evaluation completed</span>'}</td>
                                        <td><span class="badge bg-success-subtle text-success border border-success-subtle"><i class="fa-solid fa-circle-check me-1"></i> Submitted</span></td>
                                        <td class="small text-muted">${fb.feedbackDate}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">
                                        <i class="fa-regular fa-folder-open fs-2 mb-2 text-secondary d-block"></i>
                                        You have not submitted any feedback yet. <a href="../feedback" class="fw-semibold">Submit your first review now!</a>
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
            <p class="mb-0 text-muted small">College Feedback System &copy; 2026 Student Portal</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/script.js"></script>
</body>
</html>
