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

    // â”€â”€â”€ READ â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    /** Get all sellers in the system. */
    @Transactional(readOnly = true)
    public List<SellerEntity> getAllSellers() {
        return sellerRepository.findAllSellers();
    }

    /** Get a seller by ID. */
    @Transactional(readOnly = true)
    public Optional<SellerEntity> getSellerById(Integer id) {
        return sellerRepository.findById(id);
    }

    /** Get a seller by email. */
    @Transactional(readOnly = true)
    public Optional<SellerEntity> getSellerByEmail(String email) {
        return sellerRepository.findByEmail(email);
    }

    /** Search sellers by keyword. */
    @Transactional(readOnly = true)
    public List<SellerEntity> searchSellers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllSellers();
        }
        return sellerRepository.searchSellers(keyword.trim());
    }