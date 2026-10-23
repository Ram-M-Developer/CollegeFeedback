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
    <title>Submit Feedback - College Feedback System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .feedback-questions-container {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        .question-card {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #ffffff;
            transition: all 0.25s ease;
            overflow: hidden;
        }
        .question-card.answered {
            border-color: #93c5fd;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.06);
        }
        .question-card.highlight-missing {
            border-color: #ef4444;
            animation: pulse-border 1s ease infinite alternate;
        }
        @keyframes pulse-border {
            from { box-shadow: 0 0 0 1px #ef4444; }
            to { box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.25); }
        }
        .question-card-header {
            background-color: #f8fafc;
            border-bottom: 1px solid #edf2f7;
            padding: 0.75rem 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.75rem;
        }
        .option-item {
            position: relative;
            display: flex;
            align-items: flex-start;
            padding: 0.75rem 0.9rem;
            border: 1.5px solid #e2e8f0;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
            background-color: #ffffff;
            height: 100%;
        }
        .option-item:hover {
            border-color: #93c5fd;
            background-color: #f8fafc;
            transform: translateY(-1px);
        }
        .option-item input[type="radio"] {
            margin-top: 0.2rem;
            margin-right: 0.65rem;
            width: 1.15em;
            height: 1.15em;
            cursor: pointer;
            accent-color: #2563eb;
            flex-shrink: 0;
        }
        .option-item.selected,
        .option-item:has(input[type="radio"]:checked) {
            border-color: #2563eb;
            background-color: #eff6ff;
            box-shadow: 0 0 0 1px #2563eb;
        }
        .option-letter {
            display: inline-block;
            font-weight: 700;
            color: #1e293b;
            margin-right: 0.35rem;
            font-size: 0.9rem;
        }
        .option-text {
            font-size: 0.85rem;
            color: #334155;
            line-height: 1.35;
        }
        .status-badge {
            font-size: 0.75rem;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }
    </style>
</head>
<body class="bg-light">

    <!-- Student Navbar -->
    <nav class="navbar navbar-expand-lg custom-navbar sticky-top">
        <div class="container">
            <a class="navbar-brand navbar-brand-custom" href="${pageContext.request.contextPath}/student/dashboard.jsp">
                <i class="fa-solid fa-graduation-cap"></i> EduFeedback
            </a>
            <div class="collapse navbar-collapse" id="studentNav">
                <ul class="navbar-nav ms-auto align-items-center gap-2">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard.jsp"><i class="fa-solid fa-house me-1"></i> Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/feedback"><i class="fa-solid fa-comment-dots me-1"></i> Give Feedback</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/action?action=viewProfile"><i class="fa-solid fa-user me-1"></i> Profile</a></li>
                    <li class="nav-item ms-lg-2">
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm rounded-pill px-3"><i class="fa-solid fa-right-from-bracket me-1"></i> Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid flex-grow-1 d-flex flex-column justify-content-center py-2 px-md-4" style="max-width: 960px;">

        <div class="text-center mb-2">
            <h4 class="fw-bold mb-1"><i class="fa-solid fa-clipboard-list text-primary me-2"></i> Submit Faculty Feedback</h4>
            <p class="text-muted small mb-0">Your honest evaluation helps improve teaching quality and learning outcomes</p>
        </div>

        <%-- Session Notifications --%>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show mb-2 py-2 rounded-3 small" role="alert">
                <i class="fa-solid fa-circle-exclamation me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="card-body p-3 p-md-4">
                <form action="${pageContext.request.contextPath}/feedback" method="post" id="feedbackForm">

                    <!-- Selection Row -->
                    <div class="row g-3 mb-3">
                        <!-- Step 1: Department -->
                        <div class="col-md-4">
                            <label for="departmentSelect" class="form-label fw-bold small mb-1">1. Select Department *</label>
                            <select class="form-select" id="departmentSelect" name="department" required>
                                <option value="">-- Choose Academic Department --</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept}">${dept}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Step 2: Faculty -->
                        <div class="col-md-4">
                            <label for="facultySelect" class="form-label fw-bold small mb-1">2. Select Faculty Member *</label>
                            <select class="form-select" id="facultySelect" name="facultyId" required>
                                <option value="">-- Select Department First --</option>
                            </select>
                        </div>

                        <!-- Step 3: Subject (Auto-filled) -->
                        <div class="col-md-4">
                            <label for="subjectInput" class="form-label fw-bold small mb-1">3. Subject / Course</label>
                            <input type="text" class="form-control bg-light" id="subjectInput" placeholder="Subject will auto-fill" readonly>
                        </div>
                    </div>

                    <!-- Feedback Questions Section -->
                    <div class="mb-4">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <p class="fw-bold small mb-0 text-primary">
                                <i class="fa-solid fa-list-check me-1"></i> Feedback Questions
                                <span class="text-muted fw-normal">&nbsp;— Select the most accurate option for each question</span>
                            </p>
                            <span class="badge bg-light text-secondary border small fw-normal" id="overall-progress-badge">0 of 5 Answered</span>
                        </div>

                        <div class="feedback-questions-container">
                            <!-- Question 1 -->
                            <div class="question-card" id="qcard-1">
                                <div class="question-card-header">
                                    <span class="fw-semibold small text-dark">
                                        <span class="badge bg-primary me-1.5 px-2 py-1">Q1</span>
                                        How is the <u>clarity of teaching</u> and explanation of concepts?
                                    </span>
                                    <span class="badge bg-secondary-subtle text-secondary status-badge" id="q1-status">Required</span>
                                </div>
                                <div class="card-body p-2.5 p-md-3">
                                    <div class="row g-2">
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q1_a">
                                                <input type="radio" name="q1" id="q1_a" value="5" required>
                                                <div>
                                                    <span class="option-letter">A.</span>
                                                    <span class="option-text">Explains concepts with high clarity using practical real-life examples and illustrations.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q1_b">
                                                <input type="radio" name="q1" id="q1_b" value="4">
                                                <div>
                                                    <span class="option-letter">B.</span>
                                                    <span class="option-text">Explanations are clear, well-structured, and easy to follow during lectures.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q1_c">
                                                <input type="radio" name="q1" id="q1_c" value="3">
                                                <div>
                                                    <span class="option-letter">C.</span>
                                                    <span class="option-text">Basic concepts are clear, but difficult topics sometimes need further explanation.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q1_d">
                                                <input type="radio" name="q1" id="q1_d" value="1">
                                                <div>
                                                    <span class="option-letter">D.</span>
                                                    <span class="option-text">Explanations are often rushed, unclear, and difficult to comprehend.</span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Question 2 -->
                            <div class="question-card" id="qcard-2">
                                <div class="question-card-header">
                                    <span class="fw-semibold small text-dark">
                                        <span class="badge bg-primary me-1.5 px-2 py-1">Q2</span>
                                        How is the faculty's <u>subject knowledge</u> and expertise?
                                    </span>
                                    <span class="badge bg-secondary-subtle text-secondary status-badge" id="q2-status">Required</span>
                                </div>
                                <div class="card-body p-2.5 p-md-3">
                                    <div class="row g-2">
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q2_a">
                                                <input type="radio" name="q2" id="q2_a" value="5" required>
                                                <div>
                                                    <span class="option-letter">A.</span>
                                                    <span class="option-text">Demonstrates exceptional subject mastery and shares rich practical insights beyond textbooks.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q2_b">
                                                <input type="radio" name="q2" id="q2_b" value="4">
                                                <div>
                                                    <span class="option-letter">B.</span>
                                                    <span class="option-text">Possesses strong subject knowledge and clarifies syllabus concepts confidently.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q2_c">
                                                <input type="radio" name="q2" id="q2_c" value="3">
                                                <div>
                                                    <span class="option-letter">C.</span>
                                                    <span class="option-text">Knows standard textbook syllabus adequately, with minimal practical extensions.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q2_d">
                                                <input type="radio" name="q2" id="q2_d" value="1">
                                                <div>
                                                    <span class="option-letter">D.</span>
                                                    <span class="option-text">Lacks adequate subject depth and occasionally struggles to clarify student doubts.</span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Question 3 -->
                            <div class="question-card" id="qcard-3">
                                <div class="question-card-header">
                                    <span class="fw-semibold small text-dark">
                                        <span class="badge bg-primary me-1.5 px-2 py-1">Q3</span>
                                        How is the faculty's <u>punctuality and regularity</u> in conducting classes?
                                    </span>
                                    <span class="badge bg-secondary-subtle text-secondary status-badge" id="q3-status">Required</span>
                                </div>
                                <div class="card-body p-2.5 p-md-3">
                                    <div class="row g-2">
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q3_a">
                                                <input type="radio" name="q3" id="q3_a" value="5" required>
                                                <div>
                                                    <span class="option-letter">A.</span>
                                                    <span class="option-text">Always arrives on time, extremely regular, and completes topics according to schedule.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q3_b">
                                                <input type="radio" name="q3" id="q3_b" value="4">
                                                <div>
                                                    <span class="option-letter">B.</span>
                                                    <span class="option-text">Consistently regular and punctual for almost all scheduled lecture sessions.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q3_c">
                                                <input type="radio" name="q3" id="q3_c" value="3">
                                                <div>
                                                    <span class="option-letter">C.</span>
                                                    <span class="option-text">Usually attends regularly, but sometimes arrives late or reschedules lectures.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q3_d">
                                                <input type="radio" name="q3" id="q3_d" value="1">
                                                <div>
                                                    <span class="option-letter">D.</span>
                                                    <span class="option-text">Frequently late, irregular, or misses scheduled classes without prior notification.</span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Question 4 -->
                            <div class="question-card" id="qcard-4">
                                <div class="question-card-header">
                                    <span class="fw-semibold small text-dark">
                                        <span class="badge bg-primary me-1.5 px-2 py-1">Q4</span>
                                        How is the faculty's <u>interaction and student engagement</u> in class?
                                    </span>
                                    <span class="badge bg-secondary-subtle text-secondary status-badge" id="q4-status">Required</span>
                                </div>
                                <div class="card-body p-2.5 p-md-3">
                                    <div class="row g-2">
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q4_a">
                                                <input type="radio" name="q4" id="q4_a" value="5" required>
                                                <div>
                                                    <span class="option-letter">A.</span>
                                                    <span class="option-text">Creates an engaging, active environment with open discussions and student involvement.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q4_b">
                                                <input type="radio" name="q4" id="q4_b" value="4">
                                                <div>
                                                    <span class="option-letter">B.</span>
                                                    <span class="option-text">Encourages student participation and welcomes questions willingly during lectures.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q4_c">
                                                <input type="radio" name="q4" id="q4_c" value="3">
                                                <div>
                                                    <span class="option-letter">C.</span>
                                                    <span class="option-text">Moderate interaction; classes are predominantly conducted as one-way lectures.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q4_d">
                                                <input type="radio" name="q4" id="q4_d" value="1">
                                                <div>
                                                    <span class="option-letter">D.</span>
                                                    <span class="option-text">Minimal or no student interaction, and actively discourages questions in class.</span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Question 5 -->
                            <div class="question-card" id="qcard-5">
                                <div class="question-card-header">
                                    <span class="fw-semibold small text-dark">
                                        <span class="badge bg-primary me-1.5 px-2 py-1">Q5</span>
                                        How is the faculty's <u>availability for doubt-clearing</u> and student support?
                                    </span>
                                    <span class="badge bg-secondary-subtle text-secondary status-badge" id="q5-status">Required</span>
                                </div>
                                <div class="card-body p-2.5 p-md-3">
                                    <div class="row g-2">
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q5_a">
                                                <input type="radio" name="q5" id="q5_a" value="5" required>
                                                <div>
                                                    <span class="option-letter">A.</span>
                                                    <span class="option-text">Readily accessible, exceptionally patient, and always supportive for student doubts.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q5_b">
                                                <input type="radio" name="q5" id="q5_b" value="4">
                                                <div>
                                                    <span class="option-letter">B.</span>
                                                    <span class="option-text">Accessible during designated office hours and clarifies doubts helpfully.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q5_c">
                                                <input type="radio" name="q5" id="q5_c" value="3">
                                                <div>
                                                    <span class="option-letter">C.</span>
                                                    <span class="option-text">Available only when specifically approached by students after class hours.</span>
                                                </div>
                                            </label>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <label class="option-item" for="q5_d">
                                                <input type="radio" name="q5" id="q5_d" value="1">
                                                <div>
                                                    <span class="option-letter">D.</span>
                                                    <span class="option-text">Rarely accessible outside class and reluctant to provide extra guidance.</span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Hidden computed rating (avg of Q1-Q5) sent to servlet -->
                    <input type="hidden" name="rating" id="computedRating" value="">

                    <!-- Additional Comments -->
                    <div class="mb-3">
                        <label for="comments" class="form-label fw-bold small mb-1">
                            <i class="fa-solid fa-pen-to-square me-1 text-secondary"></i> Additional Comments &amp; Suggestions
                        </label>
                        <textarea class="form-control" id="comments" name="comments" rows="3"
                                  placeholder="Provide specific feedback regarding clarity of explanations, lab sessions, availability, etc."></textarea>
                    </div>

                    <!-- Bottom Action Bar -->
                    <div class="mt-3 pt-2 border-top d-flex align-items-center justify-content-between">
                        <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="text-muted small text-decoration-none">
                            <i class="fa-solid fa-arrow-left me-1"></i> Return to Dashboard
                        </a>
                        <button type="submit" class="btn btn-primary px-4 py-2 fw-bold rounded-pill shadow-sm">
                            <i class="fa-solid fa-paper-plane me-2"></i> Submit Feedback
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const deptSelect = document.getElementById('departmentSelect');
            const facultySelect = document.getElementById('facultySelect');
            const subjectInput = document.getElementById('subjectInput');
            const contextPath = '${pageContext.request.contextPath}';

            if (deptSelect && facultySelect) {
                deptSelect.addEventListener('change', function () {
                    const selectedDept = this.value;
                    facultySelect.innerHTML = '<option value="">-- Loading Faculty... --</option>';

                    if (!selectedDept) {
                        facultySelect.innerHTML = '<option value="">-- Select Department First --</option>';
                        if (subjectInput) subjectInput.value = '';
                        return;
                    }

                    fetch(contextPath + '/feedback?action=getFacultyByDept&department=' + encodeURIComponent(selectedDept))
                        .then(response => {
                            if (!response.ok) throw new Error('HTTP error ' + response.status);
                            return response.json();
                        })
                        .then(faculties => {
                            facultySelect.innerHTML = '<option value="">-- Select Faculty --</option>';
                            if (!faculties || faculties.length === 0) {
                                facultySelect.innerHTML = '<option value="">No faculty available for this department</option>';
                                if (subjectInput) subjectInput.value = '';
                                return;
                            }
                            faculties.forEach(fac => {
                                const opt = document.createElement('option');
                                opt.value = fac.facultyId;
                                opt.textContent = fac.facultyName + ' (' + fac.subject + ')';
                                opt.dataset.subject = fac.subject;
                                facultySelect.appendChild(opt);
                            });
                        })
                        .catch(err => {
                            console.error('Error fetching faculty:', err);
                            facultySelect.innerHTML = '<option value="">Error loading faculty</option>';
                        });
                });

                facultySelect.addEventListener('change', function () {
                    const selectedOpt = this.options[this.selectedIndex];
                    if (subjectInput && selectedOpt && selectedOpt.dataset.subject) {
                        subjectInput.value = selectedOpt.dataset.subject;
                    } else if (subjectInput) {
                        subjectInput.value = '';
                    }
                });
            }

            // Interactive option selection and progress tracking
            const qNames = ['q1', 'q2', 'q3', 'q4', 'q5'];

            function updateQuestionStatus(qName, qIndex) {
                const checked = document.querySelector('input[name="' + qName + '"]:checked');
                const card = document.getElementById('qcard-' + qIndex);
                const badge = document.getElementById(qName + '-status');

                // Update selected styling on all options for this question
                const radios = document.querySelectorAll('input[name="' + qName + '"]');
                radios.forEach(r => {
                    const label = r.closest('.option-item');
                    if (label) {
                        if (r.checked) label.classList.add('selected');
                        else label.classList.remove('selected');
                    }
                });

                if (checked) {
                    if (card) {
                        card.classList.add('answered');
                        card.classList.remove('highlight-missing');
                    }
                    if (badge) {
                        badge.className = 'badge bg-success-subtle text-success border border-success-subtle status-badge';
                        badge.innerHTML = '<i class="fa-solid fa-check me-1"></i> Answered';
                    }
                }

                // Update overall progress counter
                let answeredCount = 0;
                qNames.forEach(name => {
                    if (document.querySelector('input[name="' + name + '"]:checked')) {
                        answeredCount++;
                    }
                });
                const progressBadge = document.getElementById('overall-progress-badge');
                if (progressBadge) {
                    progressBadge.textContent = answeredCount + ' of 5 Answered';
                    if (answeredCount === 5) {
                        progressBadge.className = 'badge bg-success text-white border small fw-semibold';
                    } else {
                        progressBadge.className = 'badge bg-light text-secondary border small fw-normal';
                    }
                }
            }

            qNames.forEach((name, idx) => {
                const radios = document.querySelectorAll('input[name="' + name + '"]');
                radios.forEach(radio => {
                    radio.addEventListener('change', function () {
                        updateQuestionStatus(name, idx + 1);
                    });
                });
            });

            // On submit: validate all Q answered, compute average rating, set hidden field
            const feedbackForm = document.getElementById('feedbackForm');
            if (feedbackForm) {
                feedbackForm.addEventListener('submit', function (e) {
                    if (!facultySelect || !facultySelect.value) {
                        e.preventDefault();
                        alert('Please select an academic department and faculty member before submitting.');
                        if (!deptSelect.value) deptSelect.focus();
                        else facultySelect.focus();
                        return false;
                    }

                    let total = 0;
                    let firstUnansweredCard = null;

                    qNames.forEach((qName, idx) => {
                        const checked = document.querySelector('input[name="' + qName + '"]:checked');
                        const card = document.getElementById('qcard-' + (idx + 1));
                        if (!checked) {
                            if (!firstUnansweredCard) firstUnansweredCard = card;
                            if (card) card.classList.add('highlight-missing');
                        } else {
                            total += parseInt(checked.value);
                        }
                    });

                    if (firstUnansweredCard) {
                        e.preventDefault();
                        alert('Please select an answer option for all 5 questions before submitting your feedback.');
                        firstUnansweredCard.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        return false;
                    }

                    // Average of Q1-Q5, rounded, clamped to 1-5
                    const avg = Math.min(5, Math.max(1, Math.round(total / qNames.length)));
                    document.getElementById('computedRating').value = avg;

                    // If student left comments empty, summarize the selected answer options
                    const commentsInput = document.getElementById('comments');
                    if (commentsInput && !commentsInput.value.trim()) {
                        const optSummary = [];
                        qNames.forEach((qName, idx) => {
                            const checked = document.querySelector('input[name="' + qName + '"]:checked');
                            if (checked) {
                                const letter = checked.id.split('_')[1].toUpperCase();
                                optSummary.push('Q' + (idx + 1) + ':' + letter);
                            }
                        });
                        commentsInput.value = 'Evaluation completed (' + optSummary.join(', ') + ')';
                    }
                });
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/js/script.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>
