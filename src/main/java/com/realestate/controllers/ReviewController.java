package com.realestate.controllers;
import com.realestate.models.*;
import com.realestate.services.*;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * ReviewController â€” handles all review/feedback submission endpoints.
 */
@Controller
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private BookingService bookingService;

    // â”€â”€â”€ POST: Submit Agent / Seller Review â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/submit-agent-review")
    public String submitAgentReview(
            @RequestParam("agentId")     int agentId,
            @RequestParam("rating")      int rating,
            @RequestParam("reviewText")  String reviewText,
            HttpSession session) {

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return "redirect:/login?redirect=/agents?id=" + agentId;
        }
        int reviewerId = Integer.parseInt(userIdObj.toString());

        try {
            ReviewEntity entity = new ReviewEntity();
            entity.setReviewerId(reviewerId);
            entity.setTargetAgentId(agentId);
            entity.setRating(rating);
            entity.setReviewText(reviewText);
            entity.setStatus("approved");
            reviewService.createFeedback(entity);

            return "redirect:/agents?id=" + agentId + "&review_submitted=true";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/agents?id=" + agentId + "&error=review_failed";
        }
    }

    // â”€â”€â”€ POST: Submit Property Review â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/submit-review")
    public String submitPropertyReview(
            @RequestParam("user_id")            int userId,
            @RequestParam("target_property_id") int propertyId,
            @RequestParam("rating")             int rating,
            @RequestParam("review_text")        String reviewText,
            @RequestParam(value = "target_name",     required = false) String targetName,
            @RequestParam(value = "from_dashboard",  required = false) String fromDashboard,
            HttpSession session) {

        if (session.getAttribute("userId") == null) {
            return "redirect:/login?redirect=/property-detail?id=" + propertyId;
        }
        int reviewerId = Integer.parseInt(session.getAttribute("userId").toString());

        try {
            List<BookingEntity> bookings = bookingService.getBookingsByBuyer(reviewerId);
            long completedCount = bookings.stream()
                    .filter(b -> b.getPropertyId() != null && b.getPropertyId() == propertyId && "completed".equals(b.getStatus()))
                    .count();

            String reviewStatus = (completedCount > 0) ? "approved" : "pending";

            ReviewEntity entity = new ReviewEntity();
            entity.setReviewerId(reviewerId);
            entity.setTargetPropertyId(propertyId);
            entity.setRating(rating);
            entity.setReviewText(reviewText);
            entity.setStatus(reviewStatus);
            reviewService.createFeedback(entity);

            if ("true".equals(fromDashboard)) {
                return "redirect:/buyer-dashboard?section=reviews&reviewSuccess=true";
            }
            return "redirect:/property-detail?id=" + propertyId + "&reviewSuccess=true";
        } catch (Exception e) {
            e.printStackTrace();
            if ("true".equals(fromDashboard)) {
                return "redirect:/buyer-dashboard?section=reviews&reviewError=true";
            }
            return "redirect:/property-detail?id=" + propertyId + "&reviewError=true";
        }
    }

    // â”€â”€â”€ POST: Submit General Site Review â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/submit-site-review")
    public String submitSiteReview(
            @RequestParam("rating")      int rating,
            @RequestParam("reviewText")  String reviewText,
            HttpSession session) {

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return "redirect:/login?redirect=/#reviews";
        }
        int reviewerId = Integer.parseInt(userIdObj.toString());

        try {
            ReviewEntity entity = new ReviewEntity();
            entity.setReviewerId(reviewerId);
            entity.setRating(rating);
            entity.setReviewText(reviewText);
            entity.setStatus("approved");
            reviewService.createFeedback(entity);

            return "redirect:/?site_review_submitted=true#reviews";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/?error=review_failed#reviews";
        }
    }

    // ─── UPDATE REVIEW (Buyer) ──────────────────────────────────────────────
    @PostMapping("/buyer-dashboard/update-review")
    public String updateReview(
            @RequestParam("review_id") int reviewId,
            @RequestParam("rating") int rating,
            @RequestParam("review_text") String reviewText,
            HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";

        try {
            int requestingUserId = Integer.parseInt(userIdObj.toString());
            reviewService.updateFeedback(reviewId, rating, reviewText, requestingUserId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/buyer-dashboard?section=reviews&updated=true";
    }

    // ─── DELETE REVIEW (Buyer) ──────────────────────────────────────────────
    @GetMapping("/buyer-dashboard/delete-review")
    public String deleteReview(@RequestParam("id") int reviewId, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";

        try {
            reviewService.deleteFeedback(reviewId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/buyer-dashboard?section=reviews&deleted=true";
    }
}
