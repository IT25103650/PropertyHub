package com.realestate.services;
import com.realestate.models.*;
import com.realestate.repositories.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;


@Service
@Transactional
public class BuyerService {

    @Autowired
    private BuyerRepository buyerRepository;

    // Create Operations

    public BuyerEntity createBuyer(BuyerEntity buyer) {
        if (buyerRepository.existsByEmail(buyer.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + buyer.getEmail());
        }
        buyer.setRole("buyer");
        buyer.setIsActive(true);
        return buyerRepository.save(buyer);
    }

    // Read Operations

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


    // Update Operations

    public BuyerEntity updateBuyer(Integer id, BuyerEntity updatedData) {
        BuyerEntity existing = buyerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Buyer not found: " + id));

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

        return buyerRepository.save(existing);
    }

    public BuyerEntity toggleBuyerStatus(Integer id) {
        BuyerEntity buyer = buyerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Buyer not found: " + id));
        buyer.setIsActive(!buyer.getIsActive());
        return buyerRepository.save(buyer);
    }


    // Delete Operations



    public void deleteBuyer(Integer id) {
        if (!buyerRepository.existsById(id)) {
            throw new IllegalArgumentException("Buyer not found: " + id);
        }
        buyerRepository.deleteById(id);
    }
}