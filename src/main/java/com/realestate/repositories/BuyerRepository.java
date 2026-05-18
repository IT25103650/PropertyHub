package com.realestate.repositories;

import com.realestate.models.BuyerEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

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

    // Basic CRUD methods are inherited from JpaRepository:
    // - save()
    // - findById()
    // - findAll()
    // - deleteById()
    // - existsById()
    // - count()
}