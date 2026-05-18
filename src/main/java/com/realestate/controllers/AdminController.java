package com.realestate.controllers;
import com.realestate.models.*;
import com.realestate.services.*;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.realestate.models.UserReport;

@Controller
class LegacyAdminController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private AdminService adminService;

    @Autowired
    private BuyerService buyerService;

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private BookingService bookingService;

    // â”€â”€â”€ Guard â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    private boolean isAdmin(HttpSession session) {
        return "admin".equals(session.getAttribute("userRole"));
    }

    private void logAdminAction(HttpSession session, String actionType, String description) {
        if (!isAdmin(session)) return;
        try {
            int adminId = Integer.parseInt(session.getAttribute("userId").toString());
            jdbcTemplate.update(
                "INSERT INTO Admin_Log (admin_id, action_type, description) VALUES (?, ?, ?)",
                adminId, actionType, description
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // â”€â”€â”€ DASHBOARD (Read all) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/admin-dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            // Stats
            model.addAttribute("totalUsers",        jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Users", Long.class));
            model.addAttribute("activeUsers",       jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Users WHERE is_active = true", Long.class));
            model.addAttribute("deactivatedUsers",  jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Users WHERE is_active = false", Long.class));
            model.addAttribute("newUsersThisMonth", jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Users WHERE MONTH(created_at) = MONTH(CURRENT_DATE()) AND YEAR(created_at) = YEAR(CURRENT_DATE())", Long.class));
            model.addAttribute("totalProperties",   jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Properties", Long.class));
            model.addAttribute("totalBookings",     jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Bookings", Long.class));
            model.addAttribute("pendingBookings",   jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Bookings WHERE status = 'pending'", Long.class));
            model.addAttribute("confirmedBookings", jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Bookings WHERE status = 'confirmed'", Long.class));
            model.addAttribute("cancelledBookings", jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Bookings WHERE status = 'cancelled'", Long.class));
            model.addAttribute("totalReviews",      jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Reviews", Long.class));
            model.addAttribute("pendingReviews",    jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Reviews WHERE status = 'pending'", Long.class));
            model.addAttribute("approvedReviews",   jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Reviews WHERE status = 'approved'", Long.class));
            model.addAttribute("pendingProperties", jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Properties WHERE status = 'pending'", Long.class));
            model.addAttribute("soldRentedProperties", jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Properties WHERE status IN ('sold','rented')", Long.class));

            // Users
            List<Map<String, Object>> users = jdbcTemplate.queryForList(
                "SELECT * FROM Users ORDER BY user_id DESC");
            model.addAttribute("users", users);

            // Properties
            List<Map<String, Object>> properties = jdbcTemplate.queryForList(
                "SELECT p.*, " +
                "u.first_name, u.last_name, " +
                "(SELECT image_url FROM Property_Images WHERE property_id = p.property_id LIMIT 1) as image_url " +
                "FROM Properties p JOIN Users u ON p.owner_id = u.user_id ORDER BY p.created_at DESC");
            model.addAttribute("properties", properties);

            // Bookings
            List<Map<String, Object>> bookings = jdbcTemplate.queryForList(
                "SELECT b.booking_id, b.booking_date, b.booking_time, b.viewing_type, b.status, " +
                "p.title as property_title, " +
                "u.first_name, u.last_name, u.email " +
                "FROM Bookings b " +
                "JOIN Properties p ON b.property_id = p.property_id " +
                "JOIN Users u ON b.buyer_id = u.user_id " +
                "ORDER BY b.booking_date DESC");
            model.addAttribute("bookings", bookings);

            // Reviews
            List<Map<String, Object>> reviews = jdbcTemplate.queryForList(
                "SELECT r.review_id, r.rating, r.review_text, r.status, r.created_at, " +
                "u.first_name, u.last_name, " +
                "p.title as property_title " +
                "FROM Reviews r " +
                "JOIN Users u ON r.reviewer_id = u.user_id " +
                "LEFT JOIN Properties p ON r.target_property_id = p.property_id " +
                "ORDER BY r.created_at DESC");
            model.addAttribute("reviews", reviews);

            // Activity Log (latest 100)
            List<Map<String, Object>> activityLog = jdbcTemplate.queryForList(
                "SELECT al.log_id, al.action_type, al.description, al.created_at, " +
                "CONCAT(u.first_name, ' ', u.last_name) as admin_name " +
                "FROM Admin_Log al JOIN Users u ON al.admin_id = u.user_id " +
                "ORDER BY al.created_at DESC LIMIT 100");
            model.addAttribute("activityLog", activityLog);

            // All property images (for the image manager in edit rows)
            List<Map<String, Object>> propertyImages = jdbcTemplate.queryForList(
                "SELECT image_id, property_id, image_url, is_primary FROM Property_Images ORDER BY property_id, is_primary DESC");
            model.addAttribute("propertyImages", propertyImages);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "AdminManagement/admin-dashboard";
    }

    // â”€â”€â”€ SEPARATE ADMIN LOGIN PAGE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @org.springframework.web.bind.annotation.GetMapping("/admin-login")
    public String adminLoginPage(HttpSession session) {
        if (isAdmin(session)) return "redirect:/admin-dashboard";
        return "AdminManagement/admin-login";
    }

    @org.springframework.web.bind.annotation.PostMapping("/admin-login")
    public String adminLoginSubmit(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpSession session) {
        try {
            Optional<AdminEntity> adminOpt = adminService.getAdminByEmail(email);
            if (adminOpt.isPresent()) {
                AdminEntity user = adminOpt.get();
                if (user.getPasswordHash().equals(password)) {
                    session.setAttribute("userId", String.valueOf(user.getUserId()));
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userName", user.getFirstName() + " " + user.getLastName());
}
