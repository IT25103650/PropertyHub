package com.realestate.services;
import com.realestate.models.*;
import com.realestate.repositories.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

/**
 * Service layer for Booking and Viewing Management business logic.
 *
 * Component 04 - Booking and Viewing Management
 * Developer: [Student 4]
 */
@Service
@Transactional
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    // ─── CREATE ───────────────────────────────────────────────────────────────────

    /**
     * Create a new booking/viewing appointment.
     * Validates that required fields (buyer, property, date, time) are present.
     */
    public BookingEntity createBooking(BookingEntity booking) {
        if (booking.getBuyerId() == null) {
            throw new IllegalArgumentException("Buyer ID is required for a booking.");
        }
        if (booking.getPropertyId() == null) {
            throw new IllegalArgumentException("Property ID is required for a booking.");
        }
        if (booking.getBookingDate() == null) {
            throw new IllegalArgumentException("Booking date is required.");
        }
        if (booking.getBookingDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Booking date cannot be in the past.");
        }
        if (booking.getBookingTime() == null) {
            throw new IllegalArgumentException("Booking time is required.");
        }

        booking.setStatus(BookingEntity.STATUS_PENDING);
        if (booking.getViewingType() == null) booking.setViewingType("physical");

        return bookingRepository.save(booking);
    }

    // ─── READ ─────────────────────────────────────────────────────────────────────

    /** Get all bookings (admin use). */
    @Transactional(readOnly = true)
    public List<BookingEntity> getAllBookings() {
        return bookingRepository.findAll(
            org.springframework.data.domain.Sort.by(
                org.springframework.data.domain.Sort.Direction.DESC, "bookingDate"));
    }

    /** Get a single booking by ID. */
    @Transactional(readOnly = true)
    public Optional<BookingEntity> getBookingById(Integer id) {
        return bookingRepository.findById(id);
    }

    /** Get all bookings made by a specific buyer. */
    @Transactional(readOnly = true)
    public List<BookingEntity> getBookingsByBuyer(Integer buyerId) {
        return bookingRepository.findByBuyerIdOrderByBookingDateDesc(buyerId);
    }

    /** Get all bookings for a specific property. */
    @Transactional(readOnly = true)
    public List<BookingEntity> getBookingsByProperty(Integer propertyId) {
        return bookingRepository.findByPropertyIdOrderByBookingDateDesc(propertyId);
    }

    /** Get all bookings for properties owned by a seller. */
    @Transactional(readOnly = true)
    public List<BookingEntity> getBookingsBySeller(Integer sellerId) {
        return bookingRepository.findBySellerIdOrderByBookingDateDesc(sellerId);
    }

    /** Get bookings filtered by status. */
    @Transactional(readOnly = true)
    public List<BookingEntity> getBookingsByStatus(String status) {
        return bookingRepository.findByStatusOrderByBookingDateDesc(status);
    }

    /** Count bookings by status. */
    @Transactional(readOnly = true)
    public long countByStatus(String status) {
        return bookingRepository.countByStatus(status);
    }

    // ─── UPDATE ───────────────────────────────────────────────────────────────────

    /**
     * Update a booking's date, time, and notes (Buyer action).
     * Only allowed when status is still 'pending'.
     */
    public BookingEntity updateBooking(Integer id, LocalDate newDate, LocalTime newTime, String newNotes) {
        BookingEntity booking = bookingRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Booking not found: " + id));

        if (!BookingEntity.STATUS_PENDING.equals(booking.getStatus())) {
            throw new IllegalStateException(
                "Cannot update a booking that is already " + booking.getStatus() + ".");
        }
        if (newDate != null) {
            if (newDate.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("Booking date cannot be in the past.");
            }
            booking.setBookingDate(newDate);
        }
        if (newTime != null) booking.setBookingTime(newTime);
        if (newNotes != null) booking.setNotes(newNotes);

        return bookingRepository.save(booking);
    }

    /**
     * Admin-only: Update any booking's date, time, status, and notes regardless of current status.
     * Bypasses the pending-only restriction that applies to buyer updates.
     */
    public BookingEntity adminUpdateBooking(Integer id, LocalDate newDate, LocalTime newTime,
                                            String newStatus, String newNotes) {
        BookingEntity booking = bookingRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Booking not found: " + id));

        if (newDate != null) booking.setBookingDate(newDate);
        if (newTime != null) booking.setBookingTime(newTime);
        if (newStatus != null && !newStatus.isBlank()) booking.setStatus(newStatus);
        if (newNotes != null) booking.setNotes(newNotes);

        return bookingRepository.save(booking);
    }

    // ─── STATUS TRANSITIONS ───────────────────────────────────────────────────────

    /**
     * Approve/confirm a booking (seller or admin action).
     */
    public BookingEntity approveBooking(Integer id) {
        BookingEntity booking = bookingRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Booking not found: " + id));
        booking.setStatus(BookingEntity.STATUS_CONFIRMED);
        return bookingRepository.save(booking);
    }

    /**
     * Reject a booking (seller or admin action).
     * Sets the status back to cancelled.
     */
    public BookingEntity rejectBooking(Integer id) {
        BookingEntity booking = bookingRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Booking not found: " + id));
        booking.setStatus(BookingEntity.STATUS_CANCELLED);
        return bookingRepository.save(booking);
    }

    /**
     * Cancel a booking (buyer action).
     * Only allowed when status is pending or confirmed.
     */
    public BookingEntity cancelBooking(Integer id, Integer requestingBuyerId) {
        BookingEntity booking = bookingRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Booking not found: " + id));

        if (!booking.getBuyerId().equals(requestingBuyerId)) {
            throw new SecurityException("You can only cancel your own bookings.");
        }
        if (BookingEntity.STATUS_COMPLETED.equals(booking.getStatus())) {
            throw new IllegalStateException("Cannot cancel a completed booking.");
        }
        booking.setStatus(BookingEntity.STATUS_CANCELLED);
        return bookingRepository.save(booking);
    }

    /**
     * Mark a booking as completed (seller or admin action).
     */
    public BookingEntity completeBooking(Integer id) {
        BookingEntity booking = bookingRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Booking not found: " + id));
        booking.setStatus(BookingEntity.STATUS_COMPLETED);
        return bookingRepository.save(booking);
    }

    // ─── DELETE ───────────────────────────────────────────────────────────────────

    /**
     * Permanently delete a booking record (admin only).
     */
    public void deleteBooking(Integer id) {
        if (!bookingRepository.existsById(id)) {
            throw new IllegalArgumentException("Booking not found: " + id);
        }
        bookingRepository.deleteById(id);
    }
}
