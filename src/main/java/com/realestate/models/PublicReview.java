package com.realestate.models;

public class PublicReview extends Review {

    public PublicReview(String reviewId, String propertyId, String reviewerId, int rating, String comment) {
        super(reviewId, propertyId, reviewerId, rating, comment);
    }

    @Override
    public String displayReview() {
        return "Public Review [" + getRating() + "/5]: " + getComment();
    }

}
