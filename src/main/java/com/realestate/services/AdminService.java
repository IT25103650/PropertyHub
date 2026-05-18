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
 */
@Service
@Transactional
public class AdminService {

    @Autowired
    private AdminRepository adminRepository;

    public AdminEntity createAdmin(AdminEntity admin) {
        if (adminRepository.existsByEmail(admin.getEmail())) {
            throw new IllegalArgumentException("Email already registered: " + admin.getEmail());
        }
        admin.setRole("admin");
        admin.setIsActive(true);
        return adminRepository.save(admin);
    }

    @Transactional(readOnly = true)
    public List<AdminEntity> getAllAdmins() {
        return adminRepository.findAllAdmins();
    }

    @Transactional(readOnly = true)
    public Optional<AdminEntity> getAdminById(Integer id) {
        return adminRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Optional<AdminEntity> getAdminByEmail(String email) {
        return adminRepository.findByEmail(email);
    }

    @Transactional(readOnly = true)
    public List<AdminEntity> searchAdmins(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return getAllAdmins();
        return adminRepository.searchAdmins(keyword.trim());
    }

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

        return adminRepository.save(existing);
    }
}
