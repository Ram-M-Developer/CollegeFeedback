package com.collegefeedback.dao;

import com.collegefeedback.model.Student;
import com.collegefeedback.util.DBConnection;
import com.collegefeedback.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public Student authenticate(String email, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Student student = null;

        String sql = "SELECT * FROM students WHERE email = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);

            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (PasswordUtil.checkPassword(password, storedPassword)) {
                    student = mapResultSetToStudent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return student;
    }

    public boolean registerStudent(Student student) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        String hashedPassword = PasswordUtil.hashPassword(student.getPassword());
        String sql = "INSERT INTO students (reg_no, student_name, department, email, password) VALUES (?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, student.getRegNo());
            stmt.setString(2, student.getStudentName());
            stmt.setString(3, student.getDepartment());
            stmt.setString(4, student.getEmail());
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

    public boolean isRegNoExists(String regNo, int excludeStudentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean exists = false;

        String sql = "SELECT COUNT(*) FROM students WHERE reg_no = ? AND student_id != ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, regNo);
            stmt.setInt(2, excludeStudentId);
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

    public boolean isEmailExists(String email, int excludeStudentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean exists = false;

        String sql = "SELECT COUNT(*) FROM students WHERE email = ? AND student_id != ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setInt(2, excludeStudentId);
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

    public Student getById(int studentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Student student = null;

        String sql = "SELECT * FROM students WHERE student_id = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                student = mapResultSetToStudent(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return student;
    }

    public List<Student> getAllStudents() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Student> list = new ArrayList<>();

        String sql = "SELECT * FROM students ORDER BY student_id DESC";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToStudent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return list;
    }

    public boolean updateStudent(Student student) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        String sql;
        if (student.getPassword() != null && !student.getPassword().trim().isEmpty()) {
            sql = "UPDATE students SET reg_no=?, student_name=?, department=?, email=?, password=? WHERE student_id=?";
        } else {
            sql = "UPDATE students SET reg_no=?, student_name=?, department=?, email=? WHERE student_id=?";
        }

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, student.getRegNo());
            stmt.setString(2, student.getStudentName());
            stmt.setString(3, student.getDepartment());
            stmt.setString(4, student.getEmail());

            if (student.getPassword() != null && !student.getPassword().trim().isEmpty()) {
                stmt.setString(5, PasswordUtil.hashPassword(student.getPassword()));
                stmt.setInt(6, student.getStudentId());
            } else {
                stmt.setInt(5, student.getStudentId());
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

    public boolean deleteStudent(int studentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        String sql = "DELETE FROM students WHERE student_id = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);

            int rows = stmt.executeUpdate();
            success = (rows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt);
        }

        return success;
    }

    public int getTotalStudentsCount() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int count = 0;

        String sql = "SELECT COUNT(*) FROM students";

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

    private Student mapResultSetToStudent(ResultSet rs) throws SQLException {
        return new Student(
            rs.getInt("student_id"),
            rs.getString("reg_no"),
            rs.getString("student_name"),
            rs.getString("department"),
            rs.getString("email"),
            rs.getString("password"),
            rs.getTimestamp("created_at")
        );
    }
}
