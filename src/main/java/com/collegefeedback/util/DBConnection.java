package com.collegefeedback.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {

    private static String dbUrl = "jdbc:mysql://localhost:3306/college_feedback?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static String dbUser = "root";
    private static String dbPassword = "NewPassword123";

    private static boolean useFallbackH2 = false;
    private static boolean h2Initialized = false;

    // H2 Embedded fallback connection string (MySQL Mode)
    private static final String H2_URL = "jdbc:h2:file:./database/h2_college_feedback;MODE=MySQL;DATABASE_TO_LOWER=TRUE;AUTO_SERVER=TRUE;CASE_INSENSITIVE_IDENTIFIERS=TRUE";
    private static final String H2_USER = "sa";
    private static final String H2_PASSWORD = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found.");
        }
        try {
            Class.forName("org.h2.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("H2 Driver not found.");
        }
    }

    public static void setCredentials(String url, String user, String password) {
        if (url != null && !url.trim().isEmpty()) dbUrl = url;
        if (user != null && !user.trim().isEmpty()) dbUser = user;
        if (password != null) dbPassword = password;
    }

    public static Connection getConnection() throws SQLException {
        if (!useFallbackH2) {
            try {
                return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            } catch (SQLException mysqlEx) {
                System.err.println("[DBConnection] MySQL Connection Failed (" + mysqlEx.getMessage() + "). Switching to H2 Embedded Database Fallback.");
                useFallbackH2 = true;
            }
        }

        // H2 Fallback Connection
        Connection conn = DriverManager.getConnection(H2_URL, H2_USER, H2_PASSWORD);

        if (!h2Initialized) {
            synchronized (DBConnection.class) {
                if (!h2Initialized) {
                    initH2DatabaseSchema(conn);
                    h2Initialized = true;
                }
            }
        }

        return conn;
    }

    private static void initH2DatabaseSchema(Connection conn) {
        System.out.println("[DBConnection] Initializing H2 Schema & Seed Data...");
        Statement stmt = null;
        try {
            stmt = conn.createStatement();

            // Check if tables already exist
            ResultSet rs = conn.getMetaData().getTables(null, null, "%", new String[]{"TABLE"});
            boolean tableExists = false;
            while (rs.next()) {
                String tableName = rs.getString("TABLE_NAME");
                if ("students".equalsIgnoreCase(tableName)) {
                    tableExists = true;
                    break;
                }
            }
            rs.close();
            if (tableExists) {
                return; // Tables already populated
            }

            // Execute SQL statements
            stmt.execute("CREATE TABLE IF NOT EXISTS admins (admin_id INT PRIMARY KEY AUTO_INCREMENT, username VARCHAR(50) UNIQUE NOT NULL, password VARCHAR(255) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL);");
            stmt.execute("CREATE TABLE IF NOT EXISTS students (student_id INT PRIMARY KEY AUTO_INCREMENT, reg_no VARCHAR(20) UNIQUE NOT NULL, student_name VARCHAR(100) NOT NULL, department VARCHAR(50) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL, password VARCHAR(255) NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);");
            stmt.execute("CREATE TABLE IF NOT EXISTS faculty (faculty_id INT PRIMARY KEY AUTO_INCREMENT, faculty_name VARCHAR(100) NOT NULL, department VARCHAR(50) NOT NULL, subject VARCHAR(100) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL, password VARCHAR(255), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);");
            stmt.execute("CREATE TABLE IF NOT EXISTS feedback (feedback_id INT PRIMARY KEY AUTO_INCREMENT, student_id INT NOT NULL, faculty_id INT NOT NULL, rating INT NOT NULL, comments TEXT, feedback_date DATE NOT NULL);");

            // Seed Admin
            stmt.execute("INSERT INTO admins (username, password, email) VALUES ('admin', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si', 'admin@college.edu');");

            // Seed Faculty
            stmt.execute("INSERT INTO faculty (faculty_name, department, subject, email, password) VALUES " +
                "('Dr. Robert Smith', 'Computer Science', 'Data Structures & Algorithms', 'robert.smith@college.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'), " +
                "('Prof. Alice Johnson', 'Computer Science', 'Database Management Systems', 'alice.johnson@college.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'), " +
                "('Dr. Michael Brown', 'Electrical Engineering', 'Control Systems', 'michael.brown@college.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'), " +
                "('Prof. Sarah Davis', 'Mechanical Engineering', 'Thermodynamics', 'sarah.davis@college.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'), " +
                "('Dr. David Wilson', 'Information Technology', 'Web Technologies', 'david.wilson@college.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si');");

            // Seed Students
            stmt.execute("INSERT INTO students (reg_no, student_name, department, email, password) VALUES " +
                "('CS2023001', 'John Doe', 'Computer Science', 'student@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'), " +
                "('CS2023002', 'Emma Watson', 'Computer Science', 'emma.w@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'), " +
                "('EE2023001', 'James Miller', 'Electrical Engineering', 'james.m@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'), " +
                "('ME2023001', 'Sophia Taylor', 'Mechanical Engineering', 'sophia.t@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'), " +
                "('IT2023001', 'Daniel Anderson', 'Information Technology', 'daniel.a@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'), " +
                "('CS2023003', 'Olivia Martin', 'Computer Science', 'olivia.m@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si');");

            // Seed Feedback
            stmt.execute("INSERT INTO feedback (student_id, faculty_id, rating, comments, feedback_date) VALUES " +
                "(1, 1, 5, 'Exceptional teaching methods! Explains complex data structures clearly.', '2026-08-15'), " +
                "(1, 2, 4, 'Great DBMS course. Hands-on SQL queries were very helpful.', '2026-08-16'), " +
                "(2, 1, 5, 'Dr. Smith is very supportive during doubt sessions.', '2026-08-20'), " +
                "(2, 2, 3, 'Good lectures, need more practical database optimization examples.', '2026-08-21'), " +
                "(3, 3, 4, 'Dr. Michael explains Control Systems concepts clearly.', '2026-08-22'), " +
                "(4, 4, 5, 'Thermodynamics lab experiments were well organized.', '2026-08-25'), " +
                "(5, 5, 5, 'Dr. Wilson taught modern web frameworks very effectively!', '2026-08-28'), " +
                "(6, 1, 4, 'Very knowledgeable professor. Assignments are good.', '2026-09-01'), " +
                "(6, 5, 5, 'Best web tech lab sessions ever.', '2026-09-02');");

            System.out.println("[DBConnection] H2 Database Schema & Seeds Successfully Loaded!");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (stmt != null) {
                try { stmt.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public static void close(Connection conn, PreparedStatement stmt, ResultSet rs) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (stmt != null) {
            try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public static void close(Connection conn, PreparedStatement stmt) {
        close(conn, stmt, null);
    }
}
