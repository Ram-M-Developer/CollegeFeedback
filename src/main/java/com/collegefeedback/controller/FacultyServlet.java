package com.collegefeedback.controller;

import com.collegefeedback.dao.FacultyDAO;
import com.collegefeedback.dao.FeedbackDAO;
import com.collegefeedback.model.Faculty;
import com.collegefeedback.model.Feedback;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/faculty/action")
public class FacultyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("userRole") : null;

        FacultyDAO facultyDAO = new FacultyDAO();
        FeedbackDAO feedbackDAO = new FeedbackDAO();

        if ("FACULTY".equalsIgnoreCase(role)) {
            Faculty currentFaculty = (Faculty) session.getAttribute("currentUser");
            if (currentFaculty == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            if ("viewProfile".equalsIgnoreCase(action)) {
                request.getRequestDispatcher("/faculty/profile.jsp").forward(request, response);
            } else {
                // Faculty dashboard metrics
                double avgRating = feedbackDAO.getFacultyAverageRating(currentFaculty.getFacultyId());
                List<Feedback> feedbackList = feedbackDAO.getFeedbacksByFaculty(currentFaculty.getFacultyId());

                request.setAttribute("avgRating", avgRating);
                request.setAttribute("feedbackList", feedbackList);
                request.getRequestDispatcher("/faculty/dashboard.jsp").forward(request, response);
            }
            return;
        }

        // ADMIN Faculty CRUD GET actions
        if ("ADMIN".equalsIgnoreCase(role)) {
            if ("delete".equalsIgnoreCase(action)) {
                int facultyId = Integer.parseInt(request.getParameter("id"));
                boolean deleted = facultyDAO.deleteFaculty(facultyId);
                if (deleted) {
                    session.setAttribute("successMessage", "Faculty deleted successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to delete faculty.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/faculty.jsp");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("userRole") : null;

        FacultyDAO facultyDAO = new FacultyDAO();

        if ("ADMIN".equalsIgnoreCase(role)) {
            if ("add".equalsIgnoreCase(action)) {
                String name = request.getParameter("name");
                String department = request.getParameter("department");
                String subject = request.getParameter("subject");
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                if (facultyDAO.isEmailExists(email, 0)) {
                    session.setAttribute("errorMessage", "Faculty email already exists!");
                    response.sendRedirect(request.getContextPath() + "/admin/faculty.jsp");
                    return;
                }

                Faculty faculty = new Faculty();
                faculty.setFacultyName(name);
                faculty.setDepartment(department);
                faculty.setSubject(subject);
                faculty.setEmail(email);
                faculty.setPassword(password);

                boolean added = facultyDAO.addFaculty(faculty);
                if (added) {
                    session.setAttribute("successMessage", "Faculty member added successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to add faculty member.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/faculty.jsp");
            } else if ("edit".equalsIgnoreCase(action)) {
                int facultyId = Integer.parseInt(request.getParameter("facultyId"));
                String name = request.getParameter("name");
                String department = request.getParameter("department");
                String subject = request.getParameter("subject");
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                if (facultyDAO.isEmailExists(email, facultyId)) {
                    session.setAttribute("errorMessage", "Another faculty with this email already exists!");
                    response.sendRedirect(request.getContextPath() + "/admin/faculty.jsp");
                    return;
                }

                Faculty faculty = new Faculty();
                faculty.setFacultyId(facultyId);
                faculty.setFacultyName(name);
                faculty.setDepartment(department);
                faculty.setSubject(subject);
                faculty.setEmail(email);
                faculty.setPassword(password);

                boolean updated = facultyDAO.updateFaculty(faculty);
                if (updated) {
                    session.setAttribute("successMessage", "Faculty member updated successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to update faculty member.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/faculty.jsp");
            }
        }
    }
}
