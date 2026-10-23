package com.collegefeedback.controller;

import com.collegefeedback.dao.AdminDAO;
import com.collegefeedback.dao.FacultyDAO;
import com.collegefeedback.dao.StudentDAO;
import com.collegefeedback.model.Admin;
import com.collegefeedback.model.Faculty;
import com.collegefeedback.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/action")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        StudentDAO studentDAO = new StudentDAO();

        if ("deleteStudent".equalsIgnoreCase(action)) {
            int studentId = Integer.parseInt(request.getParameter("id"));
            boolean deleted = studentDAO.deleteStudent(studentId);

            if (deleted) {
                session.setAttribute("successMessage", "Student record deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete student record.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/students.jsp");
            return;
        }

        if ("deleteFaculty".equalsIgnoreCase(action) || "delete".equalsIgnoreCase(action)) {
            int facultyId = Integer.parseInt(request.getParameter("id"));
            FacultyDAO facultyDAO = new FacultyDAO();
            boolean deleted = facultyDAO.deleteFaculty(facultyId);

            if (deleted) {
                session.setAttribute("successMessage", "Faculty member deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete faculty member.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/faculty.jsp");
            return;
        }

        if ("viewProfile".equalsIgnoreCase(action)) {
            request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        System.out.println(">>> AdminServlet doPost called. action=[" + action + "]");

        if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        StudentDAO studentDAO = new StudentDAO();

        if ("addStudent".equalsIgnoreCase(action)) {
            String regNo = request.getParameter("regNo");
            String name = request.getParameter("name");
            String department = request.getParameter("department");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (studentDAO.isRegNoExists(regNo, 0)) {
                session.setAttribute("errorMessage", "Register Number already exists!");
                response.sendRedirect(request.getContextPath() + "/admin/students.jsp");
                return;
            }

            if (studentDAO.isEmailExists(email, 0)) {
                session.setAttribute("errorMessage", "Student email already exists!");
                response.sendRedirect(request.getContextPath() + "/admin/students.jsp");
                return;
            }

            Student student = new Student();
            student.setRegNo(regNo);
            student.setStudentName(name);
            student.setDepartment(department);
            student.setEmail(email);
            student.setPassword(password != null ? password : "student123");

            boolean success = studentDAO.registerStudent(student);
            if (success) {
                session.setAttribute("successMessage", "Student added successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to add student.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/students.jsp");

        } else if ("editStudent".equalsIgnoreCase(action)) {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String regNo = request.getParameter("regNo");
            String name = request.getParameter("name");
            String department = request.getParameter("department");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (studentDAO.isRegNoExists(regNo, studentId)) {
                session.setAttribute("errorMessage", "Register Number belongs to another student!");
                response.sendRedirect(request.getContextPath() + "/admin/students.jsp");
                return;
            }

            if (studentDAO.isEmailExists(email, studentId)) {
                session.setAttribute("errorMessage", "Email belongs to another student!");
                response.sendRedirect(request.getContextPath() + "/admin/students.jsp");
                return;
            }

            Student student = new Student();
            student.setStudentId(studentId);
            student.setRegNo(regNo);
            student.setStudentName(name);
            student.setDepartment(department);
            student.setEmail(email);
            student.setPassword(password);

            boolean updated = studentDAO.updateStudent(student);
            if (updated) {
                session.setAttribute("successMessage", "Student record updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update student record.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/students.jsp");

        } else if ("addFaculty".equalsIgnoreCase(action) || "add".equalsIgnoreCase(action)) {
            String name = request.getParameter("name");
            String department = request.getParameter("department");
            String subject = request.getParameter("subject");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            FacultyDAO facultyDAO = new FacultyDAO();
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
            faculty.setPassword(password != null && !password.trim().isEmpty() ? password : "faculty123");

            boolean added = facultyDAO.addFaculty(faculty);
            if (added) {
                session.setAttribute("successMessage", "Faculty member added successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to add faculty member.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/faculty.jsp");
            return;

        } else if ("editFaculty".equalsIgnoreCase(action) || "edit".equalsIgnoreCase(action)) {
            int facultyId = Integer.parseInt(request.getParameter("facultyId"));
            String name = request.getParameter("name");
            String department = request.getParameter("department");
            String subject = request.getParameter("subject");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            FacultyDAO facultyDAO = new FacultyDAO();
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
            return;

        } else if ("updateAdminPassword".equalsIgnoreCase(action)) {
            Admin currentAdmin = (Admin) session.getAttribute("currentUser");
            String newPassword = request.getParameter("newPassword");

            AdminDAO adminDAO = new AdminDAO();
            boolean updated = adminDAO.updatePassword(currentAdmin.getAdminId(), newPassword);
            if (updated) {
                session.setAttribute("successMessage", "Admin password updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update admin password.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/profile.jsp");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
    }
}
