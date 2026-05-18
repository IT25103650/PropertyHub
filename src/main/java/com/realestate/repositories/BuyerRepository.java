package com.realestate.repositories;

import com.realestate.models.BuyerEntity;
import org.springframework.data.jpa.repository.JpaRepository;
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
    // Basic Query Method

    /**
     * Find a buyer by email address (used for login/uniqueness check).
     * Spring Data JPA automatically implements this method.
     */
    Optional<BuyerEntity> findByEmail(String email);

    /**
     * Check if email is already registered.
     * Returns true if a buyer with given email exists.
     */
    boolean existsByEmail(String email);

    /**
     * Find all active buyers.
     * Returns list of buyers where is_active = true.
     */
    List<BuyerEntity> findByIsActiveTrue();
}