package com.realestate.models;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

/**
 * JPA entity for storing user feedback and property reviews in the PropertyHub system.
 * This class maps to the "Reviews" table in the database.
 *
 * Relationships:
 *   - Many-to-One → users (Each review is written by a user (reviewer/buyer))
 *   - Many-to-One → Properties (A review can be linked to a target property (optional))
 *   - Many-to-One → users ( A review can also be linked to an target agent/seller (optional))
 *
 * Component 06 - Feedback and Review Management
 */
@Entity
@Table(name = "Reviews")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReviewEntity {

    // ─── Status constants ──────────────────────────────────────────────────────
    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_APPROVED = "approved";
    public static final String STATUS_REJECTED = "rejected";



}