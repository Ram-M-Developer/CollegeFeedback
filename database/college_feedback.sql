-- College Feedback Management System Database Schema & Initial Data

CREATE DATABASE IF NOT EXISTS college_feedback;
USE college_feedback;

-- Drop existing tables if re-running script
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS faculty;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS admins;

-- TABLE: admins
CREATE TABLE admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- TABLE: students
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    reg_no VARCHAR(20) UNIQUE NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLE: faculty
CREATE TABLE faculty (
    faculty_id INT PRIMARY KEY AUTO_INCREMENT,
    faculty_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABLE: feedback
CREATE TABLE feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    faculty_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comments TEXT,
    feedback_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE CASCADE,
    CONSTRAINT unique_student_faculty_subject UNIQUE (student_id, faculty_id)
);

-- ========================================================
-- SAMPLE SEED DATA
-- Passwords below work with standard plain text or BCrypt
-- Admin: admin / admin123
-- Faculty: email / faculty123
-- Student: email / student123
-- ========================================================

-- Insert Sample Admin
INSERT INTO admins (username, password, email) VALUES
('admin', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si', 'admin@college.edu');

-- Insert Sample Faculty
INSERT INTO faculty (faculty_name, department, subject, email, password) VALUES
('Dr. Robert Smith', 'Computer Science', 'Data Structures & Algorithms', 'robert.smith@college.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'),
('Prof. Alice Johnson', 'Computer Science', 'Database Management Systems', 'alice.johnson@college.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'),
('Dr. Michael Brown', 'Electrical Engineering', 'Control Systems', 'michael.brown@college.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'),
('Prof. Sarah Davis', 'Mechanical Engineering', 'Thermodynamics', 'sarah.davis@college.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'),
('Dr. David Wilson', 'Information Technology', 'Web Technologies', 'david.wilson@college.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si');

-- Insert Sample Students
INSERT INTO students (reg_no, student_name, department, email, password) VALUES
('CS2023001', 'John Doe', 'Computer Science', 'student@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'),
('CS2023002', 'Emma Watson', 'Computer Science', 'emma.w@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'),
('EE2023001', 'James Miller', 'Electrical Engineering', 'james.m@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'),
('ME2023001', 'Sophia Taylor', 'Mechanical Engineering', 'sophia.t@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'),
('IT2023001', 'Daniel Anderson', 'Information Technology', 'daniel.a@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si'),
('CS2023003', 'Olivia Martin', 'Computer Science', 'olivia.m@gmail.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQiy.Si');

-- Insert Sample Feedback
INSERT INTO feedback (student_id, faculty_id, rating, comments, feedback_date) VALUES
(1, 1, 5, 'Exceptional teaching methods! Explains complex data structures with clear real-world examples.', '2026-08-15'),
(1, 2, 4, 'Great DBMS course. Hands-on SQL queries in lab were very helpful.', '2026-08-16'),
(2, 1, 5, 'Dr. Smith is very supportive during doubt sessions and clarifies all queries.', '2026-08-20'),
(2, 2, 3, 'Good lectures, but need more practical database optimization examples.', '2026-08-21'),
(3, 3, 4, 'Dr. Michael explains Control Systems concepts clearly with detailed derivations.', '2026-08-22'),
(4, 4, 5, 'Thermodynamics lab experiments were well organized by Prof. Sarah.', '2026-08-25'),
(5, 5, 5, 'Dr. Wilson taught modern web frameworks very effectively!', '2026-08-28'),
(6, 1, 4, 'Very knowledgeable professor. Class assignments are challenging and good.', '2026-09-01'),
(6, 5, 5, 'Best web tech lab sessions ever. Very encouraging environment.', '2026-09-02');
