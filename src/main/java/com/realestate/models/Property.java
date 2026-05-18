package com.realestate.models;

public abstract class Property {
    private String propertyId;
    private String propertyTitle;
    private String propertyType;
    private String location;
    private double price;
    private String status;
    private String ownerId;

    public Property() {}

    public Property(String propertyId, String propertyTitle, String propertyType, String location, double price, String status, String ownerId) {
        this.propertyId = propertyId;
        this.propertyTitle = propertyTitle;
        this.propertyType = propertyType;
        this.location = location;
        this.price = price;
        this.status = status;
        this.ownerId = ownerId;
    }

    public String getPropertyId() { return propertyId; }
    public void setPropertyId(String propertyId) { this.propertyId = propertyId; }
    
    public String getPropertyTitle() { return propertyTitle; }
    public void setPropertyTitle(String propertyTitle) { this.propertyTitle = propertyTitle; }
    
    public String getPropertyType() { return propertyType; }
    public void setPropertyType(String propertyType) { this.propertyType = propertyType; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getOwnerId() { return ownerId; }
    public void setOwnerId(String ownerId) { this.ownerId = ownerId; }

    public abstract String displayPropertyDetails();
}

