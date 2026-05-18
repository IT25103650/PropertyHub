package com.realestate.models;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;


 // JPA entity for storing user feedback and reviews.
 // Maps to the "Reviews" table in the database.

 /*
 Relationships:
    - Many-to-One → users (Each review is written by a user (reviewer/buyer))
    - Many-to-One → Properties (A review can be linked to a target property (optional))
    - Many-to-One → users ( A review can also be linked to an target agent/seller (optional))
 */


@Entity
@Table(name = "Reviews")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReviewEntity {

    //Status constants
    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_APPROVED = "approved";
    public static final String STATUS_REJECTED = "rejected";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "review_id")
    private Integer reviewId;

    //FK to Users — the buyer who wrote the review.
    @Column(name = "reviewer_id", nullable = false)
    private Integer reviewerId;

    //FK to Users — optional target agent/seller.
    @Column(name = "target_agent_id")
    private Integer targetAgentId;

    //FK to Properties — optional target property.
    @Column(name = "target_property_id")
    private Integer targetPropertyId;

    //Rating from 1 to 5 (inclusive).
    @Column(name = "rating", nullable = false)
    private Integer rating;

    //Full review comment.
    @Column(name = "review_text", columnDefinition = "TEXT")
    private String reviewText;


     //Moderation status.
     //Allowed values: pending | approved | rejected

    @Column(name = "status")
    private String status = STATUS_PENDING;

    @Column(name = "created_at", updatable = false)
    @Setter(AccessLevel.NONE)
    private LocalDateTime createdAt;

    //Lifecycle hooks
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.status == null) this.status = STATUS_PENDING;
    }

}