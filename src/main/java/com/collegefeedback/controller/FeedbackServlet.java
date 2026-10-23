package com.collegefeedback.controller;

import com.collegefeedback.dao.FacultyDAO;
import com.collegefeedback.dao.FeedbackDAO;
import com.collegefeedback.model.Faculty;
import com.collegefeedback.model.Feedback;
import com.collegefeedback.model.Student;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // AJAX dynamic endpoint: Get faculty by department
        if ("getFacultyByDept".equalsIgnoreCase(action)) {
            String dept = request.getParameter("department");
            FacultyDAO facultyDAO = new FacultyDAO();
            List<Faculty> facultyList = facultyDAO.getFacultyByDepartment(dept);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(new Gson().toJson(facultyList));
            out.flush();
            return;
        }

        // Standard GET: Load Feedback page with departments list
        FacultyDAO facultyDAO = new FacultyDAO();
        List<String> departments = facultyDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/student/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Student currentStudent = (session != null) ? (Student) session.getAttribute("currentUser") : null;

        if (currentStudent == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String facultyIdStr = request.getParameter("facultyId");
        String ratingStr = request.getParameter("rating");
        String comments = request.getParameter("comments");

        if (facultyIdStr == null || facultyIdStr.isEmpty() || ratingStr == null || ratingStr.isEmpty()) {
            session.setAttribute("errorMessage", "Please select a faculty member and provide a rating.");
            response.sendRedirect(request.getContextPath() + "/feedback");
            return;
        }

        try {
            int facultyId = Integer.parseInt(facultyIdStr);
            int rating = Integer.parseInt(ratingStr);

            if (rating < 1 || rating > 5) {
                session.setAttribute("errorMessage", "Rating must be between 1 and 5 stars.");
                response.sendRedirect(request.getContextPath() + "/feedback");
                return;
            }

            FeedbackDAO feedbackDAO = new FeedbackDAO();

            Feedback feedback = new Feedback();
            feedback.setStudentId(currentStudent.getStudentId());
            feedback.setFacultyId(facultyId);
            feedback.setRating(rating);
            feedback.setComments(comments != null ? comments.trim() : "");

            boolean isAlreadySubmitted = feedbackDAO.hasAlreadySubmitted(currentStudent.getStudentId(), facultyId);
            boolean success = isAlreadySubmitted ? feedbackDAO.updateFeedback(feedback) : feedbackDAO.submitFeedback(feedback);

            if (success) {
                session.setAttribute("successMessage", isAlreadySubmitted 
                    ? "Feedback updated successfully! Thank you for your review." 
                    : "Feedback submitted successfully! Thank you for your review.");
                response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
            } else {
                session.setAttribute("errorMessage", "Failed to submit feedback due to a server error.");
                response.sendRedirect(request.getContextPath() + "/feedback");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid faculty or rating selection.");
            response.sendRedirect(request.getContextPath() + "/feedback");
        }
    }
}
