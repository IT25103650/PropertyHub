package com.realestate.repositories;
import com.realestate.models.*;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

// Handles database operations for seller accounts in Component 2.
@Repository
public interface SellerRepository extends JpaRepository<SellerEntity, Integer> {

    // Find a seller by email.
    Optional<SellerEntity> findByEmail(String email);

    // Find all active sellers.
    List<SellerEntity> findByIsActiveTrue();

    // Find users who can list properties (role = seller or both).
    @Query("SELECT s FROM SellerEntity s WHERE s.role IN ('seller', 'both') ORDER BY s.createdAt DESC")
    List<SellerEntity> findAllSellers();

    // Search sellers by name or email.
    @Query("SELECT s FROM SellerEntity s WHERE s.role IN ('seller', 'both') AND (" +
            "LOWER(s.firstName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(s.lastName)  LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(s.email)     LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<SellerEntity> searchSellers(@Param("keyword") String keyword);

    // Check if email exists.
    boolean existsByEmail(String email);
}

