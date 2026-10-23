package com.collegefeedback.dao;

import com.collegefeedback.model.Feedback;
import com.collegefeedback.model.FeedbackAnalysis;
import com.collegefeedback.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class FeedbackDAO {

    public boolean submitFeedback(Feedback feedback) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        String sql = "INSERT INTO feedback (student_id, faculty_id, rating, comments, feedback_date) VALUES (?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, feedback.getStudentId());
            stmt.setInt(2, feedback.getFacultyId());
            stmt.setInt(3, feedback.getRating());
            stmt.setString(4, feedback.getComments());
            stmt.setDate(5, new Date(System.currentTimeMillis()));

            int rows = stmt.executeUpdate();
            success = (rows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt);
        }

        return success;
    }

    public boolean updateFeedback(Feedback feedback) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        String sql = "UPDATE feedback SET rating = ?, comments = ?, feedback_date = ? WHERE student_id = ? AND faculty_id = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, feedback.getRating());
            stmt.setString(2, feedback.getComments());
            stmt.setDate(3, new Date(System.currentTimeMillis()));
            stmt.setInt(4, feedback.getStudentId());
            stmt.setInt(5, feedback.getFacultyId());

            int rows = stmt.executeUpdate();
            success = (rows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt);
        }

        return success;
    }

    public boolean hasAlreadySubmitted(int studentId, int facultyId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean exists = false;

        String sql = "SELECT COUNT(*) FROM feedback WHERE student_id = ? AND faculty_id = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            stmt.setInt(2, facultyId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return exists;
    }

    public List<Feedback> getFeedbacksByStudent(int studentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Feedback> list = new ArrayList<>();

        String sql = "SELECT f.*, s.student_name, s.reg_no, fac.faculty_name, fac.department, fac.subject " +
                     "FROM feedback f " +
                     "JOIN students s ON f.student_id = s.student_id " +
                     "JOIN faculty fac ON f.faculty_id = fac.faculty_id " +
                     "WHERE f.student_id = ? " +
                     "ORDER BY f.feedback_date DESC, f.feedback_id DESC";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return list;
    }

    public List<Feedback> getFeedbacksByFaculty(int facultyId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Feedback> list = new ArrayList<>();

        String sql = "SELECT f.*, s.student_name, s.reg_no, fac.faculty_name, fac.department, fac.subject " +
                     "FROM feedback f " +
                     "JOIN students s ON f.student_id = s.student_id " +
                     "JOIN faculty fac ON f.faculty_id = fac.faculty_id " +
                     "WHERE f.faculty_id = ? " +
                     "ORDER BY f.feedback_date DESC, f.feedback_id DESC";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, facultyId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return list;
    }

    public List<Feedback> getFilteredFeedbacks(String department, Integer facultyId, Integer rating, String startDate, String endDate) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Feedback> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT f.*, s.student_name, s.reg_no, fac.faculty_name, fac.department, fac.subject " +
            "FROM feedback f " +
            "JOIN students s ON f.student_id = s.student_id " +
            "JOIN faculty fac ON f.faculty_id = fac.faculty_id WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (department != null && !department.trim().isEmpty() && !"ALL".equalsIgnoreCase(department)) {
            sql.append("AND fac.department = ? ");
            params.add(department);
        }
        if (facultyId != null && facultyId > 0) {
            sql.append("AND f.faculty_id = ? ");
            params.add(facultyId);
        }
        if (rating != null && rating > 0) {
            sql.append("AND f.rating = ? ");
            params.add(rating);
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND f.feedback_date >= ? ");
            params.add(Date.valueOf(startDate));
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND f.feedback_date <= ? ");
            params.add(Date.valueOf(endDate));
        }

        sql.append("ORDER BY f.feedback_date DESC, f.feedback_id DESC");

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return list;
    }

    public FeedbackAnalysis getFeedbackAnalysis() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        FeedbackAnalysis analysis = new FeedbackAnalysis();

        StudentDAO studentDAO = new StudentDAO();
        FacultyDAO facultyDAO = new FacultyDAO();
        analysis.setTotalStudents(studentDAO.getTotalStudentsCount());
        analysis.setTotalFaculty(facultyDAO.getTotalFacultyCount());

        try {
            conn = DBConnection.getConnection();

            // 1. Overall stats
            String overallSql = "SELECT COUNT(*), COALESCE(AVG(rating), 0) FROM feedback";
            stmt = conn.prepareStatement(overallSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                analysis.setTotalFeedbacks(rs.getInt(1));
                analysis.setOverallAverageRating(Math.round(rs.getDouble(2) * 100.0) / 100.0);
            }
            rs.close();
            stmt.close();

            // 2. Faculty Average Ratings & Counts
            String facSql = "SELECT fac.faculty_name, COALESCE(AVG(f.rating), 0) as avg_rating, COUNT(f.feedback_id) as f_count " +
                            "FROM faculty fac LEFT JOIN feedback f ON fac.faculty_id = f.faculty_id " +
                            "GROUP BY fac.faculty_id, fac.faculty_name ORDER BY avg_rating DESC";
            stmt = conn.prepareStatement(facSql);
            rs = stmt.executeQuery();
            Map<String, Double> facAvgMap = new LinkedHashMap<>();
            Map<String, Integer> facCountMap = new LinkedHashMap<>();
            while (rs.next()) {
                String name = rs.getString("faculty_name");
                facAvgMap.put(name, Math.round(rs.getDouble("avg_rating") * 100.0) / 100.0);
                facCountMap.put(name, rs.getInt("f_count"));
            }
            analysis.setFacultyAverageRatings(facAvgMap);
            analysis.setFacultyFeedbackCounts(facCountMap);
            rs.close();
            stmt.close();

            // 3. Department Feedback Counts & Average
            String deptSql = "SELECT fac.department, COALESCE(AVG(f.rating), 0) as avg_rating, COUNT(f.feedback_id) as f_count " +
                             "FROM faculty fac LEFT JOIN feedback f ON fac.faculty_id = f.faculty_id " +
                             "GROUP BY fac.department ORDER BY f_count DESC";
            stmt = conn.prepareStatement(deptSql);
            rs = stmt.executeQuery();
            Map<String, Double> deptAvgMap = new LinkedHashMap<>();
            Map<String, Integer> deptCountMap = new LinkedHashMap<>();
            while (rs.next()) {
                String deptName = rs.getString("department");
                deptAvgMap.put(deptName, Math.round(rs.getDouble("avg_rating") * 100.0) / 100.0);
                deptCountMap.put(deptName, rs.getInt("f_count"));
            }
            analysis.setDepartmentAverageRatings(deptAvgMap);
            analysis.setDepartmentFeedbackCounts(deptCountMap);
            analysis.setTotalDepartments(deptCountMap.size());
            rs.close();
            stmt.close();

            // 4. Subject Feedback Counts & Average
            String subSql = "SELECT fac.subject, COALESCE(AVG(f.rating), 0) as avg_rating, COUNT(f.feedback_id) as f_count " +
                            "FROM faculty fac LEFT JOIN feedback f ON fac.faculty_id = f.faculty_id " +
                            "GROUP BY fac.subject ORDER BY f_count DESC";
            stmt = conn.prepareStatement(subSql);
            rs = stmt.executeQuery();
            Map<String, Double> subAvgMap = new LinkedHashMap<>();
            Map<String, Integer> subCountMap = new LinkedHashMap<>();
            while (rs.next()) {
                String subName = rs.getString("subject");
                subAvgMap.put(subName, Math.round(rs.getDouble("avg_rating") * 100.0) / 100.0);
                subCountMap.put(subName, rs.getInt("f_count"));
            }
            analysis.setSubjectAverageRatings(subAvgMap);
            analysis.setSubjectFeedbackCounts(subCountMap);
            rs.close();
            stmt.close();

            // 5. Rating Distribution (1 to 5 Stars)
            String distSql = "SELECT rating, COUNT(*) as count FROM feedback GROUP BY rating";
            stmt = conn.prepareStatement(distSql);
            rs = stmt.executeQuery();
            Map<Integer, Integer> distMap = new LinkedHashMap<>();
            for (int i = 1; i <= 5; i++) {
                distMap.put(i, 0);
            }
            while (rs.next()) {
                distMap.put(rs.getInt("rating"), rs.getInt("count"));
            }
            analysis.setRatingDistribution(distMap);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return analysis;
    }

    public double getFacultyAverageRating(int facultyId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        double avg = 0.0;

        String sql = "SELECT COALESCE(AVG(rating), 0) FROM feedback WHERE faculty_id = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, facultyId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                avg = Math.round(rs.getDouble(1) * 100.0) / 100.0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return avg;
    }

    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback f = new Feedback(
            rs.getInt("feedback_id"),
            rs.getInt("student_id"),
            rs.getInt("faculty_id"),
            rs.getInt("rating"),
            rs.getString("comments"),
            rs.getDate("feedback_date")
        );
        f.setStudentName(rs.getString("student_name"));
        f.setStudentRegNo(rs.getString("reg_no"));
        f.setFacultyName(rs.getString("faculty_name"));
        f.setDepartment(rs.getString("department"));
        f.setSubject(rs.getString("subject"));
        return f;
    }
}
