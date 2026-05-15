package com.realestate.platform.models;

public abstract class Report {
    private String reportId;
    private String generatedBy;
    private String generatedAt;

    public Report() {}

    public Report(String reportId, String generatedBy, String generatedAt) {
        this.reportId = reportId;
        this.generatedBy = generatedBy;
        this.generatedAt = generatedAt;
    }

    public String getReportId() { return reportId; }
    public void setReportId(String reportId) { this.reportId = reportId; }

    public String getGeneratedBy() { return generatedBy; }
    public void setGeneratedBy(String generatedBy) { this.generatedBy = generatedBy; }

    public String getGeneratedAt() { return generatedAt; }
    public void setGeneratedAt(String generatedAt) { this.generatedAt = generatedAt; }

    public abstract void generateReport();
}
