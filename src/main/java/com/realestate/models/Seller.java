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

