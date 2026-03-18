package Booking_Viewing_property;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
public class Booking implements Serializable {

        private static final long serialVersionUID = 1L;

        private String bookingId;
        private String propertyId;
        private String buyerId;
        private LocalDate bookingDate;
        private String status; // PENDING, CONFIRMED, CANCELLED, COMPLETED

        // Constructors
        public Booking() {}

        public Booking(String bookingId, String propertyId, String buyerId, LocalDate bookingDate, String status) {
            this.bookingId = bookingId;
            this.propertyId = propertyId;
            this.buyerId = buyerId;
            this.bookingDate = bookingDate;
            this.status = status;
        }

        // Getters and Setters (Encapsulation)
        public String getBookingId() {
            return bookingId;
        }

        public void setBookingId(String bookingId) {
            this.bookingId = bookingId;
        }

        public String getPropertyId() {
            return propertyId;
        }

        public void setPropertyId(String propertyId) {
            this.propertyId = propertyId;
        }

        public String getBuyerId() {
            return buyerId;
        }

        public void setBuyerId(String buyerId) {
            this.buyerId = buyerId;
        }

        public LocalDate getBookingDate() {
            return bookingDate;
        }

        public void setBookingDate(LocalDate bookingDate) {
            this.bookingDate = bookingDate;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        // Business methods
        public void createBooking() {
            System.out.println("Booking created: " + bookingId);
        }

        public void viewBooking() {
            System.out.println("Viewing booking: " +bookingId);
        }

        public void updateBookingStatus(String newStatus) {
            this.status = newStatus;
            System.out.println("Booking status updated to: " + newStatus);
        }

        public void cancelBooking() {
            this.status = "CANCELLED";
            System.out.println("Booking cancelled: " + bookingId);
        }

        // Convert to file format
        public String toFileString() {
            DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE;
            return String.join(",",
                    bookingId,
                    propertyId,
                    buyerId,
                    bookingDate.format(formatter),
                    status
            );
        }

        // Create from file format
        public static Booking fromFileString(String line) {
            String[] parts = line.split(",");
            Booking booking = new Booking();
            booking.setBookingId(parts[0]);
            booking.setPropertyId(parts[1]);
            booking.setBuyerId(parts[2]);
            booking.setBookingDate(LocalDate.parse(parts[3]));
            booking.setStatus(parts[4]);
            return booking;
        }
    }
