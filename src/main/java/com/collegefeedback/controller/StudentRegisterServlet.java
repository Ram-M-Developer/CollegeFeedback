package com.collegefeedback.controller;

import com.collegefeedback.dao.StudentDAO;
import com.collegefeedback.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class StudentRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String regNo = request.getParameter("regNo");
        String name = request.getParameter("name");
        String department = request.getParameter("department");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (regNo == null || regNo.trim().isEmpty() ||
            name == null || name.trim().isEmpty() ||
            department == null || department.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required!");
            preserveFormFields(request, regNo, name, department, email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            preserveFormFields(request, regNo, name, department, email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        StudentDAO studentDAO = new StudentDAO();

        if (studentDAO.isRegNoExists(regNo.trim(), 0)) {
            request.setAttribute("errorMessage", "Register Number already exists! Please check your registration number.");
            preserveFormFields(request, regNo, name, department, email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (studentDAO.isEmailExists(email.trim(), 0)) {
            request.setAttribute("errorMessage", "Email address is already registered!");
            preserveFormFields(request, regNo, name, department, email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        Student student = new Student();
        student.setRegNo(regNo.trim());
        student.setStudentName(name.trim());
        student.setDepartment(department.trim());
        student.setEmail(email.trim());
        student.setPassword(password.trim());

        boolean success = studentDAO.registerStudent(student);

        if (success) {
            request.getSession().setAttribute("successMessage", "Registration successful! You can now log in.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            request.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
            preserveFormFields(request, regNo, name, department, email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void preserveFormFields(HttpServletRequest req, String regNo, String name, String department, String email) {
        req.setAttribute("regNo", regNo);
        req.setAttribute("name", name);
        req.setAttribute("department", department);
        req.setAttribute("email", email);
    }
}
