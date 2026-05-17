package com.realestate.controllers;
import com.realestate.models.*;
import com.realestate.services.*;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.Optional;

@Controller
public class SellerDashboardController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private SellerService sellerService;

    @Autowired
    private PropertyService propertyService;

    // load common seller data into model
    private int loadSellerData(HttpSession session, Model model) {
        Object obj = session.getAttribute("userId");
        if (obj == null) return -1;
        int sellerId = Integer.parseInt(obj.toString());

        Optional<SellerEntity> sellerOpt = sellerService.getSellerById(sellerId);
        if (sellerOpt.isPresent()) {
            SellerEntity user = sellerOpt.get();
            String fn = user.getFirstName() != null ? user.getFirstName() : "";
            String ln = user.getLastName() != null ? user.getLastName() : "";
            model.addAttribute("fullName",  fn + " " + ln);
            model.addAttribute("firstName", fn);
            model.addAttribute("lastName",  ln);
            model.addAttribute("email",     user.getEmail());
            model.addAttribute("phone",     user.getPhone() != null ? user.getPhone() : "");
            model.addAttribute("profileImage", user.getProfileImageUrl() != null ? user.getProfileImageUrl() : "");
            model.addAttribute("initials",
                    (fn.length() > 0 ? String.valueOf(fn.charAt(0)) : "") +
                            (ln.length() > 0 ? String.valueOf(ln.charAt(0)) : ""));
        }

        // Properties
        List<PropertyEntity> properties = propertyService.getPropertiesByOwner(sellerId);
        List<Map<String, Object>> mappedProps = new java.util.ArrayList<>();
        for (PropertyEntity p : properties) {
            Map<String, Object> map = new java.util.LinkedHashMap<>();
            map.put("property_id", p.getPropertyId());
            map.put("title", p.getTitle());
            map.put("location", p.getLocation());
            map.put("price", p.getPrice());
            map.put("listing_type", p.getListingType());
            map.put("property_type", p.getPropertyType());
            map.put("status", p.getStatus());
            map.put("bedrooms", p.getBedrooms());
            map.put("bathrooms", p.getBathrooms());
            mappedProps.add(map);
        }
        model.addAttribute("properties", mappedProps);
        model.addAttribute("propertyCount", mappedProps.size());

        // Bookings on seller's properties
        String bookingSql =
                "SELECT bk.booking_id, bk.viewing_type, bk.booking_date, bk.booking_time, bk.status, " +
                        "       p.title AS property_title, p.property_id, " +
                        "       u.first_name, u.last_name, u.email AS buyer_email " +
                        "FROM Bookings bk " +
                        "JOIN Properties p ON bk.property_id = p.property_id " +
                        "JOIN Users u ON bk.buyer_id = u.user_id " +
                        "WHERE p.owner_id = ? " +
                        "ORDER BY bk.booking_date DESC";
        List<Map<String, Object>> bookings = jdbcTemplate.queryForList(bookingSql, sellerId);
        model.addAttribute("bookings", bookings);

        long pending   = bookings.stream().filter(b -> "pending".equals(b.get("status"))).count();
        long confirmed = bookings.stream().filter(b -> "confirmed".equals(b.get("status"))).count();
        model.addAttribute("pendingCount",   pending);
        model.addAttribute("confirmedCount", confirmed);

        // Inquiries on seller's properties
        String inquirySql =
                "SELECT i.*, p.title AS property_title, " +
                        "       u.first_name, u.last_name, u.email AS buyer_email " +
                        "FROM Inquiries i " +
                        "JOIN Properties p ON i.property_id = p.property_id " +
                        "JOIN Users u ON i.user_id = u.user_id " +
                        "WHERE p.owner_id = ? " +
                        "ORDER BY i.created_at DESC";
        List<Map<String, Object>> inquiries = jdbcTemplate.queryForList(inquirySql, sellerId);
        model.addAttribute("inquiries", inquiries);
        long unreadInquiries = inquiries.stream().filter(i -> Boolean.FALSE.equals(i.get("is_read"))).count();
        model.addAttribute("unreadInquiries", unreadInquiries);

        return sellerId;
    }

    // Role guard helper
    private boolean isSellerOrBoth(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return "seller".equalsIgnoreCase(role) || "both".equalsIgnoreCase(role) || "admin".equalsIgnoreCase(role);
    }

    // MAIN DASHBOARD
    @GetMapping("/seller-dashboard")
    public String sellerDashboard(HttpSession session, Model model) {
        int id = loadSellerData(session, model);
        if (id < 0) return "redirect:/login";
        // STRICT: only seller or both can access seller dashboard
        String role = (String) session.getAttribute("userRole");
        if ("buyer".equalsIgnoreCase(role)) {
            return "redirect:/buyer-dashboard?denied=seller";
        }
        return "SellerManagement/seller-dashboard";
    }

    // ADD PROPERTY
    @PostMapping("/seller-dashboard/add-property")
    public String addProperty(
            @RequestParam("title")         String title,
            @RequestParam("description")   String description,
            @RequestParam("property_type") String propertyType,
            @RequestParam("listing_type")  String listingType,
            @RequestParam("price")         double price,
            @RequestParam("location")      String location,
            @RequestParam(value = "bedrooms",  required = false) Integer bedrooms,
            @RequestParam(value = "bathrooms", required = false) Integer bathrooms,
            @RequestParam(value = "sqft",      required = false) Integer sqft,
            @RequestParam(value = "images",    required = false) List<MultipartFile> images,
            HttpSession session) {

        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        int sellerId = Integer.parseInt(session.getAttribute("userId").toString());

        try {
            PropertyEntity entity = new PropertyEntity();
            entity.setOwnerId(sellerId);
            entity.setTitle(title);
            entity.setDescription(description);
            entity.setPropertyType(propertyType);
            entity.setListingType(listingType);
            entity.setPrice(java.math.BigDecimal.valueOf(price));
            entity.setLocation(location);
            entity.setBedrooms(bedrooms);
            entity.setBathrooms(bathrooms);
            entity.setSqft(sqft);
            entity.setStatus("available");

            PropertyEntity savedEntity = propertyService.createProperty(entity);
            int newPropertyId = savedEntity.getPropertyId();

            // Handle image uploads
            if (images != null && !images.isEmpty()) {
                String uploadDir = "uploads" + File.separator;
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                boolean isFirst = true;
                for (MultipartFile img : images) {
                    if (img != null && !img.isEmpty()) {
                        String origName = img.getOriginalFilename();
                        String ext = (origName != null && origName.contains("."))
                                ? origName.substring(origName.lastIndexOf('.')) : ".jpg";
                        String fileName = UUID.randomUUID().toString() + ext;
                        Path   dest     = Paths.get(uploadDir + fileName);
                        Files.copy(img.getInputStream(), dest);
                        String imageUrl = "/uploads/" + fileName;
                        jdbcTemplate.update(
                                "INSERT INTO Property_Images (property_id, image_url, is_primary) VALUES (?, ?, ?)",
                                newPropertyId, imageUrl, isFirst ? 1 : 0);
                        isFirst = false;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/seller-dashboard?section=add-property&add_error=true";
        }

        return "redirect:/seller-dashboard?section=properties&added=true";
    }

    // DELETE PROPERTY
    @GetMapping("/seller-dashboard/delete-property")
    public String deleteProperty(@RequestParam("id") int propertyId, HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        int sellerId = Integer.parseInt(session.getAttribute("userId").toString());
        // Delete related images, bookings, reviews first
        jdbcTemplate.update("DELETE FROM Property_Images WHERE property_id = ?", propertyId);
        jdbcTemplate.update("DELETE FROM Bookings WHERE property_id = ?", propertyId);
        jdbcTemplate.update("DELETE FROM Reviews WHERE target_property_id = ?", propertyId);
        jdbcTemplate.update("DELETE FROM Saved_Properties WHERE property_id = ?", propertyId);
        propertyService.deleteProperty(propertyId);
        return "redirect:/seller-dashboard?section=properties&deleted=true";
    }

    // EDIT PROPERTY
    @GetMapping("/seller-dashboard/edit-property")
    public String editPropertyForm(@RequestParam("id") int propertyId, HttpSession session, Model model) {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        int sellerId = Integer.parseInt(session.getAttribute("userId").toString());
        int id = loadSellerData(session, model);
        if (id < 0) return "redirect:/login";
        try {
            Map<String, Object> prop = jdbcTemplate.queryForMap(
                    "SELECT * FROM Properties WHERE property_id = ? AND owner_id = ?", propertyId, sellerId);
            model.addAttribute("editProp", prop);

            // Load images for this property so the image manager can render them
            List<Map<String, Object>> propImages = jdbcTemplate.queryForList(
                    "SELECT image_id, property_id, image_url, is_primary FROM Property_Images " +
                            "WHERE property_id = ? ORDER BY is_primary DESC", propertyId);
            model.addAttribute("editPropImages", propImages);
        } catch (Exception e) {
            return "redirect:/seller-dashboard?section=properties";
        }
        return "SellerManagement/seller-dashboard";
    }

    // UPDATE PROPERTY
    @PostMapping("/seller-dashboard/update-property")
    public String updateProperty(
            @RequestParam("property_id")  int propertyId,
            @RequestParam("title")         String title,
            @RequestParam("description")   String description,
            @RequestParam("property_type") String propertyType,
            @RequestParam("listing_type")  String listingType,
            @RequestParam("price")         double price,
            @RequestParam("location")      String location,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "status", required = false, defaultValue = "available") String status,
            @RequestParam(value = "bedrooms",  required = false) Integer bedrooms,
            @RequestParam(value = "bathrooms", required = false) Integer bathrooms,
            @RequestParam(value = "sqft",      required = false) Integer sqft,
            HttpSession session) {

        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        int sellerId = Integer.parseInt(session.getAttribute("userId").toString());

        PropertyEntity updatedEntity = new PropertyEntity();
        updatedEntity.setTitle(title);
        updatedEntity.setDescription(description);
        updatedEntity.setPropertyType(propertyType);
        updatedEntity.setListingType(listingType);
        updatedEntity.setPrice(java.math.BigDecimal.valueOf(price));
        updatedEntity.setLocation(location);
        updatedEntity.setAddress(address);
        updatedEntity.setStatus(status);
        updatedEntity.setBedrooms(bedrooms);
        updatedEntity.setBathrooms(bathrooms);
        updatedEntity.setSqft(sqft);

        propertyService.updateProperty(propertyId, updatedEntity);

        return "redirect:/seller-dashboard?section=properties&updated=true";
    }

    // UPDATE PROFILE
    @PostMapping("/seller-dashboard/update-profile")
    public String updateProfile(
            @RequestParam("first_name") String firstName,
            @RequestParam("last_name")  String lastName,
            @RequestParam("email")      String email,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "profileImageFile", required = false) MultipartFile profileImage,
            HttpSession session) {

        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        int sellerId = Integer.parseInt(session.getAttribute("userId").toString());

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

            SellerEntity updatedEntity = new SellerEntity();
            updatedEntity.setFirstName(firstName);
            updatedEntity.setLastName(lastName);
            updatedEntity.setEmail(email);
            updatedEntity.setPhone(phone);
            if (profileImageUrl != null) {
                updatedEntity.setProfileImageUrl(profileImageUrl);
                session.setAttribute("userProfileImage", profileImageUrl);
            }

            sellerService.updateSeller(sellerId, updatedEntity);

            // Refresh session name
            session.setAttribute("userName", firstName + " " + lastName);
            session.setAttribute("userEmail", email);
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/seller-dashboard?section=profile&error=update_failed";
        }

        return "redirect:/seller-dashboard?section=profile&updated=true";
    }

    // DELETE ACCOUNT
    @PostMapping("/seller-dashboard/delete-account")
    public String deleteSellerAccount(HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        int sellerId = Integer.parseInt(session.getAttribute("userId").toString());

        // Cascade: delete images, bookings, reviews on their properties, then properties, then account
        List<Map<String, Object>> props = jdbcTemplate.queryForList(
                "SELECT property_id FROM Properties WHERE owner_id = ?", sellerId);
        for (Map<String, Object> p : props) {
            int pid = ((Number) p.get("property_id")).intValue();
            jdbcTemplate.update("DELETE FROM Property_Images WHERE property_id = ?", pid);
            jdbcTemplate.update("DELETE FROM Bookings WHERE property_id = ?", pid);
            jdbcTemplate.update("DELETE FROM Reviews WHERE target_property_id = ?", pid);
            jdbcTemplate.update("DELETE FROM Saved_Properties WHERE property_id = ?", pid);
        }
        jdbcTemplate.update("DELETE FROM Properties WHERE owner_id = ?", sellerId);
        sellerService.deleteSeller(sellerId);
        session.invalidate();
        return "redirect:/?account_deleted=true";
    }

    // ADD PROPERTY IMAGE (Seller)
    @PostMapping("/seller-dashboard/add-image")
    public String addImage(
            @RequestParam("property_id") int propertyId,
            @RequestParam("image_file")  org.springframework.web.multipart.MultipartFile imageFile,
            @RequestParam(value = "is_primary", required = false) String isPrimaryStr,
            HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        int sellerId = Integer.parseInt(session.getAttribute("userId").toString());
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM Properties WHERE property_id = ? AND owner_id = ?",
                Integer.class, propertyId, sellerId);
        if (count == null || count == 0) return "redirect:/seller-dashboard?section=properties";

        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                String uploadDir = "uploads" + java.io.File.separator;
                java.nio.file.Path uploadPath = java.nio.file.Paths.get(uploadDir);
                if (!java.nio.file.Files.exists(uploadPath)) {
                    java.nio.file.Files.createDirectories(uploadPath);
                }
                String origName = imageFile.getOriginalFilename();
                String ext = (origName != null && origName.contains(".")) ? origName.substring(origName.lastIndexOf('.')) : ".jpg";
                String fileName = "prop_" + java.util.UUID.randomUUID().toString() + ext;
                java.nio.file.Path dest = java.nio.file.Paths.get(uploadDir + fileName);
                java.nio.file.Files.copy(imageFile.getInputStream(), dest);
                String imageUrl = "/uploads/" + fileName;

                boolean isPrimary = "true".equals(isPrimaryStr);
                if (isPrimary) {
                    jdbcTemplate.update("UPDATE Property_Images SET is_primary = false WHERE property_id = ?", propertyId);
                }
                jdbcTemplate.update(
                        "INSERT INTO Property_Images (property_id, image_url, is_primary) VALUES (?, ?, ?)",
                        propertyId, imageUrl, isPrimary);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/seller-dashboard/edit-property?id=" + propertyId + "&updated=true";
    }

    // UPDATE PROPERTY IMAGE (Seller)
    @PostMapping("/seller-dashboard/update-image")
    public String updateImage(
            @RequestParam("image_id")    int imageId,
            @RequestParam("property_id") int propertyId,
            @RequestParam("image_url")   String imageUrl,
            HttpSession session) {
        if (!isSellerOrBoth(session)) return "redirect:/login";
        int sellerId = ((Number) session.getAttribute("userId")).intValue();
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM Properties WHERE property_id = ? AND owner_id = ?", Integer.class, propertyId, sellerId);
        if (count == null || count == 0) return "redirect:/seller-dashboard?section=properties";
        jdbcTemplate.update("UPDATE Property_Images SET image_url = ? WHERE image_id = ? AND property_id = ?", imageUrl, imageId, propertyId);
        return "redirect:/seller-dashboard/edit-property?id=" + propertyId + "&updated=true";
    }

    // DELETE PROPERTY IMAGE (Seller)
    @GetMapping("/seller-dashboard/delete-image")
    public String deleteImage(
            @RequestParam("image_id")    int imageId,
            @RequestParam("property_id") int propertyId,
            HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        int sellerId = Integer.parseInt(session.getAttribute("userId").toString());
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM Properties WHERE property_id = ? AND owner_id = ?",
                Integer.class, propertyId, sellerId);
        if (count == null || count == 0) return "redirect:/seller-dashboard?section=properties";
        jdbcTemplate.update("DELETE FROM Property_Images WHERE image_id = ? AND property_id = ?", imageId, propertyId);
        return "redirect:/seller-dashboard/edit-property?id=" + propertyId + "&updated=true";
    }

    // SET PRIMARY IMAGE (Seller)
    @GetMapping("/seller-dashboard/set-primary-image")
    public String setPrimaryImage(
            @RequestParam("image_id")    int imageId,
            @RequestParam("property_id") int propertyId,
            HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        int sellerId = Integer.parseInt(session.getAttribute("userId").toString());
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM Properties WHERE property_id = ? AND owner_id = ?",
                Integer.class, propertyId, sellerId);
        if (count == null || count == 0) return "redirect:/seller-dashboard?section=properties";
        jdbcTemplate.update("UPDATE Property_Images SET is_primary = false WHERE property_id = ?", propertyId);
        jdbcTemplate.update("UPDATE Property_Images SET is_primary = true  WHERE image_id = ?",   imageId);
        return "redirect:/seller-dashboard/edit-property?id=" + propertyId + "&updated=true";
    }

    // RESPOND TO INQUIRY
    // INQUIRY: SEND (buyer at seller)
    @PostMapping("/send-agent-inquiry")
    public String sendInquiry(
            @RequestParam("agentId")                                int agentId,
            @RequestParam(value = "propertyId", required = false)   Integer propertyId,
            @RequestParam("message")                                String message,
            @RequestParam(value = "fromProperty", required = false) String fromProperty,
            HttpSession session) {

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            if ("true".equals(fromProperty)) {
                return "redirect:/login?redirect=/property-detail?id=" + propertyId;
            }
            return "redirect:/login?redirect=/agents?id=" + agentId;
        }
        int senderId = Integer.parseInt(userIdObj.toString());

        try {
            if (propertyId == null) {
                propertyId = jdbcTemplate.queryForObject(
                        "SELECT property_id FROM Properties WHERE owner_id = ? LIMIT 1",
                        Integer.class, agentId);
            }
            jdbcTemplate.update(
                    "INSERT INTO Inquiries (user_id, property_id, message, is_read) VALUES (?, ?, ?, FALSE)",
                    senderId, propertyId, message);

            if ("true".equals(fromProperty)) {
                return "redirect:/property-detail?id=" + propertyId + "&message_sent=true";
            }
            return "redirect:/agents?id=" + agentId + "&message_sent=true";
        } catch (Exception e) {
            e.printStackTrace();
            if ("true".equals(fromProperty)) {
                return "redirect:/property-detail?id=" + propertyId + "&error=message_failed";
            }
            return "redirect:/agents?id=" + agentId + "&error=message_failed";
        }
    }

    // INQUIRY: RESPOND (seller replies)
    @PostMapping("/seller-dashboard/respond-inquiry")
    public String respondInquiry(
            @RequestParam("inquiry_id")    int inquiryId,
            @RequestParam("reply_message") String replyMessage,
            HttpSession session) {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        if (!isSellerOrBoth(session)) return "redirect:/buyer-dashboard?denied=seller";
        jdbcTemplate.update(
                "UPDATE Inquiries SET reply_message = ?, is_read = TRUE WHERE inquiry_id = ?",
                replyMessage, inquiryId);
        return "redirect:/seller-dashboard?section=inquiries&replied=true";
    }
}
