package com.realestate.models;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * JPA Entity representing a Property listing in the PropertyHub system.
 * Maps to the 'Properties' table.
 *
 * Component 03 - Property Management
 * Developer: [Student 3]
 */
@Entity
@Table(name = "Properties")
@Getter
@Setter
@NoArgsConstructor
public class PropertyEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "property_id")
    private Integer propertyId;

    /** FK to Users (seller/owner). */
    @Column(name = "owner_id", nullable = false)
    private Integer ownerId;

    @Column(name = "title", nullable = false, length = 150)
    private String title;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    /** E.g. house, apartment, land, commercial. */
    @Column(name = "property_type", nullable = false)
    private String propertyType;

    /** E.g. sale, rent. */
    @Column(name = "listing_type", nullable = false)
    private String listingType;

    @Column(name = "price", nullable = false, precision = 15, scale = 2)
    private BigDecimal price;

    @Column(name = "location", nullable = false, length = 255)
    private String location;

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "bedrooms")
    private Integer bedrooms;

    @Column(name = "bathrooms")
    private Integer bathrooms;

    @Column(name = "sqft")
    private Integer sqft;

    /** E.g. available, pending, sold, rented. */
    @Column(name = "status")
    private String status = "available";

    @Column(name = "view_count")
    private Integer viewCount = 0;

    @Column(name = "created_at", updatable = false)
    @Setter(AccessLevel.NONE)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    @Setter(AccessLevel.NONE)
    private LocalDateTime updatedAt;

    // ─── Constructors ──────────────────────────────────────────────────────────

    public PropertyEntity(Integer ownerId, String title, String description,
                          String propertyType, String listingType,
                          BigDecimal price, String location) {
        this.ownerId      = ownerId;
        this.title        = title;
        this.description  = description;
        this.propertyType = propertyType;
        this.listingType  = listingType;
        this.price        = price;
        this.location     = location;
        this.status       = "available";
    }

    // ─── Lifecycle hooks ───────────────────────────────────────────────────────
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        if (this.status == null) this.status = "available";
        if (this.viewCount == null) this.viewCount = 0;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

}

