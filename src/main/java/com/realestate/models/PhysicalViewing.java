package com.realestate.platform.models;

public class PhysicalViewing extends Booking {
    private String assignedAgentId;

    public PhysicalViewing(String bookingId, String buyerId, String propertyId, String bookingDate, String status, String assignedAgentId) {
        super(bookingId, buyerId, propertyId, bookingDate, status);
        this.assignedAgentId = assignedAgentId;
    }

