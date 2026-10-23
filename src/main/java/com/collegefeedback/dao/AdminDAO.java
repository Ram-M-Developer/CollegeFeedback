package com.collegefeedback.dao;

import com.collegefeedback.model.Admin;
import com.collegefeedback.util.DBConnection;
import com.collegefeedback.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {

    public Admin authenticate(String usernameOrEmail, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Admin admin = null;

        String sql = "SELECT * FROM admins WHERE username = ? OR email = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, usernameOrEmail);
            stmt.setString(2, usernameOrEmail);

            rs = stmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (PasswordUtil.checkPassword(password, storedPassword)) {
                    admin = new Admin(
                        rs.getInt("admin_id"),
                        rs.getString("username"),
                        storedPassword,
                        rs.getString("email")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return admin;
    }

    public Admin getById(int adminId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Admin admin = null;

        String sql = "SELECT * FROM admins WHERE admin_id = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, adminId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                admin = new Admin(
                    rs.getInt("admin_id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("email")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt, rs);
        }

        return admin;
    }

    public boolean updatePassword(int adminId, String newPassword) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean updated = false;

        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        String sql = "UPDATE admins SET password = ? WHERE admin_id = ?";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, adminId);

            int rows = stmt.executeUpdate();
            updated = (rows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, stmt);
        }

        return updated;
    }
}
