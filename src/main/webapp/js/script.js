/**
 * College Feedback Management System - Core JavaScript Library
 */

document.addEventListener('DOMContentLoaded', function () {
    initRatingLabel();
    initDepartmentFacultyCascade();
    initAdminCharts();
    initTableSearch();
});

/**
 * Utility: Dynamically determine web application context path
 */
function getContextPath() {
    if (typeof window.CONTEXT_PATH !== 'undefined' && window.CONTEXT_PATH !== null) {
        return window.CONTEXT_PATH;
    }
    const pathname = window.location.pathname;
    const parts = pathname.split('/').filter(Boolean);
    if (parts.length > 0 && parts[0] === 'collegefeedback') {
        return '/collegefeedback';
    }
    return '';
}

/**
 * 1. Interactive Star Rating Text Preview
 */
function initRatingLabel() {
    const ratingInputs = document.querySelectorAll('.star-rating-container input[type="radio"]');
    const ratingTextLabel = document.getElementById('ratingTextLabel');

    const labels = {
        '1': '★ Very Poor (1/5)',
        '2': '★★ Poor (2/5)',
        '3': '★★★ Average (3/5)',
        '4': '★★★★ Good (4/5)',
        '5': '★★★★★ Excellent (5/5)'
    };

    if (ratingInputs.length > 0 && ratingTextLabel) {
        ratingInputs.forEach(input => {
            input.addEventListener('change', function () {
                ratingTextLabel.textContent = labels[this.value] || '';
                ratingTextLabel.className = 'fw-bold mt-2 text-warning';
            });
        });
    }
}

/**
 * 2. Dynamic Cascading Dropdown: Department -> Faculty -> Subject
 */
function initDepartmentFacultyCascade() {
    const deptSelect = document.getElementById('departmentSelect');
    const facultySelect = document.getElementById('facultySelect');
    const subjectInput = document.getElementById('subjectInput');

    if (deptSelect && facultySelect) {
        deptSelect.addEventListener('change', function () {
            const selectedDept = this.value;
            facultySelect.innerHTML = '<option value="">-- Loading Faculty... --</option>';

            if (!selectedDept) {
                facultySelect.innerHTML = '<option value="">-- Select Department First --</option>';
                if (subjectInput) subjectInput.value = '';
                return;
            }

            const contextPath = getContextPath();
            fetch(`${contextPath}/feedback?action=getFacultyByDept&department=${encodeURIComponent(selectedDept)}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
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
                        opt.textContent = `${fac.facultyName} (${fac.subject})`;
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
}

/**
 * 3. Initialize Admin Visual Analytics Charts via Chart.js (Feedback Volume)
 */
function initAdminCharts() {
    const deptCtx = document.getElementById('departmentPerformanceChart');
    const facultyCtx = document.getElementById('facultyPerformanceChart');
    const subjectCtx = document.getElementById('subjectPerformanceChart');

    // Only run if at least one chart element exists on current page
    if (!deptCtx && !facultyCtx && !subjectCtx) return;

    const contextPath = getContextPath();
    fetch(`${contextPath}/report?action=chartData`)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            // A. Department Feedback Share Doughnut Chart
            if (deptCtx && data.departmentFeedbackCounts) {
                const depts = Object.keys(data.departmentFeedbackCounts);
                const deptCounts = Object.values(data.departmentFeedbackCounts);

                new Chart(deptCtx, {
                    type: 'doughnut',
                    data: {
                        labels: depts,
                        datasets: [{
                            data: deptCounts,
                            backgroundColor: ['#2563eb', '#10b981', '#f59e0b', '#8b5cf6', '#ec4899', '#06b6d4']
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { position: 'bottom' }
                        }
                    }
                });
            }

            // B. Faculty Feedback Submissions Bar Chart
            if (facultyCtx && data.facultyFeedbackCounts) {
                const names = Object.keys(data.facultyFeedbackCounts);
                const counts = Object.values(data.facultyFeedbackCounts);

                new Chart(facultyCtx, {
                    type: 'bar',
                    data: {
                        labels: names,
                        datasets: [{
                            label: 'Total Submissions Received',
                            data: counts,
                            backgroundColor: '#2563eb',
                            borderRadius: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: { precision: 0 }
                            }
                        }
                    }
                });
            }

            // C. Subject Feedback Submissions Bar Chart
            if (subjectCtx && data.subjectFeedbackCounts) {
                const subjects = Object.keys(data.subjectFeedbackCounts);
                const subCounts = Object.values(data.subjectFeedbackCounts);

                new Chart(subjectCtx, {
                    type: 'bar',
                    data: {
                        labels: subjects,
                        datasets: [{
                            label: 'Total Submissions Per Subject',
                            data: subCounts,
                            backgroundColor: '#8b5cf6',
                            borderRadius: 6
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: { precision: 0 }
                            }
                        }
                    }
                });
            }
        })
        .catch(err => console.error('Failed to load chart analytics data:', err));
}

/**
 * 4. Client-side Real-time Search Filter for Admin Data Tables
 */
function initTableSearch() {
    const searchInput = document.getElementById('tableSearchInput');
    const table = document.querySelector('.custom-table table');

    if (searchInput && table) {
        searchInput.addEventListener('keyup', function () {
            const query = this.value.toLowerCase().trim();
            const rows = table.querySelectorAll('tbody tr');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(query)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }
}

