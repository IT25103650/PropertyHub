package com.realestate.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * JPA Entity representing a Buyer user in the PropertyHub system.
 * Maps to the shared 'Users' table with role = 'buyer'.
 *
 * Component 01 - Buyer Management
 * Developer: [Student 1]
 *
 * Commit 1: Basic Entity Structure & Fields
 */
@Entity
@Table(name = "Users")
public class BuyerEntity {

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

    @Column(name = "role", nullable = false)
    private String role = "buyer";

    @Column(name = "phone", length = 20)
    private String phone;

    // Constructors
    public BuyerEntity() {}

    public BuyerEntity(String firstName, String lastName, String email, String passwordHash, String phone) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
    }

    // Getters
    public Integer getUserId() { return userId; }
    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }
    public String getEmail() { return email; }
    public String getPasswordHash() { return passwordHash; }
    public String getRole() { return role; }
    public String getPhone() { return phone; }

    // Setters
    public void setUserId(Integer userId) { this.userId = userId; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public void setEmail(String email) { this.email = email; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public void setRole(String role) { this.role = role; }
    public void setPhone(String phone) { this.phone = phone; }
}
