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

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";

        String role = (String) session.getAttribute("userRole");
        if ("seller".equalsIgnoreCase(role)) {
            return "redirect:/seller-dashboard?denied=buyer";
        }
        int userId = Integer.parseInt(userIdObj.toString());

        try {
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
            model.addAttribute("fullName", "User"); model.addAttribute("initials", "U");
            model.addAttribute("email", ""); model.addAttribute("phone", ""); model.addAttribute("welcomeName", "User");
        }

        //
        // BOOKINGS SECTION
        //
        try {
            List<Map<String, Object>> bookings = jdbcTemplate.queryForList(
                    "SELECT b.booking_id, p.title AS property_title, p.location, b.viewing_type, " +
                            "b.booking_date, b.booking_time, b.status " +
                            "FROM Bookings b JOIN Properties p ON b.property_id = p.property_id " +
                            "WHERE b.buyer_id = ? ORDER BY b.booking_date DESC", userId);
            model.addAttribute("bookings", bookings);
            model.addAttribute("bookingCount", bookings.stream().filter(b ->
                    "pending".equals(b.get("status")) || "confirmed".equals(b.get("status"))).count());
        } catch (Exception e) {
            model.addAttribute("bookings", java.util.Collections.emptyList());
            model.addAttribute("bookingCount", 0);
        }

        // Placeholders for other sections
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

    //
    // BOOKING MANAGEMENT
    //

    @PostMapping("/buyer-dashboard/update-booking")
    public String updateBooking(
            @RequestParam("booking_id") int bookingId,
            @RequestParam(value = "booking_date", required = false) String bookingDate,
            @RequestParam(value = "booking_time", required = false) String bookingTime,
            @RequestParam(value = "viewing_type", required = false) String viewingType,
            HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";
        int userId = Integer.parseInt(userIdObj.toString());
        // Only update if booking belongs to this buyer AND is pending
        if (viewingType != null && !viewingType.isEmpty()) {
            jdbcTemplate.update(
                    "UPDATE Bookings SET booking_date=?, booking_time=?, viewing_type=? " +
                            "WHERE booking_id=? AND buyer_id=? AND status='pending'",
                    bookingDate, bookingTime, viewingType, bookingId, userId);
        } else {
            jdbcTemplate.update(
                    "UPDATE Bookings SET booking_date=?, booking_time=? " +
                            "WHERE booking_id=? AND buyer_id=? AND status='pending'",
                    bookingDate, bookingTime, bookingId, userId);
        }
        return "redirect:/buyer-dashboard?section=bookings&updated=true";
    }

    @GetMapping("/buyer-dashboard/cancel-booking")
    public String cancelBooking(@RequestParam("id") int bookingId, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";
        int userId = Integer.parseInt(userIdObj.toString());
        jdbcTemplate.update(
                "UPDATE Bookings SET status='cancelled' WHERE booking_id=? AND buyer_id=?",
                bookingId, userId);
        return "redirect:/buyer-dashboard?section=bookings&cancelled=true";
    }

    // ============================================================
    // PROFILE MANAGEMENT (from Commit 1)
    // ============================================================

    @PostMapping("/buyer-dashboard/update-profile")
    public String updateProfile(
            @RequestParam("name")  String name,
            @RequestParam("email") String email,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "profileImageFile", required = false) MultipartFile profileImage,
            HttpSession session) {
        // ... (same as Commit 1)
        return "redirect:/buyer-dashboard?updated=true";
    }

    @PostMapping("/buyer-dashboard/delete-account")
    public String deleteBuyerAccount(HttpSession session) {
        // ... (same as Commit 1)
        return "redirect:/?account_deleted=true";
    }
}