package com.realestate.services;
import com.realestate.models.*;
import com.realestate.repositories.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Service layer for Property Management business logic.
 * All property-specific operations are centralised here.
 *
 * Component 03 - Property Management
 * Developer: [Student 3]
 */
@Service
@Transactional
public class PropertyService {

    @Autowired
    private PropertyRepository propertyRepository;

    // â”€â”€â”€ CREATE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    /**
     * Create a new property listing.
     * Validates that required fields are present before saving.
     */
    public PropertyEntity createProperty(PropertyEntity property) {
        if (property.getOwnerId() == null) {
            throw new IllegalArgumentException("Property must have an owner (seller).");
        }
        if (property.getTitle() == null || property.getTitle().isBlank()) {
            throw new IllegalArgumentException("Property title is required.");
        }
        if (property.getStatus() == null) {
            property.setStatus("available");
        }
        return propertyRepository.save(property);
    }

    // â”€â”€â”€ READ â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    /** Get all properties ordered by newest first. */
    @Transactional(readOnly = true)
    public List<PropertyEntity> getAllProperties() {
        return propertyRepository.findAll(
            org.springframework.data.domain.Sort.by(
                org.springframework.data.domain.Sort.Direction.DESC, "createdAt"));
    }

    /** Get a single property by ID. */
    @Transactional(readOnly = true)
    public Optional<PropertyEntity> getPropertyById(Integer id) {
        return propertyRepository.findById(id);
    }

    /** Get all properties belonging to a specific seller/owner. */
    @Transactional(readOnly = true)
    public List<PropertyEntity> getPropertiesByOwner(Integer ownerId) {
        return propertyRepository.findByOwnerIdOrderByCreatedAtDesc(ownerId);
    }

    /** Get properties by status (available / sold / rented / pending). */
    @Transactional(readOnly = true)
    public List<PropertyEntity> getPropertiesByStatus(String status) {
        return propertyRepository.findByStatusOrderByCreatedAtDesc(status);
    }

    /** Search properties by keyword (title or location). */
    @Transactional(readOnly = true)
    public List<PropertyEntity> searchProperties(String keyword) {
        if (keyword == null || keyword.isBlank()) return getAllProperties();
        return propertyRepository.searchByKeyword(keyword.trim());
    }

    /**
     * Filter properties with optional criteria.
     * Any null parameter is ignored in the query.
     */
    @Transactional(readOnly = true)
    public List<PropertyEntity> filterProperties(
            String location, BigDecimal minPrice, BigDecimal maxPrice,
            String propType, String listType, Integer minBeds, String status) {
        return propertyRepository.filterProperties(
                location, minPrice, maxPrice, propType, listType, minBeds, status);
    }

    /** Total properties count. */
    @Transactional(readOnly = true)
    public long countAll() {
        return propertyRepository.count();
    }

    /** Count by status. */
    @Transactional(readOnly = true)
    public long countByStatus(String status) {
        return propertyRepository.countByStatus(status);
    }

    // â”€â”€â”€ UPDATE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    /**
     * Update a property listing.
     * @throws IllegalArgumentException if not found.
     */
    public PropertyEntity updateProperty(Integer id, PropertyEntity updated) {
        PropertyEntity existing = propertyRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Property not found: " + id));

        existing.setTitle(updated.getTitle());
        existing.setDescription(updated.getDescription());
        existing.setPropertyType(updated.getPropertyType());
        existing.setListingType(updated.getListingType());
        existing.setPrice(updated.getPrice());
        existing.setLocation(updated.getLocation());
        existing.setAddress(updated.getAddress());
        existing.setBedrooms(updated.getBedrooms());
        existing.setBathrooms(updated.getBathrooms());
        existing.setSqft(updated.getSqft());

        if (updated.getStatus() != null && !updated.getStatus().isBlank()) {
            existing.setStatus(updated.getStatus());
        }

        return propertyRepository.save(existing);
    }

    /**
     * Mark property as available, sold, rented, or inactive.
     */
    public PropertyEntity updatePropertyStatus(Integer id, String newStatus) {
        PropertyEntity property = propertyRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Property not found: " + id));
        property.setStatus(newStatus);
        return propertyRepository.save(property);
    }

    // â”€â”€â”€ DELETE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    /**
     * Delete a property listing.
     * Note: related images, bookings, reviews cascade via DB FK constraints.
     */
    public void deleteProperty(Integer id) {
        if (!propertyRepository.existsById(id)) {
            throw new IllegalArgumentException("Property not found: " + id);
        }
        propertyRepository.deleteById(id);
    }
}

