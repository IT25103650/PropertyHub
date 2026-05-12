package com.realestate.platform.models;

public class VirtualViewing extends Booking {
    private String meetingLink;

    public VirtualViewing(String bookingId, String buyerId, String propertyId, String bookingDate, String status, String meetingLink) {
        super(bookingId, buyerId, propertyId, bookingDate, status);
        this.meetingLink = meetingLink;
    }

    public String getMeetingLink() { 
        return meetingLink; 
    }

    public void setMeetingLink(String meetingLink) {
         this.meetingLink = meetingLink; 
    }
	@Override
    public String confirmBooking() {
        setStatus("confirmed");
        return "Virtual viewing confirmed. Link: " + meetingLink;
    }
}
