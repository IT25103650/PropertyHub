package com.realestate.services;
import com.realestate.models.*;
import com.realestate.repositories.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service layer for Feedback and Review Management business logic.
 * All review-specific operations are centralised here.
 *
 * Component 06 - Feedback and Review Management
 * Developer: [Student 6]
 */
@Service
@Transactional
public class ReviewService {

    @Autowired
    private ReviewRepository ReviewRepository;

    // ─── CREATE ─────────────────────────────────────────────────────────────────

    /**
     * Submit a new feedback / review.
     * Validates rating range (1-5) and reviewer ID.
     * NOTE: targetPropertyId and targetAgentId can BOTH be null for site-level reviews.
     */
    public ReviewEntity createFeedback(ReviewEntity feedback) {
        if (feedback.getReviewerId() == null) {
            throw new IllegalArgumentException("Reviewer ID is required.");
        }
        if (feedback.getRating() == null || feedback.getRating() < 1 || feedback.getRating() > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5.");
        }
        // Site-level reviews have both targets null — this is valid, so NO validation here.
        // Only set status to pending if not already set (e.g. auto-approved reviews)
        if (feedback.getStatus() == null) {
            feedback.setStatus(ReviewEntity.STATUS_PENDING);
        }
        return ReviewRepository.save(feedback);
    }



}