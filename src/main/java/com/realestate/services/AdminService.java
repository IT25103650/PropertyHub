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
}
