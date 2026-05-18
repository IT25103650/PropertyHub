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

        // Bookings
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

        //
        // Saved Properties
        //
        try {
            List<Map<String, Object>> saved = jdbcTemplate.queryForList(
                    "SELECT p.*, sp.alert_price, " +
                            "(SELECT image_url FROM Property_Images WHERE property_id = p.property_id LIMIT 1) as image_url " +
                            "FROM Saved_Properties sp JOIN Properties p ON sp.property_id = p.property_id WHERE sp.buyer_id = ?", userId);
            model.addAttribute("savedProperties", saved);
            model.addAttribute("savedCount", saved.size());
        } catch (Exception e) {
            model.addAttribute("savedProperties", java.util.Collections.emptyList());
            model.addAttribute("savedCount", 0);
        }

        //
        // Reviews
        //
        try {
            List<Map<String, Object>> reviews = jdbcTemplate.queryForList(
                    "SELECT r.review_id, r.rating, r.review_text, r.status, r.created_at, " +
                            "p.title as property_title FROM Reviews r " +
                            "LEFT JOIN Properties p ON r.target_property_id = p.property_id " +
                            "WHERE r.reviewer_id = ? ORDER BY r.created_at DESC", userId);
            model.addAttribute("reviews", reviews);
            model.addAttribute("reviewCount", reviews.size());
        } catch (Exception e) {
            model.addAttribute("reviews", java.util.Collections.emptyList());
            model.addAttribute("reviewCount", 0);
        }

        // All Properties (for review form)
        try {
            List<Map<String, Object>> allProperties = jdbcTemplate.queryForList(
                    "SELECT property_id, title, location FROM Properties WHERE status = 'available' ORDER BY title");
            model.addAttribute("allProperties", allProperties);
        } catch (Exception e) {
            model.addAttribute("allProperties", java.util.Collections.emptyList());
        }

        //Inquiries
        try {
            String inqSql = "SELECT i.*, p.title AS property_title, u.first_name AS seller_first_name, u.last_name AS seller_last_name " +
                    "FROM Inquiries i JOIN Properties p ON i.property_id = p.property_id " +
                    "JOIN Users u ON p.owner_id = u.user_id WHERE i.user_id = ? ORDER BY i.created_at DESC";
            List<Map<String, Object>> inquiries = jdbcTemplate.queryForList(inqSql, userId);
            model.addAttribute("inquiries", inquiries);
            model.addAttribute("inquiryCount", inquiries.size());
            model.addAttribute("unreadReplies", inquiries.stream().filter(i -> i.get("reply_message") != null && Boolean.TRUE.equals(i.get("is_read"))).count());
        } catch (Exception e) {
            model.addAttribute("inquiries", java.util.Collections.emptyList());
            model.addAttribute("inquiryCount", 0);
            model.addAttribute("unreadReplies", 0);
        }

        return "BuyerManagement/buyer-dashboard";
    }

    //
    // Booking Management
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

    //
    // Favourites and Alerts
    //
    @PostMapping("/buyer-dashboard/save-favourite")
    public String saveFavourite(@RequestParam("property_id") int propertyId, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login?redirect=/property/listing";
        int userId = Integer.parseInt(userIdObj.toString());
        try {
            jdbcTemplate.update(
                    "INSERT IGNORE INTO Saved_Properties (buyer_id, property_id) VALUES (?, ?)",
                    userId, propertyId);
        } catch (Exception ignored) {}
        return "redirect:/property-detail?id=" + propertyId + "&saved=true";
    }

    @PostMapping("/buyer-dashboard/set-alert")
    public String setAlert(
            @RequestParam("property_id") int propertyId,
            @RequestParam(value = "alert_price", required = false) String alertPriceStr,
            HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";
        int userId = Integer.parseInt(userIdObj.toString());
        try {
            if (alertPriceStr != null && !alertPriceStr.trim().isEmpty()) {
                double alertPrice = Double.parseDouble(alertPriceStr.trim());
                jdbcTemplate.update(
                        "UPDATE Saved_Properties SET alert_price = ? WHERE buyer_id = ? AND property_id = ?",
                        alertPrice, userId, propertyId);
            } else {
                jdbcTemplate.update(
                        "UPDATE Saved_Properties SET alert_price = NULL WHERE buyer_id = ? AND property_id = ?",
                        userId, propertyId);
            }
        } catch (Exception ignored) {}
        return "redirect:/buyer-dashboard?section=saved&alert=saved";
    }

    @GetMapping("/buyer-dashboard/remove-favourite")
    public String removeFavourite(@RequestParam("id") int propertyId, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";
        int userId = Integer.parseInt(userIdObj.toString());
        jdbcTemplate.update(
                "DELETE FROM Saved_Properties WHERE buyer_id=? AND property_id=?",
                userId, propertyId);
        return "redirect:/buyer-dashboard?section=saved&removed=true";
    }

    //
    // Review Management
    //

    @GetMapping("/buyer-dashboard/delete-review")
    public String deleteReview(@RequestParam("id") int reviewId, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";
        int userId = Integer.parseInt(userIdObj.toString());
        jdbcTemplate.update("DELETE FROM Reviews WHERE review_id = ? AND reviewer_id = ?", reviewId, userId);
        return "redirect:/buyer-dashboard?section=reviews&deleted=true";
    }

    @PostMapping("/buyer-dashboard/update-review")
    public String updateReview(
            @RequestParam("review_id") int reviewId,
            @RequestParam("rating") int rating,
            @RequestParam("review_text") String reviewText,
            HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";
        int userId = Integer.parseInt(userIdObj.toString());

        jdbcTemplate.update(
                "UPDATE Reviews SET rating = ?, review_text = ? WHERE review_id = ? AND reviewer_id = ?",
                rating, reviewText, reviewId, userId
        );
        return "redirect:/buyer-dashboard?section=reviews&updated=true";
    }

    //
    // Profile Management
    //

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
        jdbcTemplate.update("DELETE FROM Bookings WHERE buyer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Saved_Properties WHERE buyer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Reviews WHERE reviewer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Users WHERE user_id = ?", userId);
        session.invalidate();
        return "redirect:/?account_deleted=true";
    }
}