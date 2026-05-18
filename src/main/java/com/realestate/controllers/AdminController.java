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
                    session.setAttribute("userRole", "admin");
                    logAdminAction(session, "ADMIN_LOGIN", "Admin logged in: " + email);
                    return "redirect:/admin-dashboard";
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return "redirect:/admin-login?error=true";
    }

    // â”€â”€â”€ CREATE USER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/admin/create-user")
    public String createUser(
            @RequestParam("first_name") String firstName,
            @RequestParam("last_name")  String lastName,
            @RequestParam("email")      String email,
            @RequestParam("password")   String password,
            @RequestParam("role")       String role,
            @RequestParam(value = "phone", required = false) String phone,
            HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";

        try {
            if ("admin".equalsIgnoreCase(role)) {
                AdminEntity entity = new AdminEntity();
                entity.setFirstName(firstName);
                entity.setLastName(lastName);
                entity.setEmail(email);
                entity.setPasswordHash(password);
                entity.setRole(role);
                entity.setPhone(phone);
                adminService.createAdmin(entity);
            } else {
                BuyerEntity entity = new BuyerEntity();
                entity.setFirstName(firstName);
                entity.setLastName(lastName);
                entity.setEmail(email);
                entity.setPasswordHash(password);
                entity.setRole(role);
                entity.setPhone(phone);
                buyerService.createBuyer(entity);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        logAdminAction(session, "CREATE_USER", "Created user: " + email);
        return "redirect:/admin-dashboard?panel=users&created=true";
    }

    // â”€â”€â”€ UPDATE USER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/admin/update-user")
    public String updateUser(
            @RequestParam("user_id")    int userId,
            @RequestParam("first_name") String firstName,
            @RequestParam("last_name")  String lastName,
            @RequestParam("email")      String email,
            @RequestParam("role")       String role,
            @RequestParam("is_active")  boolean isActive,
            @RequestParam(value = "phone",    required = false) String phone,
            @RequestParam(value = "password", required = false) String password,
            HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";

        try {
            if ("admin".equalsIgnoreCase(role)) {
                AdminEntity entity = new AdminEntity();
                entity.setFirstName(firstName);
                entity.setLastName(lastName);
                entity.setEmail(email);
                entity.setRole(role);
                entity.setIsActive(isActive);
                entity.setPhone(phone);
                if (password != null && !password.trim().isEmpty()) {
                    entity.setPasswordHash(password);
                }
                adminService.updateAdmin(userId, entity);
            } else {
                BuyerEntity entity = new BuyerEntity();
                entity.setFirstName(firstName);
                entity.setLastName(lastName);
                entity.setEmail(email);
                entity.setRole(role);
                entity.setIsActive(isActive);
                entity.setPhone(phone);
                if (password != null && !password.trim().isEmpty()) {
                    entity.setPasswordHash(password);
                }
                buyerService.updateBuyer(userId, entity);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        logAdminAction(session, "UPDATE_USER", "Updated user ID: " + userId);
        return "redirect:/admin-dashboard?panel=users&updated=true";
    }

    // â”€â”€â”€ DELETE USER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/admin/delete-user")
    public String deleteUser(@RequestParam("id") int userId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        // Cascade: remove all user data first
        List<Map<String, Object>> props = jdbcTemplate.queryForList(
                "SELECT property_id FROM Properties WHERE owner_id = ?", userId);
        for (Map<String, Object> p : props) {
            int pid = ((Number) p.get("property_id")).intValue();
            jdbcTemplate.update("DELETE FROM Property_Images WHERE property_id = ?", pid);
            jdbcTemplate.update("DELETE FROM Bookings WHERE property_id = ?", pid);
            jdbcTemplate.update("DELETE FROM Reviews WHERE target_property_id = ?", pid);
            jdbcTemplate.update("DELETE FROM Saved_Properties WHERE property_id = ?", pid);
            jdbcTemplate.update("DELETE FROM Inquiries WHERE property_id = ?", pid);
        }
        jdbcTemplate.update("DELETE FROM Properties WHERE owner_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Bookings WHERE buyer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Saved_Properties WHERE buyer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Reviews WHERE reviewer_id = ?", userId);
        jdbcTemplate.update("DELETE FROM Inquiries WHERE user_id = ?", userId);

        logAdminAction(session, "DELETE_USER", "Deleted user ID: " + userId);

        // Delete the user directly — bypasses @Where role filters in entity repos
        jdbcTemplate.update("DELETE FROM Users WHERE user_id = ?", userId);

        return "redirect:/admin-dashboard?panel=users&deleted=true";
    }

    // â”€â”€â”€ UPDATE PROPERTY STATUS & DETAILS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/admin/update-property")
    public String updateProperty(
            @RequestParam("property_id") int propertyId,
            @RequestParam("status")      String status,
            @RequestParam("title")       String title,
            @RequestParam("price")       Double price,
            @RequestParam("location")    String location,
            @RequestParam("property_type") String propertyType,
            @RequestParam(value = "bedrooms", required = false) Integer bedrooms,
            @RequestParam(value = "bathrooms", required = false) Integer bathrooms,
            @RequestParam(value = "size_sqft", required = false) Integer sizeSqft,
            HttpSession session) {

        if (!isAdmin(session)) return "redirect:/login";
        jdbcTemplate.update(
                "UPDATE Properties SET status=?, title=?, price=?, location=?, property_type=?, bedrooms=?, bathrooms=?, sqft=? WHERE property_id=?",
                status, title, price, location, propertyType, bedrooms, bathrooms, sizeSqft, propertyId);
        logAdminAction(session, "UPDATE_PROPERTY", "Updated property ID: " + propertyId + " to status " + status);
        return "redirect:/admin-dashboard?panel=properties&updated=true";
    }

    // â”€â”€â”€ DELETE PROPERTY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/admin/delete-property")
    public String deleteProperty(@RequestParam("id") int propertyId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        jdbcTemplate.update("DELETE FROM Property_Images WHERE property_id = ?", propertyId);
        jdbcTemplate.update("DELETE FROM Bookings WHERE property_id = ?", propertyId);
        jdbcTemplate.update("DELETE FROM Reviews WHERE target_property_id = ?", propertyId);
        jdbcTemplate.update("DELETE FROM Saved_Properties WHERE property_id = ?", propertyId);
        jdbcTemplate.update("DELETE FROM Inquiries WHERE property_id = ?", propertyId);
        jdbcTemplate.update("DELETE FROM Properties WHERE property_id = ?", propertyId);
        logAdminAction(session, "DELETE_PROPERTY", "Deleted property ID: " + propertyId);
        return "redirect:/admin-dashboard?panel=properties&deleted=true";
    }

    // â”€â”€â”€ APPROVE REVIEW â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/admin/approve-review")
    public String approveReview(@RequestParam("id") int reviewId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        try {
            reviewService.approveFeedback(reviewId);
        } catch (Exception e) { e.printStackTrace(); }
        logAdminAction(session, "APPROVE_REVIEW", "Approved review ID: " + reviewId);
        return "redirect:/admin-dashboard?panel=reviews&approved=true";
    }

    // â”€â”€â”€ DELETE REVIEW â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/admin/delete-review")
    public String deleteReview(@RequestParam("id") int reviewId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        try {
            reviewService.deleteFeedback(reviewId);
        } catch (Exception e) { e.printStackTrace(); }
        logAdminAction(session, "DELETE_REVIEW", "Deleted review ID: " + reviewId);
        return "redirect:/admin-dashboard?panel=reviews&deleted=true";
    }

    // â”€â”€â”€ UPDATE REVIEW â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/admin/update-review")
    public String updateReview(
            @RequestParam("review_id") int reviewId,
            @RequestParam("rating") int rating,
            @RequestParam("review_text") String reviewText,
            HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";

        jdbcTemplate.update(
                "UPDATE Reviews SET rating = ?, review_text = ? WHERE review_id = ?",
                rating, reviewText, reviewId
        );
        logAdminAction(session, "UPDATE_REVIEW", "Updated review ID: " + reviewId);
        return "redirect:/admin-dashboard?panel=reviews&updated=true";
    }

    // â”€â”€â”€ DELETE BOOKING â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/admin/delete-booking")
    public String deleteBooking(@RequestParam("id") int bookingId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        try {
            bookingService.deleteBooking(bookingId);
        } catch (Exception e) { e.printStackTrace(); }
        logAdminAction(session, "DELETE_BOOKING", "Deleted booking ID: " + bookingId);
        return "redirect:/admin-dashboard?panel=bookings&deleted=true";
    }

    // â”€â”€â”€ UPDATE BOOKING â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/admin/update-booking")
    public String updateBooking(
            @RequestParam("booking_id") int bookingId,
            @RequestParam("booking_date") String bookingDate,
            @RequestParam("booking_time") String bookingTime,
            @RequestParam("status") String status,
            HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        jdbcTemplate.update(
                "UPDATE Bookings SET booking_date = ?, booking_time = ?, status = ? WHERE booking_id = ?",
                bookingDate, bookingTime, status, bookingId
        );
        logAdminAction(session, "UPDATE_BOOKING", "Updated booking ID: " + bookingId);
        return "redirect:/admin-dashboard?panel=bookings&updated=true";
    }

    // â”€â”€â”€ LOGOUT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/admin/logout")
    public String adminLogout(HttpSession session) {
        if (isAdmin(session)) {
            logAdminAction(session, "ADMIN_LOGOUT", "Admin logged out: " + session.getAttribute("userEmail"));
        }
        session.invalidate();
        return "redirect:/admin-login";
    }

    // â”€â”€â”€ ADD PROPERTY IMAGE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/admin/add-image")
    public String addPropertyImage(
            @RequestParam("property_id") int propertyId,
            @RequestParam("image_file")  org.springframework.web.multipart.MultipartFile imageFile,
            @RequestParam(value = "is_primary", required = false) String isPrimaryStr,
            HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";

        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                String uploadDir = "uploads" + java.io.File.separator;
                java.nio.file.Path uploadPath = java.nio.file.Paths.get(uploadDir);
                if (!java.nio.file.Files.exists(uploadPath)) {
                    java.nio.file.Files.createDirectories(uploadPath);
                }
                String origName = imageFile.getOriginalFilename();
                String ext = (origName != null && origName.contains(".")) ? origName.substring(origName.lastIndexOf('.')) : ".jpg";
                String fileName = "admin_prop_" + java.util.UUID.randomUUID().toString() + ext;
                java.nio.file.Path dest = java.nio.file.Paths.get(uploadDir + fileName);
                java.nio.file.Files.copy(imageFile.getInputStream(), dest);
                String imageUrl = "/uploads/" + fileName;

                boolean isPrimary = "true".equals(isPrimaryStr);
                if (isPrimary) {
                    // Clear existing primary first
                    jdbcTemplate.update("UPDATE Property_Images SET is_primary = false WHERE property_id = ?", propertyId);
                }
                jdbcTemplate.update(
                        "INSERT INTO Property_Images (property_id, image_url, is_primary) VALUES (?, ?, ?)",
                        propertyId, imageUrl, isPrimary);
                logAdminAction(session, "ADD_IMAGE", "Added image to property ID: " + propertyId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/admin-dashboard?panel=properties&updated=true";
    }

    // â”€â”€â”€ DELETE PROPERTY IMAGE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/admin/update-image")
    public String adminUpdateImage(
            @RequestParam("image_id")    int imageId,
            @RequestParam("property_id") int propertyId,
            @RequestParam("image_url")   String imageUrl,
            HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        jdbcTemplate.update("UPDATE Property_Images SET image_url = ? WHERE image_id = ? AND property_id = ?", imageUrl, imageId, propertyId);
        logAdminAction(session, "UPDATE_IMAGE", "Updated image ID: " + imageId + " for property: " + propertyId);
        return "redirect:/admin-dashboard?panel=properties&updated=true";
    }

    @GetMapping("/admin/delete-image")
    public String deletePropertyImage(
            @RequestParam("image_id")    int imageId,
            @RequestParam("property_id") int propertyId,
            HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        jdbcTemplate.update("DELETE FROM Property_Images WHERE image_id = ?", imageId);
        logAdminAction(session, "DELETE_IMAGE", "Deleted image ID: " + imageId + " from property ID: " + propertyId);
        return "redirect:/admin-dashboard?panel=properties&updated=true";
    }

    // â”€â”€â”€ SET PRIMARY PROPERTY IMAGE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/admin/set-primary-image")
    public String setPrimaryImage(
            @RequestParam("image_id")    int imageId,
            @RequestParam("property_id") int propertyId,
            HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        // Unset all primaries for this property, then set the chosen one
        jdbcTemplate.update("UPDATE Property_Images SET is_primary = false WHERE property_id = ?", propertyId);
        jdbcTemplate.update("UPDATE Property_Images SET is_primary = true  WHERE image_id = ?",   imageId);
        logAdminAction(session, "SET_PRIMARY_IMAGE", "Set image ID: " + imageId + " as primary for property ID: " + propertyId);
        return "redirect:/admin-dashboard?panel=properties&updated=true";
    }

    // â”€â”€â”€ GENERATE USER REPORT (uses UserReport model) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/admin/generate-report")
    public String generateUserReport(
            @RequestParam(value = "role", required = false, defaultValue = "all") String role,
            HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        String adminId = session.getAttribute("userId").toString();
        String now     = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());

        // Build and invoke the UserReport model object
        UserReport report = new UserReport("RPT-" + System.currentTimeMillis(), adminId, now, role);
        report.generateReport(); // prints to console / could be extended
        try {
            jdbcTemplate.update("INSERT INTO Reports (report_id, generated_by, generated_at, filter_role) VALUES (?, ?, ?, ?)",
                    report.getReportId(), report.getGeneratedBy(), report.getGeneratedAt(), report.getFilterRole());
        } catch(Exception ignored) {}

        // Query filtered user list
        List<Map<String, Object>> reportUsers;
        if ("all".equalsIgnoreCase(role)) {
            reportUsers = jdbcTemplate.queryForList(
                    "SELECT user_id, first_name, last_name, email, role, is_active, created_at FROM Users ORDER BY created_at DESC");
        } else {
            reportUsers = jdbcTemplate.queryForList(
                    "SELECT user_id, first_name, last_name, email, role, is_active, created_at FROM Users WHERE role = ? ORDER BY created_at DESC", role);
        }

        adminDashboard(session, model);
        model.addAttribute("reportUsers", reportUsers);
        model.addAttribute("reportRole",  role);
        model.addAttribute("reportId",    report.getReportId());
        model.addAttribute("reportAt",    report.getGeneratedAt());
        model.addAttribute("totalRows",   reportUsers.size());

        logAdminAction(session, "GENERATE_REPORT", "Generated user report with role filter: " + role + " (" + reportUsers.size() + " users)");
        return "AdminManagement/admin-dashboard";
    }
}
