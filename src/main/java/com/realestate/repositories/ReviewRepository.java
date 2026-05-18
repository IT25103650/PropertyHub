package com.realestate.repositories;
import com.realestate.models.*;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

// Repository for accessing feedback and review data.
// Component 06 - Feedback and Review Management

@Repository
public interface ReviewRepository extends JpaRepository<ReviewEntity, Integer> {

    //All reviews written by a specific buyer/reviewer.
    List<ReviewEntity> findByReviewerIdOrderByCreatedAtDesc(Integer reviewerId);

    //All reviews for a specific property.
    List<ReviewEntity> findByTargetPropertyIdOrderByCreatedAtDesc(Integer propertyId);

    //All reviews targeting a specific seller/agent.
    List<ReviewEntity> findByTargetAgentIdOrderByCreatedAtDesc(Integer agentId);

    //All reviews by moderation status.
    List<ReviewEntity> findByStatusOrderByCreatedAtDesc(String status);

    // Retrieves all approved reviews for a property (visible on public listing page).

    @Query("SELECT f FROM ReviewEntity f WHERE " +
            "f.targetPropertyId = :propertyId AND f.status = 'approved' " +
            "ORDER BY f.createdAt DESC")
    List<ReviewEntity> findApprovedByProperty(@Param("propertyId") Integer propertyId);

    // Calculates the average rating of approved reviews for a property.
    @Query("SELECT AVG(f.rating) FROM ReviewEntity f WHERE " +
            "f.targetPropertyId = :propertyId AND f.status = 'approved'")
    Double avgRatingByProperty(@Param("propertyId") Integer propertyId);

    //Count reviews by status
    long countByStatus(String status);

    //Count reviews written by a specific buyer.
    long countByReviewerId(Integer reviewerId);
}

