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

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import jakarta.servlet.ServletContext;
import org.springframework.web.multipart.MultipartFile;
import java.util.Optional;

@Controller
public class BuyerDashboardController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private BuyerService buyerService;

    @Autowired
    private BookingService bookingService;

    @Autowired
    private ReviewService reviewService;

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
            // User Profile
            Optional<BuyerEntity> userOpt = buyerService.getBuyerById(userId);
            if (userOpt.isPresent()) {
                BuyerEntity user = userOpt.get();
                String firstName = user.getFirstName() != null ? user.getFirstName() : "";
                String lastName  = user.getLastName() != null ? user.getLastName() : "";
                String initials  = (firstName.length() > 0 ? String.valueOf(firstName.charAt(0)) : "?") +
                        (lastName.length()  > 0 ? String.valueOf(lastName.charAt(0))  : "");

                model.addAttribute("fullName",    firstName + " " + lastName);
                model.addAttribute("initials",    initials.toUpperCase());
                model.addAttribute("email",       user.getEmail());
                model.addAttribute("phone",       user.getPhone() != null ? user.getPhone() : "");
                model.addAttribute("welcomeName", firstName);
                model.addAttribute("profileImage", user.getProfileImageUrl() != null ? user.getProfileImageUrl() : "");
            } else {
                throw new Exception("User not found");
            }
        } catch (Exception e) {
            model.addAttribute("fullName", "User"); model.addAttribute("initials", "U");
            model.addAttribute("email", ""); model.addAttribute("phone", ""); model.addAttribute("welcomeName", "User");
        }

        try {
            List<BookingEntity> bookings = bookingService.getBookingsByBuyer(userId);
            List<Map<String, Object>> mappedBookings = new java.util.ArrayList<>();
            for (BookingEntity b : bookings) {
                Map<String, Object> map = new java.util.LinkedHashMap<>();
                map.put("booking_id", b.getBookingId());
                map.put("booking_date", b.getBookingDate());
                map.put("booking_time", b.getBookingTime());
                map.put("status", b.getStatus());
                map.put("viewing_type", b.getViewingType());
                map.put("property_id", b.getPropertyId());
                try {
                    Map<String, Object> prop = jdbcTemplate.queryForMap(
                            "SELECT title, location FROM Properties WHERE property_id = ?", b.getPropertyId());
                    map.put("property_title", prop.get("title"));
                    map.put("location", prop.get("location"));
                } catch(Exception ignored) {}
                mappedBookings.add(map);
            }
            model.addAttribute("bookings", mappedBookings);
            model.addAttribute("bookingCount", mappedBookings.stream().filter(b ->
                    "pending".equals(b.get("status")) || "confirmed".equals(b.get("status"))).count());
        } catch (Exception e) {
            model.addAttribute("bookings", java.util.Collections.emptyList());
            model.addAttribute("bookingCount", 0);
        }

        // Saved Properties (with alert_price)
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

        // Reviews
        try {
            List<ReviewEntity> reviews = reviewService.getFeedbackByReviewer(userId);
            List<Map<String, Object>> mappedReviews = new java.util.ArrayList<>();
            for (ReviewEntity r : reviews) {
                Map<String, Object> map = new java.util.LinkedHashMap<>();
                map.put("review_id", r.getReviewId());
                map.put("rating", r.getRating());
                map.put("review_text", r.getReviewText());
                map.put("status", r.getStatus());
                map.put("created_at", r.getCreatedAt());
                if (r.getTargetPropertyId() != null) {
                    try {
                        String title = jdbcTemplate.queryForObject("SELECT title FROM Properties WHERE property_id=?", String.class, r.getTargetPropertyId());
                        map.put("property_title", title);
                    } catch(Exception ignored) {}
                } else if (r.getTargetAgentId() != null) {
                    try {
                        Map<String, Object> agent = jdbcTemplate.queryForMap("SELECT first_name, last_name FROM Users WHERE user_id=?", r.getTargetAgentId());
                        map.put("agent_name", agent.get("first_name") + " " + agent.get("last_name"));
                    } catch(Exception ignored) {}
                }
                mappedReviews.add(map);
            }
            model.addAttribute("reviews", mappedReviews);
            model.addAttribute("reviewCount", mappedReviews.size());
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

        // Inquiries (Sent by Buyer)
        try {
            String inqSql = "SELECT i.*, p.title AS property_title, u.first_name AS seller_first_name, u.last_name AS seller_last_name " +
                    "FROM Inquiries i JOIN Properties p ON i.property_id = p.property_id " +
                    "JOIN Users u ON p.owner_id = u.user_id WHERE i.user_id = ? ORDER BY i.created_at DESC";
            List<Map<String, Object>> inquiries = jdbcTemplate.queryForList(inqSql, userId);
            // Mark all replied inquiries as read when buyer visits the messages page
            jdbcTemplate.update("UPDATE Inquiries SET is_read = TRUE WHERE user_id = ? AND reply_message IS NOT NULL AND is_read = FALSE", userId);
            model.addAttribute("inquiries", inquiries);
            model.addAttribute("inquiryCount", inquiries.size());
            model.addAttribute("unreadReplies", inquiries.stream().filter(i -> i.get("reply_message") != null && !Boolean.TRUE.equals(i.get("is_read"))).count());
        } catch (Exception e) {
            model.addAttribute("inquiries", java.util.Collections.emptyList());
            model.addAttribute("inquiryCount", 0);
            model.addAttribute("unreadReplies", 0);
        }

        return "BuyerManagement/buyer-dashboard";
    }



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

            BuyerEntity updatedData = new BuyerEntity();
            updatedData.setFirstName(firstName);
            updatedData.setLastName(lastName);
            updatedData.setEmail(email);
            updatedData.setPhone(phone);
            if (profileImageUrl != null) {
                updatedData.setProfileImageUrl(profileImageUrl);
            }
            buyerService.updateBuyer(userId, updatedData);

            if (profileImageUrl != null) {
                session.setAttribute("userProfileImage", profileImageUrl);
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
        // Cascade: delete bookings, saved properties, reviews, then the account
        jdbcTemplate.update("DELETE FROM Bookings WHERE buyer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Saved_Properties WHERE buyer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Reviews WHERE reviewer_id = ?", userId);
        buyerService.deleteBuyer(userId);
        session.invalidate();
        return "redirect:/?account_deleted=true";
    }
}
