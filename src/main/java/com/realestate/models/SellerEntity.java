package com.realestate.models;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

/**
 * JPA Entity representing a Seller user in the PropertyHub system.
 * Maps to the shared 'Users' table with role = 'seller'.
 *
 * Component 02 - Seller Management
 * Developer: [Student 2]
 */
@Entity
@Table(name = "Users")
@org.hibernate.annotations.Where(clause = "role IN ('seller','both')")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SellerEntity {

    public SellerEntity(String firstName, String lastName, String email, String passwordHash, String phone) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
    }


