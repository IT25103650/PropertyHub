package com.realestate.controllers;
import com.realestate.models.*;
import com.realestate.services.*;


import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Controller
public class HomeController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/")
    public String index(Model model, HttpSession session) {
        List<Map<String, Object>> sellers = jdbcTemplate.queryForList(
            "SELECT user_id, first_name, last_name, email, phone, profile_image_url FROM Users WHERE role = 'seller' OR role = 'both'"
        );
        
        for (Map<String, Object> seller : sellers) {
            Integer id = (Integer) seller.get("user_id");
            Double avgObj = jdbcTemplate.queryForObject(
                "SELECT AVG(rating) FROM Reviews WHERE target_agent_id = ? AND status = 'approved'", 
                Double.class, id);
            double avgRating = avgObj != null ? Math.round(avgObj * 10.0) / 10.0 : 0.0;
            seller.put("avgRating", avgRating);
            seller.put("intRating", (int) Math.round(avgRating));
            
            Integer reviewCount = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM Reviews WHERE target_agent_id = ? AND status = 'approved'", 
                Integer.class, id);
            seller.put("reviewCount", reviewCount != null ? reviewCount : 0);
        }
        
        model.addAttribute("agentsList", sellers);

        // Fetch site reviews
        List<Map<String, Object>> siteReviews = jdbcTemplate.queryForList(
            "SELECT r.rating, r.review_text, u.first_name, u.last_name, u.role, u.profile_image_url " +
            "FROM Reviews r JOIN Users u ON r.reviewer_id = u.user_id " +
            "WHERE r.status = 'approved' AND r.target_agent_id IS NULL AND r.target_property_id IS NULL " +
            "ORDER BY r.created_at DESC LIMIT 3"
        );
        model.addAttribute("siteReviews", siteReviews);

        // Fetch Featured Properties
        List<Map<String, Object>> featuredProps = jdbcTemplate.queryForList(
            "SELECT p.*, u.first_name, u.last_name, " +
            "(SELECT image_url FROM Property_Images WHERE property_id = p.property_id AND is_primary = TRUE LIMIT 1) AS primary_image " +
            "FROM Properties p " +
            "JOIN Users u ON p.owner_id = u.user_id " +
            "WHERE p.status = 'available' " +
            "ORDER BY p.created_at DESC LIMIT 3"
        );
        
        Object userIdObj = null;
        if (model.containsAttribute("session")) {
            // Spring MVC might not put session directly here, use Http request if needed
        }
        
        for (Map<String, Object> prop : featuredProps) {
            String img = (String) prop.get("primary_image");
            prop.put("img", img != null && !img.isEmpty() ? img : "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800");
            
            // Format price
            Double price = prop.get("price") != null ? ((Number) prop.get("price")).doubleValue() : 0.0;
            java.text.NumberFormat fmt = java.text.NumberFormat.getInstance(java.util.Locale.US);
            String listType = (String) prop.get("listing_type");
            prop.put("priceStr", fmt.format(price.longValue()) + " LKR" + ("rent".equals(listType) ? "/mo" : ""));
            
            // Format agent name
            prop.put("agent", prop.get("first_name") + " " + prop.get("last_name"));
        }
        model.addAttribute("featuredProperties", featuredProps);

        return "PropertyManagement/index";
    }

    @GetMapping("/login")
    public String login(@RequestParam(value = "redirect", required = false) String redirect, Model model) {
        if (redirect != null) model.addAttribute("redirectUrl", redirect);
        return "BuyerManagement/login";
    }


    @GetMapping("/register")
    public String register(@RequestParam(value = "redirect", required = false) String redirect, Model model) {
        if (redirect != null) model.addAttribute("redirectUrl", redirect);
        return "BuyerManagement/register";
    }

    @GetMapping("/agents")
    public String agents(@RequestParam(value = "id", required = false) Integer id, Model model) {
        if (id == null) {
            return "redirect:/#agents";
        }
        
        try {
            Map<String, Object> agent = jdbcTemplate.queryForMap(
                "SELECT user_id, first_name, last_name, email, phone, profile_image_url FROM Users WHERE user_id = ?", id);
            model.addAttribute("agent", agent);

            List<Map<String, Object>> properties = jdbcTemplate.queryForList(
                "SELECT * FROM Properties WHERE owner_id = ? AND status = 'available'", id);
            
            for (Map<String, Object> prop : properties) {
                try {
                    String img = jdbcTemplate.queryForObject(
                        "SELECT image_url FROM Property_Images WHERE property_id = ? AND is_primary = TRUE LIMIT 1",
                        String.class, prop.get("property_id"));
                    prop.put("primary_image", img);
                } catch (Exception e) {
                    prop.put("primary_image", "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800");
                }
            }
            model.addAttribute("properties", properties);
            
            Double avgObj = jdbcTemplate.queryForObject(
                "SELECT AVG(rating) FROM Reviews WHERE target_agent_id = ? AND status = 'approved'", 
                Double.class, id);
            double avgRating = avgObj != null ? Math.round(avgObj * 10.0) / 10.0 : 0.0;
            model.addAttribute("avgRating", avgRating);
            model.addAttribute("intRating", (int) Math.round(avgRating));
            
            Integer reviewCount = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM Reviews WHERE target_agent_id = ? AND status = 'approved'", 
                Integer.class, id);
            model.addAttribute("reviewCount", reviewCount != null ? reviewCount : 0);
            
            List<Map<String, Object>> reviews = jdbcTemplate.queryForList(
                "SELECT r.rating, r.review_text, r.created_at, u.first_name, u.last_name " +
                "FROM Reviews r JOIN Users u ON r.reviewer_id = u.user_id " +
                "WHERE r.target_agent_id = ? AND r.status = 'approved' ORDER BY r.created_at DESC", 
                id);
            model.addAttribute("reviews", reviews);
            
        } catch (Exception e) {
            return "redirect:/#agents";
        }
        
        return "SellerManagement/agent-profile";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/?logged_out=true";
    }
}


