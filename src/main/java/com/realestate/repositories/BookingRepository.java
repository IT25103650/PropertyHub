package com.realestate.repositories;
import com.realestate.models.*;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository interface for Booking data access.
 *
 * Component 04 - Booking and Viewing Management
 * Developer: [Student 4]
 */
@Repository
public interface BookingRepository extends JpaRepository<BookingEntity, Integer> {

    /** All bookings for a specific buyer, newest first. */
    List<BookingEntity> findByBuyerIdOrderByBookingDateDesc(Integer buyerId);

    /** All bookings for a specific property, newest first. */
    List<BookingEntity> findByPropertyIdOrderByBookingDateDesc(Integer propertyId);

    /** All bookings with a given status. */
    List<BookingEntity> findByStatusOrderByBookingDateDesc(String status);

    /**
     * All bookings for properties owned by a specific seller.
     * Uses a native SQL subquery to avoid cross-package JPQL entity references.
     */
    @Query(value = "SELECT * FROM Bookings WHERE property_id IN " +
                   "(SELECT property_id FROM Properties WHERE owner_id = :sellerId) " +
                   "ORDER BY booking_date DESC",
           nativeQuery = true)
    List<BookingEntity> findBySellerIdOrderByBookingDateDesc(@Param("sellerId") Integer sellerId);

    /** Count bookings per buyer. */
    long countByBuyerId(Integer buyerId);

    /** Count bookings per status. */
    long countByStatus(String status);
}

