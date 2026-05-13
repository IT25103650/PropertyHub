package com.realestate.platform.controllers;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.text.NumberFormat;
import java.util.*;

@Controller
public class BookingController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ─── GET: Book a viewing page ─────────────────────────────────────────────
    @GetMapping("/book")
    public String bookPage(
            @RequestParam(value = "propertyId", required = false) Integer propertyId,
            Model model,
            HttpSession session) {

        // Must be logged in
        if (session.getAttribute("userId") == null) {
            return "redirect:/login?redirect=/book?propertyId=" + propertyId;
        }
        // Sellers cannot book
        String role = (String) session.getAttribute("userRole");
        if ("seller".equalsIgnoreCase(role)) {
            return "redirect:/seller-dashboard?denied=buyer";
        }

        if (propertyId != null) {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT p.*, u.first_name, u.last_name FROM Properties p " +
                "JOIN Users u ON p.owner_id = u.user_id WHERE p.property_id = ?", propertyId);

            if (!rows.isEmpty()) {
                Map<String, Object> prop = rows.get(0);
                model.addAttribute("prop", prop);

                // Primary image
                List<Map<String, Object>> imgs = jdbcTemplate.queryForList(
                    "SELECT image_url FROM Property_Images WHERE property_id = ? AND is_primary = 1 LIMIT 1", propertyId);
                String primaryImg = imgs.isEmpty() ? null : (String) imgs.get(0).get("image_url");
                if (primaryImg == null) {
                    primaryImg = "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600&auto=format&fit=crop";
                }
                model.addAttribute("primaryImg", primaryImg);

                // Price string
                NumberFormat fmt = NumberFormat.getInstance(Locale.US);
                double price = ((Number) prop.get("price")).doubleValue();
                String listType = String.valueOf(prop.get("listing_type"));
                model.addAttribute("priceStr", fmt.format((long) price) + " LKR" + ("rent".equals(listType) ? "/mo" : ""));
            }
        }
        return "Booking & Viewing Management/booking-form";
		  // ─── GET: Booking history page ────────────────────────────────────────────
    @GetMapping("/booking-history")
    public String bookingHistory(Model model, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return "redirect:/login?redirect=/booking-history";
        }
        int buyerId = Integer.parseInt(userIdObj.toString());

        List<Map<String, Object>> bookings = jdbcTemplate.queryForList(
            "SELECT b.*, p.title AS property_title, p.location FROM Bookings b " +
            "JOIN Properties p ON b.property_id = p.property_id " +
            "WHERE b.buyer_id = ? ORDER BY b.booking_date DESC", buyerId);

        long total     = bookings.size();
        long pending   = bookings.stream().filter(b -> "pending".equals(b.get("status"))).count();
        long confirmed = bookings.stream().filter(b -> "confirmed".equals(b.get("status"))).count();
        long cancelled = bookings.stream().filter(b -> "cancelled".equals(b.get("status"))).count();

        model.addAttribute("bookings",          bookings);
        model.addAttribute("totalBookings",     total);
        model.addAttribute("pendingBookings",   pending);
        model.addAttribute("confirmedBookings", confirmed);
        model.addAttribute("cancelledBookings", cancelled);
        return "Booking & Viewing Management/booking-history";
    }
