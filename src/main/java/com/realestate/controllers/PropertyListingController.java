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

import java.text.NumberFormat;
import java.util.*;

@Controller
public class PropertyListingController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private PropertyService propertyService;

    // â”€â”€â”€ PUBLIC PROPERTY LISTING â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/property/listing")
    public String listing(
            @RequestParam(value = "location",     required = false) String location,
            @RequestParam(value = "propertyType", required = false) String propertyType,
            @RequestParam(value = "listingType",  required = false) String listingType,
            @RequestParam(value = "minPrice",     required = false) String minPrice,
            @RequestParam(value = "maxPrice",     required = false) String maxPrice,
            @RequestParam(value = "minBeds",      required = false) String minBeds,
            Model model, HttpSession session) {

        StringBuilder sql = new StringBuilder(
            "SELECT p.property_id, p.title, p.description, p.property_type, p.listing_type, " +
            "       p.price, p.location, p.bedrooms, p.bathrooms, p.sqft, p.status, " +
            "       u.first_name, u.last_name, " +
            "       (SELECT pi.image_url FROM Property_Images pi " +
            "        WHERE pi.property_id = p.property_id AND pi.is_primary = TRUE LIMIT 1) AS primary_image " +
            "FROM Properties p " +
            "JOIN Users u ON p.owner_id = u.user_id " +
            "WHERE p.status = 'available'"
        );

        List<Object> params = new ArrayList<>();

        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND p.location LIKE ?");
            params.add("%" + location.trim() + "%");
        }
        if (propertyType != null && !propertyType.trim().isEmpty()) {
            sql.append(" AND p.property_type = ?");
            params.add(propertyType.trim());
        }
        if (listingType != null && !listingType.trim().isEmpty()) {
            sql.append(" AND p.listing_type = ?");
            params.add(listingType.trim());
        }
        if (minPrice != null && !minPrice.trim().isEmpty()) {
            try { sql.append(" AND p.price >= ?"); params.add(Double.parseDouble(minPrice.trim())); }
            catch (NumberFormatException ignored) {}
        }
        if (maxPrice != null && !maxPrice.trim().isEmpty()) {
            try { sql.append(" AND p.price <= ?"); params.add(Double.parseDouble(maxPrice.trim())); }
            catch (NumberFormatException ignored) {}
        }
        if (minBeds != null && !minBeds.trim().isEmpty()) {
            try { sql.append(" AND p.bedrooms >= ?"); params.add(Integer.parseInt(minBeds.trim())); }
            catch (NumberFormatException ignored) {}
        }

        sql.append(" ORDER BY p.created_at DESC");

        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql.toString(), params.toArray());

        // Build enriched view models
        List<Map<String, Object>> viewModels = new ArrayList<>();
        NumberFormat fmt = NumberFormat.getInstance(Locale.US);
        Set<Integer> savedPropertyIds = new HashSet<>();
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj != null) {
            try {
                int userId = Integer.parseInt(userIdObj.toString());
                List<Integer> savedIds = jdbcTemplate.queryForList(
                    "SELECT property_id FROM Saved_Properties WHERE buyer_id = ?",
                    Integer.class, userId);
                savedPropertyIds.addAll(savedIds);
            } catch (Exception ignored) {}
        }

        for (Map<String, Object> row : rows) {
            Map<String, Object> vm = new LinkedHashMap<>(row);

            // Format price
            double price = ((Number) row.get("price")).doubleValue();
            String listType = String.valueOf(row.get("listing_type"));
            vm.put("priceStr", fmt.format((long) price) + " LKR" + ("rent".equals(listType) ? "/mo" : ""));

            // Agent name
            vm.put("agent", row.get("first_name") + " " + row.get("last_name"));

            // Listing badge
            if ("rent".equals(listType)) {
                vm.put("badge", "For Rent");
                vm.put("badgeColor", "background:linear-gradient(135deg,#3b82f6,#6366f1)");
            } else {
                vm.put("badge", "For Sale");
                vm.put("badgeStyle", "background:linear-gradient(135deg,#10b981,#059669)");
                vm.put("badgeColor", "background:linear-gradient(135deg,#10b981,#059669)");
            }

            // Fallback image
            String img = (String) row.get("primary_image");
            vm.put("img", img != null && !img.isEmpty()
                ? img
                : "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600&auto=format&fit=crop&q=80");
            // Null-safe specs
            vm.put("beds",  row.get("bedrooms")  != null ? row.get("bedrooms")  : "—");
            vm.put("baths", row.get("bathrooms") != null ? row.get("bathrooms") : "—");
            vm.put("sqft",  row.get("sqft")      != null ? row.get("sqft")      : "—");
            vm.put("title", row.get("title"));
            vm.put("location", row.get("location"));
            vm.put("property_id", row.get("property_id"));
            vm.put("isSaved", savedPropertyIds.contains(((Number) row.get("property_id")).intValue()));

            viewModels.add(vm);
        }

        model.addAttribute("properties",   viewModels);
        model.addAttribute("location",     location);
        model.addAttribute("propertyType", propertyType);
        model.addAttribute("listingType",  listingType);
        model.addAttribute("minPrice",     minPrice);
        model.addAttribute("maxPrice",     maxPrice);
        model.addAttribute("minBeds",      minBeds);

        return "PropertyManagement/property-listing";
    }

    // â”€â”€â”€ PROPERTY DETAIL â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    @GetMapping("/property-detail")
    public String detail(
            @RequestParam(value = "id", required = false) Integer propertyId,
            Model model,
            HttpSession session) {

        if (propertyId == null) {
            // No ID supplied â€“ fall back to listing
            return "redirect:/property/listing";
        }

        // Load property
        Optional<PropertyEntity> propOpt = propertyService.getPropertyById(propertyId);
        if (!propOpt.isPresent()) {
            return "redirect:/property/listing";
        }
        PropertyEntity prop = propOpt.get();

        Map<String, Object> ownerInfo = jdbcTemplate.queryForMap(
            "SELECT first_name, last_name, email AS owner_email FROM Users WHERE user_id = ?",
            prop.getOwnerId());

        // Increment view_count
        try {
            jdbcTemplate.update("UPDATE Properties SET view_count = COALESCE(view_count, 0) + 1 WHERE property_id = ?", propertyId);
        } catch (Exception ignored) {}

        // Images
        List<Map<String, Object>> images = jdbcTemplate.queryForList(
            "SELECT image_url, is_primary FROM Property_Images WHERE property_id = ? ORDER BY is_primary DESC",
            propertyId);

        // Reviews
        List<Map<String, Object>> reviews = jdbcTemplate.queryForList(
            "SELECT r.rating, r.review_text, r.created_at, u.first_name, u.last_name, u.profile_image_url " +
            "FROM Reviews r JOIN Users u ON r.reviewer_id = u.user_id " +
            "WHERE r.target_property_id = ? AND r.status = 'approved' ORDER BY r.created_at DESC",
            propertyId);

        // Avg rating
        double avgRating = reviews.stream()
            .mapToInt(r -> ((Number) r.get("rating")).intValue())
            .average().orElse(0.0);

        // Formatted price
        NumberFormat fmt = NumberFormat.getInstance(Locale.US);
        double price = prop.getPrice() != null ? prop.getPrice().doubleValue() : 0.0;
        String listType = prop.getListingType();
        String priceStr = fmt.format((long) price) + " LKR" + ("rent".equals(listType) ? "/mo" : "");

        // Primary image
        String primaryImg = images.stream()
            .filter(img -> Boolean.TRUE.equals(img.get("is_primary")) || Integer.valueOf(1).equals(img.get("is_primary")))
            .map(img -> (String) img.get("image_url"))
            .findFirst()
            .orElse(images.isEmpty() ? null : (String) images.get(0).get("image_url"));
        if (primaryImg == null) {
            primaryImg = "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=2000&auto=format&fit=crop&q=80";
        }

        model.addAttribute("prop",       prop);
        model.addAttribute("images",     images);
        model.addAttribute("reviews",    reviews);
        model.addAttribute("avgRating",  Math.round(avgRating * 10.0) / 10.0);
        model.addAttribute("priceStr",   priceStr);
        model.addAttribute("primaryImg", primaryImg);
        model.addAttribute("ownerName",  ownerInfo.get("first_name") + " " + ownerInfo.get("last_name"));
        model.addAttribute("listType",   "rent".equals(listType) ? "For Rent" : "For Sale");

        boolean isSaved = false;
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj != null) {
            try {
                int userId = Integer.parseInt(userIdObj.toString());
                Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM Saved_Properties WHERE buyer_id = ? AND property_id = ?",
                    Integer.class, userId, propertyId);
                isSaved = (count != null && count > 0);
            } catch (Exception ignored) {}
        }
        model.addAttribute("isSaved", isSaved);

        return "PropertyManagement/property-detail";
    }
}
