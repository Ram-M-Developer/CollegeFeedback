package com.collegefeedback.controller;

import com.collegefeedback.dao.AdminDAO;
import com.collegefeedback.dao.FacultyDAO;
import com.collegefeedback.dao.StudentDAO;
import com.collegefeedback.model.Admin;
import com.collegefeedback.model.Faculty;
import com.collegefeedback.model.Student;
import com.collegefeedback.util.DBConnection;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/faculty/login", "/student/login", "/admin/login"})
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        String url = context.getInitParameter("dbUrl");
        String user = context.getInitParameter("dbUser");
        String pass = context.getInitParameter("dbPassword");
        DBConnection.setCredentials(url, user, pass);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String emailOrUsername = request.getParameter("emailOrUsername");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (emailOrUsername == null || emailOrUsername.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);

        if ("STUDENT".equalsIgnoreCase(role)) {
            StudentDAO studentDAO = new StudentDAO();
            Student student = studentDAO.authenticate(emailOrUsername.trim(), password);

            if (student != null) {
                session.setAttribute("userRole", "STUDENT");
                session.setAttribute("currentUser", student);
                session.setAttribute("successMessage", "Welcome back, " + student.getStudentName() + "!");
                response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
                return;
            }
        } else if ("FACULTY".equalsIgnoreCase(role)) {
            FacultyDAO facultyDAO = new FacultyDAO();
            Faculty faculty = facultyDAO.authenticate(emailOrUsername.trim(), password);

            if (faculty != null) {
                session.setAttribute("userRole", "FACULTY");
                session.setAttribute("currentUser", faculty);
                session.setAttribute("successMessage", "Welcome back, Prof. " + faculty.getFacultyName() + "!");
                response.sendRedirect(request.getContextPath() + "/faculty/dashboard.jsp");
                return;
            }
        } else if ("ADMIN".equalsIgnoreCase(role)) {
            AdminDAO adminDAO = new AdminDAO();
            Admin admin = adminDAO.authenticate(emailOrUsername.trim(), password);

            if (admin != null) {
                session.setAttribute("userRole", "ADMIN");
                session.setAttribute("currentUser", admin);
                session.setAttribute("successMessage", "Admin login successful!");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                return;
            }
        }

        request.setAttribute("errorMessage", "Invalid " + role + " credentials! Please try again.");
        request.setAttribute("selectedRole", role);
        request.setAttribute("emailOrUsername", emailOrUsername);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
