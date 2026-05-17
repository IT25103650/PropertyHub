package com.realestate.models;

public class Buyer extends User {
    private String preferredLocations;

    public Buyer() {
        setRole("BUYER");
    }

    public Buyer(String userId, String name, String email, String password, String preferredLocations) {
        super(userId, name, email, password, "BUYER");
        this.preferredLocations = preferredLocations;
    }

    public String getPreferredLocations() {
        return preferredLocations;
    }

    public void setPreferredLocations(String preferredLocations) {
        this.preferredLocations = preferredLocations;
    }

    @Override
    public String displayDashboard() {
        // Polymorphism applied according to OOP assignment requirement Component 01
        return "redirect:/buyer-dashboard";
    }
}
