package com.collegefeedback.controller;

import com.collegefeedback.dao.FeedbackDAO;
import com.collegefeedback.model.Feedback;
import com.collegefeedback.model.FeedbackAnalysis;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/report")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        FeedbackDAO feedbackDAO = new FeedbackDAO();

        if ("chartData".equalsIgnoreCase(action)) {
            FeedbackAnalysis analysis = feedbackDAO.getFeedbackAnalysis();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(new Gson().toJson(analysis));
            out.flush();
            return;
        }

        // Generate / View Filtered Reports
        String dept = request.getParameter("department");
        String facultyIdStr = request.getParameter("facultyId");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        Integer facultyId = (facultyIdStr != null && !facultyIdStr.isEmpty()) ? Integer.parseInt(facultyIdStr) : null;

        List<Feedback> filteredList = feedbackDAO.getFilteredFeedbacks(dept, facultyId, null, startDate, endDate);
        FeedbackAnalysis analysis = feedbackDAO.getFeedbackAnalysis();

        request.setAttribute("filteredFeedbacks", filteredList);
        request.setAttribute("analysis", analysis);
        request.setAttribute("selectedDept", dept);
        request.setAttribute("selectedFacultyId", facultyId);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
}
