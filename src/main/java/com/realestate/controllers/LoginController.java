package com.realestate.controllers;
import com.realestate.models.*;
import com.realestate.services.*;

import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Map;

/**
 * LoginController — handles user login for buyers, sellers, and admins.
 *
 * IMPORTANT: BuyerEntity, SellerEntity, and AdminEntity all use @Where clauses
 * that filter rows by role. Because of this, we cannot use a single repository
 * to look up all users. Instead we query the Users table directly via JdbcTemplate
 * so that any role (buyer, seller, both, admin) can log in successfully.
 */
@Controller
public class LoginController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/login")
    public String loginUser(@RequestParam("email") String email,
                             @RequestParam("password") String password,
                             @RequestParam(value="redirect", required=false) String redirect,
                             HttpSession session) {

        try {
            // Query Users table directly — avoids @Where role-filter issue
            List<Map<String, Object>> results = jdbcTemplate.queryForList(
                "SELECT user_id, first_name, last_name, email, password_hash, role, profile_image_url, is_active " +
                "FROM Users WHERE email = ? LIMIT 1", email);

            if (!results.isEmpty()) {
                Map<String, Object> user = results.get(0);
                String storedHash = (String) user.get("password_hash");
                String role       = (String) user.get("role");

                // Check if account is active
                Object isActiveObj = user.get("is_active");
                boolean isActive   = isActiveObj == null || Boolean.TRUE.equals(isActiveObj)
                                     || Integer.valueOf(1).equals(isActiveObj);

                if (!isActive) {
                    String failUrl = "redirect:/login?error=inactive";
                    if (redirect != null && !redirect.trim().isEmpty()) {
                        failUrl += "&redirect=" + redirect;
                    }
                    return failUrl;
                }

                // Plain-text password comparison (project uses plain text, not bcrypt)
                if (password.equals(storedHash)) {
                    String userId    = String.valueOf(user.get("user_id"));
                    String firstName = (String) user.get("first_name");
                    String lastName  = (String) user.get("last_name");
                    String profileImg = (String) user.get("profile_image_url");

                    session.setAttribute("userId",         userId);
                    session.setAttribute("userEmail",      email);
                    session.setAttribute("userName",       firstName + " " + lastName);
                    session.setAttribute("userRole",       role);
                    session.setAttribute("userProfileImage", profileImg != null ? profileImg : "");

                    // Check if explicit redirect exists
                    if (redirect != null && !redirect.trim().isEmpty()) {
                        return "redirect:" + redirect;
                    }

                    // Default redirection based on role
                    if ("admin".equalsIgnoreCase(role)) {
                        return "redirect:/admin-dashboard";
                    } else if ("seller".equalsIgnoreCase(role)) {
                        return "redirect:/seller-dashboard";
                    } else {
                        // buyer OR both — drop them at the main site as a logged-in member
                        return "redirect:/";
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            String errUrl = "redirect:/login?error=true";
            if (redirect != null && !redirect.trim().isEmpty()) {
                errUrl += "&redirect=" + redirect;
            }
            return errUrl;
        }

        // Wrong password or email not found
        String failUrl = "redirect:/login?error=true";
        if (redirect != null && !redirect.trim().isEmpty()) {
            failUrl += "&redirect=" + redirect;
        }
        return failUrl;
    }
}
