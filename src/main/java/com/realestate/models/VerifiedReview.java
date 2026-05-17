package com.realestate.models;

public class VerifiedReview extends Review{

    private String purchaseDate;

    public VerifiedReview(String reviewId, String propertyId, String reviewerId, int rating, String comment, String purchaseDate) {
        super(reviewId, propertyId, reviewerId, rating, comment);
        this.purchaseDate = purchaseDate;
    }

    public String getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(String purchaseDate) { this.purchaseDate = purchaseDate; }

    @Override
    public String displayReview() {
        return "Verified Buyer Review (Purchased: " + purchaseDate + ") [" + getRating() + "/5]: " + getComment() + " ✓";
    }

}
