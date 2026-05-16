package com.realestate.controllers;
import com.realestate.models.*;
import com.realestate.services.*;


import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
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
    private BuyerService buyerService;

    @Autowired
    private SellerService sellerService;

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

            Integer newUserId = null;
            String savedImgUrl = profileImageUrl;

            if ("seller".equalsIgnoreCase(role)) {
                SellerEntity seller = new SellerEntity();
                seller.setFirstName(firstName);
                seller.setLastName(lastName);
                seller.setEmail(email);
                seller.setPasswordHash(password);
                seller.setRole(role);
                seller.setProfileImageUrl(profileImageUrl);
                SellerEntity savedSeller = sellerService.createSeller(seller);
                newUserId = savedSeller.getUserId();
                savedImgUrl = savedSeller.getProfileImageUrl();
            } else {
                BuyerEntity buyer = new BuyerEntity();
                buyer.setFirstName(firstName);
                buyer.setLastName(lastName);
                buyer.setEmail(email);
                buyer.setPasswordHash(password);
                buyer.setRole(role);
                buyer.setProfileImageUrl(profileImageUrl);
                BuyerEntity savedBuyer = buyerService.createBuyer(buyer);
                newUserId = savedBuyer.getUserId();
                savedImgUrl = savedBuyer.getProfileImageUrl();
            }

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
