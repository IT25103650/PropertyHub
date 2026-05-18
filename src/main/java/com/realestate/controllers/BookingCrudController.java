package com.realestate.controllers;
import com.realestate.models.*;
import com.realestate.services.*;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * BookingCrudController – dedicated controller for Booking & Viewing Management CRUD.
 */
@Controller
public class BookingCrudController {

    @Autowired
    private BookingService bookingService;

    // ─── Helper: seller/admin role guard ────────────────────────────────────
    private boolean isSellerOrBoth(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return "seller".equalsIgnoreCase(role) || "both".equalsIgnoreCase(role) || "admin".equalsIgnoreCase(role);
    }

    // ═══════════════════════════════════════════════════════════════════════
    //  BUYER-SIDE BOOKING CRUD
    // ═══════════════════════════════════════════════════════════════════════

    // ─── UPDATE BOOKING (Buyer) ─────────────────────────────────────────────
    @PostMapping("/buyer-dashboard/update-booking")
    public String updateBooking(
            @RequestParam("booking_id") int bookingId,
            @RequestParam(value = "booking_date", required = false) String bookingDate,
            @RequestParam(value = "booking_time", required = false) String bookingTime,
            @RequestParam(value = "viewing_type", required = false) String viewingType,
            HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";
        
        try {
            LocalDate parsedDate = (bookingDate != null && !bookingDate.isEmpty()) ? LocalDate.parse(bookingDate) : null;
            LocalTime parsedTime = (bookingTime != null && !bookingTime.isEmpty()) ? LocalTime.parse(bookingTime) : null;
            bookingService.updateBooking(bookingId, parsedDate, parsedTime, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "redirect:/buyer-dashboard?section=bookings&updated=true";
    }

    // ─── CANCEL BOOKING (Buyer) ─────────────────────────────────────────────
    @GetMapping("/buyer-dashboard/cancel-booking")
    public String cancelBuyerBooking(@RequestParam("id") int bookingId, HttpSession session) {
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) return "redirect:/login";
        int userId = Integer.parseInt(userIdObj.toString());
        
        try {
            bookingService.cancelBooking(bookingId, userId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "redirect:/buyer-dashboard?section=bookings&cancelled=true";
    }

    // ═══════════════════════════════════════════════════════════════════════
    //  SELLER-SIDE BOOKING CRUD
    // ═══════════════════════════════════════════════════════════════════════

    // ─── CONFIRM BOOKING (Seller) ───────────────────────────────────────────
    @GetMapping("/seller-dashboard/confirm-booking")
    public String confirmBooking(@RequestParam("id") int bookingId, HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        
        try {
            bookingService.approveBooking(bookingId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "redirect:/seller-dashboard?section=bookings&updated=true";
    }

    // ─── CANCEL BOOKING (Seller) ────────────────────────────────────────────
    @GetMapping("/seller-dashboard/cancel-booking")
    public String cancelSellerBooking(@RequestParam("id") int bookingId, HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        
        try {
            bookingService.rejectBooking(bookingId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "redirect:/seller-dashboard?section=bookings&updated=true";
    }

    // ─── COMPLETE BOOKING (Seller) ──────────────────────────────────────────
    @GetMapping("/seller-dashboard/complete-booking")
    public String completeBooking(@RequestParam("id") int bookingId, HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        
        try {
            bookingService.completeBooking(bookingId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "redirect:/seller-dashboard?section=bookings&updated=true";
    }
}
