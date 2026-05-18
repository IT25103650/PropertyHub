package com.realestate.services;
import com.realestate.models.*;
import com.realestate.repositories.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service layer for Buyer Management business logic.
 *
 * Component 01 - Buyer Management
 * Developer: [Student 1]
 *
 * Commit 2: UPDATE operations (existing CREATE/READ retained)
 */
@Service
@Transactional
public class BuyerService {

    @Autowired
    private BuyerRepository buyerRepository;

    //
    // Create Operations
    //

    public BuyerEntity createBuyer(BuyerEntity buyer) {
        if (buyerRepository.existsByEmail(buyer.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + buyer.getEmail());
        }
        buyer.setRole("buyer");
        buyer.setIsActive(true);
        return buyerRepository.save(buyer);
    }

    //
    // Read Operations
    //

    @Transactional(readOnly = true)
    public List<BuyerEntity> getAllBuyers() {
        return buyerRepository.findAllBuyers();
    }

    @Transactional(readOnly = true)
    public Optional<BuyerEntity> getBuyerById(Integer id) {
        return buyerRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Optional<BuyerEntity> getBuyerByEmail(String email) {
        return buyerRepository.findByEmail(email);
    }

    @Transactional(readOnly = true)
    public List<BuyerEntity> searchBuyers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllBuyers();
        }
        return buyerRepository.searchBuyers(keyword.trim());
    }

    @Transactional(readOnly = true)
    public long countBuyers() {
        return buyerRepository.findAllBuyers().size();
    }

    @Transactional(readOnly = true)
    public boolean isEmailAvailable(String email) {
        return !buyerRepository.existsByEmail(email);
    }

    //
    // Update Operations
    //

    /**
     * Update buyer profile information.
     * @throws IllegalArgumentException if buyer not found.
     */
    public BuyerEntity updateBuyer(Integer id, BuyerEntity updatedData) {
        BuyerEntity existing = buyerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Buyer not found: " + id));

        existing.setFirstName(updatedData.getFirstName());
        existing.setLastName(updatedData.getLastName());
        existing.setEmail(updatedData.getEmail());
        existing.setPhone(updatedData.getPhone());

        // Only update password if a new one is provided
        if (updatedData.getPasswordHash() != null && !updatedData.getPasswordHash().isBlank()) {
            existing.setPasswordHash(updatedData.getPasswordHash());
        }
        // Only update profile image if provided
        if (updatedData.getProfileImageUrl() != null && !updatedData.getProfileImageUrl().isBlank()) {
            existing.setProfileImageUrl(updatedData.getProfileImageUrl());
        }

        return buyerRepository.save(existing);
    }

    /** Toggle buyer active/inactive status (used by admin). */
    public BuyerEntity toggleBuyerStatus(Integer id) {
        BuyerEntity buyer = buyerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Buyer not found: " + id));
        buyer.setIsActive(!buyer.getIsActive());
        return buyerRepository.save(buyer);
    }
}