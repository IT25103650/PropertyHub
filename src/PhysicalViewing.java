package com.realestate.platform.models;

public class PhysicalViewing extends Booking {
    private String assignedAgentId;

    public PhysicalViewing(String bookingId, String buyerId, String propertyId, String bookingDate, String status, String assignedAgentId) {
        super(bookingId, buyerId, propertyId, bookingDate, status);
        this.assignedAgentId = assignedAgentId;
    }

    public String getAssignedAgentId() { 
        return assignedAgentId; 
    }
    public void setAssignedAgentId(String assignedAgentId) {
         this.assignedAgentId = assignedAgentId; 
    }