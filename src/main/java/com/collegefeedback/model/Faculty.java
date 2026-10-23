package com.collegefeedback.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Faculty implements Serializable {
    private static final long serialVersionUID = 1L;

    private int facultyId;
    private String facultyName;
    private String department;
    private String subject;
    private String email;
    private String password;
    private Timestamp createdAt;

    public Faculty() {}

    public Faculty(int facultyId, String facultyName, String department, String subject, String email, String password, Timestamp createdAt) {
        this.facultyId = facultyId;
        this.facultyName = facultyName;
        this.department = department;
        this.subject = subject;
        this.email = email;
        this.password = password;
        this.createdAt = createdAt;
    }

    public int getFacultyId() {
        return facultyId;
    }

    public void setFacultyId(int facultyId) {
        this.facultyId = facultyId;
    }

    public String getFacultyName() {
        return facultyName;
    }

    public void setFacultyName(String facultyName) {
        this.facultyName = facultyName;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
