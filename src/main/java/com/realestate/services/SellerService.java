package com.realestate.services;
import com.realestate.models.*;
import com.realestate.repositories.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

    // Coordinates the core business logic
@Service
@Transactional
public class SellerService {

    @Autowired
    private SellerRepository sellerRepository;

    // CREATE method
        // Registers a new seller and checks that the email isn't already in use.

        public SellerEntity createSeller(SellerEntity seller) {
        if (sellerRepository.existsByEmail(seller.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + seller.getEmail());
        }
        seller.setRole("seller");
        seller.setIsActive(true);
        return sellerRepository.save(seller);
    }

    // READ Method
    // Get all sellers in the system.
    @Transactional(readOnly = true)
    public List<SellerEntity> getAllSellers() {
        return sellerRepository.findAllSellers();
    }

    // Get a seller by ID.
    @Transactional(readOnly = true)
    public Optional<SellerEntity> getSellerById(Integer id) {
        return sellerRepository.findById(id);
    }

    // Get a seller by email.
    @Transactional(readOnly = true)
    public Optional<SellerEntity> getSellerByEmail(String email) {
        return sellerRepository.findByEmail(email);
    }

    // Search sellers by keyword.
    @Transactional(readOnly = true)
    public List<SellerEntity> searchSellers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllSellers();
        }
        return sellerRepository.searchSellers(keyword.trim());
    }

    // UPDATE Method
        // Updates profile details for an existing seller

        public SellerEntity updateSeller(Integer id, SellerEntity updatedData) {
        SellerEntity existing = sellerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Seller not found: " + id));

        existing.setFirstName(updatedData.getFirstName());
        existing.setLastName(updatedData.getLastName());
        existing.setEmail(updatedData.getEmail());
        existing.setPhone(updatedData.getPhone());

        if (updatedData.getPasswordHash() != null && !updatedData.getPasswordHash().isBlank()) {
            existing.setPasswordHash(updatedData.getPasswordHash());
        }
        if (updatedData.getProfileImageUrl() != null && !updatedData.getProfileImageUrl().isBlank()) {
            existing.setProfileImageUrl(updatedData.getProfileImageUrl());
        }

        return sellerRepository.save(existing);
    }

    // Toggle seller active/inactive status.
    public SellerEntity toggleSellerStatus(Integer id) {
        SellerEntity seller = sellerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Seller not found: " + id));
        seller.setIsActive(!seller.getIsActive());
        return sellerRepository.save(seller);
    }

    // DELETE Method
        // Removes a seller account and details

        public void deleteSeller(Integer id) {
        if (!sellerRepository.existsById(id)) {
            throw new IllegalArgumentException("Seller not found: " + id);
        }
        sellerRepository.deleteById(id);
    }

    // VALIDATION
    @Transactional(readOnly = true)
    public boolean isEmailAvailable(String email) {
        return !sellerRepository.existsByEmail(email);
    }
}