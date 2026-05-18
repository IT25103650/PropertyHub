package com.realestate.models;

public class Seller extends User {

    private String agencyName;

    // Implement Constructor
    public Seller() {
        setRole("SELLER");
    }

    public Seller(String userId, String name, String email, String password, String agencyName) {
        super(userId, name, email, password, "SELLER");
        this.agencyName = agencyName;
    }

    // Impelemnet Getters And Setters
    public String getAgencyName() {
        return agencyName;
    }

    public void setAgencyName(String agencyName) {
        this.agencyName = agencyName;
    }

    // Implement Display Details Method(Override)
    @Override
    public String displayDashboard() {
        // Polymorphism applied according to OOP assignment requirement Component 05
        return "redirect:/seller-dashboard";
    }
}

