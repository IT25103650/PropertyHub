public abstract class Review {

    private String reviewId;
    private String propertyId;
    private String reviewerId;
    private int rating;
    private String comment;

    public Review(String reviewId, String propertyId, String reviewerId, int rating, String comment) {
        this.reviewId = reviewId;
        this.propertyId = propertyId;
        this.reviewerId = reviewerId;
        this.rating = rating;
        this.comment = comment;
    }

}