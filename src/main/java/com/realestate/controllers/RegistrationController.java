package com.realestate.controllers;
import com.realestate.models.*;
import com.realestate.services.*;


import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Controller
public class RegistrationController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/register")
    public String registerUser(@RequestParam("name") String name,
                               @RequestParam("email") String email,
                               @RequestParam("password") String password,
                               @RequestParam("role") String role,
                               @RequestParam(value="redirect", required=false) String redirect,
                               @RequestParam(value="profileImage", required=false) MultipartFile profileImage,
                               HttpSession session) {
        
        // Basic name splitting for schema (first_name, last_name)
        String firstName = name;
        String lastName = "";
        if (name.contains(" ")) {
            firstName = name.substring(0, name.indexOf(" "));
            lastName = name.substring(name.indexOf(" ") + 1);
        }

        try {
            // Handle optional profile image upload
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

            String sql = "INSERT INTO Users (first_name, last_name, email, password_hash, role, profile_image_url) VALUES (?, ?, ?, ?, ?, ?)";
            jdbcTemplate.update(sql, firstName, lastName, email, password, role, profileImageUrl);
            
            // Auto-login the user
            String fetchSql = "SELECT user_id, profile_image_url FROM Users WHERE email = ?";
            java.util.Map<String, Object> newUser = jdbcTemplate.queryForMap(fetchSql, email);
            Integer newUserId = (Integer) newUser.get("user_id");
            String savedImgUrl = (String) newUser.get("profile_image_url");

            session.setAttribute("userId", String.valueOf(newUserId));
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", name);
            session.setAttribute("userRole", role);
            session.setAttribute("userProfileImage", savedImgUrl != null ? savedImgUrl : "");

            // Redirect logic - honour explicit redirect first
            if (redirect != null && !redirect.trim().isEmpty()) {
                return "redirect:" + redirect;
            }
            // Role-based default redirect
            if ("seller".equalsIgnoreCase(role)) {
                return "redirect:/seller-dashboard";
            } else {
                // buyer OR both â€” land on main site
                return "redirect:/?reg=success";
            }
        } catch (Exception e) {
            e.printStackTrace();
            String errUrl = "redirect:/register?error=true";
            if (redirect != null && !redirect.trim().isEmpty()) {
                errUrl += "&redirect=" + redirect;
            }
            return errUrl;
        }
    }
}

