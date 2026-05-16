package com.realestate.models;

/**
 * Represents a user who operates both as a Buyer AND a Seller.
 * Inherits the full chain: Person → User → BuyerSeller
 * Combines the fields of both roles.
 */
public class BuyerSeller extends User {

    // Buyer-side field
    private String preferredLocations;

    // Seller-side field
    private String agencyName;

    public BuyerSeller() {
        setRole("BOTH");
    }

    public BuyerSeller(String userId, String name, String email, String password,
                       String preferredLocations, String agencyName) {
        super(userId, name, email, password, "BOTH");
        this.preferredLocations = preferredLocations;
        this.agencyName         = agencyName;
    }

    // ── Buyer getters/setters ─────────────────────────────────────────────────
    public String getPreferredLocations() { return preferredLocations; }
    public void   setPreferredLocations(String preferredLocations) {
        this.preferredLocations = preferredLocations;
    }

    // ── Seller getters/setters ────────────────────────────────────────────────
    public String getAgencyName() { return agencyName; }
    public void   setAgencyName(String agencyName) { this.agencyName = agencyName; }

    @Override
    public String displayDashboard() {
        // Both dashboards available – redirect to buyer by default; UI shows both links
        return "redirect:/buyer-dashboard";
    }
}

