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

import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

@Controller
class LegacyBookingController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private BookingService bookingService;

    // â”€â”€â”€ GET: Book a viewing page â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
        return "BookingManagement/booking-form";
    }

    // â”€â”€â”€ GET: Booking history page â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/booking-history")
    public String bookingHistory(Model model, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return "redirect:/login?redirect=/booking-history";
        }
        int buyerId = Integer.parseInt(userIdObj.toString());

        List<BookingEntity> bookings = bookingService.getBookingsByBuyer(buyerId);

        long total     = bookings.size();
        long pending   = bookings.stream().filter(b -> "pending".equals(b.getStatus())).count();
        long confirmed = bookings.stream().filter(b -> "confirmed".equals(b.getStatus())).count();
        long cancelled = bookings.stream().filter(b -> "cancelled".equals(b.getStatus())).count();

        model.addAttribute("bookings",          bookings);
        model.addAttribute("totalBookings",     total);
        model.addAttribute("pendingBookings",   pending);
        model.addAttribute("confirmedBookings", confirmed);
        model.addAttribute("cancelledBookings", cancelled);
        return "BookingManagement/booking-history";
    }

    // â”€â”€â”€ GET: Viewing schedule (alias for booking history) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/viewing-schedule")
    public String viewingSchedule(HttpSession session) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/login?redirect=/viewing-schedule";
        }
        return "redirect:/booking-history";
    }

    // â”€â”€â”€ POST: Submit booking from property-detail OR booking-form â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @PostMapping("/book-appointment")
    public String bookAppointment(
            @RequestParam(value = "viewing_type", required = false, defaultValue = "physical") String viewingType,
            @RequestParam(value = "booking_date", required = false) String bookingDate,
            @RequestParam(value = "booking_time", required = false) String bookingTime,
            @RequestParam(value = "property_id",  required = false, defaultValue = "1") int propertyId,
            @RequestParam(value = "notes", required = false) String notes,
            HttpSession session) {

        if (bookingDate == null || bookingDate.trim().isEmpty() || bookingTime == null || bookingTime.trim().isEmpty()) {
            return "redirect:/property-detail?id=" + propertyId + "&error=missing_booking_info";
        }

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return "redirect:/login?redirect=/property-detail?id=" + propertyId;
        }
        String role = (String) session.getAttribute("userRole");
        if ("seller".equalsIgnoreCase(role)) {
            return "redirect:/property-detail?id=" + propertyId + "&error=sellers_cannot_book";
        }
        int buyerId = Integer.parseInt(userIdObj.toString());

        try {
            BookingEntity booking = new BookingEntity();
            booking.setBuyerId(buyerId);
            booking.setPropertyId(propertyId);
            booking.setViewingType(viewingType);
            booking.setBookingDate(LocalDate.parse(bookingDate));
            booking.setBookingTime(LocalTime.parse(bookingTime));
            booking.setNotes(notes);
            
            bookingService.createBooking(booking);
            return "redirect:/property-detail?id=" + propertyId + "&booked=success";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/property-detail?id=" + propertyId + "&error=booking_failed";
        }
    }
}
