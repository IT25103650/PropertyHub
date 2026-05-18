package com.realestate.services;
import com.realestate.models.*;
import com.realestate.repositories.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service layer for Seller Management business logic.
 *
 * Component 02 - Seller Management
 * Developer: [Student 2]
 */
@Service
@Transactional
public class SellerService {

    @Autowired
    private SellerRepository sellerRepository;

    // â”€â”€â”€ CREATE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    /**
     * Register a new seller account.
     * @throws IllegalArgumentException if email is already taken.
     */
    public SellerEntity createSeller(SellerEntity seller) {
        if (sellerRepository.existsByEmail(seller.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + seller.getEmail());
        }
        seller.setRole("seller");
        seller.setIsActive(true);
        return sellerRepository.save(seller);
    }