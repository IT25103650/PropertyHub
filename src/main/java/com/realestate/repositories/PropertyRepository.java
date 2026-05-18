package com.realestate.repositories;
import com.realestate.models.*;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

/**
 * Repository interface for Property data access using Spring Data JPA.
 * Auto-implements standard CRUD; custom queries handle search/filter.
 *
 * Component 03 - Property Management
 * Developer: [Student 3]
 */
@Repository
public interface PropertyRepository extends JpaRepository<PropertyEntity, Integer> {

    /** All properties owned by a specific seller. */
    List<PropertyEntity> findByOwnerIdOrderByCreatedAtDesc(Integer ownerId);

    /** All properties with a given status (available / sold / rented / pending). */
    List<PropertyEntity> findByStatusOrderByCreatedAtDesc(String status);

    /** All properties of a given listing type (sale / rent). */
    List<PropertyEntity> findByListingTypeOrderByCreatedAtDesc(String listingType);

    /** All properties of a given property type (house / apartment / land / commercial). */
    List<PropertyEntity> findByPropertyTypeOrderByCreatedAtDesc(String propertyType);

    /** Search by title or location keyword. */
    @Query("SELECT p FROM PropertyEntity p WHERE " +
           "LOWER(p.title)    LIKE LOWER(CONCAT('%', :kw, '%')) OR " +
           "LOWER(p.location) LIKE LOWER(CONCAT('%', :kw, '%')) " +
           "ORDER BY p.createdAt DESC")
    List<PropertyEntity> searchByKeyword(@Param("kw") String keyword);

    /**
     * Advanced filter: each parameter is optional (null = skip that filter).
     * Returns all available properties matching the given criteria.
     */
    @Query("SELECT p FROM PropertyEntity p WHERE " +
           "(:location IS NULL    OR LOWER(p.location)     LIKE LOWER(CONCAT('%', :location, '%'))) AND " +
           "(:minPrice IS NULL    OR p.price               >= :minPrice) AND " +
           "(:maxPrice IS NULL    OR p.price               <= :maxPrice) AND " +
           "(:propType IS NULL    OR p.propertyType        = :propType) AND " +
           "(:listType IS NULL    OR p.listingType         = :listType) AND " +
           "(:minBeds  IS NULL    OR p.bedrooms            >= :minBeds) AND " +
           "(:status   IS NULL    OR p.status              = :status) " +
           "ORDER BY p.createdAt DESC")
    List<PropertyEntity> filterProperties(
            @Param("location") String location,
            @Param("minPrice") BigDecimal minPrice,
            @Param("maxPrice") BigDecimal maxPrice,
            @Param("propType") String propType,
            @Param("listType") String listType,
            @Param("minBeds")  Integer minBeds,
            @Param("status")   String status);

    /** Count all properties by owner. */
    long countByOwnerId(Integer ownerId);

    /** Count by status. */
    long countByStatus(String status);
}

