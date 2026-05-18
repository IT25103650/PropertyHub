package com.realestate.repositories;

import com.realestate.models.BuyerEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Buyer data access.
 * Spring Data JPA auto-implements standard CRUD methods.
 *
 * Component 01 - Buyer Management
 * Developer: [Student 1]
 *
 */
@Repository
public interface BuyerRepository extends JpaRepository<BuyerEntity, Integer> {

    //
    // Basic Query Methods
    //

    /** Find a buyer by email address (used for login/uniqueness check). */
    Optional<BuyerEntity> findByEmail(String email);

    /** Find all active buyers. */
    List<BuyerEntity> findByIsActiveTrue();

    /** Check if email is already registered. */
    boolean existsByEmail(String email);

    //
    // Custom Query Method
    //

    /**
     * Find all buyers whose role is 'buyer' or 'both'.
     * Sorted by creation date descending (newest first).
     * Uses JPQL query to filter by role.
     */
    @Query("SELECT b FROM BuyerEntity b WHERE b.role IN ('buyer', 'both') ORDER BY b.createdAt DESC")
    List<BuyerEntity> findAllBuyers();

    /**
     * Search buyers by first name, last name, or email.
     * Case-insensitive search using LIKE operator.
     *
     * @param keyword search keyword (will be wrapped with % for partial matching)
     * @return list of buyers matching the search criteria
     */
    @Query("SELECT b FROM BuyerEntity b WHERE " +
            "LOWER(b.firstName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(b.lastName)  LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(b.email)     LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<BuyerEntity> searchBuyers(@Param("keyword") String keyword);
}