package com.realestate.controllers;

import com.realestate.models.*;
import com.realestate.services.*;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class BuyerDashboardController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/buyer-dashboard")
    public String buyerDashboard(HttpSession session, Model model) {
        // ... (same as Commit 1)
        return "BuyerManagement/buyer-dashboard";
    }

    // ============================================================
    // PROFILE MANAGEMENT
    // ============================================================

    @PostMapping("/buyer-dashboard/update-profile")
    public String updateProfile(
            @RequestParam("name")  String name,
            @RequestParam("email") String email,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "profileImageFile", required = false) MultipartFile profileImage,
            HttpSession session) {

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";
        int userId = Integer.parseInt(userIdObj.toString());

        // Split name into first/last
        String[] parts = name.trim().split("\\s+", 2);
        String firstName = parts[0];
        String lastName  = parts.length > 1 ? parts[1] : "";

        try {
            String profileImageUrl = null;
            if (profileImage != null && !profileImage.isEmpty()) {
                String uploadDir = "uploads" + File.separator;
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                String origName = profileImage.getOriginalFilename();
                String ext = (origName != null && origName.contains("."))
                        ? origName.substring(origName.lastIndexOf('.')) : ".jpg";
                String fileName = "profile_" + UUID.randomUUID().toString() + ext;
                Path dest = Paths.get(uploadDir + fileName);
                Files.copy(profileImage.getInputStream(), dest);
                profileImageUrl = "/uploads/" + fileName;
            }

            if (profileImageUrl != null) {
                jdbcTemplate.update(
                        "UPDATE Users SET first_name=?, last_name=?, email=?, phone=?, profile_image_url=? WHERE user_id=?",
                        firstName, lastName, email, phone, profileImageUrl, userId);
                session.setAttribute("userProfileImage", profileImageUrl);
            } else {
                jdbcTemplate.update(
                        "UPDATE Users SET first_name=?, last_name=?, email=?, phone=? WHERE user_id=?",
                        firstName, lastName, email, phone, userId);
            }

            // Refresh session name
            session.setAttribute("userName", name);
            session.setAttribute("userEmail", email);
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/buyer-dashboard?error=update_failed";
        }

        return "redirect:/buyer-dashboard?updated=true";
    }

    @PostMapping("/buyer-dashboard/delete-account")
    public String deleteBuyerAccount(HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";
        int userId = Integer.parseInt(userIdObj.toString());

        // Cascade: delete related records first
        jdbcTemplate.update("DELETE FROM Bookings WHERE buyer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Saved_Properties WHERE buyer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Reviews WHERE reviewer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Users WHERE user_id = ?", userId);

        session.invalidate();
        return "redirect:/?account_deleted=true";
    }
}