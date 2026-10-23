<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.collegefeedback.dao.FeedbackDAO" %>
<%@ page import="com.collegefeedback.dao.FacultyDAO" %>
<%@ page import="com.collegefeedback.model.Feedback" %>
<%@ page import="com.collegefeedback.model.Faculty" %>
<%@ page import="java.util.List" %>
<c:if test="${empty sessionScope.currentUser || sessionScope.userRole != 'ADMIN'}">
    <c:redirect url="../login.jsp?error=Unauthorized+Admin+Access"/>
</c:if>

<%
    String dept = request.getParameter("department");
    String facultyIdStr = request.getParameter("facultyId");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");

    Integer facultyId = (facultyIdStr != null && !facultyIdStr.isEmpty()) ? Integer.parseInt(facultyIdStr) : null;

    FeedbackDAO feedbackDAO = new FeedbackDAO();
    FacultyDAO facultyDAO = new FacultyDAO();

    List<Feedback> feedbackList = feedbackDAO.getFilteredFeedbacks(dept, facultyId, null, startDate, endDate);
    List<Faculty> allFaculties = facultyDAO.getAllFaculty();
    List<String> allDepts = facultyDAO.getAllDepartments();

    request.setAttribute("feedbackList", feedbackList);
    request.setAttribute("allFaculties", allFaculties);
    request.setAttribute("allDepts", allDepts);
    request.setAttribute("selDept", dept);
    request.setAttribute("selFacultyId", facultyId);
    request.setAttribute("startDate", startDate);
    request.setAttribute("endDate", endDate);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Log - Admin</title>
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
                <li><a href="feedback.jsp" class="active"><i class="fa-solid fa-comments"></i> Feedback Log</a></li>
                <li><a href="reports.jsp"><i class="fa-solid fa-file-invoice"></i> Reports & Analysis</a></li>
                <li class="sidebar-title mt-3">Settings</li>
                <li><a href="profile.jsp"><i class="fa-solid fa-gear"></i> Admin Settings</a></li>
                <li><a href="../logout" class="text-danger"><i class="fa-solid fa-power-off"></i> Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="admin-main-content">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-0">Student Feedback Log Review</h3>
                    <p class="text-muted small">Filter, search, and analyze recorded student feedback submissions</p>
                </div>
                <span class="badge bg-primary fs-6 px-3 py-2 rounded-pill fw-semibold">
                    Total Records Found: ${feedbackList.size()}
                </span>
            </div>

            <!-- Multi-Criteria Filter Card -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-header bg-white py-3 px-4 border-0">
                    <h5 class="fw-bold mb-0"><i class="fa-solid fa-filter text-primary me-2"></i> Filter Submissions</h5>
                </div>
                <div class="card-body p-4 pt-0">
                    <form action="feedback.jsp" method="get">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label small fw-bold">Department</label>
                                <select class="form-select form-select-sm" name="department">
                                    <option value="ALL">All Departments</option>
                                    <c:forEach var="d" items="${allDepts}">
                                        <option value="${d}" ${selDept == d ? 'selected' : ''}>${d}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label small fw-bold">Faculty Member</label>
                                <select class="form-select form-select-sm" name="facultyId">
                                    <option value="">All Faculty</option>
                                    <c:forEach var="fac" items="${allFaculties}">
                                        <option value="${fac.facultyId}" ${selFacultyId == fac.facultyId ? 'selected' : ''}>${fac.facultyName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label small fw-bold">From Date</label>
                                <input type="date" class="form-control form-control-sm" name="startDate" value="${startDate}">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label small fw-bold">To Date</label>
                                <input type="date" class="form-control form-control-sm" name="endDate" value="${endDate}">
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <a href="feedback.jsp" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Reset Filters</a>
                            <button type="submit" class="btn btn-sm btn-primary rounded-pill px-4 fw-bold">
                                <i class="fa-solid fa-magnifying-glass me-1"></i> Apply Filter
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Feedback Log Table -->
            <div class="custom-table">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student</th>
                            <th>Reg No</th>
                            <th>Faculty Name</th>
                            <th>Subject</th>
                            <th>Comments</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty feedbackList}">
                                <c:forEach var="fb" items="${feedbackList}">
                                    <tr>
                                        <td class="fw-semibold text-muted">#${fb.feedbackId}</td>
                                        <td class="fw-bold text-dark">${fb.studentName}</td>
                                        <td><span class="badge bg-light text-dark border">${fb.studentRegNo}</span></td>
                                        <td class="fw-bold text-primary">${fb.facultyName}</td>
                                        <td><span class="badge bg-info-subtle text-dark border">${fb.subject}</span></td>
                                        <td class="small text-muted" style="max-width: 280px;">${fb.comments}</td>
                                        <td class="small text-muted">${fb.feedbackDate}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">No feedback records match the selected filter criteria.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/script.js"></script>
</body>
</html>
