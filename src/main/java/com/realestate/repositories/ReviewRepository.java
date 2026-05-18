package com.realestate.repositories;
import com.realestate.models.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReviewRepository extends JpaRepository<ReviewEntity, Integer> {

/**
 * Repository interface for Feedback/Review data access.
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


}
