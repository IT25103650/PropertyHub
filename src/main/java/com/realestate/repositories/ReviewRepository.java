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

}
