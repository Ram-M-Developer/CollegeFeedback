package com.collegefeedback.controller;

import com.collegefeedback.dao.FeedbackDAO;
import com.collegefeedback.dao.StudentDAO;
import com.collegefeedback.model.Feedback;
import com.collegefeedback.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/action")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("currentUser") : null;

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("viewProfile".equalsIgnoreCase(action)) {
            StudentDAO dao = new StudentDAO();
            Student updatedStudent = dao.getById(student.getStudentId());
            if (updatedStudent != null) {
                session.setAttribute("currentUser", updatedStudent);
            }
            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
        } else {
            // Load dashboard feedbacks
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            List<Feedback> myFeedbacks = feedbackDAO.getFeedbacksByStudent(student.getStudentId());
            request.setAttribute("myFeedbacks", myFeedbacks);
            request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("currentUser") : null;

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("updateProfile".equalsIgnoreCase(action)) {
            String name = request.getParameter("name");
            String department = request.getParameter("department");
            String password = request.getParameter("password");

            StudentDAO dao = new StudentDAO();
            student.setStudentName(name);
            student.setDepartment(department);
            if (password != null && !password.trim().isEmpty()) {
                student.setPassword(password);
            }

            boolean updated = dao.updateStudent(student);
            if (updated) {
                session.setAttribute("currentUser", dao.getById(student.getStudentId()));
                session.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Profile update failed.");
            }
            response.sendRedirect(request.getContextPath() + "/student/profile.jsp");
        }
    }
}
