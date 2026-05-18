package com.realestate.services;
import com.realestate.models.*;
import com.realestate.repositories.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service layer for Admin Management business logic.

 * Developer: [Student 5]
 */
@Service
@Transactional
public class AdminService {

    @Autowired
    private AdminRepository adminRepository;

    // ─── CREATE ───────────────────────────────────────────────────────────────

    /**
     * Create a new admin account.
     * @throws IllegalArgumentException if the email is already registered.
     */
    public AdminEntity createAdmin(AdminEntity admin) {
        if (adminRepository.existsByEmail(admin.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + admin.getEmail());
        }
        admin.setRole("admin");
        admin.setIsActive(true);
        return adminRepository.save(admin);
    }

    // ─── READ ─────────────────────────────────────────────────────────────────

    /** Get all admin accounts. */
    @Transactional(readOnly = true)
    public List<AdminEntity> getAllAdmins() {
        return adminRepository.findAllAdmins();
    }

    /** Get a specific admin by ID. */
    @Transactional(readOnly = true)
    public Optional<AdminEntity> getAdminById(Integer id) {
        return adminRepository.findById(id);
    }

    /** Get an admin by email (used for login). */
    @Transactional(readOnly = true)
    public Optional<AdminEntity> getAdminByEmail(String email) {
        return adminRepository.findByEmail(email);
    }

    /** Search admins by name or email keyword. */
    @Transactional(readOnly = true)
    public List<AdminEntity> searchAdmins(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return getAllAdmins();
        return adminRepository.searchAdmins(keyword.trim());
    }

    // ─── UPDATE ───────────────────────────────────────────────────────────────

    /**
     * Update admin profile information.
     * @throws IllegalArgumentException if admin not found.
     */
    public AdminEntity updateAdmin(Integer id, AdminEntity updatedData) {
        AdminEntity existing = adminRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Admin not found: " + id));

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

        return adminRepository.save(existing);
    }

    /** Toggle admin active/inactive status. */
    public AdminEntity toggleAdminStatus(Integer id) {
        AdminEntity admin = adminRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Admin not found: " + id));
        admin.setIsActive(!admin.getIsActive());
        return adminRepository.save(admin);
    }

    // ─── DELETE ───────────────────────────────────────────────────────────────

    /**
     * Delete an admin account.
     * @throws IllegalArgumentException if admin not found.
     */
    public void deleteAdmin(Integer id) {
        if (!adminRepository.existsById(id)) {
            throw new IllegalArgumentException("Admin not found: " + id);
        }
        adminRepository.deleteById(id);
    }

    // ─── VALIDATION ───────────────────────────────────────────────────────────

    @Transactional(readOnly = true)
    public boolean isEmailAvailable(String email) {
        return !adminRepository.existsByEmail(email);
    }
}
