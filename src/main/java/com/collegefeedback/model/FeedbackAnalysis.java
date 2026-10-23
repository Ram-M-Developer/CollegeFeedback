package com.collegefeedback.model;

import java.io.Serializable;
import java.util.Map;

public class FeedbackAnalysis implements Serializable {
    private static final long serialVersionUID = 1L;

    private int totalStudents;
    private int totalFaculty;
    private int totalFeedbacks;
    private double overallAverageRating;

    private Map<String, Double> facultyAverageRatings;
    private Map<String, Integer> facultyFeedbackCounts;
    private Map<String, Double> departmentAverageRatings;
    private Map<String, Double> subjectAverageRatings;
    private Map<Integer, Integer> ratingDistribution; // 1 Star to 5 Star counts

    private int totalDepartments;
    private Map<String, Integer> departmentFeedbackCounts;
    private Map<String, Integer> subjectFeedbackCounts;

    public FeedbackAnalysis() {}

    public int getTotalDepartments() {
        return totalDepartments;
    }

    public void setTotalDepartments(int totalDepartments) {
        this.totalDepartments = totalDepartments;
    }

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    public int getTotalFaculty() {
        return totalFaculty;
    }

    public void setTotalFaculty(int totalFaculty) {
        this.totalFaculty = totalFaculty;
    }

    public int getTotalFeedbacks() {
        return totalFeedbacks;
    }

    public void setTotalFeedbacks(int totalFeedbacks) {
        this.totalFeedbacks = totalFeedbacks;
    }

    public double getOverallAverageRating() {
        return overallAverageRating;
    }

    public void setOverallAverageRating(double overallAverageRating) {
        this.overallAverageRating = overallAverageRating;
    }

    public Map<String, Double> getFacultyAverageRatings() {
        return facultyAverageRatings;
    }

    public void setFacultyAverageRatings(Map<String, Double> facultyAverageRatings) {
        this.facultyAverageRatings = facultyAverageRatings;
    }

    public Map<String, Integer> getFacultyFeedbackCounts() {
        return facultyFeedbackCounts;
    }

    public void setFacultyFeedbackCounts(Map<String, Integer> facultyFeedbackCounts) {
        this.facultyFeedbackCounts = facultyFeedbackCounts;
    }

    public Map<String, Integer> getDepartmentFeedbackCounts() {
        return departmentFeedbackCounts;
    }

    public void setDepartmentFeedbackCounts(Map<String, Integer> departmentFeedbackCounts) {
        this.departmentFeedbackCounts = departmentFeedbackCounts;
    }

    public Map<String, Integer> getSubjectFeedbackCounts() {
        return subjectFeedbackCounts;
    }

    public void setSubjectFeedbackCounts(Map<String, Integer> subjectFeedbackCounts) {
        this.subjectFeedbackCounts = subjectFeedbackCounts;
    }

    public Map<String, Double> getDepartmentAverageRatings() {
        return departmentAverageRatings;
    }

    public void setDepartmentAverageRatings(Map<String, Double> departmentAverageRatings) {
        this.departmentAverageRatings = departmentAverageRatings;
    }

    public Map<String, Double> getSubjectAverageRatings() {
        return subjectAverageRatings;
    }

    public void setSubjectAverageRatings(Map<String, Double> subjectAverageRatings) {
        this.subjectAverageRatings = subjectAverageRatings;
    }

    public Map<Integer, Integer> getRatingDistribution() {
        return ratingDistribution;
    }

    public void setRatingDistribution(Map<Integer, Integer> ratingDistribution) {
        this.ratingDistribution = ratingDistribution;
    }
}
