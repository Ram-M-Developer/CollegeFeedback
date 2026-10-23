<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.collegefeedback.dao.StudentDAO" %>
<%@ page import="com.collegefeedback.model.Student" %>
<%@ page import="java.util.List" %>
<c:if test="${empty sessionScope.currentUser || sessionScope.userRole != 'ADMIN'}">
    <c:redirect url="../login.jsp?error=Unauthorized+Admin+Access"/>
</c:if>

<%
    StudentDAO dao = new StudentDAO();
    List<Student> students = dao.getAllStudents();
    request.setAttribute("students", students);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Students - Admin</title>
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
                <li><a href="students.jsp" class="active"><i class="fa-solid fa-user-graduate"></i> Manage Students</a></li>
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

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i> ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h3 class="fw-bold mb-0">Student Directory Management</h3>
                    <p class="text-muted small">Create, edit, search or remove registered student accounts</p>
                </div>
                <button type="button" class="btn btn-primary rounded-pill px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#addStudentModal">
                    <i class="fa-solid fa-plus me-2"></i> Add New Student
                </button>
            </div>

            <!-- Search & Filter Card -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-3">
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                        <input type="text" class="form-control bg-light border-start-0" id="tableSearchInput" placeholder="Type register number, student name, department or email to filter list...">
                    </div>
                </div>
            </div>

            <!-- Students Data Table -->
            <div class="custom-table">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Reg Number</th>
                            <th>Student Name</th>
                            <th>Department</th>
                            <th>Email Address</th>
                            <th>Registered On</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty students}">
                                <c:forEach var="st" items="${students}">
                                    <tr>
                                        <td class="fw-semibold text-muted">#${st.studentId}</td>
                                        <td><span class="badge bg-primary-subtle text-primary fw-bold px-2.5 py-1 rounded">${st.regNo}</span></td>
                                        <td class="fw-bold text-dark">${st.studentName}</td>
                                        <td>${st.department}</td>
                                        <td>${st.email}</td>
                                        <td class="small text-muted">${st.createdAt}</td>
                                        <td class="text-end">
                                            <button class="btn btn-sm btn-outline-primary rounded-circle me-1" 
                                                    onclick="editStudent('${st.studentId}', '${st.regNo}', '${st.studentName}', '${st.department}', '${st.email}')" 
                                                    title="Edit Student">
                                                <i class="fa-solid fa-pen"></i>
                                            </button>
                                            <a href="action?action=deleteStudent&id=${st.studentId}" 
                                               class="btn btn-sm btn-outline-danger rounded-circle"
                                               onclick="return confirm('Are you sure you want to delete student: ${st.studentName}? This will also delete their feedback records.');" 
                                               title="Delete Student">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">No student records found in database.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </main>
    </div>

    <!-- Modal: Add Student -->
    <div class="modal fade" id="addStudentModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-plus text-primary me-2"></i> Add New Student</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="action" method="post">
                    <input type="hidden" name="action" value="addStudent">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Register Number *</label>
                            <input type="text" class="form-control" name="regNo" placeholder="CS2026001" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Student Name *</label>
                            <input type="text" class="form-control" name="name" placeholder="John Doe" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Department *</label>
                            <select class="form-select" name="department" required>
                                <option value="">-- Select Department --</option>
                                <option value="Computer Science">Computer Science</option>
                                <option value="Electrical Engineering">Electrical Engineering</option>
                                <option value="Mechanical Engineering">Mechanical Engineering</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="Civil Engineering">Civil Engineering</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Email Address *</label>
                            <input type="email" class="form-control" name="email" placeholder="student@college.edu" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Password *</label>
                            <input type="password" class="form-control" name="password" value="student123" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0 px-4 pb-4">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Save Student</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal: Edit Student -->
    <div class="modal fade" id="editStudentModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-pen text-primary me-2"></i> Edit Student Record</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="action" method="post">
                    <input type="hidden" name="action" value="editStudent">
                    <input type="hidden" name="studentId" id="editStudentId">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Register Number *</label>
                            <input type="text" class="form-control" name="regNo" id="editRegNo" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Student Name *</label>
                            <input type="text" class="form-control" name="name" id="editName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Department *</label>
                            <select class="form-select" name="department" id="editDepartment" required>
                                <option value="Computer Science">Computer Science</option>
                                <option value="Electrical Engineering">Electrical Engineering</option>
                                <option value="Mechanical Engineering">Mechanical Engineering</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="Civil Engineering">Civil Engineering</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Email Address *</label>
                            <input type="email" class="form-control" name="email" id="editEmail" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">New Password (leave blank to keep current)</label>
                            <input type="password" class="form-control" name="password" placeholder="••••••••">
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0 px-4 pb-4">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Update Student</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/script.js"></script>
    <script>
        function editStudent(id, regNo, name, dept, email) {
            document.getElementById('editStudentId').value = id;
            document.getElementById('editRegNo').value = regNo;
            document.getElementById('editName').value = name;
            document.getElementById('editDepartment').value = dept;
            document.getElementById('editEmail').value = email;

            const modal = new bootstrap.Modal(document.getElementById('editStudentModal'));
            modal.show();
        }
    </script>
</body>
</html>
