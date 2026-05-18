package com.realestate.models;

public abstract class Booking {
    private String bookingId;
    private String buyerId;
    private String propertyId;
    private String bookingDate;
    private String status;

    public Booking() {}

    public Booking(String bookingId, String buyerId, String propertyId, String bookingDate, String status) {
        this.bookingId = bookingId;
        this.buyerId = buyerId;
        this.propertyId = propertyId;
        this.bookingDate = bookingDate;
        this.status = status;
    }