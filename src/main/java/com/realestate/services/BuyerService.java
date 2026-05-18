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
 */
@Service
@Transactional
public class BuyerService {

    @Autowired
    private BuyerRepository buyerRepository;

    //
    // Create Operations
    //

    /**
     * Register a new buyer account.
     * @throws IllegalArgumentException if email is already taken.
     */
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

    /** Get all buyers in the system. */
    @Transactional(readOnly = true)
    public List<BuyerEntity> getAllBuyers() {
        return buyerRepository.findAllBuyers();
    }

    /** Get a buyer by their primary key. */
    @Transactional(readOnly = true)
    public Optional<BuyerEntity> getBuyerById(Integer id) {
        return buyerRepository.findById(id);
    }

    /** Get a buyer by their email address. */
    @Transactional(readOnly = true)
    public Optional<BuyerEntity> getBuyerByEmail(String email) {
        return buyerRepository.findByEmail(email);
    }

    /** Search buyers by name or email keyword. */
    @Transactional(readOnly = true)
    public List<BuyerEntity> searchBuyers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllBuyers();
        }
        return buyerRepository.searchBuyers(keyword.trim());
    }

    /** Count total buyers. */
    @Transactional(readOnly = true)
    public long countBuyers() {
        return buyerRepository.findAllBuyers().size();
    }

    /** Check if an email is available for registration. */
    @Transactional(readOnly = true)
    public boolean isEmailAvailable(String email) {
        return !buyerRepository.existsByEmail(email);
    }
}

