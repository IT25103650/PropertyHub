package com.realestate.models;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

/**
 * JPA Entity representing a Buyer user in the PropertyHub system.
 * Maps to the shared 'Users' table with role = 'buyer'.
 *
 * The @Where clause ensures this entity only ever reads/writes rows
 * where role IN ('buyer','both'), preventing conflicts with SellerEntity
 * and AdminEntity which share the same table.
 *
 * Component 01 - Buyer Management
 * Developer: [Student 1]
 *
 */
@Entity
@Table(name = "Users")
@org.hibernate.annotations.Where(clause = "role IN ('buyer','both')")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BuyerEntity {

    public BuyerEntity(String firstName, String lastName, String email, String passwordHash, String phone) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "first_name", nullable = false, length = 50)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 50)
    private String lastName;

    @Column(name = "email", nullable = false, unique = true, length = 100)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    // Role is always 'buyer' for this entity
    @Column(name = "role", nullable = false)
    private String role = "buyer";

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "profile_image_url", length = 255)
    private String profileImageUrl;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "created_at", updatable = false)
    @Setter(AccessLevel.NONE)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    @Setter(AccessLevel.NONE)
    private LocalDateTime updatedAt;

    //  Lifecycle hooks
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        if (this.role == null) this.role = "buyer";
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    // Custom Getter
    public String getFullName() {
        return firstName + " " + lastName;
    }
}