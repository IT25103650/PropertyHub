public class VerifiedReview extends Review {

    private String purchaseDate;

    public VerifiedReview(String reviewId, String propertyId, String reviewerId, int rating, String comment, String purchaseDate) {
        super(reviewId, propertyId, reviewerId, rating, comment);
        this.purchaseDate = purchaseDate;
    }

}