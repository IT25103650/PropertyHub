package com.realestate.utils;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;

/**
 * WebMvcConfig — registers static resource handlers so that uploaded files
 * (profile images, property photos) are served over HTTP.
 *
 * Files are saved to the "uploads/" directory relative to the working directory
 * (the project root when running via mvn spring-boot:run).
 * This handler maps the URL path /uploads/** to that physical directory.
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Get absolute path to the uploads directory
        String uploadPath = Paths.get("uploads").toAbsolutePath().toUri().toString();

        // Map /uploads/** URL to the uploads directory on disk
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadPath);
    }
}
