package com.collegefeedback.dao;

import com.collegefeedback.model.Faculty;
import com.collegefeedback.util.DBConnection;
import com.collegefeedback.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FacultyDAO {

    public Faculty authenticate(String email, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Faculty faculty = null;

        String sql = "SELECT * FROM faculty WHERE email = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (storedPassword != null && PasswordUtil.checkPassword(password, storedPassword)) {
                    faculty = mapResultSetToFaculty(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return faculty;
    }

    public boolean addFaculty(Faculty faculty) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        String hashedPassword = PasswordUtil.hashPassword(faculty.getPassword() != null ? faculty.getPassword() : "faculty123");
        String sql = "INSERT INTO faculty (faculty_name, department, subject, email, password) VALUES (?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, faculty.getFacultyName());
            stmt.setString(2, faculty.getDepartment());
            stmt.setString(3, faculty.getSubject());
            stmt.setString(4, faculty.getEmail());
            stmt.setString(5, hashedPassword);

            int rows = stmt.executeUpdate();
            success = (rows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt);
        }

        return success;
    }

    public boolean isEmailExists(String email, int excludeFacultyId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean exists = false;

        String sql = "SELECT COUNT(*) FROM faculty WHERE email = ? AND faculty_id != ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setInt(2, excludeFacultyId);
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

    public Faculty getById(int facultyId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Faculty faculty = null;

        String sql = "SELECT * FROM faculty WHERE faculty_id = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, facultyId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                faculty = mapResultSetToFaculty(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return faculty;
    }

    public List<Faculty> getAllFaculty() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Faculty> list = new ArrayList<>();

        String sql = "SELECT * FROM faculty ORDER BY faculty_name ASC";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToFaculty(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return list;
    }

    public List<Faculty> getFacultyByDepartment(String department) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Faculty> list = new ArrayList<>();

        String sql = "SELECT * FROM faculty WHERE department = ? ORDER BY faculty_name ASC";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, department);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToFaculty(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return list;
    }

    public List<String> getAllDepartments() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<String> list = new ArrayList<>();

        String sql = "SELECT DISTINCT department FROM faculty ORDER BY department ASC";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("department"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return list;
    }

    public boolean updateFaculty(Faculty faculty) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        String sql;
        if (faculty.getPassword() != null && !faculty.getPassword().trim().isEmpty()) {
            sql = "UPDATE faculty SET faculty_name=?, department=?, subject=?, email=?, password=? WHERE faculty_id=?";
        } else {
            sql = "UPDATE faculty SET faculty_name=?, department=?, subject=?, email=? WHERE faculty_id=?";
        }

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, faculty.getFacultyName());
            stmt.setString(2, faculty.getDepartment());
            stmt.setString(3, faculty.getSubject());
            stmt.setString(4, faculty.getEmail());

            if (faculty.getPassword() != null && !faculty.getPassword().trim().isEmpty()) {
                stmt.setString(5, PasswordUtil.hashPassword(faculty.getPassword()));
                stmt.setInt(6, faculty.getFacultyId());
            } else {
                stmt.setInt(5, faculty.getFacultyId());
            }

            int rows = stmt.executeUpdate();
            success = (rows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt);
        }

        return success;
    }

    public boolean deleteFaculty(int facultyId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        String sql = "DELETE FROM faculty WHERE faculty_id = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, facultyId);

            int rows = stmt.executeUpdate();
            success = (rows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt);
        }

        return success;
    }

    public int getTotalFacultyCount() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int count = 0;

        String sql = "SELECT COUNT(*) FROM faculty";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return count;
    }

    private Faculty mapResultSetToFaculty(ResultSet rs) throws SQLException {
        return new Faculty(
            rs.getInt("faculty_id"),
            rs.getString("faculty_name"),
            rs.getString("department"),
            rs.getString("subject"),
            rs.getString("email"),
            rs.getString("password"),
            rs.getTimestamp("created_at")
        );
    }
}
