package com.realestate.services;
import com.realestate.models.*;
import com.realestate.repositories.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service layer for Feedback and Review Management business logic.
 * All review-specific operations are centralised here.
 *
 * Component 06 - Feedback and Review Management
 * Developer: [Student 6]
 */
@Service
@Transactional
public class ReviewService {

    @Autowired
    private ReviewRepository ReviewRepository;
    
}