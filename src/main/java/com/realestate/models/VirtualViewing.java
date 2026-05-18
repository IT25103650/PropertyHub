package com.realestate.models;

public class VirtualViewing extends Booking {
    private String meetingLink;

    public VirtualViewing(String bookingId, String buyerId, String propertyId, String bookingDate, String status, String meetingLink) {
        super(bookingId, buyerId, propertyId, bookingDate, status);
        this.meetingLink = meetingLink;
    }
