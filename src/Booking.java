package com.realestate.platform.models;

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

    public String getBookingId() { 
        return bookingId;
     }

    public void setBookingId(String bookingId) {
         this.bookingId = bookingId; 
    }

    public String getBuyerId() { 
        return buyerId; 
    }
    public void setBuyerId(String buyerId) {
         this.buyerId = buyerId; 
    }

    public String getPropertyId() {
         return propertyId; 
    }

    public void setPropertyId(String propertyId) {
         this.propertyId = propertyId; 
    }
