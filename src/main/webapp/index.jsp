<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Feedback Management System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- Header / Navbar -->
    <nav class="navbar navbar-expand-lg custom-navbar sticky-top">
        <div class="container">
            <a class="navbar-brand navbar-brand-custom" href="index.jsp">
                <i class="fa-solid fa-graduation-cap">null</i> EduFeedback
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center gap-2">
                    <li class="nav-item"><a class="nav-link active" href="index.jsp">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="#about">About System</a></li>
                    <li class="nav-item"><a class="nav-link" href="#features">Features</a></li>
                    <li class="nav-item"><a class="nav-link" href="#how-it-works">How It Works</a></li>
                    <li class="nav-item ms-lg-2">
                        <a href="login.jsp" class="btn btn-outline-primary fw-semibold px-4 rounded-pill">Login</a>
                    </li>
                    <li class="nav-item">
                        <a href="register.jsp" class="btn btn-primary fw-semibold px-4 rounded-pill">Student Register</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section text-center">
        <div class="container">
            <span class="badge bg-light text-primary fs-6 px-3 py-2 rounded-pill fw-semibold mb-3">
                <i class="fa-solid fa-star me-1 text-warning"></i> Empowering Education Quality
            </span>
            <h1 class="hero-title mb-3">COLLEGE FEEDBACK MANAGEMENT SYSTEM</h1>
            <p class="hero-subtitle mx-auto mb-4">
                "Improve Education Through Student Feedback" — A centralized, transparent, and intelligent platform for feedback collection, performance analysis, and decision making.
            </p>
            <div class="d-flex justify-content-center gap-3 flex-wrap mb-5">
                <a href="login.jsp" class="btn btn-warning btn-lg px-4 fw-bold rounded-pill text-dark shadow-sm">
                    <i class="fa-solid fa-right-to-bracket me-2"></i> Access Portal
                </a>
                <a href="register.jsp" class="btn btn-outline-light btn-lg px-4 fw-semibold rounded-pill">
                    <i class="fa-solid fa-user-plus me-2"></i> Join as Student
                </a>
            </div>
        </div>
    </section>

    <!-- User Roles Section -->
    <section class="py-5 bg-white">
        <div class="container py-4">
            <div class="text-center mb-5">
                <h2 class="fw-bold">Choose Your Login Portal</h2>
                <p class="text-muted">Select your specific role to log into your dashboard</p>
            </div>
            <div class="row g-4">
                <!-- Student Card -->
                <div class="col-md-4">
                    <div class="role-card text-center">
                        <div class="role-icon-box icon-student mx-auto">
                            <i class="fa-solid fa-user-graduate"></i>
                        </div>
                        <h4 class="fw-bold">STUDENT</h4>
                        <p class="text-muted small">Register, browse faculty and subjects, submit ratings 1-5 with detailed feedback comments securely.</p>
                        <a href="login.jsp?role=STUDENT" class="btn btn-primary w-100 rounded-pill mt-2">Student Login</a>
                    </div>
                </div>

                <!-- Faculty Card -->
                <div class="col-md-4">
                    <div class="role-card text-center">
                        <div class="role-icon-box icon-faculty mx-auto">
                            <i class="fa-solid fa-chalkboard-user"></i>
                        </div>
                        <h4 class="fw-bold">FACULTY</h4>
                        <p class="text-muted small">Log in to view aggregated performance ratings, overall student evaluations, and constructive review summaries.</p>
                        <a href="login.jsp?role=FACULTY" class="btn btn-warning w-100 text-dark rounded-pill mt-2 fw-semibold">Faculty Login</a>
                    </div>
                </div>

                <!-- Admin Card -->
                <div class="col-md-4">
                    <div class="role-card text-center">
                        <div class="role-icon-box icon-admin mx-auto">
                            <i class="fa-solid fa-user-shield"></i>
                        </div>
                        <h4 class="fw-bold">ADMINISTRATOR</h4>
                        <p class="text-muted small">Manage students & faculty records, execute analytics, view Chart.js performance reports, and export insights.</p>
                        <a href="login.jsp?role=ADMIN" class="btn btn-dark w-100 rounded-pill mt-2">Admin Login</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="py-5">
        <div class="container py-4">
            <div class="text-center mb-5">
                <span class="text-primary fw-bold text-uppercase tracking-wider">System Capabilities</span>
                <h2 class="fw-bold mt-1">Key Modules & Features</h2>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="p-4 bg-white rounded-3 border h-100 shadow-sm">
                        <div class="text-primary fs-3 mb-3"><i class="fa-solid fa-lock"></i></div>
                        <h5 class="fw-bold">Role-Based Security</h5>
                        <p class="text-muted small mb-0">BCrypt password hashing and session authentication filters prevent unauthorized page access.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4 bg-white rounded-3 border h-100 shadow-sm">
                        <div class="text-success fs-3 mb-3"><i class="fa-solid fa-chart-pie"></i></div>
                        <h5 class="fw-bold">Visual Analytics</h5>
                        <p class="text-muted small mb-0">Dynamic Chart.js rating breakdown, faculty bar charts, department statistics, and subject trends.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4 bg-white rounded-3 border h-100 shadow-sm">
                        <div class="text-warning fs-3 mb-3"><i class="fa-solid fa-star"></i></div>
                        <h5 class="fw-bold">Interactive 1-5 Star Ratings</h5>
                        <p class="text-muted small mb-0">Intuitive star ratings with validated duplicate submission prevention per faculty member.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section id="how-it-works" class="py-5 bg-white">
        <div class="container py-4">
            <div class="text-center mb-5">
                <h2 class="fw-bold">How The System Works</h2>
                <p class="text-muted">Simple 4-step workflow from student submission to admin report generation</p>
            </div>
            <div class="row g-4 text-center">
                <div class="col-md-3">
                    <div class="fs-1 text-primary mb-2 fw-bold">01</div>
                    <h5 class="fw-bold">Student Registration</h5>
                    <p class="text-muted small">Students create an account with their unique registration number and department.</p>
                </div>
                <div class="col-md-3">
                    <div class="fs-1 text-primary mb-2 fw-bold">02</div>
                    <h5 class="fw-bold">Select Faculty & Subject</h5>
                    <p class="text-muted small">Choose department, view matching faculty members, and load target subjects.</p>
                </div>
                <div class="col-md-3">
                    <div class="fs-1 text-primary mb-2 fw-bold">03</div>
                    <h5 class="fw-bold">Submit Rating & Comments</h5>
                    <p class="text-muted small">Give a 1 to 5 star rating along with detailed comments stored securely in MySQL.</p>
                </div>
                <div class="col-md-3">
                    <div class="fs-1 text-primary mb-2 fw-bold">04</div>
                    <h5 class="fw-bold">Admin Reports & Charts</h5>
                    <p class="text-muted small">Admin reviews SQL aggregated reports, department metrics, and generates visual charts.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container text-center">
            <p class="mb-1 fw-semibold text-dark">College Feedback Management System &copy; 2026</p>
            <p class="mb-0 text-muted small">Developed using Java Servlets, JSP, JDBC, MySQL, Bootstrap 5 & Chart.js</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
