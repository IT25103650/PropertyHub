package com.realestate.models;

public abstract class Review {

    private String reviewId;
    private String propertyId;
    private String reviewerId;
    private int rating;
    private String comment;

    public Review() {}

    public Review(String reviewId, String propertyId, String reviewerId, int rating, String comment) {
        this.reviewId = reviewId;
        this.propertyId = propertyId;
        this.reviewerId = reviewerId;
        this.rating = rating;
        this.comment = comment;
    }

    public String getReviewId() { return reviewId; }
    public void setReviewId(String reviewId) { this.reviewId = reviewId; }

    public String getPropertyId() { return propertyId; }
    public void setPropertyId(String propertyId) { this.propertyId = propertyId; }

    public String getReviewerId() { return reviewerId; }
    public void setReviewerId(String reviewerId) { this.reviewerId = reviewerId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public abstract String displayReview();

}
