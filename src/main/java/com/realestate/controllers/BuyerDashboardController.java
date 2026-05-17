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

/**
 * Controller for Buyer Dashboard - Manages buyer profile and dashboard view.
 *
 * Component 01 - Buyer Management
 * Developer: [Student 1]
 *
 */
@Controller
public class BuyerDashboardController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ============================================================
    // DASHBOARD DISPLAY WITH PROFILE
    // ============================================================

    @GetMapping("/buyer-dashboard")
    public String buyerDashboard(HttpSession session, Model model) {

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";

        String role = (String) session.getAttribute("userRole");
        // STRICT: only buyer or both can access the buyer dashboard
        if ("seller".equalsIgnoreCase(role)) {
            return "redirect:/seller-dashboard?denied=buyer";
        }
        int userId = Integer.parseInt(userIdObj.toString());

        try {
            // --- User Profile ---
            Map<String, Object> user = jdbcTemplate.queryForMap(
                    "SELECT first_name, last_name, email, phone, profile_image_url FROM Users WHERE user_id = ?", userId);

            String firstName = user.get("first_name") != null ? (String) user.get("first_name") : "";
            String lastName  = user.get("last_name")  != null ? (String) user.get("last_name")  : "";
            String initials  = (firstName.length() > 0 ? String.valueOf(firstName.charAt(0)) : "?") +
                    (lastName.length()  > 0 ? String.valueOf(lastName.charAt(0))  : "");

            model.addAttribute("fullName",    firstName + " " + lastName);
            model.addAttribute("initials",    initials.toUpperCase());
            model.addAttribute("email",       user.get("email"));
            model.addAttribute("phone",       user.getOrDefault("phone", ""));
            model.addAttribute("welcomeName", firstName);
            model.addAttribute("profileImage", user.getOrDefault("profile_image_url", ""));
        } catch (Exception e) {
            model.addAttribute("fullName", "User");
            model.addAttribute("initials", "U");
            model.addAttribute("email", "");
            model.addAttribute("phone", "");
            model.addAttribute("welcomeName", "User");
        }

        // Empty collections for other sections (to be added in future commits)
        model.addAttribute("bookings", java.util.Collections.emptyList());
        model.addAttribute("bookingCount", 0);
        model.addAttribute("savedProperties", java.util.Collections.emptyList());
        model.addAttribute("savedCount", 0);
        model.addAttribute("reviews", java.util.Collections.emptyList());
        model.addAttribute("reviewCount", 0);
        model.addAttribute("allProperties", java.util.Collections.emptyList());
        model.addAttribute("inquiries", java.util.Collections.emptyList());
        model.addAttribute("inquiryCount", 0);
        model.addAttribute("unreadReplies", 0);

        return "BuyerManagement/buyer-dashboard";
    }
}