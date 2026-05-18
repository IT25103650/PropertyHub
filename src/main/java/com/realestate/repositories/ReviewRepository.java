package com.realestate.repositories;
import com.realestate.models.*;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository interface for Feedback/Review data access.
 *
 * Component 06 - Feedback and Review Management
 */
@Repository
public interface ReviewRepository extends JpaRepository<ReviewEntity, Integer> {

    /** All reviews written by a specific buyer/reviewer. */
    List<ReviewEntity> findByReviewerIdOrderByCreatedAtDesc(Integer reviewerId);

    /** All reviews for a specific property. */
    List<ReviewEntity> findByTargetPropertyIdOrderByCreatedAtDesc(Integer propertyId);

    /** All reviews targeting a specific seller/agent. */
    List<ReviewEntity> findByTargetAgentIdOrderByCreatedAtDesc(Integer agentId);

    /** All reviews by moderation status. */
    List<ReviewEntity> findByStatusOrderByCreatedAtDesc(String status);

    /**
     * All approved reviews for a specific property (shown publicly on property page).
     */
    @Query("SELECT f FROM ReviewEntity f WHERE " +
            "f.targetPropertyId = :propertyId AND f.status = 'approved' " +
            "ORDER BY f.createdAt DESC")
    List<ReviewEntity> findApprovedByProperty(@Param("propertyId") Integer propertyId);

    /**
     * Average rating for a specific property (approved reviews only).
     */
    @Query("SELECT AVG(f.rating) FROM ReviewEntity f WHERE " +
            "f.targetPropertyId = :propertyId AND f.status = 'approved'")
    Double avgRatingByProperty(@Param("propertyId") Integer propertyId);

    /** Count reviews by status. */
    long countByStatus(String status);

    /** Count reviews written by a specific buyer. */
    long countByReviewerId(Integer reviewerId);
}

