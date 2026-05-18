package com.realestate.models;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

/**
 * JPA Entity representing a Booking / Viewing Appointment in the PropertyHub system.
 * Maps to the 'Bookings' table.
 *
 * Relationships:
 *   - Many-to-One → Users (buyer)
 *   - Many-to-One → Properties
 *
 * Component 04 - Booking and Viewing Management
 * Developer: [Student 4]
 */
@Entity
@Table(name = "Bookings")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookingEntity {

    // ─── Status constants ──────────────────────────────────────────────────────
    public static final String STATUS_PENDING   = "pending";
    public static final String STATUS_CONFIRMED = "confirmed";
    public static final String STATUS_COMPLETED = "completed";
    public static final String STATUS_CANCELLED = "cancelled";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "booking_id")
    private Integer bookingId;

    /** FK to Users (the buyer who made the booking). */
    @Column(name = "buyer_id", nullable = false)
    private Integer buyerId;

    /** FK to Properties. */
    @Column(name = "property_id", nullable = false)
    private Integer propertyId;

    /** Only 'physical' viewing is supported. */
    @Column(name = "viewing_type", length = 20, nullable = false)
    private String viewingType = "physical";

    @Column(name = "booking_date", nullable = false)
    private LocalDate bookingDate;

    @Column(name = "booking_time", nullable = false)
    private LocalTime bookingTime;
