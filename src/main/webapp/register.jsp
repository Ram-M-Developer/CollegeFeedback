<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration - College Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100 py-5">

    <div class="container" style="max-width: 540px;">
        <div class="text-center mb-4">
            <a href="index.jsp" class="navbar-brand navbar-brand-custom justify-content-center mb-2 fs-3">
                <i class="fa-solid fa-graduation-cap"></i> EduFeedback
            </a>
            <h4 class="fw-bold mb-1">Create Student Account</h4>
            <p class="text-muted small">Fill in details to register as a student</p>
        </div>

        <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="card-body p-4">

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="register" method="post" id="regForm">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Register Number *</label>
                            <input type="text" class="form-control" name="regNo" value="${regNo}" placeholder="e.g. CS2023099" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Full Name *</label>
                            <input type="text" class="form-control" name="name" value="${name}" placeholder="John Doe" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Department *</label>
                            <select class="form-select" name="department" required>
                                <option value="">-- Select Department --</option>
                                <option value="Computer Science" ${department == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                                <option value="Electrical Engineering" ${department == 'Electrical Engineering' ? 'selected' : ''}>Electrical Engineering</option>
                                <option value="Mechanical Engineering" ${department == 'Mechanical Engineering' ? 'selected' : ''}>Mechanical Engineering</option>
                                <option value="Information Technology" ${department == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                                <option value="Civil Engineering" ${department == 'Civil Engineering' ? 'selected' : ''}>Civil Engineering</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Email Address *</label>
                            <input type="email" class="form-control" name="email" value="${email}" placeholder="student@gmail.com" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Password *</label>
                            <input type="password" class="form-control" name="password" id="pass" placeholder="••••••••" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Confirm Password *</label>
                            <input type="password" class="form-control" name="confirmPassword" id="confirmPass" placeholder="••••••••" required>
                        </div>
                    </div>

                    <div id="passMismatchAlert" class="text-danger small mt-2 d-none">
                        <i class="fa-solid fa-circle-xmark me-1"></i> Passwords do not match!
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2.5 fw-bold rounded-pill shadow-sm mt-4">
                        <i class="fa-solid fa-user-plus me-2"></i> Register Account
                    </button>
                </form>
            </div>

            <div class="card-footer bg-light text-center py-3 border-0">
                <span class="text-muted small">Already have an account?</span>
                <a href="login.jsp" class="fw-semibold text-primary ms-1 small">Log In Here</a>
            </div>
        </div>

        <div class="text-center mt-3">
            <a href="index.jsp" class="text-muted small"><i class="fa-solid fa-arrow-left me-1"></i> Back to Home</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('regForm').addEventListener('submit', function (e) {
            const pass = document.getElementById('pass').value;
            const confirmPass = document.getElementById('confirmPass').value;
            const alertBox = document.getElementById('passMismatchAlert');

            if (pass !== confirmPass) {
                e.preventDefault();
                alertBox.classList.remove('d-none');
            } else {
                alertBox.classList.add('d-none');
            }
        });
    </script>
</body>
</html>
