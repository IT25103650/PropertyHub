package com.realestate.services;
import com.realestate.models.*;
import com.realestate.repositories.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

// Service class for handling feedback and review operations.
// Component 06 - Feedback and Review Management

@Service
@Transactional
public class ReviewService {

    @Autowired
    private ReviewRepository ReviewRepository;

    //CREATE

    // Submit a new feedback or review.
    // Validates the rating and reviewer details.
    // Property ID and Agent ID can be null for general site reviews.

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

    //READ

    //Get all feedback/reviews (admin use)
    @Transactional(readOnly = true)
    public List<ReviewEntity> getAllFeedback() {
        return ReviewRepository.findAll(
                org.springframework.data.domain.Sort.by(
                        org.springframework.data.domain.Sort.Direction.DESC, "createdAt"));
    }

    //Get a single review by ID
    @Transactional(readOnly = true)
    public Optional<ReviewEntity> getFeedbackById(Integer id) {
        return ReviewRepository.findById(id);
    }

    //Get all reviews written by a specific buyer
    @Transactional(readOnly = true)
    public List<ReviewEntity> getFeedbackByReviewer(Integer reviewerId) {
        return ReviewRepository.findByReviewerIdOrderByCreatedAtDesc(reviewerId);
    }

    //Get all reviews for a specific property.
    @Transactional(readOnly = true)
    public List<ReviewEntity> getFeedbackByProperty(Integer propertyId) {
        return ReviewRepository.findByTargetPropertyIdOrderByCreatedAtDesc(propertyId);
    }

    //Get approved reviews for a property (public display)
    @Transactional(readOnly = true)
    public List<ReviewEntity> getApprovedFeedbackByProperty(Integer propertyId) {
        return ReviewRepository.findApprovedByProperty(propertyId);
    }

    //Get average rating for a property.
    @Transactional(readOnly = true)
    public Double getAverageRatingForProperty(Integer propertyId) {
        return ReviewRepository.avgRatingByProperty(propertyId);
    }

    //Get all reviews by status (pending / approved / rejected)
    @Transactional(readOnly = true)
    public List<ReviewEntity> getFeedbackByStatus(String status) {
        return ReviewRepository.findByStatusOrderByCreatedAtDesc(status);
    }

    //Count reviews by status.
    @Transactional(readOnly = true)
    public long countByStatus(String status) {
        return ReviewRepository.countByStatus(status);
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────────

    // Updates review rating and content.
    // If requestingUserId is null, it's an admin request (no ownership check).
    // Admin and users can edit reviews in any status.
    // Throws IllegalArgumentException if review is not found.

    public ReviewEntity updateFeedback(Integer id, int newRating, String newText, Integer requestingUserId) {
        ReviewEntity existing = ReviewRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Review not found: " + id));

        // Only the review author can edit their review.
        // If requestingUserId is null, it is treated as admin (bypass ownership check).
        if (requestingUserId != null && !existing.getReviewerId().equals(requestingUserId)) {
            throw new SecurityException("You can only edit your own reviews.");
        }
        //Status restriction REMOVED — admin & buyers can edit approved/rejected reviews too.
        if (newRating < 1 || newRating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5.");
        }

        existing.setRating(newRating);
        existing.setReviewText(newText);
        return ReviewRepository.save(existing);
    }

    //MODERATION

    //Admin approves a review (makes it publicly visible)
    public ReviewEntity approveFeedback(Integer id) {
        ReviewEntity feedback = ReviewRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Review not found: " + id));
        feedback.setStatus(ReviewEntity.STATUS_APPROVED);
        return ReviewRepository.save(feedback);
    }

    // Admin action to reject a review and hide it from public view.
    public ReviewEntity rejectFeedback(Integer id) {
        ReviewEntity feedback = ReviewRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Review not found: " + id));
        feedback.setStatus(ReviewEntity.STATUS_REJECTED);
        return ReviewRepository.save(feedback);
    }

    //DELETE

    // Deletes a review permanently.
    // Allowed for the review author or admin (null requestingUserId).
    public void deleteFeedback(Integer id) {
        if (!ReviewRepository.existsById(id)) {
            throw new IllegalArgumentException("Review not found: " + id);
        }
        ReviewRepository.deleteById(id);
    }
}
